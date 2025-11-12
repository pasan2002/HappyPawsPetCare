package com.happypaws.petcare.servlet.Inventory;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonSerializationContext;
import com.google.gson.JsonSerializer;
import com.happypaws.petcare.dao.inventory.ProductDAO;
import com.happypaws.petcare.dao.inventory.SalesDAO;
import com.happypaws.petcare.model.Product;
import com.happypaws.petcare.model.Sale;
import com.happypaws.petcare.model.SaleItem;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.lang.reflect.Type;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.List;

/**
 * Servlet for sales operations
 * Location: src/main/java/com/happypaws/petcare/servlet/Inventory/SalesServlet.java
 */
@WebServlet("/sales/*")
public class SalesServlet extends HttpServlet {

    private SalesDAO salesDAO;
    private ProductDAO productDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        super.init();
        salesDAO = new SalesDAO();
        productDAO = new ProductDAO();
        // Configure Gson with a custom serializer for LocalDate to avoid reflection issues
        gson = new GsonBuilder()
                .registerTypeAdapter(LocalDate.class, (JsonSerializer<LocalDate>) (src, typeOfSrc, context) -> {
                    return context.serialize(src.toString());
                })
                .registerTypeAdapter(LocalDateTime.class, (JsonSerializer<LocalDateTime>) (src, typeOfSrc, context) -> {
                    return context.serialize(src.toString());
                })
                .create();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();
        String action = pathInfo != null ? pathInfo.substring(1) : "add";
        
        System.out.println("DEBUG: SalesServlet doGet called with pathInfo: " + pathInfo + ", action: " + action);

        try {
            switch (action) {
            case "add":
                showAddForm(request, response);
                break;
            case "reports":
                showReports(request, response);
                break;
            case "api/sale-items":
                getSaleItemsAPI(request, response);
                break;
            case "api/stats":
                getSalesStatsAPI(request, response);
                break;
            case "clear":
                clearFilters(request, response);
                break;
            case "removeItem":
                removeItemFromCart(request, response);
                break;
            case "api/product":
                getProductByIdAPI(request, response);
                break;
            case "export":
                exportSalesToCSV(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/sales/add");
                break;
            }
        } catch (Exception e) {
            System.err.println("ERROR in SalesServlet doGet: " + e.getMessage());
            e.printStackTrace();
            throw new ServletException("Error processing sales request", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();
        String action = pathInfo != null ? pathInfo.substring(1) : "";
        
        System.out.println("DEBUG: SalesServlet doPost called with pathInfo: " + pathInfo + ", action: " + action);

        switch (action) {
            case "addItem":
                addItemToCart(request, response);
                break;
            case "complete":
                completeSale(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/sales/add");
                break;
        }
    }

    /**
     * Export sales data to CSV file
     */
    private void exportSalesToCSV(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        // Parse date filters
        LocalDate startDate = null;
        LocalDate endDate = null;
        try {
            String startDateStr = request.getParameter("startDate");
            if (startDateStr != null && !startDateStr.isEmpty()) {
                startDate = LocalDate.parse(startDateStr);
            }
            String endDateStr = request.getParameter("endDate");
            if (endDateStr != null && !endDateStr.isEmpty()) {
                endDate = LocalDate.parse(endDateStr);
            }
        } catch (DateTimeParseException e) {
            // Ignore invalid dates, use default (all sales)
        }

        // Fetch sales data
        List<SaleItem> sales = salesDAO.getAllSaleItemsForExport(startDate, endDate);

        // Set response headers for CSV download
        response.setContentType("text/csv");
        response.setCharacterEncoding("UTF-8");
        String csvFileName = "sales_report_" + LocalDate.now() + ".csv";
        response.setHeader("Content-Disposition", "attachment; filename=\"" + csvFileName + "\"");

        // Write CSV content
        PrintWriter out = response.getWriter();
        // CSV header
        out.println("Sale ID,Product ID,Product Name,Quantity,Unit Price (LKR),Subtotal (LKR)");
        // CSV rows
        for (SaleItem sale : sales) {
            String row = String.format("%d,%d,%s,%d,%.2f,%.2f",
                    sale.getSaleId(),
                    sale.getProductId(),
                    sale.getProductName() != null ? sale.getProductName() : "N/A",
                    sale.getQuantity(),
                    sale.getUnitPrice().doubleValue(),
                    sale.getSubtotal().doubleValue());
            out.println(row);
        }
        out.flush();
    }

    /**
     * API endpoint to fetch product details by ID
     */
    private void getProductByIdAPI(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            String idParam = request.getParameter("id");
            System.out.println("DEBUG: SalesServlet getProductByIdAPI called with id: " + idParam);
            
            int productId = Integer.parseInt(idParam);
            System.out.println("DEBUG: Parsed product ID: " + productId);
            
            Product product = productDAO.getProductById(productId);
            System.out.println("DEBUG: Product found: " + (product != null ? product.getName() : "null"));
            
            if (product != null) {
                String json = gson.toJson(product);
                System.out.println("DEBUG: Sending JSON: " + json);
                response.getWriter().write(json);
            } else {
                System.out.println("DEBUG: Product not found, sending 404");
                response.setStatus(404);
                response.getWriter().write("{\"error\": \"Product not found\"}");
            }
        } catch (NumberFormatException e) {
            System.err.println("DEBUG: Invalid product ID format: " + e.getMessage());
            response.setStatus(400);
            response.getWriter().write("{\"error\": \"Invalid product ID\"}");
        } catch (Exception e) {
            System.err.println("DEBUG: Exception in getProductByIdAPI: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(500);
            response.getWriter().write("{\"error\": \"Server error: " + e.getMessage() + "\"}");
        }
    }

    /**
     * API endpoint to get sales statistics for dashboard
     */
    private void getSalesStatsAPI(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            // Get today's sales
            BigDecimal todaySales = salesDAO.getTotalSalesToday();
            
            // Get this month's sales
            BigDecimal monthSales = salesDAO.getTotalSalesThisMonth();
            
            // Create JSON response
            String json = String.format(
                "{\"todaySales\": %.2f, \"monthSales\": %.2f}",
                todaySales != null ? todaySales.doubleValue() : 0.0,
                monthSales != null ? monthSales.doubleValue() : 0.0
            );
            
            System.out.println("DEBUG: Sales stats JSON: " + json);
            response.getWriter().write(json);
            
        } catch (Exception e) {
            System.err.println("DEBUG: Exception in getSalesStatsAPI: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(500);
            response.getWriter().write("{\"error\": \"Failed to load sales statistics\"}");
        }
    }

    /**
     * Show add sale form with inventory search
     */
    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String search = request.getParameter("search");
        List<Product> products = new ArrayList<>();
        try {
            // Get all products since search functionality is not implemented in ProductDAO
            products = productDAO.getAllProducts();
        } catch (Exception e) {
            e.printStackTrace();
        }
        request.setAttribute("products", products);
        request.setAttribute("searchQuery", search);

        // Get cart from session
        HttpSession session = request.getSession();
        @SuppressWarnings("unchecked")
        List<SaleItem> cartItems = (List<SaleItem>) session.getAttribute("cartItems");
        if (cartItems == null) {
            cartItems = new ArrayList<>();
        }
        request.setAttribute("cartItems", cartItems);

        // Calculate total
        BigDecimal total = BigDecimal.ZERO;
        for (SaleItem item : cartItems) {
            total = total.add(item.getSubtotal());
        }
        request.setAttribute("total", total);

        request.getRequestDispatcher("/views/inventory-management/sales/add.jsp").forward(request, response);
    }

    /**
     * Add item to cart (session)
     */
    private void addItemToCart(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        System.out.println("DEBUG: addItemToCart called");
        try {
            String productIdStr = request.getParameter("productId");
            String quantityStr = request.getParameter("quantity");
            System.out.println("DEBUG: productId=" + productIdStr + ", quantity=" + quantityStr);
            
            int productId = Integer.parseInt(productIdStr);
            int quantity = Integer.parseInt(quantityStr);

            Product product = null;
            try {
                product = productDAO.getProductById(productId);
                System.out.println("DEBUG: product found: " + (product != null ? product.getName() : "null"));
            } catch (Exception e) {
                System.out.println("DEBUG: Error getting product: " + e.getMessage());
                e.printStackTrace();
            }
            
            if (product == null) {
                request.getSession().setAttribute("errorMessage", "Product not found!");
                response.sendRedirect(request.getContextPath() + "/sales/add");
                return;
            }

            if (quantity <= 0 || quantity > product.getStockQty()) {
                request.getSession().setAttribute("errorMessage", "Invalid quantity or insufficient stock!");
                response.sendRedirect(request.getContextPath() + "/sales/add");
                return;
            }

            BigDecimal subtotal = product.getUnitPrice().multiply(BigDecimal.valueOf(quantity));

            SaleItem item = new SaleItem();
            item.setProductId(productId);
            item.setProductName(product.getName());
            item.setQuantity(quantity);
            item.setUnitPrice(product.getUnitPrice());
            item.setSubtotal(subtotal);

            HttpSession session = request.getSession();
            @SuppressWarnings("unchecked")
            List<SaleItem> cartItems = (List<SaleItem>) session.getAttribute("cartItems");
            if (cartItems == null) {
                cartItems = new ArrayList<>();
            }
            cartItems.add(item);
            session.setAttribute("cartItems", cartItems);

            request.getSession().setAttribute("successMessage", "Item added to sale!");
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid input!");
        }

        response.sendRedirect(request.getContextPath() + "/sales/add");
    }

    /**
     * Complete the sale: insert to DB, update stock, clear cart
     */
    private void completeSale(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession();
        @SuppressWarnings("unchecked")
        List<SaleItem> cartItems = (List<SaleItem>) session.getAttribute("cartItems");
        if (cartItems == null || cartItems.isEmpty()) {
            session.setAttribute("errorMessage", "Cart is empty!");
            response.sendRedirect(request.getContextPath() + "/sales/add");
            return;
        }

        BigDecimal total = BigDecimal.ZERO;
        for (SaleItem item : cartItems) {
            total = total.add(item.getSubtotal());
        }

        int saleId = salesDAO.addSale(LocalDateTime.now(), total, cartItems);
        if (saleId > 0) {
            // Update stock for each item
            for (SaleItem item : cartItems) {
                try {
                    productDAO.updateStock(item.getProductId(), item.getQuantity());
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            session.removeAttribute("cartItems");
            session.setAttribute("successMessage", "Sale completed successfully! Sale ID: " + saleId);
        } else {
            session.setAttribute("errorMessage", "Failed to complete sale!");
        }

        response.sendRedirect(request.getContextPath() + "/sales/add");
    }

    /**
     * Show sales reports
     */
    private void showReports(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        LocalDate startDate = null;
        LocalDate endDate = null;
        try {
            String startDateStr = request.getParameter("startDate");
            if (startDateStr != null && !startDateStr.isEmpty()) {
                startDate = LocalDate.parse(startDateStr);
            }
            String endDateStr = request.getParameter("endDate");
            if (endDateStr != null && !endDateStr.isEmpty()) {
                endDate = LocalDate.parse(endDateStr);
            }
        } catch (DateTimeParseException e) {
            request.getSession().setAttribute("errorMessage", "Invalid date format!");
        }

        List<Sale> sales = salesDAO.getAllSalesForReports(startDate, endDate);
        BigDecimal totalAll = salesDAO.getTotalSales(startDate, endDate);
        BigDecimal totalToday = salesDAO.getTotalSalesToday();
        BigDecimal totalMonth = salesDAO.getTotalSalesThisMonth();

        request.setAttribute("sales", sales);
        request.setAttribute("totalAll", totalAll);
        request.setAttribute("totalToday", totalToday);
        request.setAttribute("totalMonth", totalMonth);
        request.setAttribute("startDate", startDate != null ? startDate.toString() : "");
        request.setAttribute("endDate", endDate != null ? endDate.toString() : "");

        request.getRequestDispatcher("/views/inventory-management/sales/reports.jsp").forward(request, response);
    }

    /**
     * API endpoint for sale items as JSON
     */
    private void getSaleItemsAPI(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            int saleId = Integer.parseInt(request.getParameter("saleId"));
            List<SaleItem> items = salesDAO.getSaleItems(saleId);
            String json = gson.toJson(items);
            response.getWriter().write(json);
        } catch (NumberFormatException e) {
            response.setStatus(400);
            response.getWriter().write("{\"error\": \"Invalid sale ID\"}");
        }
    }

    /**
     * Clear date range filters and redirect to reports
     */
    private void clearFilters(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.sendRedirect(request.getContextPath() + "/sales/reports");
    }

    /**
     * Remove item from cart by index
     */
    private void removeItemFromCart(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int index = Integer.parseInt(request.getParameter("index"));
            HttpSession session = request.getSession();
            @SuppressWarnings("unchecked")
            List<SaleItem> cartItems = (List<SaleItem>) session.getAttribute("cartItems");
            if (cartItems != null && index >= 0 && index < cartItems.size()) {
                cartItems.remove(index);
                session.setAttribute("cartItems", cartItems);
                request.getSession().setAttribute("successMessage", "Item removed from cart!");
            } else {
                request.getSession().setAttribute("errorMessage", "Invalid item index!");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid input!");
        }

        response.sendRedirect(request.getContextPath() + "/sales/add");
    }
}
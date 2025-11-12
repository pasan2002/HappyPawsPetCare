package com.happypaws.petcare.servlet.Inventory;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonSerializer;
import com.happypaws.petcare.dao.inventory.ProductDAO;
import com.happypaws.petcare.model.Product;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;
import java.util.List;

/**
 * Main servlet for inventory management operations
 * Location: src/main/java/com/happypaws/servlet/InventoryServlet.java
 */
@WebServlet("/inventory/*")
public class InventoryServlet extends HttpServlet {

    private ProductDAO productDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        super.init();
        productDAO = new ProductDAO();
        // Configure Gson with a custom serializer for LocalDate to avoid reflection issues
        gson = new GsonBuilder()
                .registerTypeAdapter(LocalDate.class, (JsonSerializer<LocalDate>) (src, typeOfSrc, context) -> 
                    context.serialize(src.toString()))
                .registerTypeAdapter(LocalDateTime.class, (JsonSerializer<LocalDateTime>) (src, typeOfSrc, context) -> 
                    context.serialize(src.toString()))
                .create();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();
        String action = pathInfo != null ? pathInfo.substring(1) : "list";
        
        System.out.println("DEBUG: InventoryServlet doGet called with pathInfo: " + pathInfo + ", action: " + action);

        try {
            switch (action) {
                case "list":
                    System.out.println("DEBUG: Calling listProducts");
                    listProducts(request, response);
                    break;
                case "add":
                    showAddForm(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "delete":
                    deleteProduct(request, response);
                    break;
                case "low-stock":
                    showLowStockProducts(request, response);
                    break;
                case "expiring":
                    showExpiringProducts(request, response);
                    break;
                case "api/products":
                    getProductsAPI(request, response);
                    break;
                case "api/product":
                    getProductAPI(request, response);
                    break;
                case "api/low-stock":
                    getLowStockAPI(request, response);
                    break;
                default:
                    listProducts(request, response);
                    break;
            }
        } catch (Exception e) {
            System.err.println("ERROR in InventoryServlet doGet: " + e.getMessage());
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Error processing request: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/views/inventory-management/inventory_management_home.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();
        String action = pathInfo != null ? pathInfo.substring(1) : "";

        switch (action) {
            case "add":
                addProduct(request, response);
                break;
            case "edit":
                updateProduct(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/inventory/list");
                break;
        }
    }

    /**
     * List all products
     */
    private void listProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String category = request.getParameter("category");
            String daysParam = request.getParameter("days");
            List<Product> products;
            Integer days = null;

            if (daysParam != null && !daysParam.isEmpty()) {
                try {
                    days = Integer.parseInt(daysParam);
                    products = productDAO.getExpiringProducts(days);
                } catch (Exception e) {
                    System.err.println("Error getting expiring products: " + e.getMessage());
                    e.printStackTrace();
                    days = null; // Ignore invalid days parameter
                    products = productDAO.getAllProducts();
                }
            } else if (category != null && !category.isEmpty()) {
                products = productDAO.getProductsByCategory(category);
            } else {
                products = productDAO.getAllProducts();
            }

            System.out.println("DEBUG: Retrieved " + products.size() + " products");
            request.setAttribute("products", products);
            request.setAttribute("selectedCategory", category);
            request.setAttribute("selectedDays", days);
            request.getRequestDispatcher("/views/inventory-management/inventory/list.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("Error in listProducts: " + e.getMessage());
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Error loading products: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/views/inventory-management/inventory_management_home.jsp");
        }
    }

    /**
     * Show add product form
     */
    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("DEBUG: showAddForm called, forwarding to add.jsp");
        request.getRequestDispatcher("/views/inventory-management/inventory/add.jsp").forward(request, response);
    }

    /**
     * Add new product
     */
    private void addProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("DEBUG: addProduct method called");
        
        try {
            String name = request.getParameter("name");
            String category = request.getParameter("category");
            String stockQtyStr = request.getParameter("stockQty");
            String unitPriceStr = request.getParameter("unitPrice");
            
            System.out.println("DEBUG: Received parameters - name: " + name + ", category: " + category + ", stockQty: " + stockQtyStr + ", unitPrice: " + unitPriceStr);
            
            int stockQty = Integer.parseInt(stockQtyStr);
            BigDecimal unitPrice = new BigDecimal(unitPriceStr);

            String expiryDateStr = request.getParameter("expiryDate");
            LocalDate expiryDate = null;
            if (expiryDateStr != null && !expiryDateStr.isEmpty()) {
                expiryDate = LocalDate.parse(expiryDateStr);
                System.out.println("DEBUG: Parsed expiry date: " + expiryDate);
            }

            Product product = new Product(name, category, stockQty, unitPrice, expiryDate);
            System.out.println("DEBUG: Created product object: " + product.getName());

            boolean success = productDAO.addProduct(product);
            System.out.println("DEBUG: addProduct result: " + success);
            
            if (success) {
                request.getSession().setAttribute("successMessage", "Successfully added \"" + name + "\" to inventory");
                System.out.println("DEBUG: Success message set");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to add product!");
                System.out.println("DEBUG: Error message set - DAO returned false");
            }

        } catch (NumberFormatException | DateTimeParseException e) {
            System.err.println("DEBUG: Input parsing error: " + e.getMessage());
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Invalid input data: " + e.getMessage());
        } catch (Exception e) {
            System.err.println("DEBUG: General error in addProduct: " + e.getMessage());
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Error adding product: " + e.getMessage());
        }

        System.out.println("DEBUG: Redirecting to inventory list");
        response.sendRedirect(request.getContextPath() + "/inventory/list");
    }

    /**
     * Show edit product form
     */
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("DEBUG: showEditForm called");
        
        try {
            String idParam = request.getParameter("id");
            System.out.println("DEBUG: Product ID parameter: " + idParam);
            
            int productId = Integer.parseInt(idParam);
            System.out.println("DEBUG: Parsed product ID: " + productId);
            
            Product product = productDAO.getProductById(productId);
            System.out.println("DEBUG: Retrieved product: " + (product != null ? product.getName() : "null"));

            if (product != null) {
                request.setAttribute("product", product);
                System.out.println("DEBUG: Product set as request attribute, forwarding to edit.jsp");
                request.getRequestDispatcher("/views/inventory-management/inventory/edit.jsp").forward(request, response);
            } else {
                System.out.println("DEBUG: Product not found for ID: " + productId);
                request.getSession().setAttribute("errorMessage", "Product not found!");
                response.sendRedirect(request.getContextPath() + "/inventory/list");
            }

        } catch (NumberFormatException e) {
            System.err.println("DEBUG: Invalid product ID format: " + e.getMessage());
            request.getSession().setAttribute("errorMessage", "Invalid product ID!");
            response.sendRedirect(request.getContextPath() + "/inventory/list");
        } catch (Exception e) {
            System.err.println("DEBUG: Error in showEditForm: " + e.getMessage());
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Error loading product: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/inventory/list");
        }
    }

    /**
     * Update product
     */
    private void updateProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("DEBUG: updateProduct method called");
        
        try {
            String productIdStr = request.getParameter("productId");
            String name = request.getParameter("name");
            String category = request.getParameter("category");
            String stockQtyStr = request.getParameter("stockQty");
            String unitPriceStr = request.getParameter("unitPrice");
            
            System.out.println("DEBUG: Update parameters - productId: " + productIdStr + ", name: " + name + ", category: " + category);
            System.out.println("DEBUG: Update parameters - stockQty: " + stockQtyStr + ", unitPrice: " + unitPriceStr);
            
            int productId = Integer.parseInt(productIdStr);
            int stockQty = Integer.parseInt(stockQtyStr);
            BigDecimal unitPrice = new BigDecimal(unitPriceStr);

            String expiryDateStr = request.getParameter("expiryDate");
            LocalDate expiryDate = null;
            if (expiryDateStr != null && !expiryDateStr.isEmpty()) {
                expiryDate = LocalDate.parse(expiryDateStr);
                System.out.println("DEBUG: Update expiry date: " + expiryDate);
            }

            Product product = new Product(productId, name, category, stockQty, unitPrice, expiryDate, null);
            System.out.println("DEBUG: Created product for update: " + product.getName() + " (ID: " + product.getProductId() + ")");

            boolean success = productDAO.updateProduct(product);
            System.out.println("DEBUG: updateProduct result: " + success);
            
            if (success) {
                request.getSession().setAttribute("successMessage", "Successfully updated \"" + name + "\"");
                System.out.println("DEBUG: Update success message set");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to update product!");
                System.out.println("DEBUG: Update error message set - DAO returned false");
            }

        } catch (NumberFormatException | DateTimeParseException e) {
            System.err.println("DEBUG: Update input parsing error: " + e.getMessage());
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Invalid input data: " + e.getMessage());
        } catch (Exception e) {
            System.err.println("DEBUG: General error in updateProduct: " + e.getMessage());
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Error updating product: " + e.getMessage());
        }

        System.out.println("DEBUG: Redirecting to inventory list after update");
        response.sendRedirect(request.getContextPath() + "/inventory/list");
    }

    /**
     * Delete product
     */
    private void deleteProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int productId = Integer.parseInt(request.getParameter("id"));

            if (productDAO.deleteProduct(productId)) {
                request.getSession().setAttribute("successMessage", "Product deleted successfully!");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to delete product!");
            }

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid product ID!");
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Error deleting product: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/inventory/list");
    }

    /**
     * Show low stock products
     */
    private void showLowStockProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int threshold = 10; // Default threshold
            String thresholdParam = request.getParameter("threshold");
            if (thresholdParam != null && !thresholdParam.isEmpty()) {
                try {
                    threshold = Integer.parseInt(thresholdParam);
                } catch (NumberFormatException e) {
                    // Use default threshold
                }
            }

            List<Product> lowStockProducts = productDAO.getLowStockProducts(threshold);
            request.setAttribute("products", lowStockProducts);
            request.setAttribute("threshold", threshold);
            request.getRequestDispatcher("/views/inventory-management/inventory/low-stock.jsp").forward(request, response);
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Error loading low stock products: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/views/inventory-management/inventory_management_home.jsp");
        }
    }

    /**
     * Show expiring products
     */
    private void showExpiringProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int days = 30; // Default: expiring in 30 days
            String daysParam = request.getParameter("days");
            if (daysParam != null && !daysParam.isEmpty()) {
                try {
                    days = Integer.parseInt(daysParam);
                } catch (NumberFormatException e) {
                    // Use default days
                }
            }

            List<Product> expiringProducts = productDAO.getExpiringProducts(days);
            request.setAttribute("products", expiringProducts);
            request.setAttribute("days", days);
            request.getRequestDispatcher("/views/inventory-management/inventory/expiring.jsp").forward(request, response);
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Error loading expiring products: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/views/inventory-management/inventory_management_home.jsp");
        }
    }

    /**
     * API endpoint to get products as JSON
     */
    private void getProductsAPI(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            List<Product> products = productDAO.getAllProducts();
            String json = gson.toJson(products);
            response.getWriter().write(json);
        } catch (Exception e) {
            response.getWriter().write("{\"error\":\"Failed to load products\"}");
        }
    }

    /**
     * API endpoint to get a single product by ID as JSON
     */
    private void getProductAPI(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            String idParam = request.getParameter("id");
            System.out.println("DEBUG: getProductAPI called with id parameter: " + idParam);
            
            if (idParam == null || idParam.trim().isEmpty()) {
                System.out.println("DEBUG: Product ID is missing or empty");
                response.getWriter().write("{\"error\":\"Product ID is required\"}");
                return;
            }

            int productId = Integer.parseInt(idParam);
            System.out.println("DEBUG: Parsed product ID: " + productId);
            
            Product product = productDAO.getProductById(productId);
            System.out.println("DEBUG: Product retrieved: " + (product != null ? product.getName() : "null"));
            
            if (product != null) {
                String json = gson.toJson(product);
                System.out.println("DEBUG: JSON response: " + json);
                response.getWriter().write(json);
            } else {
                System.out.println("DEBUG: Product not found for ID: " + productId);
                response.getWriter().write("{\"error\":\"Product not found\"}");
            }
        } catch (NumberFormatException e) {
            System.err.println("DEBUG: Invalid product ID format: " + e.getMessage());
            response.getWriter().write("{\"error\":\"Invalid product ID\"}");
        } catch (Exception e) {
            System.err.println("DEBUG: Exception in getProductAPI: " + e.getMessage());
            e.printStackTrace();
            response.getWriter().write("{\"error\":\"Failed to load product: " + e.getMessage() + "\"}");
        }
    }

    /**
     * API endpoint to get low stock products as JSON
     */
    private void getLowStockAPI(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            int threshold = 10;
            String thresholdParam = request.getParameter("threshold");
            if (thresholdParam != null && !thresholdParam.isEmpty()) {
                try {
                    threshold = Integer.parseInt(thresholdParam);
                } catch (NumberFormatException e) {
                    // Use default threshold
                }
            }

            List<Product> lowStockProducts = productDAO.getLowStockProducts(threshold);
            String json = gson.toJson(lowStockProducts);
            response.getWriter().write(json);
        } catch (Exception e) {
            response.getWriter().write("{\"error\":\"Failed to load low stock products\"}");
        }
    }
}
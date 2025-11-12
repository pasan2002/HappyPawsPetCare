package com.happypaws.petcare.dao.inventory;

import com.happypaws.petcare.model.Sale;
import com.happypaws.petcare.model.SaleItem;
import com.happypaws.petcare.config.DB;

import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Sale operations
 * Location: src/main/java/com/happypaws/petcare/dao/inventory/SalesDAO.java
 */
public class SalesDAO {
     // Singleton database connection - reused across all methods
    private static Connection conn;
    
    // Initialize connection once
    static {
        try {
            conn = DB.getConnection();
        } catch (Exception e) {
            throw new RuntimeException("Failed to initialize database connection", e);
        }
    }


    // SQL Queries
    private static final String INSERT_SALE =
            "INSERT INTO sales (sale_date, total_amount) VALUES (?, ?)";

    private static final String INSERT_SALE_ITEM =
            "INSERT INTO sale_items (sale_id, product_id, quantity, unit_price, subtotal) VALUES (?, ?, ?, ?, ?)";

    // UPDATED: Added date range filtering
    private static final String SELECT_ALL_SALES =
            "SELECT sale_id, sale_date, total_amount, created_at FROM sales " +
                    "WHERE (? IS NULL OR sale_date >= ?) AND (? IS NULL OR sale_date < DATEADD(day, 1, ?)) " +
                    "ORDER BY sale_date DESC";

    private static final String SELECT_SALE_ITEMS =
            "SELECT si.item_id, si.sale_id, si.product_id, p.name AS product_name, si.quantity, si.unit_price AS unit_price, si.subtotal " +
                    "FROM sale_items si JOIN products p ON si.product_id = p.product_id WHERE si.sale_id = ?";

    // UPDATED: Queries for reports with date range
    private static final String SELECT_TOTAL_SALES =
            "SELECT SUM(total_amount) AS total FROM sales " +
                    "WHERE (? IS NULL OR sale_date >= ?) AND (? IS NULL OR sale_date < DATEADD(day, 1, ?))";

    private static final String SELECT_TOTAL_SALES_TODAY =
            "SELECT SUM(total_amount) AS total FROM sales WHERE CAST(sale_date AS DATE) = CAST(GETDATE() AS DATE)";

    private static final String SELECT_TOTAL_SALES_MONTH =
            "SELECT SUM(total_amount) AS total FROM sales WHERE YEAR(sale_date) = YEAR(GETDATE()) AND MONTH(sale_date) = MONTH(GETDATE())";

    /**
     * Add a new sale and its items
     */
    public int addSale(LocalDateTime saleDate, BigDecimal totalAmount, List<SaleItem> items) {
        try {
            // Insert sale header
            try (PreparedStatement stmt = conn.prepareStatement(INSERT_SALE, Statement.RETURN_GENERATED_KEYS)) {
                stmt.setTimestamp(1, Timestamp.valueOf(saleDate));
                stmt.setBigDecimal(2, totalAmount);
                int rows = stmt.executeUpdate();
                if (rows > 0) {
                    ResultSet keys = stmt.getGeneratedKeys();
                    if (keys.next()) {
                        int saleId = keys.getInt(1);

                        // Insert items
                        for (SaleItem item : items) {
                            addSaleItem(conn, saleId, item);
                        }
                        return saleId;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    private void addSaleItem(Connection conn, int saleId, SaleItem item) throws SQLException {
        try (PreparedStatement stmt = conn.prepareStatement(INSERT_SALE_ITEM)) {
            stmt.setInt(1, saleId);
            stmt.setInt(2, item.getProductId());
            stmt.setInt(3, item.getQuantity());
            stmt.setBigDecimal(4, item.getUnitPrice());
            stmt.setBigDecimal(5, item.getSubtotal());
            stmt.executeUpdate();
        }
    }

    /**
     * Get all sale items for CSV export, optionally filtered by date range
     */
    public List<SaleItem> getAllSaleItemsForExport(LocalDate startDate, LocalDate endDate) {
        List<SaleItem> saleItems = new ArrayList<>();
        
        String query = "SELECT si.item_id, si.sale_id, si.product_id, p.name AS product_name, " +
                       "si.quantity, si.unit_price AS unit_price, si.subtotal " +
                       "FROM sale_items si " +
                       "JOIN products p ON si.product_id = p.product_id " +
                       "JOIN sales s ON si.sale_id = s.sale_id " +
                       "WHERE (? IS NULL OR s.sale_date >= ?) AND (? IS NULL OR s.sale_date < DATEADD(day, 1, ?)) " +
                       "ORDER BY s.sale_date DESC";
        
        try (PreparedStatement stmt = conn.prepareStatement(query)) {

            // Set date parameters
            if (startDate != null) {
                stmt.setDate(1, Date.valueOf(startDate));
                stmt.setDate(2, Date.valueOf(startDate));
            } else {
                stmt.setNull(1, Types.DATE);
                stmt.setNull(2, Types.DATE);
            }
            if (endDate != null) {
                stmt.setDate(3, Date.valueOf(endDate));
                stmt.setDate(4, Date.valueOf(endDate));
            } else {
                stmt.setNull(3, Types.DATE);
                stmt.setNull(4, Types.DATE);
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    SaleItem saleItem = mapResultSetToSaleItem(rs);
                    saleItems.add(saleItem);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return saleItems;
    }

    /**
     * Get sale items for a sale
     */
    public List<SaleItem> getSaleItems(int saleId) {
        List<SaleItem> items = new ArrayList<>();
        try (PreparedStatement stmt = conn.prepareStatement(SELECT_SALE_ITEMS)) {

            stmt.setInt(1, saleId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    SaleItem item = mapResultSetToSaleItem(rs);
                    items.add(item);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return items;
    }

    /**
     * Get total sales, optionally filtered by date range
     */
    public BigDecimal getTotalSales(LocalDate startDate, LocalDate endDate) {
        return getTotalSales(SELECT_TOTAL_SALES, startDate, endDate);
    }

    /**
     * Get total sales today
     */
    public BigDecimal getTotalSalesToday() {
        return getTotalSales(SELECT_TOTAL_SALES_TODAY, null, null);
    }

    /**
     * Get total sales this month
     */
    public BigDecimal getTotalSalesThisMonth() {
        return getTotalSales(SELECT_TOTAL_SALES_MONTH, null, null);
    }

    private BigDecimal getTotalSales(String query, LocalDate startDate, LocalDate endDate) {
        try (PreparedStatement stmt = conn.prepareStatement(query)) {

            // Set date parameters for queries that support it
            if (query.equals(SELECT_TOTAL_SALES)) {
                if (startDate != null) {
                    stmt.setDate(1, Date.valueOf(startDate));
                    stmt.setDate(2, Date.valueOf(startDate));
                } else {
                    stmt.setNull(1, Types.DATE);
                    stmt.setNull(2, Types.DATE);
                }
                if (endDate != null) {
                    stmt.setDate(3, Date.valueOf(endDate));
                    stmt.setDate(4, Date.valueOf(endDate));
                } else {
                    stmt.setNull(3, Types.DATE);
                    stmt.setNull(4, Types.DATE);
                }
            }

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getBigDecimal("total") != null ? rs.getBigDecimal("total") : BigDecimal.ZERO;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }

    private SaleItem mapResultSetToSaleItem(ResultSet rs) throws SQLException {
        SaleItem item = new SaleItem();
        item.setItemId(rs.getInt("item_id"));
        item.setSaleId(rs.getInt("sale_id"));
        item.setProductId(rs.getInt("product_id"));
        item.setProductName(rs.getString("product_name"));
        item.setQuantity(rs.getInt("quantity"));
        item.setUnitPrice(rs.getBigDecimal("unit_price"));
        item.setSubtotal(rs.getBigDecimal("subtotal"));
        return item;
    }

    /**
     * Get all sales as Sale objects (for reports)
     */
    public List<Sale> getAllSalesForReports(LocalDate startDate, LocalDate endDate) {
        List<Sale> sales = new ArrayList<>();
        try (PreparedStatement stmt = conn.prepareStatement(SELECT_ALL_SALES)) {

            // Set date parameters
            if (startDate != null) {
                stmt.setDate(1, Date.valueOf(startDate));
                stmt.setDate(2, Date.valueOf(startDate));
            } else {
                stmt.setNull(1, Types.DATE);
                stmt.setNull(2, Types.DATE);
            }
            if (endDate != null) {
                stmt.setDate(3, Date.valueOf(endDate));
                stmt.setDate(4, Date.valueOf(endDate));
            } else {
                stmt.setNull(3, Types.DATE);
                stmt.setNull(4, Types.DATE);
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Sale sale = mapResultSetToSale(rs);
                    sales.add(sale);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting sales for reports: " + e.getMessage());
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return sales;
    }

    private Sale mapResultSetToSale(ResultSet rs) throws SQLException {
        Sale sale = new Sale();
        sale.setSaleId(rs.getInt("sale_id"));
        sale.setSaleDate(rs.getTimestamp("sale_date").toLocalDateTime());
        sale.setTotalAmount(rs.getBigDecimal("total_amount"));
        sale.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        return sale;
    }
}
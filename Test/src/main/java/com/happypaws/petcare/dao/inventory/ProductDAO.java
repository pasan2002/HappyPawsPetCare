package com.happypaws.petcare.dao.inventory;

import com.happypaws.petcare.model.Product;
import com.happypaws.petcare.config.DB;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Product operations
 * Location: src/main/java/com/happypaws/dao/ProductDAO.java
 */
public class ProductDAO {

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
    private static final String SELECT_ALL =
            "SELECT product_id, name, category, stock_qty, unit_price, expiry_date, created_at FROM products ORDER BY name";

    private static final String SELECT_BY_ID =
            "SELECT product_id, name, category, stock_qty, unit_price, expiry_date, created_at FROM products WHERE product_id = ?";

    private static final String INSERT_PRODUCT =
            "INSERT INTO products (name, category, stock_qty, unit_price, expiry_date) VALUES (?, ?, ?, ?, ?)";

    private static final String UPDATE_PRODUCT =
            "UPDATE products SET name = ?, category = ?, stock_qty = ?, unit_price = ?, expiry_date = ? WHERE product_id = ?";

    private static final String DELETE_PRODUCT =
            "DELETE FROM products WHERE product_id = ?";

    private static final String SELECT_LOW_STOCK =
            "SELECT product_id, name, category, stock_qty, unit_price, expiry_date, created_at FROM products WHERE stock_qty <= ? ORDER BY stock_qty ASC";

    private static final String SELECT_EXPIRING =
            "SELECT product_id, name, category, stock_qty, unit_price, expiry_date, created_at FROM products WHERE expiry_date IS NOT NULL AND expiry_date <= ? ORDER BY expiry_date ASC";

    private static final String UPDATE_STOCK =
            "UPDATE products SET stock_qty = stock_qty - ? WHERE product_id = ?";

    private static final String SELECT_BY_CATEGORY =
            "SELECT product_id, name, category, stock_qty, unit_price, expiry_date, created_at FROM products WHERE category = ? ORDER BY name";

    /**
     * Get all products
     */
    public List<Product> getAllProducts() throws Exception {
        List<Product> products = new ArrayList<>();

        try (PreparedStatement stmt = conn.prepareStatement(SELECT_ALL);
             ResultSet rs = stmt.executeQuery()) {

            // DEBUG LINE:
            System.out.println("Executing query: " + SELECT_ALL);

            while (rs.next()) {
                Product product = mapResultSetToProduct(rs);
                products.add(product);
                // DEBUG LINE:
                System.out.println("Mapped product: " + product.getName());
            }

            // DEBUG LINE:
            System.out.println("Total products mapped: " + products.size());

        } catch (SQLException e) {
            System.err.println("Error getting all products: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }

        return products;
    }
    /**
     * Get product by ID
     */
    public Product getProductById(int productId) throws Exception {
        try (PreparedStatement stmt = conn.prepareStatement(SELECT_BY_ID)) {

            stmt.setInt(1, productId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToProduct(rs);
            }

        } catch (SQLException e) {
            System.err.println("Error getting product by ID: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }

        return null;
    }

    /**
     * Add new product
     */
    public boolean addProduct(Product product) throws Exception {
        try (PreparedStatement stmt = conn.prepareStatement(INSERT_PRODUCT, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, product.getName());
            stmt.setString(2, product.getCategory());
            stmt.setInt(3, product.getStockQty());
            stmt.setBigDecimal(4, product.getUnitPrice());

            if (product.getExpiryDate() != null) {
                stmt.setDate(5, Date.valueOf(product.getExpiryDate()));
            } else {
                stmt.setNull(5, Types.DATE);
            }

            int rowsAffected = stmt.executeUpdate();

            if (rowsAffected > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    product.setProductId(generatedKeys.getInt(1));
                }
                return true;
            }

        } catch (SQLException e) {
            System.err.println("Error adding product: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }

        return false;
    }

    /**
     * Update product
     */
    public boolean updateProduct(Product product) throws Exception {
        try (PreparedStatement stmt = conn.prepareStatement(UPDATE_PRODUCT)) {

            stmt.setString(1, product.getName());
            stmt.setString(2, product.getCategory());
            stmt.setInt(3, product.getStockQty());
            stmt.setBigDecimal(4, product.getUnitPrice());

            if (product.getExpiryDate() != null) {
                stmt.setDate(5, Date.valueOf(product.getExpiryDate()));
            } else {
                stmt.setNull(5, Types.DATE);
            }

            stmt.setInt(6, product.getProductId());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error updating product: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }

    /**
     * Delete product
     */
    public boolean deleteProduct(int productId) throws Exception {
        try (PreparedStatement stmt = conn.prepareStatement(DELETE_PRODUCT)) {

            stmt.setInt(1, productId);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error deleting product: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }

    /**
     * Get low stock products
     */
    public List<Product> getLowStockProducts(int threshold) throws Exception {
        List<Product> products = new ArrayList<>();

        try (PreparedStatement stmt = conn.prepareStatement(SELECT_LOW_STOCK)) {

            stmt.setInt(1, threshold);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }

        } catch (SQLException e) {
            System.err.println("Error getting low stock products: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }

        return products;
    }

    /**
     * Get expiring products
     */
    public List<Product> getExpiringProducts(int days) throws Exception {
        List<Product> products = new ArrayList<>();
        LocalDate cutoffDate = LocalDate.now().plusDays(days);

        try (PreparedStatement stmt = conn.prepareStatement(SELECT_EXPIRING)) {

            stmt.setDate(1, Date.valueOf(cutoffDate));
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }

        } catch (SQLException e) {
            System.err.println("Error getting expiring products: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }

        return products;
    }

    /**
     * Get products by category
     */
    public List<Product> getProductsByCategory(String category) throws Exception {
        List<Product> products = new ArrayList<>();

        try (PreparedStatement stmt = conn.prepareStatement(SELECT_BY_CATEGORY)) {

            stmt.setString(1, category);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }

        } catch (SQLException e) {
            System.err.println("Error getting products by category: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }

        return products;
    }

    /**
     * Update stock quantity (for sales)
     */
    public boolean updateStock(int productId, int quantitySold) throws Exception {
        try (PreparedStatement stmt = conn.prepareStatement(UPDATE_STOCK)) {

            stmt.setInt(1, quantitySold);
            stmt.setInt(2, productId);

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error updating stock: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }

    /**
     * Map ResultSet to Product object
     */
    private Product mapResultSetToProduct(ResultSet rs) throws SQLException {
        Product product = new Product();
        product.setProductId(rs.getInt("product_id"));
        product.setName(rs.getString("name"));
        product.setCategory(rs.getString("category"));
        product.setStockQty(rs.getInt("stock_qty"));
        product.setUnitPrice(rs.getBigDecimal("unit_price"));

        Date expiryDate = rs.getDate("expiry_date");
        if (expiryDate != null) {
            product.setExpiryDate(expiryDate.toLocalDate());
        }

        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            product.setCreatedAt(createdAt.toLocalDateTime());
        }

        return product;
    }
}
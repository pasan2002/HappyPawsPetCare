package com.happypaws.petcare.model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * Product model class representing inventory items
 * Location: src/main/java/com/happypaws/model/Product.java
 */
public class Product {
    private int productId;
    private String name;
    private String category;
    private int stockQty;
    private BigDecimal unitPrice;
    private LocalDate expiryDate;
    private LocalDateTime createdAt;

    // Constructors
    public Product() {}

    public Product(String name, String category, int stockQty, BigDecimal unitPrice, LocalDate expiryDate) {
        this.name = name;
        this.category = category;
        this.stockQty = stockQty;
        this.unitPrice = unitPrice;
        this.expiryDate = expiryDate;
    }

    public Product(int productId, String name, String category, int stockQty,
                   BigDecimal unitPrice, LocalDate expiryDate, LocalDateTime createdAt) {
        this.productId = productId;
        this.name = name;
        this.category = category;
        this.stockQty = stockQty;
        this.unitPrice = unitPrice;
        this.expiryDate = expiryDate;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public int getStockQty() {
        return stockQty;
    }

    public void setStockQty(int stockQty) {
        this.stockQty = stockQty;
    }

    public BigDecimal getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(BigDecimal unitPrice) {
        this.unitPrice = unitPrice;
    }

    public LocalDate getExpiryDate() {
        return expiryDate;
    }

    public void setExpiryDate(LocalDate expiryDate) {
        this.expiryDate = expiryDate;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    // Utility methods
    public boolean isLowStock(int threshold) {
        return stockQty <= threshold;
    }

    public boolean isExpired() {
        return expiryDate != null && expiryDate.isBefore(LocalDate.now());
    }

    public boolean isExpiringSoon(int days) {
        return expiryDate != null && expiryDate.isBefore(LocalDate.now().plusDays(days));
    }


    // Add this method to Product.java after the existing getters
    public String getFormattedExpiryDate() {
        if (expiryDate != null) {
            return expiryDate.format(java.time.format.DateTimeFormatter.ofPattern("MMM dd, yyyy"));
        }
        return null;
    }

    public String getFormattedCreatedAt() {
        if (createdAt != null) {
            return createdAt.format(java.time.format.DateTimeFormatter.ofPattern("MMM dd, yyyy HH:mm"));
        }
        return null;
    }

    @Override
    public String toString() {
        return "Product{" +
                "productId=" + productId +
                ", name='" + name + '\'' +
                ", category='" + category + '\'' +
                ", stockQty=" + stockQty +
                ", unitPrice=" + unitPrice +
                ", expiryDate=" + expiryDate +
                ", createdAt=" + createdAt +
                '}';
    }
}
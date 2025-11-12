package com.happypaws.petcare.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Sale model class representing a sale transaction
 * Location: src/main/java/com/happypaws/model/Sale.java
 */
public class Sale {
    private int saleId;
    private LocalDateTime saleDate;
    private BigDecimal totalAmount;
    private LocalDateTime createdAt;


    // Constructors
    public Sale() {}

    public Sale(LocalDateTime saleDate, BigDecimal totalAmount) {
        this.saleDate = saleDate;
        this.totalAmount = totalAmount;
    }

    // Getters and Setters
    public int getSaleId() {
        return saleId;
    }

    public void setSaleId(int saleId) {
        this.saleId = saleId;
    }

    public LocalDateTime getSaleDate() {
        return saleDate;
    }

    public void setSaleDate(LocalDateTime saleDate) {
        this.saleDate = saleDate;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public String getFormattedSaleDate() {
        if (saleDate != null) {
            return saleDate.format(java.time.format.DateTimeFormatter.ofPattern("MMM dd, yyyy HH:mm"));
        }
        return null;
    }

    @Override
    public String toString() {
        return "Sale{" +
                "saleId=" + saleId +
                ", saleDate=" + saleDate +
                ", totalAmount=" + totalAmount +
                ", createdAt=" + createdAt +
                '}';
    }
}
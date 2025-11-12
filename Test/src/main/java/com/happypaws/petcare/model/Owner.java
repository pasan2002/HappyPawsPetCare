package com.happypaws.petcare.model;

import java.time.LocalDateTime;

public class Owner {
    private Integer ownerId;
    private String fullName;
    private String email;
    private String phone;
    private String passwordHash;
    private LocalDateTime createdAt;

    public Owner() {}

    public Owner(Integer ownerId, String full_name, String email, String phone, String passwordHash, LocalDateTime createdAt) {
        this.ownerId = ownerId;
        this.fullName = full_name;
        this.email = email;
        this.phone = phone;
        this.passwordHash = passwordHash;
        this.createdAt = createdAt;
    }

    public Owner(Integer ownerId, String fullName, String email, String phone, String passwordHash) {
        this.ownerId = ownerId;
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.passwordHash = passwordHash;
    }

    public Integer getOwnerId() {
        return ownerId;
    }

    public void setOwnerId(Integer ownerId) {
        this.ownerId = ownerId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "Model.AppointmentManagement.Owner{" +
                "ownerId=" + ownerId +
                ", fullName='" + fullName + '\'' +
                ", email='" + email + '\'' +
                ", phone='" + phone + '\'' +
                ", passwordHash='" + passwordHash + '\''+
                ", createdAt=" + createdAt +
                '}';
    }
}



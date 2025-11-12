package com.happypaws.petcare.dao.appointment;

import com.happypaws.petcare.model.Staff;
import com.happypaws.petcare.config.DB;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO class for appointment-related staff operations
 * Handles staff search functionality for appointment booking
 */
public class AppointmentStaffDAO {
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
    
    private static Staff map(ResultSet rs) throws SQLException {
        Staff s = new Staff();
        s.setStaffId(rs.getInt("staff_id"));
        s.setFullName(rs.getString("full_name"));
        s.setRole(rs.getString("role"));
        s.setEmail(rs.getString("email"));
        s.setPhone(rs.getString("phone"));
        s.setPasswordHash(rs.getString("password_hash"));
        Timestamp ts = rs.getTimestamp("created_at");
        s.setCreatedAt(ts != null ? ts.toLocalDateTime() : null);
        return s;
    }
    
    /**
     * Get all staff members for appointment booking
     * @return List of all staff members
     */
    public List<Staff> getAllStaff() throws Exception {
        List<Staff> staffList = new ArrayList<>();
        String sql = "SELECT staff_id, full_name, role, email, phone, password_hash, created_at " +
                    "FROM dbo.staff ORDER BY full_name";
        
        try (
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                staffList.add(map(rs));
            }
        }
        
        return staffList;
    }
    
    /**
     * Search staff by name for appointment booking
     * @param searchTerm The search term to match against staff name
     * @return List of matching staff members
     */
    public List<Staff> searchStaff(String searchTerm) throws Exception {
        List<Staff> staffList = new ArrayList<>();
        String sql = "SELECT staff_id, full_name, role, email, phone, password_hash, created_at " +
                    "FROM dbo.staff WHERE full_name LIKE ? ORDER BY full_name";
        
        try (
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, "%" + searchTerm + "%");
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    staffList.add(map(rs));
                }
            }
        }
        
        return staffList;
    }
    
    /**
     * Get staff by role for appointment booking
     * @param role The role to filter by
     * @return List of staff members with the specified role
     */
    public List<Staff> getStaffByRole(String role) throws Exception {
        List<Staff> staffList = new ArrayList<>();
        String sql = "SELECT staff_id, full_name, role, email, phone, password_hash, created_at " +
                    "FROM dbo.staff WHERE role = ? ORDER BY full_name";
        
        try (
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, role);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    staffList.add(map(rs));
                }
            }
        }
        
        return staffList;
    }
}
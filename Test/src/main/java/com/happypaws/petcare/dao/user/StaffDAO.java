package com.happypaws.petcare.dao.user;

import com.happypaws.petcare.model.Staff;
import com.happypaws.petcare.config.DB;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class StaffDAO {
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
     * Get all staff members
     */
    public static List<Staff> getAll() throws Exception {
        final String SQL = "SELECT staff_id, full_name, role, email, phone, password_hash, created_at " +
                "FROM dbo.staff ORDER BY full_name";
        List<Staff> staffList = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(SQL);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                staffList.add(map(rs));
            }
        }
        return staffList;
    }


    public static Staff findByEmail(String email) throws Exception {
        final String SQL = "SELECT staff_id, full_name, role, email, phone, password_hash, created_at " +
                "FROM dbo.staff WHERE email = ?";
        try (
             PreparedStatement ps = conn.prepareStatement(SQL)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        }
    }
}
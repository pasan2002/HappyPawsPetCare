package com.happypaws.petcare.dao.user;

import com.happypaws.petcare.model.Staff;
import com.happypaws.petcare.config.DB;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class StaffManagementDAO {
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

    // CREATE - Add new staff with duplicate email check
    public boolean addStaff(Staff staff) {
        // First check if email already exists
        if (isEmailExists(staff.getEmail())) {
            return false;
        }

        String sql = "INSERT INTO staff (full_name, role, email, phone, password_hash, created_at) VALUES (?, ?, ?, ?, ?, ?)";

        try (
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, staff.getFullName());
            stmt.setString(2, staff.getRole());
            stmt.setString(3, staff.getEmail());
            stmt.setString(4, staff.getPhone());
            stmt.setString(5, staff.getPasswordHash());
            stmt.setTimestamp(6, Timestamp.valueOf(LocalDateTime.now()));
            
            return stmt.executeUpdate() > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // READ - Get all staff
    public List<Staff> getAllStaff() {
        List<Staff> staffList = new ArrayList<>();
        String sql = "SELECT staff_id, full_name, role, email, phone, password_hash, created_at FROM staff ORDER BY staff_id DESC";

        try (
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                staffList.add(extractStaffFromResultSet(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return staffList;
    }

    // READ - Get staff by ID
    public Staff getStaffById(int id) {
        String sql = "SELECT staff_id, full_name, role, email, phone, password_hash, created_at FROM staff WHERE staff_id = ?";

        try (
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return extractStaffFromResultSet(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // READ - Get staff by email
    public Staff getStaffByEmail(String email) {
        String sql = "SELECT staff_id, full_name, role, email, phone, password_hash, created_at FROM staff WHERE email = ?";

        try (
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return extractStaffFromResultSet(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // READ - Search staff by name
    public List<Staff> searchStaffByName(String name) {
        List<Staff> staffList = new ArrayList<>();
        String sql = "SELECT staff_id, full_name, role, email, phone, password_hash, created_at FROM staff WHERE full_name LIKE ? ORDER BY full_name";

        try (
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, "%" + name + "%");
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                staffList.add(extractStaffFromResultSet(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return staffList;
    }

    // READ - Get staff by role
    public List<Staff> getStaffByRole(String role) {
        List<Staff> staffList = new ArrayList<>();
        String sql = "SELECT staff_id, full_name, role, email, phone, password_hash, created_at FROM staff WHERE role = ? ORDER BY full_name";

        try (
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, role);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                staffList.add(extractStaffFromResultSet(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return staffList;
    }

    // UPDATE - Update staff (with email duplicate check for other records)
    public boolean updateStaff(Staff staff) {
        // Check if email exists for other staff
        if (isEmailExistsForOtherStaff(staff.getEmail(), staff.getStaffId())) {
            return false;
        }

        String sql = "UPDATE staff SET full_name = ?, role = ?, email = ?, phone = ? WHERE staff_id = ?";

        try (
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, staff.getFullName());
            stmt.setString(2, staff.getRole());
            stmt.setString(3, staff.getEmail());
            stmt.setString(4, staff.getPhone());
            stmt.setInt(5, staff.getStaffId());
            
            return stmt.executeUpdate() > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // UPDATE - Update staff password only
    public boolean updateStaffPassword(int staffId, String newPasswordHash) {
        String sql = "UPDATE staff SET password_hash = ? WHERE staff_id = ?";

        try (
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, newPasswordHash);
            stmt.setInt(2, staffId);
            
            return stmt.executeUpdate() > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // UPDATE - Update staff role only
    public boolean updateStaffRole(int staffId, String newRole) {
        String sql = "UPDATE staff SET role = ? WHERE staff_id = ?";

        try (
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, newRole);
            stmt.setInt(2, staffId);
            
            return stmt.executeUpdate() > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // DELETE - Delete staff
    public boolean deleteStaff(int id) {
        String sql = "DELETE FROM staff WHERE staff_id = ?";

        try (
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // VALIDATION - Check if email exists
    public boolean isEmailExists(String email) {
        String sql = "SELECT COUNT(*) FROM staff WHERE email = ?";

        try (
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // VALIDATION - Check if email exists for other staff (for updates)
    public boolean isEmailExistsForOtherStaff(String email, int currentStaffId) {
        String sql = "SELECT COUNT(*) FROM staff WHERE email = ? AND staff_id != ?";

        try (
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, email);
            stmt.setInt(2, currentStaffId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // STATISTICS - Get total staff count
    public int getTotalStaffCount() {
        String sql = "SELECT COUNT(*) FROM staff";

        try (
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // STATISTICS - Get unique roles count
    public int getUniqueRolesCount() {
        String sql = "SELECT COUNT(DISTINCT role) FROM staff";

        try (
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Helper method to extract Staff from ResultSet
    private Staff extractStaffFromResultSet(ResultSet rs) throws SQLException {
        Staff staff = new Staff();
        staff.setStaffId(rs.getInt("staff_id"));
        staff.setFullName(rs.getString("full_name"));
        staff.setRole(rs.getString("role"));
        staff.setEmail(rs.getString("email"));
        staff.setPhone(rs.getString("phone"));
        staff.setPasswordHash(rs.getString("password_hash"));
        
        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            staff.setCreatedAt(createdAt.toLocalDateTime());
        }
        
        return staff;
    }
}
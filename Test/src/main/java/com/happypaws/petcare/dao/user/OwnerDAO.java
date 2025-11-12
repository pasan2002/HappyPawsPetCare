package com.happypaws.petcare.dao.user;

import com.happypaws.petcare.model.Owner;
import com.happypaws.petcare.config.DB;

import java.sql.*;
import java.util.*;

public class OwnerDAO {
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

    private static Owner map(ResultSet rs) throws SQLException {
        Owner o = new Owner();
        o.setOwnerId(rs.getInt("ownerId"));
        o.setFullName(rs.getString("fullName"));
        o.setEmail(rs.getString("email"));
        o.setPhone(rs.getString("phone"));
        o.setPasswordHash(rs.getString("passwordHash"));
        Timestamp ts = rs.getTimestamp("createdAt");
        o.setCreatedAt(ts != null ? ts.toLocalDateTime() : null);
        return o;
    }

    public static List<Owner> getAll() throws Exception {
        final String SQL = "SELECT ownerId, fullName, email, phone, passwordHash, createdAt FROM owners";
        List<Owner> owners = new ArrayList<>();
        try (
             PreparedStatement ps = conn.prepareStatement(SQL);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) owners.add(map(rs));
        } catch (SQLException e) {
            throw new RuntimeException("Servlet.DB error while fetching owners.", e);
        }
        return owners;
    }

    public static Owner findByEmail(String email) throws Exception {
        final String SQL = "SELECT ownerId, fullName, email, phone, passwordHash, createdAt FROM owners WHERE email = ?";
        try (
             PreparedStatement ps = conn.prepareStatement(SQL)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        }
    }

    public static Owner findById(Integer ownerId) throws Exception {
        if (ownerId == null) return null;
        final String SQL = "SELECT ownerId, fullName, email, phone, passwordHash, createdAt FROM owners WHERE ownerId = ?";
        try (
             PreparedStatement ps = conn.prepareStatement(SQL)) {
            ps.setInt(1, ownerId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        }
    }

    public static boolean emailExists(String email) throws Exception {
        final String SQL = "SELECT 1 FROM owners WHERE email = ?";
        try (
             PreparedStatement ps = conn.prepareStatement(SQL)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public static void insert(Owner user) {
        final String SQL = "INSERT INTO dbo.owners (fullName, email, phone, passwordHash) " +
                "OUTPUT INSERTED.ownerId, INSERTED.createdAt VALUES (?,?,?,?)";
        try (
             PreparedStatement ps = conn.prepareStatement(SQL)) {
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone());
            ps.setString(4, user.getPasswordHash());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    user.setOwnerId(rs.getInt("ownerId"));
                    Timestamp ts = rs.getTimestamp("createdAt");
                    user.setCreatedAt(ts != null ? ts.toLocalDateTime() : null);
                } else {
                    throw new SQLException("Insert failed: OUTPUT INSERTED returned no row.");
                }
            }
        } catch (SQLException e) {
            if (e.getErrorCode() == 2627 || e.getErrorCode() == 2601) {
                throw new RuntimeException("Email already exists.", e);
            }
            throw new RuntimeException("Servlet.DB error while inserting owner.", e);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public static boolean update(Owner owner) throws Exception {
        final String SQL = "UPDATE owners SET fullName = ?, email = ?, phone = ? WHERE ownerId = ?";
        try (
             PreparedStatement ps = conn.prepareStatement(SQL)) {
            ps.setString(1, owner.getFullName());
            ps.setString(2, owner.getEmail());
            ps.setString(3, owner.getPhone());
            ps.setInt(4, owner.getOwnerId());
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            if (e.getErrorCode() == 2627 || e.getErrorCode() == 2601) {
                throw new RuntimeException("Email already exists.", e);
            }
            throw new RuntimeException("DB error while updating owner.", e);
        }
    }

    public static boolean updatePassword(int ownerId, String newPasswordHash) throws Exception {
        final String SQL = "UPDATE owners SET passwordHash = ? WHERE ownerId = ?";
        try (
             PreparedStatement ps = conn.prepareStatement(SQL)) {
            ps.setString(1, newPasswordHash);
            ps.setInt(2, ownerId);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            throw new RuntimeException("DB error while updating password.", e);
        }
    }
}
package com.happypaws.petcare.dao.grooming;

import com.happypaws.petcare.model.GroomingSession;
import com.happypaws.petcare.config.DB;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class GroomingSessionDAO {
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

    private static GroomingSession map(ResultSet rs) throws SQLException {
        GroomingSession session = new GroomingSession();
        session.setSessionId(rs.getInt("session_id"));
        session.setPetUid(rs.getString("pet_uid"));  // uniqueidentifier
        session.setStaffId(rs.getInt("staff_id"));
        
        Timestamp sessionTime = null;
        try {
            sessionTime = rs.getTimestamp("session_time");
        } catch (SQLException ignored) {}
        session.setSessionTime(sessionTime != null ? sessionTime.toLocalDateTime() : null);
        
        String serviceType = null;
        try {
            serviceType = rs.getString("service_type");
        } catch (SQLException ignored) {}
        session.setServiceType(serviceType);
        
        String notes = null;
        try {
            notes = rs.getString("notes");
        } catch (SQLException ignored) {}
        session.setNotes(notes);
        
        // Additional display fields
        try {
            session.setPetName(rs.getString("pet_name"));
        } catch (SQLException ignored) {}
        
        try {
            session.setStaffName(rs.getString("staff_name"));
        } catch (SQLException ignored) {}
        
        try {
            session.setSpecies(rs.getString("species"));
        } catch (SQLException ignored) {}
        
        return session;
    }

    public static List<GroomingSession> getAll() throws Exception {
        final String SQL = "SELECT gs.session_id, gs.pet_uid, gs.staff_id, gs.session_time, " +
                          "gs.service_type, gs.notes, " +
                          "p.name as pet_name, p.species, " +
                          "s.full_name as staff_name " +
                          "FROM dbo.grooming_sessions gs " +
                          "LEFT JOIN pets p ON gs.pet_uid = p.pet_uid " +
                          "LEFT JOIN staff s ON gs.staff_id = s.staff_id " +
                          "ORDER BY gs.session_time DESC";
        
        try (PreparedStatement ps = conn.prepareStatement(SQL);
             ResultSet rs = ps.executeQuery()) {
            List<GroomingSession> list = new ArrayList<>();
            while (rs.next()) {
                list.add(map(rs));
            }
            return list;
        }
    }

    public static GroomingSession findById(int sessionId) throws Exception {
        final String SQL = "SELECT gs.session_id, gs.pet_uid, gs.staff_id, gs.session_time, " +
                          "gs.service_type, gs.notes, " +
                          "p.name as pet_name, p.species, " +
                          "s.full_name as staff_name " +
                          "FROM dbo.grooming_sessions gs " +
                          "LEFT JOIN pets p ON gs.pet_uid = p.pet_uid " +
                          "LEFT JOIN staff s ON gs.staff_id = s.staff_id " +
                          "WHERE gs.session_id = ?";
        
        try (PreparedStatement ps = conn.prepareStatement(SQL)) {
            ps.setInt(1, sessionId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        }
    }

    public static List<GroomingSession> findByPetUid(String petUid) throws Exception {
        final String SQL = "SELECT gs.session_id, gs.pet_uid, gs.staff_id, gs.session_time, " +
                          "gs.service_type, gs.notes, " +
                          "p.name as pet_name, p.species, " +
                          "s.full_name as staff_name " +
                          "FROM dbo.grooming_sessions gs " +
                          "LEFT JOIN pets p ON gs.pet_uid = p.pet_uid " +
                          "LEFT JOIN staff s ON gs.staff_id = s.staff_id " +
                          "WHERE gs.pet_uid = ? " +
                          "ORDER BY gs.session_time DESC";
        
        try (PreparedStatement ps = conn.prepareStatement(SQL)) {
            ps.setString(1, petUid);
            try (ResultSet rs = ps.executeQuery()) {
                List<GroomingSession> list = new ArrayList<>();
                while (rs.next()) {
                    list.add(map(rs));
                }
                return list;
            }
        }
    }

    public static List<GroomingSession> findByStaffId(int staffId) throws Exception {
        final String SQL = "SELECT gs.session_id, gs.pet_uid, gs.staff_id, gs.session_time, " +
                          "gs.service_type, gs.notes, " +
                          "p.name as pet_name, p.species, " +
                          "s.full_name as staff_name " +
                          "FROM dbo.grooming_sessions gs " +
                          "LEFT JOIN pets p ON gs.pet_uid = p.pet_uid " +
                          "LEFT JOIN staff s ON gs.staff_id = s.staff_id " +
                          "WHERE gs.staff_id = ? " +
                          "ORDER BY gs.session_time DESC";
        
        try (PreparedStatement ps = conn.prepareStatement(SQL)) {
            ps.setInt(1, staffId);
            try (ResultSet rs = ps.executeQuery()) {
                List<GroomingSession> list = new ArrayList<>();
                while (rs.next()) {
                    list.add(map(rs));
                }
                return list;
            }
        }
    }

    public static void insert(GroomingSession session) throws Exception {
        final String SQL = "INSERT INTO dbo.grooming_sessions (pet_uid, staff_id, session_time, service_type, notes) " +
                          "VALUES (?, ?, ?, ?, ?)";
        
        try (PreparedStatement ps = conn.prepareStatement(SQL)) {
            ps.setString(1, session.getPetUid());  // uniqueidentifier
            ps.setInt(2, session.getStaffId());
            
            if (session.getSessionTime() != null) {
                ps.setTimestamp(3, Timestamp.valueOf(session.getSessionTime()));
            } else {
                ps.setNull(3, Types.TIMESTAMP);
            }
            
            ps.setString(4, session.getServiceType());
            ps.setString(5, session.getNotes());
            
            ps.executeUpdate();
        }
    }

    public static void update(GroomingSession session) throws Exception {
        final String SQL = "UPDATE dbo.grooming_sessions " +
                          "SET pet_uid = ?, staff_id = ?, session_time = ?, service_type = ?, notes = ? " +
                          "WHERE session_id = ?";
        
        try (PreparedStatement ps = conn.prepareStatement(SQL)) {
            ps.setString(1, session.getPetUid());  // uniqueidentifier
            ps.setInt(2, session.getStaffId());
            
            if (session.getSessionTime() != null) {
                ps.setTimestamp(3, Timestamp.valueOf(session.getSessionTime()));
            } else {
                ps.setNull(3, Types.TIMESTAMP);
            }
            
            ps.setString(4, session.getServiceType());
            ps.setString(5, session.getNotes());
            ps.setInt(6, session.getSessionId());
            
            ps.executeUpdate();
        }
    }

    public static void delete(int sessionId) throws Exception {
        final String SQL = "DELETE FROM dbo.grooming_sessions WHERE session_id = ?";
        
        try (PreparedStatement ps = conn.prepareStatement(SQL)) {
            ps.setInt(1, sessionId);
            ps.executeUpdate();
        }
    }
}

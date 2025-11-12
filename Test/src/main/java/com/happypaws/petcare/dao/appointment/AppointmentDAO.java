package com.happypaws.petcare.dao.appointment;

import com.happypaws.petcare.model.Appointment;
import com.happypaws.petcare.config.DB;

import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class  AppointmentDAO {
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

    private static Appointment mapRow(ResultSet rs) throws SQLException {
        Appointment a = new Appointment();
        a.setAppointmentId(rs.getInt("appointment_id"));
        a.setPetUid(rs.getString("pet_uid"));
        a.setOwnerId(rs.getInt("owner_id"));
        int staff = rs.getInt("staff_id");
        a.setStaffId(rs.wasNull() ? null : staff);
        a.setType(rs.getString("type"));

        Timestamp ts = rs.getTimestamp("scheduled_at");
        a.setScheduledAt(ts != null ? ts.toLocalDateTime() : null);

        a.setStatus(rs.getString("status"));

        Timestamp cts = rs.getTimestamp("created_at");
        a.setCreatedAt(cts != null ? cts.toLocalDateTime() : null);

        a.setPhoneNo(rs.getString("phoneNo"));

        BigDecimal fee = rs.getBigDecimal("fee");
        a.setFee(fee);

        a.setPaymentMethod(rs.getString("payment_method"));
        a.setPaymentStatus(rs.getString("payment_status"));
        a.setPaymentRef(rs.getString("payment_ref"));

        Timestamp paidTs = rs.getTimestamp("paid_at");
        a.setPaidAt(paidTs != null ? paidTs.toLocalDateTime() : null);

        // Handle reminder_sent column safely (might not exist in older databases)
        try {
            boolean reminderSent = rs.getBoolean("reminder_sent");
            a.setReminderSent(rs.wasNull() ? Boolean.FALSE : reminderSent);
        } catch (SQLException e) {
            // Column doesn't exist, default to false
            a.setReminderSent(Boolean.FALSE);
        }

        // Handle reminder_count column safely (might not exist in older databases)
        try {
            int reminderCount = rs.getInt("reminder_count");
            a.setReminderCount(rs.wasNull() ? 0 : reminderCount);
        } catch (SQLException e) {
            // Column doesn't exist, default to 0
            a.setReminderCount(0);
        }

        return a;
    }

    /*
        Insert appointment to the appointments table.
     */
    public static void insert(Appointment appt) throws Exception {
        final String SQL = "INSERT INTO appointments " +
                "(pet_uid, owner_id, staff_id, type, scheduled_at, status, phoneNo, " +
                " fee, payment_method, payment_status, payment_ref, paid_at) " +
                "VALUES (?,?,?,?,?,?,?,?,?,?,?,?)";
        try (
             PreparedStatement ps = conn.prepareStatement(SQL, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, appt.getPetUid());
            ps.setInt(2, appt.getOwnerId());
            if (appt.getStaffId() == null) ps.setNull(3, Types.INTEGER); else ps.setInt(3, appt.getStaffId());
            ps.setString(4, appt.getType());
            ps.setTimestamp(5, appt.getScheduledAt() != null ? Timestamp.valueOf(appt.getScheduledAt()) : null);
            ps.setString(6, appt.getStatus());
            if (appt.getPhoneNo() == null || appt.getPhoneNo().isBlank()) ps.setNull(7, Types.VARCHAR);
            else ps.setString(7, appt.getPhoneNo());

            if (appt.getFee() == null) ps.setNull(8, Types.DECIMAL); else ps.setBigDecimal(8, appt.getFee());
            if (appt.getPaymentMethod() == null) ps.setNull(9, Types.VARCHAR); else ps.setString(9, appt.getPaymentMethod());
            ps.setString(10, appt.getPaymentStatus() == null ? "unpaid" : appt.getPaymentStatus());
            if (appt.getPaymentRef() == null) ps.setNull(11, Types.VARCHAR); else ps.setString(11, appt.getPaymentRef());
            if (appt.getPaidAt() == null) ps.setNull(12, Types.TIMESTAMP); else ps.setTimestamp(12, Timestamp.valueOf(appt.getPaidAt()));

            ps.executeUpdate();

            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) appt.setAppointmentId(keys.getInt(1));
            }
            Appointment fresh = findById(appt.getAppointmentId());
            if (fresh != null) appt.setCreatedAt(fresh.getCreatedAt());
        }
    }

    public static Appointment findById(int id) throws SQLException {
        final String SQL = "SELECT * FROM appointments WHERE appointment_id=?";
        try (
             PreparedStatement ps = conn.prepareStatement(SQL)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapRow(rs) : null;
            }
        } catch (java.sql.SQLException e) {
            // Log the specific SQL error
            System.err.println("Database error in findById for appointment " + id + ": " + e.getMessage());
            throw new RuntimeException("Database connection error: " + e.getMessage(), e);
        } catch (Exception e) {
            System.err.println("Unexpected error in findById for appointment " + id + ": " + e.getMessage());
            throw new RuntimeException("Database access error: " + e.getMessage(), e);
        }
    }

    public static List<Appointment> getAll() throws Exception {
        final String SQL = "SELECT * FROM appointments ORDER BY scheduled_at DESC";
        List<Appointment> list = new ArrayList<>();
        try (
             PreparedStatement ps = conn.prepareStatement(SQL);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    public static List<Appointment> search(String petUid, String type, String status) throws Exception {
        StringBuilder sql = new StringBuilder("SELECT * FROM appointments");
        List<Object> params = new ArrayList<>();
        List<String> where = new ArrayList<>();

        if (petUid != null && !petUid.isBlank()) { where.add("pet_uid = ?"); params.add(petUid); }
        if (type != null && !type.isBlank()) { where.add("type = ?"); params.add(type); }
        if (status != null && !status.isBlank()) { where.add("LOWER(status) = LOWER(?)"); params.add(status); }

        if (!where.isEmpty()) sql.append(" WHERE ").append(String.join(" AND ", where));
        sql.append(" ORDER BY scheduled_at DESC");

        try (
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) ps.setObject(i + 1, params.get(i));
            try (ResultSet rs = ps.executeQuery()) {
                List<Appointment> list = new ArrayList<>();
                while (rs.next()) list.add(mapRow(rs));
                return list;
            }
        }
    }

    public static List<Appointment> findByOwner(int ownerId, String type, String status) throws Exception {
        StringBuilder sql = new StringBuilder("SELECT * FROM appointments WHERE owner_id = ?");
        List<Object> params = new ArrayList<>();
        params.add(ownerId);

        if (type != null && !type.isBlank()) { sql.append(" AND type = ?"); params.add(type); }
        if (status != null && !status.isBlank()) { sql.append(" AND LOWER(status) = LOWER(?)"); params.add(status); }

        sql.append(" ORDER BY scheduled_at DESC");

        try (
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) ps.setObject(i + 1, params.get(i));
            try (ResultSet rs = ps.executeQuery()) {
                List<Appointment> list = new ArrayList<>();
                while (rs.next()) list.add(mapRow(rs));
                return list;
            }
        }
    }

    public static Appointment findByIdForOwner(int appointmentId, int ownerId) throws Exception {
        final String SQL = "SELECT * FROM appointments WHERE appointment_id=? AND owner_id=?";
        try (
             PreparedStatement ps = conn.prepareStatement(SQL)) {
            ps.setInt(1, appointmentId);
            ps.setInt(2, ownerId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapRow(rs) : null;
            }
        }
    }

    public static void markPaid(int appointmentId, String ref) throws Exception {
        final String SQL =
                "UPDATE appointments " +
                        "SET payment_status='paid', payment_method='online', payment_ref=?, paid_at=SYSDATETIME() " +
                        "WHERE appointment_id=?";
        try (
             PreparedStatement ps = conn.prepareStatement(SQL)) {
            ps.setString(1, ref);
            ps.setInt(2, appointmentId);
            ps.executeUpdate();
        }
    }


    public static void update(Appointment appt) throws SQLException {
        if (appt.getAppointmentId() == null) throw new SQLException("appointment_id required");

        Appointment current = findById(appt.getAppointmentId());
        if (current == null) throw new SQLException("Model.AppointmentManagement.Appointment not found");

        String type       = appt.getType() != null ? appt.getType() : current.getType();
        LocalDateTime when= appt.getScheduledAt() != null ? appt.getScheduledAt() : current.getScheduledAt();
        String status     = appt.getStatus() != null ? appt.getStatus() : current.getStatus();
        Integer staffId   = appt.getStaffId() != null ? appt.getStaffId() : current.getStaffId();
        String phoneNo    = appt.getPhoneNo() != null ? appt.getPhoneNo() : current.getPhoneNo();

        BigDecimal fee    = appt.getFee() != null ? appt.getFee() : current.getFee();
        String payMethod  = appt.getPaymentMethod() != null ? appt.getPaymentMethod() : current.getPaymentMethod();
        String payStatus  = appt.getPaymentStatus() != null ? appt.getPaymentStatus() : current.getPaymentStatus();
        String payRef     = appt.getPaymentRef() != null ? appt.getPaymentRef() : current.getPaymentRef();
        LocalDateTime paidAt = appt.getPaidAt() != null ? appt.getPaidAt() : current.getPaidAt();

        final String SQL = "UPDATE appointments SET type=?, scheduled_at=?, status=?, staff_id=?, phoneNo=?, " +
                "fee=?, payment_method=?, payment_status=?, payment_ref=?, paid_at=? WHERE appointment_id=?";
        try (
             PreparedStatement ps = conn.prepareStatement(SQL)) {
            ps.setString(1, type);
            ps.setTimestamp(2, when != null ? Timestamp.valueOf(when) : null);
            ps.setString(3, status);
            if (staffId == null) ps.setNull(4, Types.INTEGER); else ps.setInt(4, staffId);
            if (phoneNo == null || phoneNo.isBlank()) ps.setNull(5, Types.VARCHAR); else ps.setString(5, phoneNo);

            if (fee == null) ps.setNull(6, Types.DECIMAL); else ps.setBigDecimal(6, fee);
            if (payMethod == null) ps.setNull(7, Types.VARCHAR); else ps.setString(7, payMethod);
            ps.setString(8, payStatus);
            if (payRef == null) ps.setNull(9, Types.VARCHAR); else ps.setString(9, payRef);
            if (paidAt == null) ps.setNull(10, Types.TIMESTAMP); else ps.setTimestamp(10, Timestamp.valueOf(paidAt));

            ps.setInt(11, appt.getAppointmentId());
            ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    /**
     * Automatically cancel appointments where the scheduled date has passed
     * and the status is still 'pending' or 'confirmed'
     */
    public static int cancelExpiredAppointments() throws SQLException {
        final String SQL = "UPDATE appointments SET status='cancelled' " +
                "WHERE CAST(scheduled_at AS DATE) < CAST(GETDATE() AS DATE) " +
                "AND status IN ('pending', 'confirmed')";
        
        try (
             PreparedStatement ps = conn.prepareStatement(SQL)) {
            return ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public static void delete(int id) throws Exception {
        final String SQL = "DELETE FROM appointments WHERE appointment_id=?";
        try (
             PreparedStatement ps = conn.prepareStatement(SQL)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    /**
     * Count appointments for a specific pet on a specific date
     * Used for daily appointment limit validation
     */
    public static int countAppointmentsByPetAndDate(String petUid, java.time.LocalDate appointmentDate) throws Exception {
        final String SQL = "SELECT COUNT(*) FROM appointments WHERE pet_uid = ? AND CAST(scheduled_at AS DATE) = ? AND status != 'cancelled'";
        try (
             PreparedStatement ps = conn.prepareStatement(SQL)) {
            ps.setString(1, petUid);
            ps.setDate(2, java.sql.Date.valueOf(appointmentDate));
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
                return 0;
            }
        }
    }

    /**
     * Mark reminder as sent for an appointment and increment count
     */
    public static void markReminderSent(int appointmentId) throws SQLException {
        final String SQL = "UPDATE appointments SET reminder_sent = 1, reminder_count = COALESCE(reminder_count, 0) + 1 WHERE appointment_id = ?";
        try (
             PreparedStatement ps = conn.prepareStatement(SQL)) {
            ps.setInt(1, appointmentId);
            ps.executeUpdate();
        } catch (SQLException e) {
            // If columns don't exist, try simpler update (for backwards compatibility)
            if (e.getMessage().contains("reminder_sent") || e.getMessage().contains("reminder_count")) {
                // Try fallback update with just reminder_sent
                final String FALLBACK_SQL = "UPDATE appointments SET reminder_sent = 1 WHERE appointment_id = ?";
                try (
                     PreparedStatement ps = conn.prepareStatement(FALLBACK_SQL)) {
                    ps.setInt(1, appointmentId);
                    ps.executeUpdate();
                } catch (SQLException fallbackError) {
                    // If even that fails, ignore (column doesn't exist)
                    if (!fallbackError.getMessage().contains("reminder_sent")) {
                        throw fallbackError;
                    }
                } catch (Exception ex) {
                    throw new RuntimeException(ex);
                }
            } else {
                throw e;
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}
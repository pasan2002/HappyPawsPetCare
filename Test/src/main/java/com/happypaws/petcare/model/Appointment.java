package com.happypaws.petcare.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Appointment {
    private Integer appointmentId;
    private String petUid;
    private Integer ownerId;
    private Integer staffId;
    private String type;
    private LocalDateTime scheduledAt;
    private String status;
    private LocalDateTime createdAt;
    private String phoneNo;
    private BigDecimal fee;
    private String paymentMethod;    // 'online' | 'clinic' | null
    private String paymentStatus;    // 'unpaid' | 'paid'
    private String paymentRef;       // gateway reference (e.g., Stripe PI id)
    private LocalDateTime paidAt;    // when it was paid
    private Boolean reminderSent;    // whether reminder email has been sent
    private Integer reminderCount;   // count of reminders sent (0 = none, 1 = one sent)

    public Appointment() {}

    public Appointment(Integer appointmentId, String petUid, Integer ownerId, Integer staffId, String type,
                       LocalDateTime scheduledAt, String status, LocalDateTime createdAt, String phoneNo,
                       BigDecimal fee, String paymentMethod, String paymentStatus, String paymentRef, 
                       LocalDateTime paidAt, Boolean reminderSent, Integer reminderCount) {
        this.appointmentId = appointmentId;
        this.petUid = petUid;
        this.ownerId = ownerId;
        this.staffId = staffId;
        this.type = type;
        this.scheduledAt = scheduledAt;
        this.status = status;
        this.createdAt = createdAt;
        this.phoneNo = phoneNo;
        this.fee = fee;
        this.paymentMethod = paymentMethod;
        this.paymentStatus = paymentStatus;
        this.paymentRef = paymentRef;
        this.paidAt = paidAt;
        this.reminderSent = reminderSent;
        this.reminderCount = reminderCount;
    }

    // getters/setters …

    public Integer getAppointmentId() { return appointmentId; }
    public void setAppointmentId(Integer appointmentId) { this.appointmentId = appointmentId; }

    public String getPetUid() { return petUid; }
    public void setPetUid(String petUid) { this.petUid = petUid; }

    public Integer getOwnerId() { return ownerId; }
    public void setOwnerId(Integer ownerId) { this.ownerId = ownerId; }

    public Integer getStaffId() { return staffId; }
    public void setStaffId(Integer staffId) { this.staffId = staffId; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public LocalDateTime getScheduledAt() { return scheduledAt; }
    public void setScheduledAt(LocalDateTime scheduledAt) { this.scheduledAt = scheduledAt; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public String getPhoneNo() { return phoneNo; }
    public void setPhoneNo(String phoneNo) { this.phoneNo = phoneNo; }

    public java.math.BigDecimal getFee() { return fee; }
    public void setFee(java.math.BigDecimal fee) { this.fee = fee; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }

    public String getPaymentRef() { return paymentRef; }
    public void setPaymentRef(String paymentRef) { this.paymentRef = paymentRef; }

    public LocalDateTime getPaidAt() { return paidAt; }
    public void setPaidAt(LocalDateTime paidAt) { this.paidAt = paidAt; }

    public Boolean getReminderSent() { return reminderSent; }
    public void setReminderSent(Boolean reminderSent) { this.reminderSent = reminderSent; }

    public Integer getReminderCount() { return reminderCount; }
    public void setReminderCount(Integer reminderCount) { this.reminderCount = reminderCount; }
}



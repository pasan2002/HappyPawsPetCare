package com.happypaws.petcare.service;

import com.happypaws.petcare.config.EmailConfig;
import com.happypaws.petcare.model.Appointment;
import com.happypaws.petcare.model.Owner;

import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.time.format.DateTimeFormatter;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Email service for sending appointment notifications
 */
public class EmailService {
    
    private static final Logger LOGGER = Logger.getLogger(EmailService.class.getName());
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("EEEE, MMMM d, yyyy");
    private static final DateTimeFormatter TIME_FORMATTER = DateTimeFormatter.ofPattern("h:mm a");
    private static final String DATE_TBD = "Date TBD";
    private static final String TIME_TBD = "Time TBD";
    
    // Private constructor to prevent instantiation
    private EmailService() {
        throw new UnsupportedOperationException("Utility class");
    }
    
    /**
     * Send appointment confirmation email
     */
    public static boolean sendAppointmentConfirmation(Owner owner, Appointment appointment) {
        String subject = "Appointment Confirmation - Happy Paws PetCare";
        String body = buildConfirmationEmailBody(owner, appointment);
        return sendEmail(owner.getEmail(), subject, body);
    }
    
    /**
     * Send appointment reminder email (24 hours before)
     */
    public static boolean sendAppointmentReminder(Owner owner, Appointment appointment) {
        String subject = "Appointment Reminder - Tomorrow at Happy Paws PetCare";
        String body = buildReminderEmailBody(owner, appointment);
        return sendEmail(owner.getEmail(), subject, body);
    }
    
    /**
     * Send appointment cancellation email
     */
    public static boolean sendAppointmentCancellation(Owner owner, Appointment appointment) {
        String subject = "Appointment Cancelled - Happy Paws PetCare";
        String body = buildCancellationEmailBody(owner, appointment);
        return sendEmail(owner.getEmail(), subject, body);
    }
    
    /**
     * Send appointment reschedule email
     */
    public static boolean sendAppointmentReschedule(Owner owner, Appointment appointment) {
        String subject = "Appointment Rescheduled - Happy Paws PetCare";
        String body = buildRescheduleEmailBody(owner, appointment);
        return sendEmail(owner.getEmail(), subject, body);
    }
    
    /**
     * Send payment confirmation email
     */
    public static boolean sendPaymentConfirmation(Owner owner, Appointment appointment) {
        String subject = "Payment Received - Happy Paws PetCare";
        String body = buildPaymentConfirmationEmailBody(owner, appointment);
        return sendEmail(owner.getEmail(), subject, body);
    }
    
    /**
     * Send clinic payment selection confirmation email
     */
    public static boolean sendClinicPaymentConfirmation(Owner owner, Appointment appointment) {
        String subject = "Clinic Payment Selected - Happy Paws PetCare";
        String body = buildClinicPaymentConfirmationEmailBody(owner, appointment);
        return sendEmail(owner.getEmail(), subject, body);
    }
    
    /**
     * Core email sending method
     */
    private static boolean sendEmail(String toEmail, String subject, String body) {
        try {
            if (LOGGER.isLoggable(Level.INFO)) {
                LOGGER.info(() -> "Attempting to send email to: " + toEmail + " with subject: " + subject);
            }
            
            Session session = EmailConfig.getEmailSession();
            
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EmailConfig.getSenderEmail(), EmailConfig.SENDER_NAME));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject);
            message.setContent(body, "text/html; charset=utf-8");
            
            // Send the email
            Transport.send(message);
            
            if (LOGGER.isLoggable(Level.INFO)) {
                LOGGER.info(() -> "Email sent successfully to: " + toEmail);
            }
            return true;
            
        } catch (IllegalStateException e) {
            // Email configuration issue
            if (LOGGER.isLoggable(Level.SEVERE)) {
                LOGGER.severe("Email configuration error: " + e.getMessage());
            }
            return false;
        } catch (MessagingException e) {
            // Email sending issue
            if (LOGGER.isLoggable(Level.SEVERE)) {
                LOGGER.severe("Email messaging error to: " + toEmail + " - " + e.getMessage());
            }
            return false;
        } catch (Exception e) {
            // General error
            if (LOGGER.isLoggable(Level.SEVERE)) {
                LOGGER.severe("Failed to send email to: " + toEmail + " - " + e.getMessage());
            }
            return false;
        }
    }
    
    /**
     * Build confirmation email HTML body
     */
    private static String buildConfirmationEmailBody(Owner owner, Appointment appointment) {
        String appointmentDate = appointment.getScheduledAt() != null ? 
            appointment.getScheduledAt().format(DATE_FORMATTER) : DATE_TBD;
        String appointmentTime = appointment.getScheduledAt() != null ? 
            appointment.getScheduledAt().format(TIME_FORMATTER) : TIME_TBD;
        
        return "<!DOCTYPE html>" +
            "<html>" +
            "<head>" +
            "<meta charset='UTF-8'>" +
            "<meta name='viewport' content='width=device-width, initial-scale=1.0'>" +
            "<title>Appointment Confirmation</title>" +
            "</head>" +
            "<body style='font-family: Arial, sans-serif; line-height: 1.6; color: #333; max-width: 600px; margin: 0 auto; padding: 20px;'>" +
            "<div style='background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0;'>" +
            "<h1 style='margin: 0; font-size: 28px;'>🐾 Happy Paws PetCare</h1>" +
            "<p style='margin: 10px 0 0; font-size: 18px;'>Appointment Confirmed!</p>" +
            "</div>" +
            "<div style='background: #f8f9fa; padding: 30px; border-radius: 0 0 10px 10px; border: 1px solid #e9ecef;'>" +
            "<h2 style='color: #495057; margin-top: 0;'>Hello " + escapeHtml(owner.getFullName()) + "! 👋</h2>" +
            "<p style='font-size: 16px; color: #6c757d;'>Your appointment has been successfully scheduled. Here are the details:</p>" +
            "<div style='background: white; padding: 25px; border-radius: 8px; margin: 20px 0; border-left: 4px solid #28a745;'>" +
            "<h3 style='margin-top: 0; color: #28a745;'>📅 Appointment Details</h3>" +
            "<table style='width: 100%; border-collapse: collapse;'>" +
            "<tr><td style='padding: 8px 0; font-weight: bold; color: #495057;'>Appointment ID:</td><td style='padding: 8px 0;'>#" + appointment.getAppointmentId() + "</td></tr>" +
            "<tr><td style='padding: 8px 0; font-weight: bold; color: #495057;'>Service Type:</td><td style='padding: 8px 0; text-transform: capitalize;'>" + escapeHtml(appointment.getType()) + "</td></tr>" +
            "<tr><td style='padding: 8px 0; font-weight: bold; color: #495057;'>Date:</td><td style='padding: 8px 0;'>" + appointmentDate + "</td></tr>" +
            "<tr><td style='padding: 8px 0; font-weight: bold; color: #495057;'>Time:</td><td style='padding: 8px 0;'>" + appointmentTime + "</td></tr>" +
            "<tr><td style='padding: 8px 0; font-weight: bold; color: #495057;'>Status:</td><td style='padding: 8px 0; text-transform: capitalize;'>" + escapeHtml(appointment.getStatus()) + "</td></tr>" +
            (appointment.getFee() != null ? 
                "<tr><td style='padding: 8px 0; font-weight: bold; color: #495057;'>Fee:</td><td style='padding: 8px 0;'>Rs " + appointment.getFee() + "</td></tr>" : "") +
            "</table>" +
            "</div>" +
            "<div style='background: #e3f2fd; padding: 20px; border-radius: 8px; margin: 20px 0;'>" +
            "<h4 style='margin-top: 0; color: #1976d2;'>💡 Important Notes:</h4>" +
            "<ul style='margin: 10px 0; padding-left: 20px; color: #424242;'>" +
            "<li>Please arrive 10 minutes early for your appointment</li>" +
            "<li>Bring your pet's vaccination records if this is your first visit</li>" +
            "<li>If you need to reschedule, please contact us at least 24 hours in advance</li>" +
            "</ul>" +
            "</div>" +
            "<div style='text-align: center; margin-top: 30px;'>" +
            "<p style='color: #6c757d; margin-bottom: 20px;'>Need to make changes to your appointment?</p>" +
            "<a href='#' style='background: #007bff; color: white; padding: 12px 30px; text-decoration: none; border-radius: 5px; display: inline-block; font-weight: bold;'>Manage Appointment</a>" +
            "</div>" +
            "<hr style='margin: 30px 0; border: 0; height: 1px; background: #dee2e6;'>" +
            "<div style='text-align: center; color: #6c757d; font-size: 14px;'>" +
            "<p>📍 Happy Paws PetCare Clinic<br>" +
            "📞 Contact us: (011) 234-5678<br>" +
            "📧 Email: info@happypaws.lk</p>" +
            "<p style='margin-top: 20px; font-size: 12px;'>You're receiving this email because you scheduled an appointment with Happy Paws PetCare.</p>" +
            "</div>" +
            "</div>" +
            "</body>" +
            "</html>";
    }
    
    /**
     * Build reminder email HTML body
     */
    private static String buildReminderEmailBody(Owner owner, Appointment appointment) {
        String appointmentDate = appointment.getScheduledAt() != null ? 
            appointment.getScheduledAt().format(DATE_FORMATTER) : DATE_TBD;
        String appointmentTime = appointment.getScheduledAt() != null ? 
            appointment.getScheduledAt().format(TIME_FORMATTER) : TIME_TBD;
        
        return "<!DOCTYPE html>" +
            "<html>" +
            "<head>" +
            "<meta charset='UTF-8'>" +
            "<meta name='viewport' content='width=device-width, initial-scale=1.0'>" +
            "<title>Appointment Reminder</title>" +
            "</head>" +
            "<body style='font-family: Arial, sans-serif; line-height: 1.6; color: #333; max-width: 600px; margin: 0 auto; padding: 20px;'>" +
            "<div style='background: linear-gradient(135deg, #ff9a9e 0%, #fecfef 100%); color: #333; padding: 30px; text-align: center; border-radius: 10px 10px 0 0;'>" +
            "<h1 style='margin: 0; font-size: 28px;'>🔔 Appointment Reminder</h1>" +
            "<p style='margin: 10px 0 0; font-size: 18px;'>Don't forget about tomorrow!</p>" +
            "</div>" +
            "<div style='background: #f8f9fa; padding: 30px; border-radius: 0 0 10px 10px; border: 1px solid #e9ecef;'>" +
            "<h2 style='color: #495057; margin-top: 0;'>Hi " + escapeHtml(owner.getFullName()) + "! 👋</h2>" +
            "<p style='font-size: 16px; color: #6c757d;'>This is a friendly reminder about your upcoming appointment tomorrow:</p>" +
            "<div style='background: white; padding: 25px; border-radius: 8px; margin: 20px 0; border-left: 4px solid #ffc107;'>" +
            "<h3 style='margin-top: 0; color: #f57c00;'>📅 Tomorrow's Appointment</h3>" +
            "<table style='width: 100%; border-collapse: collapse;'>" +
            "<tr><td style='padding: 8px 0; font-weight: bold; color: #495057;'>Appointment ID:</td><td style='padding: 8px 0;'>#" + appointment.getAppointmentId() + "</td></tr>" +
            "<tr><td style='padding: 8px 0; font-weight: bold; color: #495057;'>Service:</td><td style='padding: 8px 0; text-transform: capitalize;'>" + escapeHtml(appointment.getType()) + "</td></tr>" +
            "<tr><td style='padding: 8px 0; font-weight: bold; color: #495057;'>Date:</td><td style='padding: 8px 0;'>" + appointmentDate + "</td></tr>" +
            "<tr><td style='padding: 8px 0; font-weight: bold; color: #495057;'>Time:</td><td style='padding: 8px 0;'>" + appointmentTime + "</td></tr>" +
            "</table>" +
            "</div>" +
            "<div style='background: #fff3cd; padding: 20px; border-radius: 8px; margin: 20px 0; border: 1px solid #ffeaa7;'>" +
            "<h4 style='margin-top: 0; color: #856404;'>⏰ Preparation Checklist:</h4>" +
            "<ul style='margin: 10px 0; padding-left: 20px; color: #856404;'>" +
            "<li>Arrive 10 minutes early</li>" +
            "<li>Bring your pet's medical records</li>" +
            "<li>Prepare any questions for the vet</li>" +
            "<li>Ensure your pet is comfortable for travel</li>" +
            "</ul>" +
            "</div>" +
            "<div style='text-align: center; margin-top: 30px;'>" +
            "<p style='color: #6c757d; margin-bottom: 20px;'>Need to reschedule or cancel?</p>" +
            "<a href='#' style='background: #dc3545; color: white; padding: 12px 30px; text-decoration: none; border-radius: 5px; display: inline-block; font-weight: bold; margin-right: 10px;'>Cancel</a>" +
            "<a href='#' style='background: #28a745; color: white; padding: 12px 30px; text-decoration: none; border-radius: 5px; display: inline-block; font-weight: bold;'>Reschedule</a>" +
            "</div>" +
            "<hr style='margin: 30px 0; border: 0; height: 1px; background: #dee2e6;'>" +
            "<div style='text-align: center; color: #6c757d; font-size: 14px;'>" +
            "<p>📍 Happy Paws PetCare Clinic<br>" +
            "📞 Contact us: (011) 234-5678<br>" +
            "📧 Email: info@happypaws.lk</p>" +
            "</div>" +
            "</div>" +
            "</body>" +
            "</html>";
    }
    
    /**
     * Build cancellation email HTML body
     */
    private static String buildCancellationEmailBody(Owner owner, Appointment appointment) {
        return "<!DOCTYPE html>" +
            "<html>" +
            "<head>" +
            "<meta charset='UTF-8'>" +
            "<title>Appointment Cancelled</title>" +
            "</head>" +
            "<body style='font-family: Arial, sans-serif; line-height: 1.6; color: #333; max-width: 600px; margin: 0 auto; padding: 20px;'>" +
            "<div style='background: #dc3545; color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0;'>" +
            "<h1 style='margin: 0; font-size: 28px;'>❌ Appointment Cancelled</h1>" +
            "</div>" +
            "<div style='background: #f8f9fa; padding: 30px; border-radius: 0 0 10px 10px; border: 1px solid #e9ecef;'>" +
            "<h2 style='color: #495057; margin-top: 0;'>Hi " + escapeHtml(owner.getFullName()) + ",</h2>" +
            "<p>Your appointment has been cancelled as requested.</p>" +
            "<div style='background: white; padding: 25px; border-radius: 8px; margin: 20px 0; border-left: 4px solid #dc3545;'>" +
            "<h3 style='margin-top: 0; color: #dc3545;'>Cancelled Appointment</h3>" +
            "<p><strong>Appointment ID:</strong> #" + appointment.getAppointmentId() + "</p>" +
            "<p><strong>Service:</strong> " + escapeHtml(appointment.getType()) + "</p>" +
            "</div>" +
            "<p>If you'd like to book a new appointment, please visit our website or call us.</p>" +
            "<div style='text-align: center; margin-top: 30px;'>" +
            "<a href='#' style='background: #007bff; color: white; padding: 12px 30px; text-decoration: none; border-radius: 5px; display: inline-block; font-weight: bold;'>Book New Appointment</a>" +
            "</div>" +
            "</div>" +
            "</body>" +
            "</html>";
    }
    
    /**
     * Build reschedule email HTML body
     */
    private static String buildRescheduleEmailBody(Owner owner, Appointment appointment) {
        String appointmentDate = appointment.getScheduledAt() != null ? 
            appointment.getScheduledAt().format(DATE_FORMATTER) : DATE_TBD;
        String appointmentTime = appointment.getScheduledAt() != null ? 
            appointment.getScheduledAt().format(TIME_FORMATTER) : TIME_TBD;
        
        return "<!DOCTYPE html>" +
            "<html>" +
            "<head>" +
            "<meta charset='UTF-8'>" +
            "<title>Appointment Rescheduled</title>" +
            "</head>" +
            "<body style='font-family: Arial, sans-serif; line-height: 1.6; color: #333; max-width: 600px; margin: 0 auto; padding: 20px;'>" +
            "<div style='background: #ffc107; color: #212529; padding: 30px; text-align: center; border-radius: 10px 10px 0 0;'>" +
            "<h1 style='margin: 0; font-size: 28px;'>📅 Appointment Rescheduled</h1>" +
            "</div>" +
            "<div style='background: #f8f9fa; padding: 30px; border-radius: 0 0 10px 10px; border: 1px solid #e9ecef;'>" +
            "<h2 style='color: #495057; margin-top: 0;'>Hi " + escapeHtml(owner.getFullName()) + ",</h2>" +
            "<p>Your appointment has been successfully rescheduled.</p>" +
            "<div style='background: white; padding: 25px; border-radius: 8px; margin: 20px 0; border-left: 4px solid #ffc107;'>" +
            "<h3 style='margin-top: 0; color: #f57c00;'>New Appointment Details</h3>" +
            "<p><strong>Appointment ID:</strong> #" + appointment.getAppointmentId() + "</p>" +
            "<p><strong>Service:</strong> " + escapeHtml(appointment.getType()) + "</p>" +
            "<p><strong>New Date:</strong> " + appointmentDate + "</p>" +
            "<p><strong>New Time:</strong> " + appointmentTime + "</p>" +
            "</div>" +
            "<p>Please make note of your new appointment time. We look forward to seeing you!</p>" +
            "</div>" +
            "</body>" +
            "</html>";
    }
    
    /**
     * Build payment confirmation email HTML body
     */
    private static String buildPaymentConfirmationEmailBody(Owner owner, Appointment appointment) {
        return "<!DOCTYPE html>" +
            "<html>" +
            "<head>" +
            "<meta charset='UTF-8'>" +
            "<title>Payment Received</title>" +
            "</head>" +
            "<body style='font-family: Arial, sans-serif; line-height: 1.6; color: #333; max-width: 600px; margin: 0 auto; padding: 20px;'>" +
            "<div style='background: #28a745; color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0;'>" +
            "<h1 style='margin: 0; font-size: 28px;'>💳 Payment Received</h1>" +
            "</div>" +
            "<div style='background: #f8f9fa; padding: 30px; border-radius: 0 0 10px 10px; border: 1px solid #e9ecef;'>" +
            "<h2 style='color: #495057; margin-top: 0;'>Hi " + escapeHtml(owner.getFullName()) + ",</h2>" +
            "<p>Thank you! Your payment has been successfully processed.</p>" +
            "<div style='background: white; padding: 25px; border-radius: 8px; margin: 20px 0; border-left: 4px solid #28a745;'>" +
            "<h3 style='margin-top: 0; color: #28a745;'>Payment Details</h3>" +
            "<p><strong>Appointment ID:</strong> #" + appointment.getAppointmentId() + "</p>" +
            "<p><strong>Service:</strong> " + escapeHtml(appointment.getType()) + "</p>" +
            (appointment.getFee() != null ? "<p><strong>Amount Paid:</strong> Rs " + appointment.getFee() + "</p>" : "") +
            (appointment.getPaymentRef() != null ? "<p><strong>Payment Reference:</strong> " + escapeHtml(appointment.getPaymentRef()) + "</p>" : "") +
            "<p><strong>Payment Status:</strong> " + escapeHtml(appointment.getPaymentStatus()) + "</p>" +
            "</div>" +
            "<p>Your appointment is now confirmed. We look forward to seeing you!</p>" +
            "</div>" +
            "</body>" +
            "</html>";
    }
    
    /**
     * Build clinic payment confirmation email HTML body
     */
    private static String buildClinicPaymentConfirmationEmailBody(Owner owner, Appointment appointment) {
        String appointmentDate = appointment.getScheduledAt() != null ? 
            appointment.getScheduledAt().format(DATE_FORMATTER) : DATE_TBD;
        String appointmentTime = appointment.getScheduledAt() != null ? 
            appointment.getScheduledAt().format(TIME_FORMATTER) : TIME_TBD;
            
        return "<!DOCTYPE html>" +
            "<html>" +
            "<head>" +
            "<meta charset='UTF-8'>" +
            "<title>Clinic Payment Selected</title>" +
            "</head>" +
            "<body style='font-family: Arial, sans-serif; line-height: 1.6; color: #333; max-width: 600px; margin: 0 auto; padding: 20px;'>" +
            "<div style='background: #17a2b8; color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0;'>" +
            "<h1 style='margin: 0; font-size: 28px;'>🏥 Clinic Payment Selected</h1>" +
            "</div>" +
            "<div style='background: #f8f9fa; padding: 30px; border-radius: 0 0 10px 10px; border: 1px solid #e9ecef;'>" +
            "<h2 style='color: #495057; margin-top: 0;'>Hi " + escapeHtml(owner.getFullName()) + ",</h2>" +
            "<p>Thank you for selecting clinic payment for your appointment. You can pay when you arrive at our clinic.</p>" +
            "<div style='background: white; padding: 25px; border-radius: 8px; margin: 20px 0; border-left: 4px solid #17a2b8;'>" +
            "<h3 style='margin-top: 0; color: #17a2b8;'>📅 Appointment Details</h3>" +
            "<p><strong>Appointment ID:</strong> #" + appointment.getAppointmentId() + "</p>" +
            "<p><strong>Service:</strong> " + escapeHtml(appointment.getType()) + "</p>" +
            "<p><strong>Date:</strong> " + appointmentDate + "</p>" +
            "<p><strong>Time:</strong> " + appointmentTime + "</p>" +
            (appointment.getFee() != null ? "<p><strong>Fee:</strong> Rs " + appointment.getFee() + "</p>" : "") +
            "<p><strong>Payment Method:</strong> Pay at Clinic</p>" +
            "</div>" +
            "<div style='background: #e8f4fd; padding: 20px; border-radius: 8px; margin: 20px 0; border-left: 4px solid #17a2b8;'>" +
            "<h4 style='margin-top: 0; color: #17a2b8;'>💡 Payment Instructions:</h4>" +
            "<ul style='margin: 10px 0; padding-left: 20px; color: #424242;'>" +
            "<li>Please arrive 15 minutes early for payment and check-in</li>" +
            "<li>We accept cash and major credit/debit cards</li>" +
            "<li>Payment must be completed before your appointment</li>" +
            "<li>Bring exact change if paying with cash</li>" +
            "</ul>" +
            "</div>" +
            "<p>We look forward to seeing you at Happy Paws PetCare!</p>" +
            "<div style='text-align: center; color: #6c757d; font-size: 14px; margin-top: 30px;'>" +
            "<p>📍 Happy Paws PetCare Clinic<br>" +
            "📞 Contact us: (011) 234-5678<br>" +
            "📧 Email: info@happypaws.lk</p>" +
            "</div>" +
            "</div>" +
            "</body>" +
            "</html>";
    }
    
    /**
     * Escape HTML special characters to prevent XSS
     */
    private static String escapeHtml(String text) {
        if (text == null) return "";
        return text.replace("&", "&amp;")
                  .replace("<", "&lt;")
                  .replace(">", "&gt;")
                  .replace("\"", "&quot;")
                  .replace("'", "&#39;");
    }
}
package com.happypaws.petcare.service;

import com.happypaws.petcare.dao.appointment.AppointmentDAO;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

/**
 * Background service that automatically cancels expired appointments
 * Runs every hour to check for appointments that have passed their scheduled date
 */
@WebListener
public class AppointmentSchedulerService implements ServletContextListener {
    
    private ScheduledExecutorService scheduler;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        scheduler = Executors.newScheduledThreadPool(1);
        
        // Schedule the task to run every hour
        scheduler.scheduleAtFixedRate(this::cancelExpiredAppointments, 0, 1, TimeUnit.HOURS);
        
        System.out.println("AppointmentSchedulerService started - will check for expired appointments every hour");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        if (scheduler != null) {
            scheduler.shutdown();
            try {
                if (!scheduler.awaitTermination(10, TimeUnit.SECONDS)) {
                    scheduler.shutdownNow();
                }
            } catch (InterruptedException e) {
                scheduler.shutdownNow();
                Thread.currentThread().interrupt();
            }
        }
        System.out.println("AppointmentSchedulerService stopped");
    }

    private void cancelExpiredAppointments() {
        try {
            int cancelledCount = AppointmentDAO.cancelExpiredAppointments();
            if (cancelledCount > 0) {
                System.out.println("Automatically cancelled " + cancelledCount + " expired appointments");
            }
        } catch (Exception e) {
            System.err.println("Error in automatic appointment cancellation: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
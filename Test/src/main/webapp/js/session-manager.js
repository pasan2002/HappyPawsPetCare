/**
 * Smart Navigation Handler for HappyPaws Pet Care
 * Handles booking and appointment button navigation based on user session
 */

// Get the context path dynamically
const getContextPath = () => {
    const path = window.location.pathname;
    const contextPath = path.substring(0, path.indexOf('/', 1)) || '';
    return contextPath || '/Test'; // fallback to /Test if not found
};

// Session management utilities
const SessionManager = {
    
    /**
     * Check if user is logged in by making a lightweight AJAX call
     */
    async checkSession() {
        try {
            const response = await fetch(getContextPath() + '/session-check', {
                method: 'GET',
                credentials: 'include',
                headers: {
                    'Cache-Control': 'no-cache'
                }
            });
            
            if (response.ok) {
                const data = await response.json();
                return {
                    isLoggedIn: data.isLoggedIn,
                    authType: data.authType,
                    userId: data.userId
                };
            }
        } catch (error) {
            console.log('Session check failed:', error);
        }
        
        return { isLoggedIn: false, authType: null, userId: null };
    },

    /**
     * Handle logout with proper session cleanup
     */
    async logout() {
        try {
            const response = await fetch(getContextPath() + '/logout', {
                method: 'POST',
                credentials: 'include',
                headers: {
                    'Cache-Control': 'no-cache'
                }
            });
            
            if (response.ok) {
                // Clear any client-side storage
                localStorage.clear();
                sessionStorage.clear();
                
                // Redirect to login
                window.location.href = getContextPath() + '/views/user-management/login.jsp?message=logged_out';
            }
        } catch (error) {
            console.error('Logout failed:', error);
            // Force redirect anyway
            window.location.href = getContextPath() + '/views/user-management/login.jsp';
        }
    }
};

// Navigation handlers
const NavigationHandler = {
    
    /**
     * Handle booking button clicks with session-aware navigation
     */
    async handleBookingClick(event) {
        event.preventDefault();
        
        const sessionInfo = await SessionManager.checkSession();
        
        if (!sessionInfo.isLoggedIn) {
            // Not logged in - redirect to login
            window.location.href = getContextPath() + '/views/user-management/login.jsp?next=' + 
                encodeURIComponent(getContextPath() + '/views/appointment-management/add-appointment.jsp');
        } else if (sessionInfo.authType === 'owner') {
            // Pet owner - redirect to their appointments
            window.location.href = getContextPath() + '/views/appointment-management/user_appointments.jsp';
        } else {
            // Staff users - do nothing (or show a message)
            console.log('Staff users cannot book appointments through this interface');
        }
    },

    /**
     * Handle appointment button clicks with session-aware navigation
     */
    async handleAppointmentClick(event) {
        event.preventDefault();
        
        const sessionInfo = await SessionManager.checkSession();
        
        if (!sessionInfo.isLoggedIn) {
            // Not logged in - redirect to login
            window.location.href = getContextPath() + '/views/user-management/login.jsp?next=' + 
                encodeURIComponent(getContextPath() + '/views/appointment-management/user_appointments.jsp');
        } else if (sessionInfo.authType === 'owner') {
            // Pet owner - redirect to their appointments
            window.location.href = getContextPath() + '/views/appointment-management/user_appointments.jsp';
        } else {
            // Staff users - redirect to appropriate dashboard
            this.redirectToStaffDashboard(sessionInfo);
        }
    },

    /**
     * Redirect staff users to appropriate dashboard
     */
    redirectToStaffDashboard(sessionInfo) {
        const role = sessionInfo.staffRole || 'receptionist';
        const contextPath = getContextPath();
        
        switch (role) {
            case 'admin':
                window.location.href = contextPath + '/views/user-management/admin.jsp';
                break;
            case 'manager':
                window.location.href = contextPath + '/staff/management';
                break;
            case 'pharmacist':
                window.location.href = contextPath + '/views/inventory-management/inventory_management_home.jsp';
                break;
            case 'receptionist':
            case 'veterinarian':
            case 'groomer':
            default:
                window.location.href = contextPath + '/views/appointment-management/receptionist-dashboard.jsp';
                break;
        }
    }
};

// Initialize when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    
    // Find and attach event listeners to booking buttons
    const bookingButtons = document.querySelectorAll('[data-action="booking"], .booking-btn, #bookingBtn');
    bookingButtons.forEach(button => {
        button.addEventListener('click', NavigationHandler.handleBookingClick);
    });
    
    // Find and attach event listeners to appointment buttons
    const appointmentButtons = document.querySelectorAll('[data-action="appointments"], .appointment-btn, #appointmentBtn');
    appointmentButtons.forEach(button => {
        button.addEventListener('click', NavigationHandler.handleAppointmentClick);
    });
    
    // Find and attach event listeners to logout buttons
    const logoutButtons = document.querySelectorAll('[data-action="logout"], .logout-btn, #logoutBtn');
    logoutButtons.forEach(button => {
        button.addEventListener('click', function(event) {
            event.preventDefault();
            if (confirm('Are you sure you want to logout?')) {
                SessionManager.logout();
            }
        });
    });
});

// Prevent back button after logout
window.addEventListener('pageshow', function(event) {
    if (event.persisted) {
        // Page was loaded from cache (back button)
        SessionManager.checkSession().then(sessionInfo => {
            if (!sessionInfo.isLoggedIn && window.location.pathname.includes('/views/')) {
                // User is on a protected page but not logged in
                window.location.href = getContextPath() + '/views/user-management/login.jsp';
            }
        });
    }
});

// Make SessionManager available globally for other scripts
window.SessionManager = SessionManager;
window.NavigationHandler = NavigationHandler;
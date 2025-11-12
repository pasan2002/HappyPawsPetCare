<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String authType = (String) session.getAttribute("authType");
    String staffRole = (String) session.getAttribute("staffRole");
%>
<header class="sticky top-0 z-50 backdrop-blur bg-white/80 dark:bg-slate-950/70 border-b border-slate-200/70 dark:border-slate-800">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex items-center justify-between h-16">
            <a href="<%= request.getContextPath() %>/" class="flex items-center gap-2 group" aria-label="Happy Paws home">
        <span class="inline-grid h-9 w-9 place-items-center rounded-xl bg-gradient-to-br from-brand-500 to-brand-700 text-white shadow-soft">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="h-5 w-5">
            <path d="M7.5 7.5a2 2 0 1 1-4 0 2 2 0 0 1 4 0Zm6-1a2.2 2.2 0 1 1-4.4 0 2.2 2.2 0 0 1 4.4 0Zm7 3a2 2 0 1 1-4 0 2 2 0 0 1 4 0ZM6 14.5c0-2.3 2.6-3.7 6-3.7s6 1.4 6 3.7c0 2-2.7 4-6 4s-6-2-6-4Z"/>
          </svg>
        </span>
                <span class="font-display text-xl leading-tight tracking-tight">Happy Paws <span class="text-brand-700">PetCare</span></span>
            </a>
            <nav class="hidden md:flex items-center gap-8 text-sm">
                <a href="<%= request.getContextPath() %>/#features" class="hover:text-brand-700">Features</a>
                <a href="<%= request.getContextPath() %>/#services" class="hover:text-brand-700">Services</a>
                <a href="<%= request.getContextPath() %>/#stats" class="hover:text-brand-700">Stats</a>
                <a href="<%= request.getContextPath() %>/#reviews" class="hover:text-brand-700">Reviews</a>
                <a href="<%= request.getContextPath() %>/#contact" class="hover:text-brand-700">Contact</a>

                <% if (authType == null) { %>
                <a href="<%= request.getContextPath() %>/views/user-management/login.jsp" class="hover:text-brand-700">Login</a>
                <% } else if ("owner".equals(authType)) { %>
                <a href="<%= request.getContextPath() %>/owner/dashboard" class="hover:text-brand-700">Dashboard</a>
                <button data-action="logout" class="logout-btn hover:text-brand-700">Logout</button>
                <% } else { %>
                <%
                    // Determine dashboard URL based on staff role
                    String dashboardUrl = "/views/appointment-management/receptionist-dashboard.jsp"; // default
                    if ("manager".equals(staffRole)) {
                        dashboardUrl = "/staff/management"; // Manager dashboard - staff management
                    } else if ("pharmacist".equals(staffRole)) {
                        dashboardUrl = "/views/inventory-management/inventory_management_home.jsp";
                    } else if ("receptionist".equals(staffRole)) {
                        dashboardUrl = "/views/appointment-management/receptionist-dashboard.jsp";
                    } else if ("admin".equals(staffRole)) {
                        dashboardUrl = "/views/user-management/admin.jsp";
                    } else if ("veterinarian".equals(staffRole) || "vet".equals(staffRole)) {
                        dashboardUrl = "/medical/records"; // Vet dashboard - medical records
                    } else if ("groomer".equals(staffRole)) {
                        dashboardUrl = "/grooming/sessions"; // Groomer dashboard - grooming sessions
                    }
                    // Add more roles as needed
                %>
                <a href="<%= request.getContextPath() %><%= dashboardUrl %>" class="hover:text-brand-700">Dashboard</a>
                <button data-action="logout" class="logout-btn hover:text-brand-700">Logout</button>
                <% } %>
            </nav>
            <div class="flex items-center gap-3">
                <button id="themeToggle" class="p-2 rounded-lg border border-slate-200 dark:border-slate-800 hover:shadow-soft" aria-label="Toggle dark mode">
                    <svg id="themeIcon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"
                         class="h-5 w-5 fill-slate-700 dark:fill-slate-200">
                        <path d="M21 12.79A9 9 0 1 1 11.21 3a7 7 0 1 0 9.79 9.79Z"/>
                    </svg>
                </button>
                <button id="menuBtn" class="md:hidden p-2 rounded-lg border border-slate-200 dark:border-slate-800" aria-label="Open menu">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"
                         class="h-6 w-6 fill-slate-700 dark:fill-slate-200"><path d="M4 6h16v2H4zm0 5h16v2H4zm0 5h16v2H4z"/></svg>
                </button>
            </div>
        </div>
    </div>
    <div id="mobileNav" class="md:hidden hidden border-t border-slate-200 dark:border-slate-800 bg-white/90 dark:bg-slate-950/90 backdrop-blur">
        <div class="max-w-7xl mx-auto px-4 py-3 grid gap-2 text-sm">
            <a href="<%= request.getContextPath() %>/#features" class="py-2">Features</a>
            <a href="<%= request.getContextPath() %>/#services" class="py-2">Services</a>
            <a href="<%= request.getContextPath() %>/#stats" class="py-2">Stats</a>
            <a href="<%= request.getContextPath() %>/#reviews" class="py-2">Reviews</a>
            <a href="<%= request.getContextPath() %>/#contact" class="py-2">Contact</a>
            <button data-action="booking" class="booking-btn mt-2 inline-flex items-center justify-center px-4 py-2 rounded-xl bg-brand-600 hover:bg-brand-700 text-white font-medium">Book now</button>
        </div>
    </div>
</header>

<!-- Centralized Theme Manager Script - Inline -->
<script>
(function() {
    'use strict';
    
    const ThemeManager = {
        init() {
            this.applyTheme();
            this.setupEventListeners();
        },
        
        applyTheme() {
            const root = document.documentElement;
            const saved = localStorage.getItem('theme');
            const prefersDark = window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches;
            const shouldDark = saved ? (saved === 'dark') : prefersDark;
            
            if (shouldDark) {
                root.classList.add('dark');
            } else {
                root.classList.remove('dark');
            }
            
            this.updateThemeIcon();
        },
        
        updateThemeIcon() {
            const themeIcon = document.getElementById('themeIcon');
            if (themeIcon) {
                const isDark = document.documentElement.classList.contains('dark');
                themeIcon.innerHTML = isDark
                    ? '<path d="M12 3.1a1 1 0 0 1 1.1.3 9 9 0 1 0 7.5 7.5 1 1 0 0 1 1.3 1.2A11 11 0 1 1 12 2a1 1 0 0 1 0 1.1Z"/>'
                    : '<path d="M21 12.79A9 9 0 1 1 11.21 3a7 7 0 1 0 9.79 9.79Z"/>';
            }
        },
        
        toggleTheme() {
            const root = document.documentElement;
            root.classList.toggle('dark');
            const isDark = root.classList.contains('dark');
            
            try { 
                localStorage.setItem('theme', isDark ? 'dark' : 'light'); 
            } catch (e) {
                console.warn('Could not save theme preference:', e);
            }
            
            this.updateThemeIcon();
        },
        
        setupEventListeners() {
            const themeToggle = document.getElementById('themeToggle');
            if (themeToggle) {
                themeToggle.addEventListener('click', () => this.toggleTheme());
            }
            
            window.addEventListener('storage', (e) => {
                if (e.key === 'theme') {
                    this.applyTheme();
                }
            });
            
            if (window.matchMedia) {
                const mediaQuery = window.matchMedia('(prefers-color-scheme: dark)');
                mediaQuery.addEventListener('change', () => {
                    if (!localStorage.getItem('theme')) {
                        this.applyTheme();
                    }
                });
            }
        }
    };
    
    // Initialize when DOM is ready or immediately if already ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', () => ThemeManager.init());
    } else {
        ThemeManager.init();
    }
    
    // Make available globally
    window.ThemeManager = ThemeManager;
})();
</script>

<script>
    // Mobile menu toggle
    document.addEventListener('DOMContentLoaded', function() {
        const menuBtn = document.getElementById('menuBtn');
        const mobileNav = document.getElementById('mobileNav');
        
        if (menuBtn && mobileNav) {
            menuBtn.addEventListener('click', () => {
                mobileNav.classList.toggle('hidden');
            });
        }
    });
</script>

<!-- Inline Session Manager for testing -->
<script>
// Get the context path dynamically
const getContextPath = () => {
    const path = window.location.pathname;
    const contextPath = path.substring(0, path.indexOf('/', 1)) || '';
    return contextPath || '/Test';
};

// Simple session management
const SessionManager = {
    async checkSession() {
        try {
            const response = await fetch(getContextPath() + '/session-check', {
                method: 'GET',
                credentials: 'include',
                headers: { 'Cache-Control': 'no-cache' }
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

    async logout() {
        try {
            // Preserve theme setting before clearing storage
            const currentTheme = localStorage.getItem('theme');
            
            const response = await fetch(getContextPath() + '/logout', {
                method: 'POST',
                credentials: 'include',
                headers: { 'Cache-Control': 'no-cache' }
            });
            
            if (response.ok) {
                // Clear all storage except theme
                const keysToPreserve = ['theme'];
                const preservedData = {};
                
                // Save important data
                keysToPreserve.forEach(key => {
                    const value = localStorage.getItem(key);
                    if (value !== null) {
                        preservedData[key] = value;
                    }
                });
                
                // Clear all storage
                localStorage.clear();
                sessionStorage.clear();
                
                // Restore preserved data
                Object.entries(preservedData).forEach(([key, value]) => {
                    localStorage.setItem(key, value);
                });
                
                // Redirect to login
                window.location.href = getContextPath() + '/views/user-management/login.jsp?message=logged_out';
            }
        } catch (error) {
            // Preserve theme even in error case
            const currentTheme = localStorage.getItem('theme');
            console.error('Logout failed:', error);
            
            // Clear storage but preserve theme
            localStorage.clear();
            sessionStorage.clear();
            
            if (currentTheme) {
                localStorage.setItem('theme', currentTheme);
            }
            
            window.location.href = getContextPath() + '/views/user-management/login.jsp';
        }
    }
};

// Navigation handlers
const NavigationHandler = {
    async handleBookingClick(event) {
        event.preventDefault();
        const sessionInfo = await SessionManager.checkSession();
        
        if (!sessionInfo.isLoggedIn) {
            window.location.href = getContextPath() + '/views/user-management/login.jsp';
        } else if (sessionInfo.authType === 'owner') {
            window.location.href = getContextPath() + '/owner/dashboard';
        } else {
            console.log('Staff users cannot book appointments through this interface');
        }
    }
};

// Initialize when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    // Attach event listeners to booking buttons ONLY
    document.querySelectorAll('[data-action="booking"], .booking-btn').forEach(button => {
        button.addEventListener('click', NavigationHandler.handleBookingClick);
    });
    
    // Attach event listeners to logout buttons
    document.querySelectorAll('[data-action="logout"], .logout-btn').forEach(button => {
        button.addEventListener('click', function(event) {
            event.preventDefault();
            if (confirm('Are you sure you want to logout?')) {
                SessionManager.logout();
            }
        });
    });
});

// Make available globally
window.SessionManager = SessionManager;
window.NavigationHandler = NavigationHandler;
</script>

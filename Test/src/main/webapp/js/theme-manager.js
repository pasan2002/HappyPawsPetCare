/**
 * Centralized Theme Management for HappyPaws Pet Care
 * Handles theme switching and synchronization across all pages
 */

(function() {
    'use strict';
    
    // Theme management utilities
    const ThemeManager = {
        init() {
            this.applyTheme();
            this.setupEventListeners();
        },
        
        // Apply theme from localStorage or system preference
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
        
        // Update theme icon if it exists
        updateThemeIcon() {
            const themeIcon = document.getElementById('themeIcon');
            if (themeIcon) {
                const isDark = document.documentElement.classList.contains('dark');
                themeIcon.innerHTML = isDark
                    ? '<path d="M12 3.1a1 1 0 0 1 1.1.3 9 9 0 1 0 7.5 7.5 1 1 0 0 1 1.3 1.2A11 11 0 1 1 12 2a1 1 0 0 1 0 1.1Z"/>'
                    : '<path d="M21 12.79A9 9 0 1 1 11.21 3a7 7 0 1 0 9.79 9.79Z"/>';
            }
        },
        
        // Toggle theme
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
        
        // Setup event listeners
        setupEventListeners() {
            // Listen for theme toggle clicks
            const themeToggle = document.getElementById('themeToggle');
            if (themeToggle) {
                themeToggle.addEventListener('click', () => this.toggleTheme());
            }
            
            // Listen for storage changes from other tabs/pages
            window.addEventListener('storage', (e) => {
                if (e.key === 'theme') {
                    this.applyTheme();
                }
            });
            
            // Listen for system theme changes
            if (window.matchMedia) {
                const mediaQuery = window.matchMedia('(prefers-color-scheme: dark)');
                mediaQuery.addEventListener('change', () => {
                    // Only apply system theme if no user preference is saved
                    if (!localStorage.getItem('theme')) {
                        this.applyTheme();
                    }
                });
            }
        },
        
        // Get current theme
        getCurrentTheme() {
            return document.documentElement.classList.contains('dark') ? 'dark' : 'light';
        },
        
        // Set specific theme
        setTheme(theme) {
            const root = document.documentElement;
            
            if (theme === 'dark') {
                root.classList.add('dark');
            } else {
                root.classList.remove('dark');
            }
            
            try {
                localStorage.setItem('theme', theme);
            } catch (e) {
                console.warn('Could not save theme preference:', e);
            }
            
            this.updateThemeIcon();
        }
    };
    
    // Initialize theme management when DOM is ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', () => ThemeManager.init());
    } else {
        ThemeManager.init();
    }
    
    // Make ThemeManager available globally
    window.ThemeManager = ThemeManager;
    
})();
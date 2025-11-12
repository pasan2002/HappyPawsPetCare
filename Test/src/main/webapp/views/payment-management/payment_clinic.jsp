<%@ page import="com.happypaws.petcare.model.Appointment" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
    Appointment appt = (Appointment) request.getAttribute("appt");
    String c = request.getContextPath();
    String message = request.getParameter("m");
%>
<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Clinic Payment Selected — Happy Paws PetCare</title>
    <meta name="description" content="Your appointment is set for clinic payment." />

    <!-- Early theme init (prevents flash of wrong theme) -->
    <script>
        (function () {
            try {
                const saved = localStorage.getItem('theme');
                const sysDark = window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches;
                if (saved === 'dark' || (!saved && sysDark)) {
                    document.documentElement.classList.add('dark');
                } else {
                    document.documentElement.classList.remove('dark');
                }
            } catch (e) {}
        })();
    </script>

    <!-- Fonts + Tailwind -->
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Sora:wght@400;600;700&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    fontFamily: { sans: ['Inter','system-ui','sans-serif'], display: ['Sora','Inter','system-ui','sans-serif'] },
                    colors: {
                        brand: {
                            50:'#effaff',100:'#d7f0ff',200:'#b2e1ff',300:'#84cdff',400:'#53b2ff',
                            500:'#239cff',600:'#0c7de8',700:'#0a68c4',800:'#0f559e',900:'#134a7c',
                            950:'#112d4a'
                        }
                    },
                    animation: {
                        'fade-in': 'fadeIn 0.5s ease-in',
                        'slide-up': 'slideUp 0.6s ease-out',
                        'bounce-gentle': 'bounceGentle 2s infinite'
                    },
                    keyframes: {
                        fadeIn: { '0%': { opacity: '0' }, '100%': { opacity: '1' } },
                        slideUp: { '0%': { opacity: '0', transform: 'translateY(20px)' }, '100%': { opacity: '1', transform: 'translateY(0)' } },
                        bounceGentle: { '0%, 100%': { transform: 'translateY(0)' }, '50%': { transform: 'translateY(-10px)' } }
                    }
                }
            },
            darkMode: 'class'
        };
    </script>
    <style>
        .bg-grid { background-image: radial-gradient(circle, rgba(148, 163, 184, 0.1) 1px, transparent 1px); background-size: 24px 24px; }
        .shadow-soft { box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06); }
        .reveal { opacity: 0; transform: translateY(20px); transition: all 0.6s ease; }
        .reveal.visible { opacity: 1; transform: translateY(0); }
    </style>
</head>
<body class="antialiased text-slate-800 dark:text-slate-100 bg-white dark:bg-slate-950">

<!-- NAV -->
<%@ include file="../common/header.jsp" %>

<!-- PAGE HEADER / HERO -->
<section class="relative overflow-hidden">
    <div class="absolute inset-0 bg-gradient-to-b from-green-50 via-white to-white dark:from-slate-900 dark:via-slate-950 dark:to-slate-950"></div>
    <div class="absolute inset-0 bg-grid opacity-60 dark:opacity-20"></div>

    <div class="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10 md:py-14">
        <div class="text-center reveal">
            <!-- Success Icon -->
            <div class="inline-flex items-center justify-center w-16 h-16 rounded-full bg-green-100 dark:bg-green-900/30 mb-6 animate-bounce-gentle">
                <svg class="w-8 h-8 text-green-600 dark:text-green-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
                </svg>
            </div>
            
            <h1 class="font-display text-3xl md:text-4xl font-extrabold tracking-tight mb-4">
                Clinic Payment Selected
            </h1>
            <p class="text-lg text-slate-600 dark:text-slate-300 max-w-2xl mx-auto">
                Your appointment has been set up for clinic payment. You can pay when you arrive for your appointment.
            </p>
        </div>
    </div>
</section>

<!-- CONTENT -->
<section class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 pb-16">
    <div class="reveal">
        <!-- Payment Confirmation Card -->
        <div class="relative rounded-3xl border border-slate-200 dark:border-slate-800 bg-white/80 dark:bg-slate-900/60 p-6 md:p-8 shadow-soft backdrop-blur">
            <!-- Appointment Details -->
            <div class="text-center mb-8">
                <h2 class="text-xl font-semibold mb-4">Appointment Details</h2>
                
                <% if (appt != null) { %>
                <div class="grid sm:grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
                    <div class="p-4 rounded-2xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-900">
                        <p class="text-xs text-slate-500">Appointment ID</p>
                        <p class="mt-1 font-semibold">#<%= appt.getAppointmentId() %></p>
                    </div>
                    <div class="p-4 rounded-2xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-900">
                        <p class="text-xs text-slate-500">Type</p>
                        <p class="mt-1 font-semibold capitalize"><%= appt.getType() != null ? appt.getType() : "-" %></p>
                    </div>
                    <div class="p-4 rounded-2xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-900">
                        <p class="text-xs text-slate-500">Date & Time</p>
                        <p class="mt-1 font-semibold text-sm"><%= appt.getScheduledAt() != null ? appt.getScheduledAt().toString().replace("T", " ") : "-" %></p>
                    </div>
                    <div class="p-4 rounded-2xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-900">
                        <p class="text-xs text-slate-500">Fee</p>
                        <p class="mt-1 font-semibold">LKR <%= appt.getFee() != null ? appt.getFee() : "0.00" %></p>
                    </div>
                </div>
                <% } %>
            </div>

            <!-- Payment Information -->
            <div class="bg-green-50 dark:bg-green-900/20 border border-green-200 dark:border-green-800 rounded-2xl p-6 mb-8">
                <div class="flex items-start gap-4">
                    <div class="flex-shrink-0">
                        <svg class="w-6 h-6 text-green-600 dark:text-green-400 mt-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                        </svg>
                    </div>
                    <div>
                        <h3 class="font-semibold text-green-800 dark:text-green-200 mb-2">Payment Instructions</h3>
                        <div class="text-green-700 dark:text-green-300 space-y-2">
                            <p>• Please bring the appointment fee in cash when you visit our clinic</p>
                            <p>• Payment can be made at reception before your appointment</p>
                            <p>• We accept cash payments and major credit/debit cards at the clinic</p>
                            <p>• Please arrive 15 minutes early to complete payment and check-in</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Next Steps -->
            <div class="bg-blue-50 dark:bg-blue-900/20 border border-blue-200 dark:border-blue-800 rounded-2xl p-6 mb-8">
                <h3 class="font-semibold text-blue-800 dark:text-blue-200 mb-3">What's Next?</h3>
                <div class="text-blue-700 dark:text-blue-300 space-y-2">
                    <p>1. ✉️ You'll receive a confirmation email with your clinic payment details</p>
                    <p>2. 📧 We'll send you a reminder 24 hours before your appointment</p>
                    <p>3. 🕐 Arrive 15 minutes early for payment and check-in</p>
                    <p>4. 🐾 Bring your pet and any relevant medical records</p>
                </div>
            </div>

            <!-- Action Buttons -->
            <div class="flex flex-col sm:flex-row gap-4 justify-center">
                <a href="<%= c %>/views/appointment-management/user_appointments.jsp"
                   class="inline-flex items-center justify-center px-6 py-3 rounded-xl bg-brand-600 hover:bg-brand-700 text-white font-medium shadow-soft transition-colors">
                    <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path>
                    </svg>
                    View My Appointments
                </a>
                
                <a href="<%= c %>/views/index.jsp"
                   class="inline-flex items-center justify-center px-6 py-3 rounded-xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 hover:shadow-soft transition-all">
                    <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"></path>
                    </svg>
                    Back to Home
                </a>
            </div>
        </div>
    </div>
</section>

<!-- Footer -->
<%@ include file="../common/footer.jsp" %>

<!-- Theme toggle -->
<button id="themeToggle" class="fixed bottom-6 right-6 p-3 rounded-full bg-slate-200 dark:bg-slate-800 text-slate-800 dark:text-slate-200 hover:bg-slate-300 dark:hover:bg-slate-700 shadow-lg transition-colors z-50">
    <svg id="themeIcon" class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24">
        <path d="M21 12.79A9 9 0 1 1 11.21 3a7 7 0 1 0 9.79 9.79Z"/>
    </svg>
</button>

<script>
    // Theme toggle functionality
    const themeToggle = document.getElementById('themeToggle');
    const themeIcon = document.getElementById('themeIcon');
    
    themeToggle.addEventListener('click', () => {
        const isDark = document.documentElement.classList.toggle('dark');
        localStorage.setItem('theme', isDark ? 'dark' : 'light');
        if (themeIcon) {
            themeIcon.innerHTML = isDark
                ? '<path d="M12 3.1a1 1 0 0 1 1.1.3 9 9 0 1 0 7.5 7.5 1 1 0 0 1 1.3 1.2A11 11 0 1 1 12 2a1 1 0 0 1 0 1.1Z"/>'
                : '<path d="M21 12.79A9 9 0 1 1 11.21 3a7 7 0 1 0 9.79 9.79Z"/>';
        }
    });

    // Reveal on scroll
    const observer = new IntersectionObserver(entries => {
        entries.forEach(e => { if (e.isIntersecting) e.target.classList.add('visible'); });
    }, { threshold: 0.08 });
    document.querySelectorAll('.reveal').forEach(el => observer.observe(el));
</script>
</body>
</html>
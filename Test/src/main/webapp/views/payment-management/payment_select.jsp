<%@ page import="com.happypaws.petcare.model.Appointment" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
    Appointment appt = (Appointment) request.getAttribute("appt");
    Boolean isPending = (Boolean) request.getAttribute("isPending");
    boolean pendingAppointment = isPending != null && isPending;
    String c = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Select Payment Method — Happy Paws PetCare</title>
    <meta name="description" content="Choose how you'd like to pay for your appointment." />

    <!-- Theme Manager - Inline for immediate theme handling -->
    <script>
        (function() {
            'use strict';
            
            const saved = localStorage.getItem('theme');
            const prefersDark = window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches;
            const shouldDark = saved ? (saved === 'dark') : prefersDark;
            
            if (shouldDark) {
                document.documentElement.classList.add('dark');
            } else {
                document.documentElement.classList.remove('dark');
            }
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
                            500:'#2f97ff',600:'#1679e6',700:'#0f5fba',800:'#0f4c91',900:'#113e75'
                        }
                    },
                    boxShadow: { soft:'0 10px 30px rgba(0,0,0,.06)', glow:'0 0 0 6px rgba(47,151,255,.10)' }
                }
            },
            darkMode: 'class'
        }
    </script>
    <style>
        .bg-grid {
            background-image: radial-gradient(circle at 1px 1px, rgba(16,24,40,.08) 1px, transparent 0);
            background-size: 24px 24px;
            mask-image: radial-gradient(ellipse 70% 60% at 50% -10%, black 40%, transparent 60%);
        }
        .reveal { opacity: 0; transform: translateY(12px); transition: opacity .6s ease, transform .6s ease; }
        .reveal.visible { opacity: 1; transform: translateY(0); }
    </style>
</head>
<body class="antialiased text-slate-800 dark:text-slate-100 bg-white dark:bg-slate-950">

<!-- NAV -->
<%@ include file="../common/header.jsp" %>

<!-- PAGE HEADER / HERO -->
<section class="relative overflow-hidden">
    <div class="absolute inset-0 bg-gradient-to-b from-brand-50 via-white to-white dark:from-slate-900 dark:via-slate-950 dark:to-slate-950"></div>
    <div class="absolute inset-0 bg-grid opacity-60 dark:opacity-20"></div>

    <div class="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10 md:py-14">
        <div class="flex items-center justify-between gap-4 reveal">
            <div>
                <h1 class="font-display text-3xl md:text-4xl font-extrabold tracking-tight">Select Payment Method</h1>
                <p class="mt-2 text-sm text-slate-600 dark:text-slate-300">Choose how you’d like to pay for this appointment.</p>
            </div>
            <div class="flex items-center gap-2">
                <a href="<%= c %>/views/appointment-management/user_appointments.jsp"
                   class="inline-flex items-center px-4 py-2 rounded-xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 hover:shadow-soft">
                    ← Back to My Appointments
                </a>
            </div>
        </div>
    </div>
</section>

<!-- CONTENT -->
<section class="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 pb-16">
    <div class="reveal relative">
        <!-- soft halo -->
        <div class="absolute -inset-2 rounded-3xl bg-gradient-to-tr from-brand-600/20 via-brand-400/10 to-brand-600/20 blur-2xl"></div>

        <div class="relative rounded-3xl border border-slate-200 dark:border-slate-800 bg-white/80 dark:bg-slate-900/60 p-6 md:p-7 shadow-soft backdrop-blur">
            <!-- Appointment summary -->
            <div class="grid sm:grid-cols-3 gap-4">
                <% if (!pendingAppointment) { %>
                <div class="p-4 rounded-2xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-900">
                    <p class="text-xs text-slate-500">Appointment</p>
                    <p class="mt-1 font-semibold">#<%= appt.getAppointmentId() %></p>
                </div>
                <% } %>
                <div class="p-4 rounded-2xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-900">
                    <p class="text-xs text-slate-500">Type</p>
                    <p class="mt-1 font-semibold"><%= appt.getType() %></p>
                </div>
                <div class="p-4 rounded-2xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-900">
                    <p class="text-xs text-slate-500">When</p>
                    <p class="mt-1 font-semibold"><%= appt.getScheduledAt() != null ? appt.getScheduledAt().toString() : "-" %></p>
                </div>
            </div>

            <!-- Form -->
            <form method="post" action="<%= pendingAppointment ? c + "/pay/select/pending" : c + "/pay/select" %>" class="mt-6 space-y-5">
                <% if (!pendingAppointment) { %>
                <input type="hidden" name="appointmentId" value="<%= appt.getAppointmentId() %>"/>
                <% } %>

                <!-- Fee -->
                <div>
                    <label class="block text-sm font-medium mb-1">Fee (LKR)</label>
                    <input type="number" step="0.01" min="0" name="fee"
                           value="<%= appt.getFee() != null ? appt.getFee() : "" %>"
                           <%= pendingAppointment ? "readonly" : "" %>
                           class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-3 py-2 <%= pendingAppointment ? "bg-slate-50 dark:bg-slate-800 cursor-not-allowed" : "" %>" />
                    <p class="mt-1 text-xs text-slate-500"><%= pendingAppointment ? "Fee is automatically calculated based on appointment type." : "If a fee is already set, you can leave this as is." %></p>
                </div>

                <!-- Methods -->
                <div>
                    <label class="block text-sm font-medium mb-2">Payment method</label>

                    <div class="grid sm:grid-cols-2 gap-3">
                        <label class="flex items-center gap-3 p-4 rounded-2xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-900 hover:shadow-soft cursor-pointer">
                            <input type="radio" name="method" value="online" required class="h-4 w-4 text-brand-600 focus:ring-brand-600">
                            <div>
                                <div class="font-medium">Pay online now</div>
                                <div class="text-xs text-slate-500">Secure card payment via Stripe</div>
                            </div>
                        </label>

                        <label class="flex items-center gap-3 p-4 rounded-2xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-900 hover:shadow-soft cursor-pointer">
                            <input type="radio" name="method" value="clinic" required class="h-4 w-4 text-brand-600 focus:ring-brand-600">
                            <div>
                                <div class="font-medium">Pay at clinic</div>
                                <div class="text-xs text-slate-500">Settle your bill in person</div>
                            </div>
                        </label>
                    </div>
                </div>

                <!-- Actions -->
                <div class="flex items-center gap-3 pt-1">
                    <button class="inline-flex items-center px-5 py-2.5 rounded-xl bg-brand-600 hover:bg-brand-700 text-white font-medium shadow-soft">
                        Continue
                    </button>
                    <a href="<%= c %>/views/appointment-management/user_appointments.jsp"
                       class="inline-flex items-center px-4 py-2 rounded-xl border border-slate-200 dark:border-slate-800 hover:shadow-soft">
                        Cancel
                    </a>
                </div>
            </form>
        </div>
    </div>
</section>

<!-- FOOTER -->
<%@ include file="../common/footer.jsp" %>

<script>
    // Mobile nav toggle (if header provides it)
    // Mobile menu toggle
    const menuBtn = document.getElementById('menuBtn');
    const mobileNav = document.getElementById('mobileNav');
    menuBtn?.addEventListener('click', () => mobileNav.classList.toggle('hidden'));

    // Reveal on scroll
    const observer = new IntersectionObserver(entries => {
        entries.forEach(e => { if (e.isIntersecting) e.target.classList.add('visible'); });
    }, { threshold: 0.08 });
    document.querySelectorAll('.reveal').forEach(el => observer.observe(el));
</script>
</body>
</html>

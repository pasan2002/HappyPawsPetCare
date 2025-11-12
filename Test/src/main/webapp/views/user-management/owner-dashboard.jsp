<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String cpath = request.getContextPath();
    // Get owner info from session
    HttpSession userSession = request.getSession(false);
    String ownerName = userSession != null ? (String) userSession.getAttribute("ownerName") : "Pet Owner";
    if (ownerName == null) ownerName = "Pet Owner";
%>
<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Pet Owner Dashboard — Happy Paws PetCare</title>
    <meta name="description" content="Manage your pets and appointments." />

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
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Sora:wght@400;600;700&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    fontFamily: { sans: ['Inter','system-ui','sans-serif'], display: ['Sora','Inter','system-ui','sans-serif'] },
                    colors: {
                        brand: { 50:'#effaff',100:'#d7f0ff',200:'#b2e1ff',300:'#84cdff',400:'#53b2ff',500:'#2f97ff',600:'#1679e6',700:'#0f5fba',800:'#0f4c91',900:'#113e75' }
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
        .card-hover { transition: box-shadow .2s ease, transform .08s ease; }
        .card-hover:hover { transform: translateY(-2px); box-shadow: 0 20px 40px rgba(0,0,0,.12); }
    </style>
</head>
<body class="antialiased text-slate-800 dark:text-slate-100 bg-white dark:bg-slate-950">

<%@ include file="../common/header.jsp" %>

<!-- PAGE HEADER -->
<section class="relative overflow-hidden">
    <div class="absolute inset-0 bg-gradient-to-b from-brand-50 via-white to-white dark:from-slate-900 dark:via-slate-950 dark:to-slate-950"></div>
    <div class="absolute inset-0 bg-grid opacity-60 dark:opacity-20"></div>

    <div class="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10 md:py-14">
        <div class="text-center reveal">
            <h1 class="font-display text-3xl md:text-4xl font-extrabold tracking-tight">
                Welcome back, <%= ownerName %>!
            </h1>
            <p class="mt-4 text-lg text-slate-600 dark:text-slate-300 max-w-2xl mx-auto">
                Manage your pets and appointments all in one place. Keep your furry friends healthy and happy.
            </p>
        </div>
    </div>
</section>

<!-- MAIN CONTENT -->
<section class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 pb-16">
    
    <!-- Quick Actions -->
    <div class="mt-8 grid gap-6 md:grid-cols-2">
        
        <!-- My Pets Card -->
        <div class="reveal card-hover bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 shadow-soft p-8">
            <div class="flex items-center justify-between mb-6">
                <div class="flex items-center gap-4">
                    <div class="h-12 w-12 rounded-2xl bg-emerald-100 dark:bg-emerald-900/30 flex items-center justify-center">
                        <svg class="h-6 w-6 text-emerald-600 dark:text-emerald-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z" />
                        </svg>
                    </div>
                    <div>
                        <h3 class="text-xl font-semibold">My Pets</h3>
                        <p class="text-sm text-slate-600 dark:text-slate-400">Manage pet profiles and information</p>
                    </div>
                </div>
            </div>
            
            <div class="space-y-4">
                <p class="text-slate-600 dark:text-slate-400">
                    View and manage all your pet profiles, add new pets, update their information, and keep track of their medical history.
                </p>
                
                <div class="flex gap-3">
                    <a href="<%= cpath %>/owner/pets" 
                       class="flex-1 inline-flex items-center justify-center px-4 py-3 rounded-xl bg-emerald-600 hover:bg-emerald-700 text-white font-medium shadow-soft">
                        <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                        </svg>
                        View My Pets
                    </a>
                    <button onclick="location.href='<%= cpath %>/owner/pets'; setTimeout(() => toggleAddPetForm(), 500);" 
                            class="px-4 py-3 rounded-xl border border-slate-200 dark:border-slate-800 hover:shadow-soft bg-white dark:bg-slate-900">
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
                        </svg>
                    </button>
                </div>
            </div>
        </div>

        <!-- Book Appointments Card -->
        <div class="reveal card-hover bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 shadow-soft p-8">
            <div class="flex items-center justify-between mb-6">
                <div class="flex items-center gap-4">
                    <div class="h-12 w-12 rounded-2xl bg-brand-100 dark:bg-brand-900/30 flex items-center justify-center">
                        <svg class="h-6 w-6 text-brand-600 dark:text-brand-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v10a2 2 0 002 2h8a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
                        </svg>
                    </div>
                    <div>
                        <h3 class="text-xl font-semibold">My Appointments</h3>
                        <p class="text-sm text-slate-600 dark:text-slate-400">View and manage your appointments</p>
                    </div>
                </div>
            </div>
            
            <div class="space-y-4">
                <p class="text-slate-600 dark:text-slate-400">
                    View your upcoming and past appointments, track appointment history, and manage your scheduled visits.
                </p>
                
                <div class="flex gap-3">
                    <a href="<%= cpath %>/views/appointment-management/user_appointments.jsp" 
                       class="flex-1 inline-flex items-center justify-center px-4 py-3 rounded-xl bg-brand-600 hover:bg-brand-700 text-white font-medium shadow-soft">
                        <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v10a2 2 0 002 2h8a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
                        </svg>
                        View Appointments
                    </a>
                    <a href="<%= cpath %>/appointments/new" 
                       class="px-4 py-3 rounded-xl border border-slate-200 dark:border-slate-800 hover:shadow-soft bg-white dark:bg-slate-900">
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
                        </svg>
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- Quick Links Section -->
    <div class="mt-16">
        <h2 class="text-2xl font-semibold mb-8 reveal">Quick Links</h2>
        
        <div class="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
            <!-- Book New Appointment -->
            <a href="<%= cpath %>/appointments/new" 
               class="reveal card-hover block p-6 bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 shadow-soft">
                <div class="flex items-center gap-3 mb-3">
                    <div class="h-8 w-8 rounded-lg bg-blue-100 dark:bg-blue-900/30 flex items-center justify-center">
                        <svg class="h-4 w-4 text-blue-600 dark:text-blue-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
                        </svg>
                    </div>
                    <h3 class="font-medium">Book Appointment</h3>
                </div>
                <p class="text-sm text-slate-600 dark:text-slate-400">Schedule a new appointment for your pets</p>
            </a>

            <!-- User Profile -->
            <a href="<%= cpath %>/owner-profile" 
               class="reveal card-hover block p-6 bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 shadow-soft">
                <div class="flex items-center gap-3 mb-3">
                    <div class="h-8 w-8 rounded-lg bg-purple-100 dark:bg-purple-900/30 flex items-center justify-center">
                        <svg class="h-4 w-4 text-purple-600 dark:text-purple-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                        </svg>
                    </div>
                    <h3 class="font-medium">My Profile</h3>
                </div>
                <p class="text-sm text-slate-600 dark:text-slate-400">Update your personal information</p>
            </a>

            <!-- Change Password -->
            <a href="<%= cpath %>/owner-change-password" 
               class="reveal card-hover block p-6 bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 shadow-soft">
                <div class="flex items-center gap-3 mb-3">
                    <div class="h-8 w-8 rounded-lg bg-orange-100 dark:bg-orange-900/30 flex items-center justify-center">
                        <svg class="h-4 w-4 text-orange-600 dark:text-orange-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" />
                        </svg>
                    </div>
                    <h3 class="font-medium">Change Password</h3>
                </div>
                <p class="text-sm text-slate-600 dark:text-slate-400">Update your account password</p>
            </a>
        </div>
    </div>
</section>

<%@ include file="../common/footer.jsp" %>

<script>
    // Reveal on scroll
    const observer = new IntersectionObserver(entries => {
        entries.forEach(e => { if (e.isIntersecting) e.target.classList.add('visible'); });
    }, { threshold: 0.08 });
    document.querySelectorAll('.reveal').forEach(el => observer.observe(el));

    // Function to show add pet form (will be called when user navigates to pets page)
    function toggleAddPetForm() {
        // This function will be available when the pets page loads
        if (typeof window.toggleAddPetForm === 'function') {
            window.toggleAddPetForm();
        }
    }
</script>

</body>
</html>
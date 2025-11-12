<%@ page import="java.util.List" %>
<%@ page import="com.happypaws.petcare.model.MedicalRecord" %>
<%@ page import="com.happypaws.petcare.model.Pet" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<%
    Pet pet = (Pet) request.getAttribute("pet");
    List<MedicalRecord> records = (List<MedicalRecord>) request.getAttribute("records");
    String cpath = request.getContextPath();
    
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("MMM dd, yyyy HH:mm");
%>
<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Medical Records — <%= pet != null ? pet.getName() : "Pet" %> — Happy Paws PetCare</title>
    <meta name="description" content="View medical records for your pet." />

    <!-- Theme Manager - Inline -->
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
    </style>
</head>
<body class="antialiased text-slate-800 dark:text-slate-100 bg-white dark:bg-slate-950">

<%@ include file="../common/header.jsp" %>

<!-- PAGE HEADER -->
<section class="relative overflow-hidden">
    <div class="absolute inset-0 bg-gradient-to-b from-emerald-50 via-white to-white dark:from-slate-900 dark:via-slate-950 dark:to-slate-950"></div>
    <div class="absolute inset-0 bg-grid opacity-60 dark:opacity-20"></div>

    <div class="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10 md:py-14">
        <div class="reveal">
            <div class="flex items-center gap-2 text-sm text-slate-600 dark:text-slate-400 mb-3">
                <a href="<%= cpath %>/owner/pets" class="hover:text-brand-600">My Pets</a>
                <span>/</span>
                <span class="text-slate-900 dark:text-slate-100"><%= pet != null ? pet.getName() : "Pet" %></span>
            </div>
            <h1 class="font-display text-3xl md:text-4xl font-extrabold tracking-tight">
                Medical Records for <%= pet != null ? pet.getName() : "Pet" %>
            </h1>
            <p class="mt-2 text-sm text-slate-600 dark:text-slate-300">
                View your pet's complete medical history
            </p>
        </div>
    </div>
</section>

<!-- CONTENT -->
<section class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 pb-16">
    
    <!-- Pet Info Card -->
    <% if (pet != null) { %>
    <div class="reveal bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 shadow-soft p-6 mb-8">
        <h2 class="text-lg font-semibold mb-4">Pet Information</h2>
        <dl class="grid grid-cols-2 md:grid-cols-4 gap-4 text-sm">
            <div>
                <dt class="text-slate-500 mb-1">Name</dt>
                <dd class="font-medium"><%= pet.getName() %></dd>
            </div>
            <div>
                <dt class="text-slate-500 mb-1">Species</dt>
                <dd class="font-medium"><%= pet.getSpecies() != null ? pet.getSpecies() : "—" %></dd>
            </div>
            <div>
                <dt class="text-slate-500 mb-1">Breed</dt>
                <dd class="font-medium"><%= pet.getBreed() != null ? pet.getBreed() : "—" %></dd>
            </div>
            <div>
                <dt class="text-slate-500 mb-1">Date of Birth</dt>
                <dd class="font-medium"><%= pet.getDob() != null ? pet.getDob() : "—" %></dd>
            </div>
        </dl>
    </div>
    <% } %>

    <!-- Medical Records -->
    <div class="reveal">
        <div class="flex items-center justify-between mb-6">
            <h2 class="text-2xl font-bold">Medical History</h2>
            <a href="<%= cpath %>/owner/pets" 
               class="inline-flex items-center px-4 py-2 rounded-xl border border-slate-200 dark:border-slate-800 hover:shadow-soft">
                Back to Pets
            </a>
        </div>

        <% if (records != null && !records.isEmpty()) { %>
        <div class="space-y-4">
            <% for (MedicalRecord record : records) { %>
            <div class="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 shadow-soft p-6">
                <div class="flex items-start justify-between mb-4">
                    <div>
                        <div class="flex items-center gap-3 mb-2">
                            <span class="inline-flex items-center px-2 py-1 rounded-lg text-xs font-medium bg-emerald-50 dark:bg-emerald-900/30 text-emerald-700 dark:text-emerald-300">
                                Visit Record
                            </span>
                            <span class="text-sm text-slate-500">
                                <%= record.getVisitTime() != null ? record.getVisitTime().format(dateFormatter) : "Date not specified" %>
                            </span>
                        </div>
                        <h3 class="text-lg font-semibold">
                            Dr. <%= record.getStaffName() != null ? record.getStaffName() : "Unknown" %>
                        </h3>
                    </div>
                    <% if (record.getWeightKg() != null) { %>
                    <div class="text-right">
                        <div class="text-sm text-slate-500">Weight</div>
                        <div class="text-lg font-semibold"><%= record.getWeightKg() %> kg</div>
                    </div>
                    <% } %>
                </div>

                <% if (record.getNotes() != null && !record.getNotes().trim().isEmpty()) { %>
                <div class="mt-4 pt-4 border-t border-slate-200 dark:border-slate-800">
                    <h4 class="text-sm font-medium text-slate-500 mb-2">Medical Notes</h4>
                    <div class="text-sm whitespace-pre-wrap bg-slate-50 dark:bg-slate-800/50 rounded-xl p-4">
<%= record.getNotes() %>
                    </div>
                </div>
                <% } %>
            </div>
            <% } %>
        </div>
        <% } else { %>
        <!-- Empty state -->
        <div class="rounded-2xl border-2 border-dashed border-slate-200 dark:border-slate-800 p-10 text-center bg-white dark:bg-slate-900">
            <div class="mx-auto h-12 w-12 rounded-2xl bg-emerald-50 dark:bg-slate-800 flex items-center justify-center mb-3">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-emerald-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                </svg>
            </div>
            <h3 class="font-semibold">No medical records yet</h3>
            <p class="mt-1 text-sm text-slate-500 dark:text-slate-400">
                Medical records will appear here after veterinary visits.
            </p>
        </div>
        <% } %>
    </div>
</section>

<%@ include file="../common/footer.jsp" %>

<script>
    // Reveal on scroll
    const observer = new IntersectionObserver(entries => {
        entries.forEach(e => { if (e.isIntersecting) e.target.classList.add('visible'); });
    }, { threshold: 0.08 });
    document.querySelectorAll('.reveal').forEach(el => observer.observe(el));
</script>

</body>
</html>

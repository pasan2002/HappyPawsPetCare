<%@ page import="java.util.List" %>
<%@ page import="com.happypaws.petcare.model.GroomingSession" %>
<%@ page import="com.happypaws.petcare.model.Pet" %>
<%@ page import="com.happypaws.petcare.model.Staff" %>

<%
    List<GroomingSession> sessions = (List<GroomingSession>) request.getAttribute("sessions");
    List<Pet> pets = (List<Pet>) request.getAttribute("pets");
    List<Staff> staffList = (List<Staff>) request.getAttribute("staffList");
    GroomingSession editSession = (GroomingSession) request.getAttribute("editSession");
    String cpath = request.getContextPath();
    
    // Get logged-in staff information from session
    Integer loggedInStaffId = (Integer) session.getAttribute("staffId");
    String loggedInStaffName = (String) session.getAttribute("staffName");
    
    // Debug: Log session count
    if (sessions != null) {
        System.out.println("DEBUG: Total sessions loaded = " + sessions.size());
        for (GroomingSession s : sessions) {
            System.out.println("  Session ID: " + s.getSessionId() + 
                             ", Pet: " + s.getPetName() + 
                             ", Staff: " + s.getStaffName() +
                             ", Time: " + s.getSessionTime());
        }
    } else {
        System.out.println("DEBUG: sessions is NULL");
    }
%>
<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Grooming Sessions Management — Happy Paws PetCare</title>
    <meta name="description" content="Manage grooming sessions for pets." />

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
        .soft-card { transition: box-shadow .2s ease, transform .08s ease; }
        .soft-card:hover { transform: translateY(-1px); box-shadow: 0 10px 30px rgba(0,0,0,.08); }
        .fade-in { opacity: 0; transform: translateY(10px); transition: opacity 0.3s ease, transform 0.3s ease; }
        .fade-in.show { opacity: 1; transform: translateY(0); }
    </style>
</head>
<body class="antialiased text-slate-800 dark:text-slate-100 bg-white dark:bg-slate-950">

<%@ include file="../common/header.jsp" %>

<!-- PAGE HEADER -->
<section class="relative overflow-hidden">
    <div class="absolute inset-0 bg-gradient-to-b from-brand-50 via-white to-white dark:from-slate-900 dark:via-slate-950 dark:to-slate-950"></div>
    <div class="absolute inset-0 bg-grid opacity-60 dark:opacity-20"></div>

    <div class="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10 md:py-14">
        <div class="flex items-center justify-between gap-4 reveal">
            <div>
                <div class="flex items-center gap-3 mb-2">
                    <div class="w-12 h-12 rounded-2xl bg-gradient-to-br from-brand-500 to-brand-600 flex items-center justify-center shadow-lg">
                        <svg class="w-7 h-7 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z" />
                        </svg>
                    </div>
                    <h1 class="font-display text-3xl md:text-4xl font-extrabold tracking-tight">Grooming Sessions</h1>
                </div>
                <p class="mt-2 text-sm text-slate-600 dark:text-slate-300">Manage pet grooming appointments and records</p>
            </div>
            <div class="flex items-center gap-2">
                <button onclick="toggleAddSessionForm()" id="addSessionBtn"
                   class="inline-flex items-center gap-2 px-5 py-2.5 rounded-xl bg-brand-600 hover:bg-brand-700 text-white shadow-soft">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"/>
                    </svg>
                    Add New Session
                </button>
            </div>
        </div>
    </div>
</section>

<!-- CONTENT -->
<section class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 pb-16">

    <!-- Flash Messages -->
    <%
        String error = (String) request.getAttribute("error");
        String success = (String) request.getAttribute("success");
        if (error != null) {
    %>
    <div class="mt-6 rounded-xl p-4 text-sm bg-rose-50 text-rose-800 dark:bg-rose-900/30 dark:text-rose-200 border border-rose-200/50">
        <%= error %>
    </div>
    <% } else if (success != null) { %>
    <div class="mt-6 rounded-xl p-4 text-sm bg-emerald-50 text-emerald-800 dark:bg-emerald-900/30 dark:text-emerald-200 border border-emerald-200/50">
        <%= success %>
    </div>
    <% } %>

    <!-- Add/Edit Grooming Session Form (Initially Hidden) -->
    <div id="addSessionForm" class="mt-8 fade-in" style="<%= editSession != null ? "" : "display: none;" %>">
        <div class="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 shadow-soft p-6">
            <div class="flex items-center justify-between mb-6">
                <div class="flex items-center gap-3">
                    <div class="w-10 h-10 rounded-xl bg-brand-100 dark:bg-brand-900/30 flex items-center justify-center">
                        <svg class="w-6 h-6 text-brand-600 dark:text-brand-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z" />
                        </svg>
                    </div>
                    <h2 class="text-xl font-semibold">
                        <%= editSession != null ? "Edit Grooming Session" : "Add New Grooming Session" %>
                    </h2>
                </div>
                <button onclick="toggleAddSessionForm()" class="text-slate-400 hover:text-slate-600 dark:hover:text-slate-300 transition-colors">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                    </svg>
                </button>
            </div>
            
            <form method="post" action="<%= cpath %>/grooming/sessions" class="space-y-6">
                <input type="hidden" name="action" value="<%= editSession != null ? "update" : "create" %>" />
                <% if (editSession != null) { %>
                <input type="hidden" name="sessionId" value="<%= editSession.getSessionId() %>" />
                <% } %>
                
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <!-- Pet Selection -->
                    <div>
                        <label for="petUid" class="block text-sm font-medium mb-2 text-slate-700 dark:text-slate-300">
                            Pet <span class="text-rose-600">*</span>
                        </label>
                        <select id="petUid" name="petUid" required
                                class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-3 py-2 focus:border-brand-500 focus:ring-2 focus:ring-brand-500/20 transition-all">
                            <option value="">Select a pet</option>
                            <% if (pets != null) {
                                for (Pet pet : pets) { %>
                            <option value="<%= pet.getPetUid() %>" 
                                <%= editSession != null && editSession.getPetUid() != null && editSession.getPetUid().equals(pet.getPetUid()) ? "selected" : "" %>>
                                <%= pet.getName() %> (<%= pet.getSpecies() %>)
                            </option>
                            <% } } %>
                        </select>
                    </div>

                    <!-- Staff Selection -->
                    <div>
                        <label for="staffDisplay" class="block text-sm font-medium mb-2 text-slate-700 dark:text-slate-300">
                            Groomer <span class="text-rose-600">*</span>
                        </label>
                        <input type="text" id="staffDisplay" 
                               value="<%= loggedInStaffName != null ? loggedInStaffName : "Current Staff Member" %>" 
                               readonly
                               class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-slate-100 dark:bg-slate-800 px-3 py-2 text-slate-600 dark:text-slate-400 cursor-not-allowed">
                        <input type="hidden" name="staffId" value="<%= loggedInStaffId != null ? loggedInStaffId : "" %>">
                        <p class="mt-1 text-xs text-slate-500 dark:text-slate-400">You are creating this session as the logged-in staff member</p>
                    </div>

                    <!-- Session Time -->
                    <div>
                        <label for="sessionTime" class="block text-sm font-medium mb-2 text-slate-700 dark:text-slate-300">
                            Session Date & Time
                        </label>
                        <input type="datetime-local" id="sessionTime" name="sessionTime"
                               value="<%= editSession != null && editSession.getSessionTime() != null ? editSession.getSessionTime().toString().substring(0, 16) : "" %>"
                               class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-3 py-2 focus:border-brand-500 focus:ring-2 focus:ring-brand-500/20 transition-all" />
                    </div>

                    <!-- Service Type -->
                    <div>
                        <label for="serviceType" class="block text-sm font-medium mb-2 text-slate-700 dark:text-slate-300">
                            Service Type
                        </label>
                        <select id="serviceType" name="serviceType"
                                class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-3 py-2 focus:border-brand-500 focus:ring-2 focus:ring-brand-500/20 transition-all">
                            <option value="">Select service type</option>
                            <option value="bath" <%= editSession != null && "bath".equals(editSession.getServiceType()) ? "selected" : "" %>>Bath</option>
                            <option value="haircut" <%= editSession != null && "haircut".equals(editSession.getServiceType()) ? "selected" : "" %>>Haircut</option>
                            <option value="nail-trim" <%= editSession != null && "nail-trim".equals(editSession.getServiceType()) ? "selected" : "" %>>Nail Trim</option>
                            <option value="full-groom" <%= editSession != null && "full-groom".equals(editSession.getServiceType()) ? "selected" : "" %>>Full Grooming</option>
                            <option value="spa" <%= editSession != null && "spa".equals(editSession.getServiceType()) ? "selected" : "" %>>Spa Treatment</option>
                            <option value="other" <%= editSession != null && "other".equals(editSession.getServiceType()) ? "selected" : "" %>>Other</option>
                        </select>
                    </div>
                </div>

                <!-- Notes -->
                <div>
                    <label for="notes" class="block text-sm font-medium mb-2 text-slate-700 dark:text-slate-300">
                        Session Notes
                    </label>
                    <textarea id="notes" name="notes" rows="4"
                              class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-3 py-2 focus:border-brand-500 focus:ring-2 focus:ring-brand-500/20 transition-all"
                              placeholder="Enter grooming details, pet behavior, special requirements, etc..."><%= editSession != null && editSession.getNotes() != null ? editSession.getNotes() : "" %></textarea>
                </div>

                <!-- Submit Button -->
                <div class="flex items-center gap-3 pt-4">
                    <button type="submit" 
                            class="inline-flex items-center gap-2 px-6 py-3 rounded-xl bg-brand-600 hover:bg-brand-700 text-white font-medium shadow-lg shadow-brand-500/30 transition-all hover:shadow-xl hover:shadow-brand-500/40">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
                        </svg>
                        <%= editSession != null ? "Update Session" : "Create Session" %>
                    </button>
                    <button type="button" onclick="toggleAddSessionForm()"
                            class="inline-flex items-center px-4 py-3 rounded-xl border border-slate-300 dark:border-slate-700 hover:bg-slate-50 dark:hover:bg-slate-800 transition-all">
                        Cancel
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Grooming Sessions Cards -->
    <div class="mt-8">
        <% if (sessions != null && !sessions.isEmpty()) { %>
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            <% for (GroomingSession groomingSession : sessions) { %>
            <div class="bg-gradient-to-br from-white to-brand-50/20 dark:from-slate-900 dark:to-brand-950/10 rounded-2xl border border-slate-200 dark:border-slate-800 shadow-lg hover:shadow-xl hover:shadow-brand-500/10 transition-all duration-300 overflow-hidden soft-card">
                <!-- Card Header -->
                <div class="bg-gradient-to-r from-brand-500 to-brand-600 px-5 py-4">
                    <div class="flex items-center justify-between">
                        <div class="flex items-center gap-3">
                            <div class="w-10 h-10 rounded-xl bg-white/20 backdrop-blur-sm flex items-center justify-center">
                                <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z" />
                                </svg>
                            </div>
                            <div>
                                <h3 class="font-bold text-white text-lg"><%= groomingSession.getPetName() != null ? groomingSession.getPetName() : "Unknown Pet" %></h3>
                                <p class="text-white/80 text-xs"><%= groomingSession.getSpecies() != null ? groomingSession.getSpecies() : "—" %></p>
                            </div>
                        </div>
                        <div class="text-right">
                            <span class="text-white/80 text-xs font-medium">Session</span>
                            <p class="text-white font-mono font-bold">#<%= groomingSession.getSessionId() %></p>
                        </div>
                    </div>
                </div>
                
                <!-- Card Body -->
                <div class="p-5 space-y-4">
                    <!-- Groomer Info -->
                    <div class="flex items-start gap-3">
                        <div class="w-8 h-8 rounded-lg bg-brand-100 dark:bg-brand-900/30 flex items-center justify-center flex-shrink-0">
                            <svg class="w-4 h-4 text-brand-600 dark:text-brand-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                            </svg>
                        </div>
                        <div class="flex-1">
                            <p class="text-xs text-slate-500 dark:text-slate-400 font-medium">Groomer</p>
                            <p class="text-sm font-semibold text-slate-800 dark:text-slate-200"><%= groomingSession.getStaffName() != null ? groomingSession.getStaffName() : "—" %></p>
                        </div>
                    </div>

                    <!-- Session Time -->
                    <div class="flex items-start gap-3">
                        <div class="w-8 h-8 rounded-lg bg-brand-100 dark:bg-brand-900/30 flex items-center justify-center flex-shrink-0">
                            <svg class="w-4 h-4 text-brand-600 dark:text-brand-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                            </svg>
                        </div>
                        <div class="flex-1">
                            <p class="text-xs text-slate-500 dark:text-slate-400 font-medium">Date & Time</p>
                            <p class="text-sm font-semibold text-slate-800 dark:text-slate-200"><%= groomingSession.getSessionTime() != null ? groomingSession.getSessionTime().toString().replace("T", " ").substring(0, 16) : "—" %></p>
                        </div>
                    </div>

                    <!-- Service Type -->
                    <div class="flex items-start gap-3">
                        <div class="w-8 h-8 rounded-lg bg-brand-100 dark:bg-brand-900/30 flex items-center justify-center flex-shrink-0">
                            <svg class="w-4 h-4 text-brand-600 dark:text-brand-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 7h.01M7 3h5c.512 0 1.024.195 1.414.586l7 7a2 2 0 010 2.828l-7 7a2 2 0 01-2.828 0l-7-7A1.994 1.994 0 013 12V7a4 4 0 014-4z" />
                            </svg>
                        </div>
                        <div class="flex-1">
                            <p class="text-xs text-slate-500 dark:text-slate-400 font-medium">Service Type</p>
                            <span class="inline-block mt-1 px-3 py-1 rounded-full text-xs font-semibold bg-brand-600 text-white capitalize">
                                <%= groomingSession.getServiceType() != null && !groomingSession.getServiceType().isEmpty() ? groomingSession.getServiceType().replace("-", " ") : "Not specified" %>
                            </span>
                        </div>
                    </div>

                    <!-- Notes -->
                    <% if (groomingSession.getNotes() != null && !groomingSession.getNotes().isEmpty()) { %>
                    <div class="pt-3 border-t border-slate-200 dark:border-slate-800">
                        <p class="text-xs text-slate-500 dark:text-slate-400 font-medium mb-1">Notes</p>
                        <p class="text-sm text-slate-700 dark:text-slate-300 line-clamp-2"><%= groomingSession.getNotes() %></p>
                    </div>
                    <% } %>
                </div>
                
                <!-- Card Footer -->
                <div class="px-5 py-3 bg-slate-50 dark:bg-slate-800/50 border-t border-slate-200 dark:border-slate-800">
                    <div class="flex items-center gap-2">
                        <a href="<%= cpath %>/grooming/sessions?action=edit&id=<%= groomingSession.getSessionId() %>"
                           class="flex-1 inline-flex items-center justify-center gap-1 px-3 py-2 rounded-lg bg-brand-600 hover:bg-brand-700 text-white text-xs font-medium shadow-sm transition-all">
                            <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/>
                            </svg>
                            Edit
                        </a>
                        <form method="post" action="<%= request.getContextPath() %>/grooming/sessions" style="display:inline;" onsubmit="return confirm('Delete this grooming session? This action cannot be undone.');">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="sessionId" value="<%= groomingSession.getSessionId() %>">
                            <button type="submit"
                                    class="flex-1 inline-flex items-center justify-center gap-1 px-3 py-2 rounded-lg bg-rose-600 hover:bg-rose-700 text-white text-xs font-medium shadow-sm transition-all">
                                <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/>
                                </svg>
                                Delete
                            </button>
                        </form>
                    </div>
                </div>
            </div>
            <% } %>
        </div>
        <% } else { %>

        <!-- Empty state -->
        <div class="reveal">
            <div class="rounded-2xl border-2 border-dashed border-slate-300 dark:border-slate-700 p-10 text-center bg-gradient-to-br from-white to-brand-50/30 dark:from-slate-900 dark:to-brand-950/20">
                <div class="mx-auto h-16 w-16 rounded-2xl bg-gradient-to-br from-brand-100 to-brand-200 dark:from-brand-900/50 dark:to-brand-900/30 flex items-center justify-center mb-4 shadow-lg">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8 text-brand-600 dark:text-brand-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z" />
                    </svg>
                </div>
                <h3 class="font-semibold text-lg text-slate-800 dark:text-slate-200">No grooming sessions yet</h3>
                <p class="mt-1 text-sm text-slate-500 dark:text-slate-400">Start scheduling grooming appointments for your pets.</p>
                <div class="mt-6">
                    <button onclick="toggleAddSessionForm()"
                       class="inline-flex items-center gap-2 px-5 py-2.5 rounded-xl bg-brand-600 hover:bg-brand-700 text-white shadow-lg shadow-brand-500/30 transition-all hover:shadow-xl hover:shadow-brand-500/40">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"/>
                        </svg>
                        Add New Session
                    </button>
                </div>
            </div>
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

    // Toggle Add Session Form
    function toggleAddSessionForm() {
        const form = document.getElementById('addSessionForm');
        const btn = document.getElementById('addSessionBtn');
        
        if (form.style.display === 'none' || form.style.display === '') {
            form.style.display = 'block';
            setTimeout(() => form.classList.add('show'), 10);
            btn.textContent = 'Cancel';
            btn.classList.remove('bg-gradient-to-r', 'from-groom-600', 'to-fuchsia-600', 'hover:from-groom-700', 'hover:to-fuchsia-700', 'shadow-lg', 'shadow-groom-500/30', 'hover:shadow-xl', 'hover:shadow-groom-500/40');
            btn.classList.add('bg-slate-600', 'hover:bg-slate-700');
            
            // Scroll to form
            form.scrollIntoView({ behavior: 'smooth', block: 'start' });
        } else {
            form.classList.remove('show');
            setTimeout(() => form.style.display = 'none', 300);
            btn.textContent = 'Add New Session';
            btn.classList.remove('bg-slate-600', 'hover:bg-slate-700');
            btn.classList.add('bg-brand-600', 'hover:bg-brand-700', 'shadow-lg', 'shadow-brand-500/30', 'hover:shadow-xl', 'hover:shadow-brand-500/40');
            
            // Reload to clear edit mode
            window.location.href = '<%= cpath %>/grooming/sessions';
        }
    }

    async function deleteSession(sessionId) {
        console.log("deleteSession called with sessionId:", sessionId);
        
        if(!confirm("Delete this grooming session? This action cannot be undone.")) {
            console.log("Delete cancelled by user");
            return;
        }
        
        const formData = new FormData();
        formData.append('action', 'delete');
        formData.append('sessionId', sessionId);
        
        console.log("Sending delete request for sessionId:", sessionId);
        
        try {
            const res = await fetch("<%= cpath %>/grooming/sessions", {
                method: "POST",
                body: formData
            });
            
            console.log("Delete response status:", res.status);
            
            if(res.ok) {
                console.log("Delete successful, reloading page");
                location.reload();
            } else {
                const errorText = await res.text();
                console.error("Delete failed:", errorText);
                alert("Failed to delete grooming session: " + (res.status === 403 ? "Access denied" : "Server error"));
            }
        } catch (e) {
            console.error("Delete error:", e);
            alert("Error deleting session: " + e.message);
        }
    }
    
    // Auto-show form if in edit mode
    <% if (editSession != null) { %>
    window.addEventListener('DOMContentLoaded', function() {
        const form = document.getElementById('addSessionForm');
        const btn = document.getElementById('addSessionBtn');
        form.classList.add('show');
        btn.textContent = 'Cancel';
        btn.classList.remove('bg-brand-600', 'hover:bg-brand-700', 'shadow-lg', 'shadow-brand-500/30', 'hover:shadow-xl', 'hover:shadow-brand-500/40');
        btn.classList.add('bg-slate-600', 'hover:bg-slate-700');
    });
    <% } %>
    
    <% if (error != null) { %>
    window.addEventListener('DOMContentLoaded', function() {
        toggleAddSessionForm();
    });
    <% } %>
</script>

</body>
</html>

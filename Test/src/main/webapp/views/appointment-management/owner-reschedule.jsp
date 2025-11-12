<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Request Reschedule — Happy Paws PetCare</title>
    <meta name="description" content="Request to reschedule your confirmed appointment." />

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
    </style>
</head>
<body class="antialiased text-slate-800 dark:text-slate-100 bg-white dark:bg-slate-950">

<%@ include file="../common/header.jsp" %>

<%
    String apcontext = request.getContextPath();
    String idParam = request.getParameter("id");
%>

<!-- PAGE HEADER -->
<section class="relative overflow-hidden">
    <div class="absolute inset-0 bg-gradient-to-b from-brand-50 via-white to-white dark:from-slate-900 dark:via-slate-950 dark:to-slate-950"></div>
    <div class="absolute inset-0 bg-grid opacity-60 dark:opacity-20"></div>

    <div class="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10 md:py-14">
        <div class="flex items-center justify-between gap-4 reveal">
            <div>
                <h1 class="font-display text-3xl md:text-4xl font-extrabold tracking-tight">Request Reschedule</h1>
                <p class="mt-2 text-sm text-slate-600 dark:text-slate-300">Owners can reschedule only confirmed appointments.</p>
                <div class="mt-3 flex items-center gap-2 text-xs text-amber-600 dark:text-amber-400">
                    <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
                        <path fill-rule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clip-rule="evenodd"></path>
                    </svg>
                    <span>Your reschedule request will reset the appointment status to "pending" for receptionist confirmation.</span>
                </div>
            </div>
            <a href="<%= apcontext %>/views/user_appointments.jsp"
               class="inline-flex items-center px-4 py-2 rounded-xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 hover:shadow-soft">
                ← My appointments
            </a>
        </div>

        <!-- Flash messages -->
        <% if (request.getParameter("e") != null) { %>
        <div class="reveal mt-6 rounded-xl p-4 text-sm bg-rose-50 text-rose-800 dark:bg-rose-900/30 dark:text-rose-200 border border-rose-200/50">
            <%= request.getParameter("e") %>
        </div>
        <% } %>
    </div>
</section>

<!-- CONTENT -->
<section class="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 pb-16">
    <div id="alert" class="hidden mt-6 rounded-xl p-4 text-sm"></div>

    <div class="reveal relative">
        <div class="absolute -inset-2 rounded-3xl bg-gradient-to-tr from-brand-600/20 via-brand-400/10 to-brand-600/20 blur-2xl"></div>

        <form method="post" action="<%= apcontext %>/owner/reschedule"
              class="relative mt-6 rounded-3xl border border-slate-200 dark:border-slate-800 bg-white/80 dark:bg-slate-900/60 p-6 md:p-7 shadow-soft backdrop-blur overflow-hidden">
        <input type="hidden" name="appointmentId" id="appointmentId" value="<%= idParam != null ? idParam : "" %>"/>

        <div class="space-y-6">
            <div class="grid sm:grid-cols-2 gap-4">
                <div>
                    <label class="block text-sm font-medium mb-1">Pet</label>
                    <div class="flex items-center gap-2">
                        <input id="petDisplay" disabled
                               class="flex-1 rounded-xl border border-slate-300 dark:border-slate-700 bg-slate-50 dark:bg-slate-800/50 px-3 py-2 text-sm" />
                        <div class="w-3 h-3 rounded-full bg-green-500 flex-shrink-0" title="Pet confirmed"></div>
                    </div>
                </div>
                <div>
                    <label class="block text-sm font-medium mb-1">Type</label>
                    <input id="type" disabled
                           class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-slate-50 dark:bg-slate-800/50 px-3 py-2 text-sm" />
                </div>
            </div>

            <div class="grid sm:grid-cols-3 gap-4">
                <div>
                    <label class="block text-sm font-medium mb-1">Current date</label>
                    <input id="currentDate" disabled
                           class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-slate-50 dark:bg-slate-800/50 px-3 py-2 text-sm" />
                </div>
                <div>
                    <label class="block text-sm font-medium mb-1">Current time</label>
                    <input id="currentTime" disabled
                           class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-slate-50 dark:bg-slate-800/50 px-3 py-2 text-sm" />
                </div>
                <div>
                    <label class="block text-sm font-medium mb-1">Status</label>
                    <div class="flex items-center gap-2">
                        <input id="status" disabled
                               class="flex-1 rounded-xl border border-slate-300 dark:border-slate-700 bg-slate-50 dark:bg-slate-800/50 px-3 py-2 text-sm" />
                        <div id="statusIndicator" class="w-3 h-3 rounded-full flex-shrink-0" title="Status indicator"></div>
                    </div>
                </div>
            </div>

            <div class="bg-slate-50 dark:bg-slate-800/50 rounded-xl p-4 border border-slate-200 dark:border-slate-700">
                <h3 class="text-sm font-medium text-slate-700 dark:text-slate-300 mb-3">Reschedule to New Date & Time</h3>
                <div class="grid sm:grid-cols-2 gap-4">
                    <div>
                        <label for="date" class="block text-sm font-medium mb-1">New date <span class="text-rose-600">*</span></label>
                        <input id="date" name="date" type="date" required
                               class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-3 py-2" />
                        <div id="dateError" class="text-red-500 text-sm mt-1 hidden"></div>
                    </div>
                    <div>
                        <label for="time" class="block text-sm font-medium mb-1">New time <span class="text-rose-600">*</span></label>
                        <input id="time" name="time" type="time" required
                               min="08:00" max="18:00"
                               title="Appointment time must be between 8:00 AM and 6:00 PM"
                               class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-3 py-2" />
                        <div id="timeError" class="text-red-500 text-sm mt-1 hidden"></div>
                        <p class="text-xs text-slate-500 mt-1">Business hours: 8:00 AM - 6:00 PM</p>
                    </div>
                </div>
            </div>

            <div class="flex items-center gap-3 pt-2">
                <button class="inline-flex items-center px-5 py-2.5 rounded-xl bg-brand-600 hover:bg-brand-700 text-white font-medium shadow-soft">
                    Submit reschedule
                </button>
                <a href="<%= apcontext %>/views/user_appointments.jsp"
                   class="inline-flex items-center px-4 py-2 rounded-xl border border-slate-200 dark:border-slate-800 hover:shadow-soft">
                    Cancel
                </a>
            </div>
        </div>
    </form>
    </div>
</section>

<%@ include file="../common/footer.jsp" %>

<script>
    const BASE = "<%= apcontext %>/appointments";
    const APPT_ID = "<%= idParam != null ? idParam : "" %>";

    function showAlert(type, msg){
        const el = document.getElementById('alert');
        el.className = "mt-6 rounded-xl p-4 text-sm " +
            (type === 'success'
                ? "bg-emerald-50 text-emerald-800 dark:bg-emerald-900/30 dark:text-emerald-200 border border-emerald-200/50"
                : "bg-rose-50 text-rose-800 dark:bg-rose-900/30 dark:text-rose-200 border border-rose-200/50");
        el.textContent = msg;
        el.classList.remove('hidden');
    }

    function toParts(iso){
        if (!iso) return { d:"", t:"" };
        const d = new Date(iso);
        const yyyy = d.getFullYear();
        const mm = String(d.getMonth()+1).padStart(2,'0');
        const dd = String(d.getDate()).padStart(2,'0');
        const HH = String(d.getHours()).padStart(2,'0');
        const MM = String(d.getMinutes()).padStart(2,'0');
        return { d:`${yyyy}-${mm}-${dd}`, t:`${HH}:${MM}` };
    }

    async function loadAppt(){
        if (!APPT_ID) { showAlert('error','Missing appointment id.'); return; }
        
        try {
            const res = await fetch(`${BASE}?id=${encodeURIComponent(APPT_ID)}`);
            if (!res.ok){ showAlert('error','Failed to load appointment.'); return; }
            const a = await res.json();

            // Enhanced UI display with pet info
            const petInfo = a.petUid ? `${a.petUid}` : 'N/A';
            document.getElementById('petDisplay').value = petInfo;
            document.getElementById('type').value = a.type || '';
            document.getElementById('status').value = a.status || '';
            
            // Status indicator color
            const statusIndicator = document.getElementById('statusIndicator');
            const status = (a.status || '').toLowerCase();
            statusIndicator.className = `w-2 h-2 rounded-full ${
                status == 'confirmed' ? 'bg-green-500' :
                status == 'pending' ? 'bg-yellow-500' :
                status == 'done' ? 'bg-blue-500' :
                status == 'cancelled' ? 'bg-red-500' : 'bg-gray-500'
            }`;
            
            const parts = toParts(a.scheduledAt);
            document.getElementById('currentDate').value = parts.d;
            document.getElementById('currentTime').value = parts.t;

            // Enhanced validation - allow only confirmed appointments
            if (status !== 'confirmed') {
                showAlert('error','Only confirmed appointments can be rescheduled. Current status: ' + (a.status || 'Unknown'));
                // disable form
                document.querySelectorAll('input[name], button[type="submit"]').forEach(el=>{
                    el.disabled = true; 
                    el.classList.add('opacity-60','cursor-not-allowed');
                });
                return;
            }

            // Set constraints for new date/time
            const now = new Date();
            const yyyy = now.getFullYear();
            const mm = String(now.getMonth()+1).padStart(2,'0'); 
            const dd = String(now.getDate()).padStart(2,'0');
            document.getElementById('date').min = `${yyyy}-${mm}-${dd}`;
            
            // Pre-fill with current date/time as starting point
            document.getElementById('date').value = parts.d;
            document.getElementById('time').value = parts.t;
            
            showAlert('success', 'Appointment loaded successfully. You can now select a new date and time.');
            
        } catch (error) {
            console.error('Error loading appointment:', error);
            showAlert('error', 'Failed to load appointment details. Please try again.');
        }
    }

    // Enhanced form validation
    function validateForm() {
        let isValid = true;
        const dateInput = document.getElementById('date');
        const timeInput = document.getElementById('time');
        const dateError = document.getElementById('dateError');
        const timeError = document.getElementById('timeError');

        // Clear previous errors
        dateError.classList.add('hidden');
        timeError.classList.add('hidden');
        dateInput.classList.remove('border-red-500');
        timeInput.classList.remove('border-red-500');

        // Validate date
        const selectedDate = new Date(dateInput.value);
        const today = new Date();
        today.setHours(0, 0, 0, 0);
        
        if (selectedDate < today) {
            dateError.textContent = 'New appointment date cannot be in the past';
            dateError.classList.remove('hidden');
            dateInput.classList.add('border-red-500');
            isValid = false;
        }

        // Validate time (business hours 8:00-18:00)
        const timeValue = timeInput.value;
        if (timeValue) {
            const [hours] = timeValue.split(':').map(Number);
            if (hours < 8 || hours >= 18) {
                timeError.textContent = 'Appointment time must be between 8:00 AM and 6:00 PM';
                timeError.classList.remove('hidden');
                timeInput.classList.add('border-red-500');
                isValid = false;
            }
        }

        return isValid;
    }

    // Add form submission validation
    document.querySelector('form').addEventListener('submit', function(e) {
        if (!validateForm()) {
            e.preventDefault();
            showAlert('error', 'Please fix the errors above before submitting.');
        }
    });

    // Real-time validation
    document.getElementById('date').addEventListener('change', validateForm);
    document.getElementById('time').addEventListener('change', validateForm);

    document.addEventListener('DOMContentLoaded', loadAppt);

    // Reveal on scroll
    const observer = new IntersectionObserver(entries => {
        entries.forEach(e => { if (e.isIntersecting) e.target.classList.add('visible'); });
    }, { threshold: 0.08 });
    document.querySelectorAll('.reveal').forEach(el => observer.observe(el));
</script>

</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Receptionist Dashboard — Happy Paws PetCare</title>
  <meta name="description" content="Manage bookings, reschedules, completions, and cancellations." />

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
  <!-- Chart.js for analytics -->
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
    .bg-grid{background-image:radial-gradient(circle at 1px 1px, rgba(16,24,40,.08) 1px, transparent 0);background-size:24px 24px;mask-image:radial-gradient(ellipse 70% 60% at 50% -10%, black 40%, transparent 60%)}
    .reveal{opacity:0;transform:translateY(12px);transition:opacity .6s ease,transform .6s ease}
    .reveal.visible{opacity:1;transform:translateY(0)}
    th{font-weight:600;color:rgb(71 85 105)}
    .dark th{color:rgb(203 213 225)}
    .cal-day{cursor:pointer}
    .cal-day.disabled{opacity:.45;cursor:default}
    .cal-day.selected{outline:2px solid rgb(47,151,255);outline-offset:2px;border-radius:.75rem}
    
    /* Disabled button states */
    button:disabled, button.disabled {
      opacity: 0.5 !important;
      cursor: not-allowed !important;
      pointer-events: none;
    }
    
    button:disabled:hover, button.disabled:hover {
      box-shadow: none !important;
      background-color: inherit !important;
    }

    /* Reminder Button States */
    .reminder-btn-available {
      border-color: rgb(34 197 94) !important; /* Green border */
      background-color: rgb(240 253 244) !important; /* Light green background */
      color: rgb(21 128 61) !important; /* Dark green text */
      position: relative;
    }

    .reminder-btn-available::before {
      content: "🟢";
      position: absolute;
      left: 8px;
      top: 50%;
      transform: translateY(-50%);
      font-size: 12px;
    }

    .reminder-btn-available {
      padding-left: 28px !important; /* Make room for emoji */
    }

    .reminder-btn-sent {
      border-color: rgb(34 197 94) !important; /* Green border */
      background-color: rgb(220 252 231) !important; /* Darker green background */
      color: rgb(21 128 61) !important; /* Dark green text */
      position: relative;
    }

    .reminder-btn-sent::before {
      content: "✅";
      position: absolute;
      left: 8px;
      top: 50%;
      transform: translateY(-50%);
      font-size: 12px;
    }

    .reminder-btn-sent {
      padding-left: 32px !important; /* Make room for emoji */
    }

    .reminder-btn-restricted {
      border-color: rgb(251 146 60) !important; /* Orange border */
      background-color: rgb(255 247 237) !important; /* Light orange background */
      color: rgb(154 52 18) !important; /* Dark orange text */
      position: relative;
    }

    .reminder-btn-restricted::before {
      content: "🟡";
      position: absolute;
      left: 8px;
      top: 50%;
      transform: translateY(-50%);
      font-size: 12px;
    }

    .reminder-btn-restricted {
      padding-left: 28px !important; /* Make room for emoji */
    }

    /* Dark mode support */
    .dark .reminder-btn-available {
      background-color: rgb(20 83 45) !important;
      color: rgb(187 247 208) !important;
    }

    .dark .reminder-btn-sent {
      background-color: rgb(22 101 52) !important;
      color: rgb(187 247 208) !important;
    }

    .dark .reminder-btn-restricted {
      background-color: rgb(120 53 15) !important;
      color: rgb(254 215 170) !important;
    }
  </style>
</head>
<body class="antialiased text-slate-800 dark:text-slate-100 bg-white dark:bg-slate-950">

<%@ include file="../common/header.jsp" %>

<!-- PAGE HEADER -->
<section class="relative overflow-hidden">
  <div class="absolute inset-0 bg-gradient-to-b from-brand-50 via-white to-white dark:from-slate-900 dark:via-slate-950 dark:to-slate-950"></div>
  <div class="absolute inset-0 bg-grid opacity-60 dark:opacity-20"></div>

  <div class="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10 md:py-14">
    <div class="grid md:grid-cols-2 gap-6 items-center reveal">
      <div>
        <h1 class="font-display text-3xl md:text-4xl font-extrabold tracking-tight">Receptionist Dashboard</h1>
        <p class="mt-2 text-sm text-slate-600 dark:text-slate-300">
          Manage bookings, reschedules, mark done, and cancellations — all in one place.
        </p>
        <div class="mt-6 flex flex-wrap gap-3 items-center">
          <a href="<%= request.getContextPath() %>/views/appointment-management/add-appointment.jsp"
             class="inline-flex items-center justify-center px-5 py-3 rounded-xl bg-brand-600 hover:bg-brand-700 text-white font-medium shadow-soft">
            + Add appointment
          </a>
          <button onclick="refreshData()"
                  class="inline-flex items-center justify-center px-5 py-3 rounded-xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 hover:shadow-soft">
            Refresh
          </button>
        </div>
      </div>

      <!-- Quick stats -->
      <div class="reveal">
        <div class="relative mx-auto w-full max-w-xl">
          <div class="absolute -inset-2 rounded-3xl bg-gradient-to-tr from-brand-600/25 via-brand-400/15 to-brand-600/25 blur-2xl"></div>
          <div class="relative rounded-3xl bg-white/70 dark:bg-slate-900/60 border border-slate-200/70 dark:border-slate-700 p-6 shadow-soft backdrop-blur">
            <div class="grid grid-cols-3 gap-3">
              <div class="p-4 rounded-2xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-900 text-center">
                <p class="text-xs text-slate-500">Today Confirmed</p>
                <p id="heroActive" class="text-2xl font-extrabold tabular-nums">0</p>
              </div>
              <div class="p-4 rounded-2xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-900 text-center">
                <p class="text-xs text-slate-500">Completed</p>
                <p id="heroCompleted" class="text-2xl font-extrabold tabular-nums">0</p>
              </div>
              <div class="p-4 rounded-2xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-900 text-center">
                <p class="text-xs text-slate-500">Cancelled</p>
                <p id="heroCancelled" class="text-2xl font-extrabold tabular-nums">0</p>
              </div>
            </div>
            <p class="mt-3 text-[11px] text-slate-500 dark:text-slate-400">Counts update as you take actions below.</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</section>

<section class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 pb-16">

  <!-- ===== Calendar (click a day to filter tables) ===== -->
  <div class="reveal rounded-3xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 shadow-soft p-5">
    <div class="flex items-center justify-between">
      <h2 class="font-semibold text-base">Calendar</h2>
      <div class="flex items-center gap-2">
        <button id="calPrev" class="px-3 py-1.5 rounded-lg border border-slate-300 dark:border-slate-700">‹</button>
        <div id="calLabel" class="min-w-[12ch] text-center font-medium"></div>
        <button id="calNext" class="px-3 py-1.5 rounded-lg border border-slate-300 dark:border-slate-700">›</button>
      </div>
    </div>

    <div class="mt-3 grid grid-cols-7 text-[11px] text-slate-500 dark:text-slate-400">
      <div class="py-1 text-center">Sun</div><div class="py-1 text-center">Mon</div><div class="py-1 text-center">Tue</div>
      <div class="py-1 text-center">Wed</div><div class="py-1 text-center">Thu</div><div class="py-1 text-center">Fri</div><div class="py-1 text-center">Sat</div>
    </div>

    <div id="calGrid" class="grid grid-cols-7 gap-1 mt-1"></div>

    <p class="mt-3 text-[11px] text-slate-500 dark:text-slate-400">
      Click a day to filter the appointment lists below. Click “Clear” on the pill to remove the filter.
    </p>
  </div>

  <!-- Active date pill -->
  <div id="dateFilterPill" class="hidden mt-6">
    <span class="inline-flex items-center gap-2 rounded-xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 px-3 py-1 text-xs">
      <span class="text-slate-500">Filtered by</span>
      <strong id="dateFilterText" class="font-medium"></strong>
      <button class="px-2 py-0.5 rounded-lg border border-slate-300 dark:border-slate-700"
              onclick="clearDateFilter()">Clear</button>
    </span>
  </div>

  <!-- Analytics Section -->
  <div class="reveal mt-8">
    <div class="flex items-center justify-between mb-6">
      <h2 class="font-display text-2xl font-bold tracking-tight">Analytics Dashboard</h2>
      <button onclick="forceRefreshAnalytics()" 
              class="px-4 py-2 rounded-lg border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 hover:bg-slate-50 dark:hover:bg-slate-800 text-sm font-medium transition-colors">
        Refresh Charts
      </button>
    </div>
    
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-6">
      <!-- Status Distribution Chart -->
      <div class="rounded-3xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 shadow-soft p-6">
        <h3 class="font-semibold text-lg text-slate-700 dark:text-slate-200 mb-4">Appointment Status Distribution</h3>
        <div class="relative h-64">
          <canvas id="statusChart"></canvas>
        </div>
      </div>

      <!-- Weekly Trends Chart -->
      <div class="rounded-3xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 shadow-soft p-6">
        <h3 class="font-semibold text-lg text-slate-700 dark:text-slate-200 mb-4">Weekly Appointment Trends</h3>
        <div class="relative h-64">
          <canvas id="weeklyChart"></canvas>
        </div>
      </div>
    </div>

    <!-- Performance Metrics -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
      <div class="rounded-2xl border border-blue-200 dark:border-blue-800 bg-gradient-to-r from-blue-50 to-indigo-50 dark:from-blue-900/20 dark:to-indigo-900/20 p-4">
        <div class="flex items-center justify-between">
          <div>
            <p class="text-xs font-medium text-blue-600 dark:text-blue-400 uppercase tracking-wider">Completion Rate</p>
            <p class="text-2xl font-bold text-blue-900 dark:text-blue-100" id="completionRate">0%</p>
          </div>
          <div class="w-10 h-10 bg-blue-500 rounded-full flex items-center justify-center">
            <svg class="w-5 h-5 text-white" fill="currentColor" viewBox="0 0 24 24">
              <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/>
            </svg>
          </div>
        </div>
      </div>

      <div class="rounded-2xl border border-amber-200 dark:border-amber-800 bg-gradient-to-r from-amber-50 to-orange-50 dark:from-amber-900/20 dark:to-orange-900/20 p-4">
        <div class="flex items-center justify-between">
          <div>
            <p class="text-xs font-medium text-amber-600 dark:text-amber-400 uppercase tracking-wider">Cancellation Rate</p>
            <p class="text-2xl font-bold text-amber-900 dark:text-amber-100" id="cancellationRate">0%</p>
          </div>
          <div class="w-10 h-10 bg-amber-500 rounded-full flex items-center justify-center">
            <svg class="w-5 h-5 text-white" fill="currentColor" viewBox="0 0 24 24">
              <path d="M12 2C6.47 2 2 6.47 2 12s4.47 10 10 10 10-4.47 10-10S17.53 2 12 2zm5 13.59L15.59 17 12 13.41 8.41 17 7 15.59 10.59 12 7 8.41 8.41 7 12 10.59 15.59 7 17 8.41 13.41 12 17 15.59z"/>
            </svg>
          </div>
        </div>
      </div>

      <div class="rounded-2xl border border-emerald-200 dark:border-emerald-800 bg-gradient-to-r from-emerald-50 to-green-50 dark:from-emerald-900/20 dark:to-green-900/20 p-4">
        <div class="flex items-center justify-between">
          <div>
            <p class="text-xs font-medium text-emerald-600 dark:text-emerald-400 uppercase tracking-wider">Today Active</p>
            <p class="text-2xl font-bold text-emerald-900 dark:text-emerald-100" id="todayActive">0</p>
          </div>
          <div class="w-10 h-10 bg-emerald-500 rounded-full flex items-center justify-center">
            <svg class="w-5 h-5 text-white" fill="currentColor" viewBox="0 0 24 24">
              <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/>
            </svg>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- Upcoming -->
  <div class="reveal mt-6">
    <div class="flex items-center justify-between">
      <h3 class="font-display text-xl font-bold tracking-tight">Upcoming appointments</h3>
      <span id="countActive" class="text-xs text-slate-500"></span>
    </div>

    <div class="mt-3 rounded-3xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 shadow-soft overflow-hidden">
      <div class="max-h-[560px] overflow-auto">
        <table class="min-w-full text-sm table-fixed">
          <colgroup>
            <col class="w-[18rem]" />
            <col class="w-[16rem]" />
            <col class="w-[7rem]" />
            <col class="w-[10rem]" />
            <col class="w-[12rem]" />
            <col class="w-[10rem]" />
            <col class="w-[14rem]" />
            <col class="w-[8rem]" />
            <col class="w-[10rem]" />
          </colgroup>
          <thead class="bg-slate-50/70 dark:bg-slate-800/70 backdrop-blur sticky top-0 z-10 border-b border-slate-200 dark:border-slate-800">
          <tr class="text-xs font-medium text-slate-500 dark:text-slate-400">
            <th class="px-4 py-3 text-left">When</th>
            <th class="px-4 py-3 text-left">Pet</th>
            <th class="px-4 py-3 text-left">Owner</th>
            <th class="px-4 py-3 text-left">Type</th>
            <th class="px-4 py-3 text-left">Phone</th>
            <th class="px-4 py-3 text-left">Status</th>
            <th class="px-4 py-3 text-left">Payment</th>
            <th class="px-4 py-3 text-left">Fee</th>
            <th class="px-4 py-3 text-left">Actions</th>
          </tr>
          </thead>
          <tbody id="appointmentsBody" class="divide-y divide-slate-200 dark:divide-slate-800"></tbody>
        </table>
      </div>
    </div>
  </div>

  <!-- Completed -->
  <div class="reveal mt-10">
    <div class="flex items-center justify-between">
      <h3 class="font-display text-xl font-bold tracking-tight">Completed appointments</h3>
      <span id="countCompleted" class="text-xs text-slate-500"></span>
    </div>
    <div class="mt-3 rounded-3xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 shadow-soft overflow-hidden">
      <table class="min-w-full text-sm">
        <thead class="bg-slate-50 dark:bg-slate-800/50">
        <tr>
          <th class="px-4 py-3 text-left">ID</th>
          <th class="px-4 py-3 text-left">Pet UID</th>
          <th class="px-4 py-3 text-left">Owner</th>
          <th class="px-4 py-3 text-left">Type</th>
          <th class="px-4 py-3 text-left">Completed at</th>
        </tr>
        </thead>
        <tbody id="completedBody" class="divide-y divide-slate-200 dark:divide-slate-800"></tbody>
      </table>
    </div>
  </div>

  <!-- Cancelled -->
  <div class="reveal mt-10">
    <div class="flex items-center justify-between">
      <h3 class="font-display text-xl font-bold tracking-tight">Cancelled appointments</h3>
      <span id="countCanceled" class="text-xs text-slate-500"></span>
    </div>
    <div class="mt-3 rounded-3xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 shadow-soft overflow-hidden">
      <table class="min-w-full text-sm">
        <thead class="bg-slate-50 dark:bg-slate-800/50">
        <tr>
          <th class="px-4 py-3 text-left">ID</th>
          <th class="px-4 py-3 text-left">Pet UID</th>
          <th class="px-4 py-3 text-left">Owner</th>
          <th class="px-4 py-3 text-left">Type</th>
          <th class="px-4 py-3 text-left">Scheduled at</th>
          <th class="px-4 py-3 text-left">Actions</th>
        </tr>
        </thead>
        <tbody id="canceledBody" class="divide-y divide-slate-200 dark:divide-slate-800"></tbody>
      </table>
    </div>
  </div>
</section>

<!-- ACTIONS MODAL -->
<div id="actionModal" class="fixed inset-0 z-[100] hidden" aria-hidden="true">
  <div class="absolute inset-0 bg-slate-900/60 backdrop-blur-sm"></div>
  <div class="absolute inset-0 flex items-center justify-center p-4">
    <div class="w-full max-w-md rounded-2xl bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-700 shadow-soft"
         role="dialog" aria-modal="true" aria-labelledby="actionModalTitle">
      <div class="flex items-start justify-between gap-4 p-5 border-b border-slate-200 dark:border-slate-800">
        <div>
          <h4 id="actionModalTitle" class="font-semibold text-base">Choose an action</h4>
          <p id="actionModalSub" class="mt-0.5 text-xs text-slate-500"></p>
        </div>
        <button id="actionModalClose"
                class="px-2.5 py-1.5 rounded-lg border border-slate-300 dark:border-slate-700 hover:shadow-soft"
                aria-label="Close">✕</button>
      </div>

      <div class="p-5 space-y-3">
        <div id="actionMeta" class="text-xs text-slate-500"></div>
        <div id="dateValidationInfo" class="text-xs bg-amber-50 dark:bg-amber-900/20 border border-amber-200 dark:border-amber-800 rounded-lg p-3 hidden">
          <div class="font-medium text-amber-800 dark:text-amber-200 mb-1">⏰ Time Restrictions:</div>
          <ul class="text-amber-700 dark:text-amber-300 space-y-1">
            <li>• Reminders: Only day before appointment</li>
            <li>• Mark Done: Only after appointment time has passed</li>
          </ul>
        </div>

        <div class="grid grid-cols-2 gap-3">
          <button id="btnConfirm"
                  class="rounded-xl border border-slate-300 dark:border-slate-700 px-4 py-2 hover:shadow-soft">
            Confirm
          </button>

          <button id="btnReminder"
                  class="rounded-xl border border-blue-300 dark:border-blue-600 bg-blue-50 dark:bg-blue-900/20 text-blue-700 dark:text-blue-300 px-4 py-2 hover:shadow-soft">
            Send Reminder
          </button>

          <a id="btnReschedule"
             class="rounded-xl border border-slate-300 dark:border-slate-700 px-4 py-2 hover:shadow-soft text-center"
             href="#">
            Reschedule
          </a>

          <button id="btnDone"
                  class="rounded-xl border border-slate-300 dark:border-slate-700 px-4 py-2 hover:shadow-soft">
            Mark Done
          </button>

          <button id="btnCancel"
                  class="rounded-xl bg-rose-600 text-white px-4 py-2 hover:bg-rose-700 col-span-2">
            Cancel Appointment
          </button>
        </div>
      </div>
    </div>
  </div>
</div>

<%@ include file= "/views/common/footer.jsp" %>

<script>
  // Reveal on scroll
  const observer = new IntersectionObserver(entries => {
    entries.forEach(e => { if (e.isIntersecting) e.target.classList.add('visible'); });
  }, { threshold: 0.08 });
  document.querySelectorAll('.reveal').forEach(el => observer.observe(el));

  // Theme toggle hookup (optional header button)
  (function setupThemeToggle(){
    const btn = document.getElementById('themeToggle');
    const icon = document.getElementById('themeIcon');
    const root = document.documentElement;
    function setIcon() {
      const isDark = root.classList.contains('dark');
      if (!icon) return;
      icon.innerHTML = isDark
              ? '<path d="M12 3.1a1 1 0 0 1 1.1.3 9 9 0 1 0 7.5 7.5 1 1 0 0 1 1.3 1.2A11 11 0 1 1 12 2a1 1 0 0 1 0 1.1Z"/>'
              : '<path d="M21 12.79A9 9 0 1 1 11.21 3a7 7 0 1 0 9.79 9.79Z"/>';
    }
    setIcon();
    btn && btn.addEventListener('click', () => {
      root.classList.toggle('dark');
      try { localStorage.setItem('theme', root.classList.contains('dark') ? 'dark' : 'light'); } catch (e) {}
      setIcon();
    });
  })();

  // === API ===
  const BASE = "<%= request.getContextPath() %>/appointments";
  const RES_PAGE = "<%= request.getContextPath() %>/views/appointment-management/reschedule-appointment.jsp";

  // Flag to prevent operations when page is unloading (e.g., during logout)
  let isPageUnloading = false;
  
  // AbortController to cancel ongoing fetch requests when page unloads
  let fetchAbortController = new AbortController();

  // ===== Calendar state =====
  let CAL_YEAR, CAL_MONTH; // month is 0-based
  let FILTER_DATE = null;  // "YYYY-MM-DD"
  let APPT_CACHE = [];

  // ---- helpers
  function fmtWhen(iso) {
    if (!iso) return { date: "-", time: "" };
    const d = new Date(iso);
    return {
      date: d.toLocaleDateString(undefined, { year: 'numeric', month: 'short', day: 'numeric' }),
      time: d.toLocaleTimeString(undefined, { hour: 'numeric', minute: '2-digit' })
    };
  }

  // Pet data cache to avoid repeated API calls
  const PET_CACHE = new Map();

  // Function to fetch pet details by UID (via staff-only API)
  async function fetchPetByUid(petUid) {
    if (!petUid) return null;

    // Check cache first
    if (PET_CACHE.has(petUid)) {
      return PET_CACHE.get(petUid);
    }

    const url = `<%= request.getContextPath() %>/api/pets/by-uid?uid=${encodeURIComponent(petUid)}`;
    try {
      const res = await fetch(url, { 
        headers: { 'Accept': 'application/json' },
        signal: fetchAbortController.signal 
      });
      if (!res.ok) {
        console.warn('Pet lookup failed', res.status);
        PET_CACHE.set(petUid, null);
        return null;
      }
      const pet = await res.json();
      PET_CACHE.set(petUid, pet);
      return pet;
    } catch (e) {
      // Silently ignore abort errors
      if (e.name === 'AbortError') {
        return null;
      }
      console.warn('Failed to fetch pet details for', petUid, e);
      PET_CACHE.set(petUid, null);
      return null;
    }
  }

  // Function to enhance appointments with pet data
  async function enhanceAppointmentsWithPetData(appointments) {
    console.log('Enhancing appointments with pet data:', appointments.length, 'appointments');
    const enhanced = [];
    
    for (const appt of appointments) {
      const enhancedAppt = { ...appt };
      
      // Fetch pet details if petUid exists
      if (appt.petUid) {
        console.log('Processing appointment with petUid:', appt.petUid);
        const pet = await fetchPetByUid(appt.petUid);
        if (pet) {
          console.log('Enhanced appointment with pet data:', pet);
          enhancedAppt.petName = pet.name;
          enhancedAppt.petSpecies = pet.species;
          enhancedAppt.petBreed = pet.breed;
          enhancedAppt.ownerName = pet.ownerName;
        } else {
          console.log('No pet data found for UID:', appt.petUid);
        }
      } else {
        console.log('Appointment has no petUid:', appt);
      }
      
      enhanced.push(enhancedAppt);
    }
    
    console.log('Enhanced appointments:', enhanced);
    return enhanced;
  }

  // Helper function to format pet display
  function formatPetDisplay(appt) {
    if (appt.petName) {
      let display = appt.petName;
      if (appt.petSpecies) {
        display += ` (${appt.petSpecies})`;
      }
      return display;
    }
    return appt.petUid || 'Unknown Pet';
  }

  // Helper function to format owner display
  function formatOwnerDisplay(appt) {
    return appt.ownerName || `Owner ID: ${appt.ownerId || 'Unknown'}`;
  }
  function pill(s) {
    const key = (s || 'pending').toLowerCase();
    const styles = {
      pending:   "bg-amber-100 text-amber-700 dark:bg-amber-200/20 dark:text-amber-300",
      confirmed: "bg-emerald-100 text-emerald-700 dark:bg-emerald-200/20 dark:text-emerald-300",
      done:      "bg-slate-100 text-slate-700 dark:bg-slate-200/10 dark:text-slate-300",
      cancelled: "bg-rose-100 text-rose-700 dark:bg-rose-200/20 dark:text-rose-300"
    }[key] || "bg-slate-100 text-slate-700 dark:bg-slate-200/10 dark:text-slate-300";
    const txt = key.charAt(0).toUpperCase() + key.slice(1);
    return `<span class="inline-flex items-center px-2.5 py-0.5 rounded-lg text-xs font-medium ${styles}">${txt}</span>`;
  }
  function paymentPill(method, status) {
    const m = (method || "-").toUpperCase();
    const s = (status || "UNPAID").toUpperCase();
    const ok = s === "PAID";
    const base = ok
            ? "bg-emerald-100 text-emerald-700 dark:bg-emerald-200/20 dark:text-emerald-300"
            : "bg-amber-100 text-amber-700 dark:bg-amber-200/20 dark:text-amber-300";
    const label = m === "CLINIC" ? `Pay at clinic — ${s}` : `${m} — ${s}`;
    return `<span class="inline-flex rounded-lg px-2.5 py-0.5 text-xs font-medium ${base}">${label}</span>`;
  }
  function dateKey(iso) {
    if (!iso) return '';
    const d = new Date(iso);
    const y = d.getFullYear();
    const m = String(d.getMonth()+1).padStart(2,'0');
    const da= String(d.getDate()).padStart(2,'0');
    return `${y}-${m}-${da}`;
  }

  // ===== Rows =====
  function rowActive(appt){
    const { date, time } = fmtWhen(appt.scheduledAt);
    const fee = (appt.fee != null) ? `Rs${appt.fee}` : "-";
    const petDisplay = formatPetDisplay(appt);
    const ownerDisplay = formatOwnerDisplay(appt);

    const payload = encodeURIComponent(JSON.stringify({
      id: appt.appointmentId,
      method: appt.paymentMethod || '',
      status: appt.paymentStatus || '',
      petUid: appt.petUid || '',
      petName: appt.petName || '',
      petSpecies: appt.petSpecies || '',
      ownerId: appt.ownerId || '',
      ownerName: appt.ownerName || '',
      type: appt.type || '',
      phoneNo: appt.phoneNo || '',
      scheduledAt: appt.scheduledAt || '',
      fee: appt.fee
    }));

    return `<tr class="odd:bg-white even:bg-slate-50/40 dark:odd:bg-slate-900 dark:even:bg-slate-900/60 hover:bg-slate-50/70 dark:hover:bg-slate-800/40 transition">
      <td class="px-4 py-3">
        <div class="font-medium">${date}</div>
        <div class="text-xs text-slate-500">${time}</div>
      </td>
      <td class="px-4 py-3">
        <div class="font-medium">${petDisplay}</div>
        <div class="text-xs text-slate-500 font-mono">UID: ${appt.petUid || "-"}</div>
      </td>
      <td class="px-4 py-3">
        <div class="font-medium">${ownerDisplay}</div>
        ${appt.ownerId ? `<div class="text-xs text-slate-500">ID: ${appt.ownerId}</div>` : ''}
      </td>
      <td class="px-4 py-3">${appt.type || "-"}</td>
      <td class="px-4 py-3"><span class="tabular-nums">${appt.phoneNo || "-"}</span></td>
      <td class="px-4 py-3">${pill(appt.status)}</td>
      <td class="px-4 py-3">${paymentPill(appt.paymentMethod, appt.paymentStatus)}</td>
      <td class="px-4 py-3"><span class="font-medium">${fee}</span></td>
      <td class="px-4 py-3">
        <button class="px-3 py-1.5 rounded-lg border border-slate-300 dark:border-slate-700 hover:shadow-soft transition"
                onclick="openActionModal('${payload}')">
          Actions
        </button>
      </td>
    </tr>`;
  }
  function rowCompleted(appt){
    const when = appt.scheduledAt ? new Date(appt.scheduledAt).toLocaleString() : "-";
    return `<tr>
      <td class="px-4 py-3">${appt.appointmentId}</td>
      <td class="px-4 py-3 font-mono text-xs">${appt.petUid || "-"}</td>
      <td class="px-4 py-3">${appt.ownerId || "-"}</td>
      <td class="px-4 py-3">${appt.type || "-"}</td>
      <td class="px-4 py-3">${when}</td>
    </tr>`;
  }
  function rowCanceled(appt){
    const when = appt.scheduledAt ? new Date(appt.scheduledAt).toLocaleString() : "-";
    return `<tr>
      <td class="px-4 py-3">${appt.appointmentId}</td>
      <td class="px-4 py-3 font-mono text-xs">${appt.petUid || "-"}</td>
      <td class="px-4 py-3">${appt.ownerId || "-"}</td>
      <td class="px-4 py-3">${appt.type || "-"}</td>
      <td class="px-4 py-3">${when}</td>
      <td class="px-4 py-3">
        <button class="px-3 py-1.5 rounded-lg bg-rose-600 text-white hover:bg-rose-700"
                onclick="deleteAppointment(${appt.appointmentId})">
          Delete
        </button>
      </td>
    </tr>`;
  }

  // ===== Date filter (calendar → tables) =====
  function setCalendarFilter(dateISO) {
    FILTER_DATE = dateISO;
    updateDatePill();
    renderTables();
    highlightSelectedDay();
  }
  function clearDateFilter() {
    FILTER_DATE = null;
    updateDatePill();
    renderTables();
    highlightSelectedDay();
  }
  function updateDatePill(){
    const pill = document.getElementById('dateFilterPill');
    const txt  = document.getElementById('dateFilterText');
    if (!pill) return;
    if (FILTER_DATE) {
      const d = new Date(FILTER_DATE + 'T00:00:00');
      txt.textContent = d.toLocaleDateString(undefined, { year:'numeric', month:'short', day:'numeric' });
      pill.classList.remove('hidden');
    } else {
      pill.classList.add('hidden');
    }
  }

  // ===== Calendar rendering =====
  function monthLabel(y,m){ return new Date(y,m,1).toLocaleString(undefined,{month:'long',year:'numeric'}); }
  function startOfMonth(y,m){ return new Date(y,m,1); }
  function endOfMonth(y,m){ return new Date(y,m+1,0); } // last day
  function ymd(d){ const y=d.getFullYear(), m=String(d.getMonth()+1).padStart(2,'0'), da=String(d.getDate()).padStart(2,'0'); return `${y}-${m}-${da}`; }
  
  // Get current date in Sri Lanka timezone (Asia/Colombo, UTC+5:30)
  function getSriLankaDate() {
    const now = new Date();
    // Convert to Sri Lanka time using toLocaleString
    const sriLankaTimeStr = now.toLocaleString('en-US', { timeZone: 'Asia/Colombo' });
    return new Date(sriLankaTimeStr);
  }
  
  // Get today's date string in YYYY-MM-DD format using Sri Lanka timezone
  function getTodayStrSriLanka() {
    const today = getSriLankaDate();
    return ymd(today);
  }

  function computeCountsByDate(list){
    const map = Object.create(null);
    list.forEach(a => {
      const key = dateKey(a.scheduledAt);
      if (!key) return;
      map[key] = (map[key] || 0) + 1; // count all statuses; tweak if you only want active
    });
    return map;
  }

  function renderCalendar(){
    const label = document.getElementById('calLabel');
    const grid  = document.getElementById('calGrid');
    if (!label || !grid) return;

    label.textContent = monthLabel(CAL_YEAR, CAL_MONTH);
    grid.innerHTML = "";

    const first = startOfMonth(CAL_YEAR, CAL_MONTH);
    const last  = endOfMonth(CAL_YEAR, CAL_MONTH);

    const lead = first.getDay();                // blanks before the 1st
    const days = last.getDate();                // number of days in month
    const counts = computeCountsByDate(APPT_CACHE);

    // leading blanks (previous month)
    for (let i=0;i<lead;i++){
      grid.insertAdjacentHTML('beforeend',
              `<div class="p-2 rounded-xl text-center text-xs text-slate-400 dark:text-slate-600 bg-slate-50 dark:bg-slate-800/40"> </div>`);
    }

    // days
    for (let d=1; d<=days; d++){
      const dt = new Date(CAL_YEAR, CAL_MONTH, d);
      const key = ymd(dt);
      const count = counts[key] || 0;

      const isToday = key === getTodayStrSriLanka();
      const isSelected = FILTER_DATE === key;

      grid.insertAdjacentHTML('beforeend', `
        <button
          class="cal-day ${isSelected ? 'selected' : ''} rounded-xl text-left p-2 border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 hover:shadow-soft"
          data-cal-date="${key}">
          <div class="flex items-center justify-between">
            <span class="text-sm font-medium ${isToday ? 'text-brand-700' : ''}">${d}</span>
            ${count ? `<span class="inline-flex items-center justify-center text-[10px] px-1.5 py-0.5 rounded-full bg-brand-600 text-white">${count}</span>` : ''}
          </div>
        </button>
      `);
    }

    // trailing blanks to complete the grid
    const totalCells = lead + days;
    const tail = (7 - (totalCells % 7)) % 7;
    for (let i=0;i<tail;i++){
      grid.insertAdjacentHTML('beforeend',
              `<div class="p-2 rounded-xl text-center text-xs text-slate-400 dark:text-slate-600 bg-slate-50 dark:bg-slate-800/40"> </div>`);
    }
  }

  function highlightSelectedDay(){
    document.querySelectorAll('[data-cal-date]').forEach(el=>{
      el.classList.toggle('selected', FILTER_DATE === el.getAttribute('data-cal-date'));
    });
  }

  // calendar nav
  document.addEventListener('click', (e)=>{
    const cell = e.target.closest('[data-cal-date]');
    if (cell){ setCalendarFilter(cell.getAttribute('data-cal-date')); }
  });
  document.getElementById('calPrev').addEventListener('click', ()=>{
    CAL_MONTH--; if (CAL_MONTH<0){ CAL_MONTH=11; CAL_YEAR--; }
    renderCalendar(); highlightSelectedDay();
  });
  document.getElementById('calNext').addEventListener('click', ()=>{
    CAL_MONTH++; if (CAL_MONTH>11){ CAL_MONTH=0; CAL_YEAR++; }
    renderCalendar(); highlightSelectedDay();
  });

  // ===== Data rendering =====
  function renderTables(){
    const activeBody    = document.getElementById("appointmentsBody");
    const completedBody = document.getElementById("completedBody");
    const canceledBody  = document.getElementById("canceledBody");
    activeBody.innerHTML = completedBody.innerHTML = canceledBody.innerHTML = "";

    let activeCount=0, completedCount=0, canceledCount=0;
    let todayConfirmedCount=0; // New counter for today's confirmed appointments

    const list = FILTER_DATE
            ? APPT_CACHE.filter(a => dateKey(a.scheduledAt) === FILTER_DATE)
            : APPT_CACHE;

    // Get today's date in Sri Lanka timezone for filtering
    const todayStr = getTodayStrSriLanka();
    
    console.log('renderTables - Today date (Sri Lanka time):', todayStr);

    list.forEach(a=>{
      const s = (a.status || "").toLowerCase().trim();
      
      // Count today's confirmed appointments for active count
      if (s === "confirmed") {
        // Extract date from scheduledAt in various formats
        let appointmentDate = null;
        if (a.scheduledAt) {
          if (a.scheduledAt.includes('T')) {
            appointmentDate = a.scheduledAt.split('T')[0];
          } else if (a.scheduledAt.includes(' ')) {
            appointmentDate = a.scheduledAt.split(' ')[0];
          } else {
            appointmentDate = a.scheduledAt;
          }
        }
        
        console.log('renderTables - Checking confirmed appointment:', a.appointmentId, 'Date:', appointmentDate, 'vs Today:', todayStr);
        
        if (appointmentDate === todayStr) {
          todayConfirmedCount++;
          console.log('renderTables - MATCHED! Today confirmed count now:', todayConfirmedCount);
        }
      }
      
      if (s === "cancelled") { 
        canceledBody.insertAdjacentHTML("beforeend", rowCanceled(a));  
        canceledCount++; 
      }
      else if (s === "done") { 
        completedBody.insertAdjacentHTML("beforeend", rowCompleted(a)); 
        completedCount++; 
      }
      else { 
        activeBody.insertAdjacentHTML("beforeend", rowActive(a)); 
        activeCount++; 
      }
    });

    document.getElementById("countActive").textContent    = activeCount    ? `${activeCount} items`    : "No items";
    document.getElementById("countCompleted").textContent = completedCount ? `${completedCount} items` : "No items";
    document.getElementById("countCanceled").textContent  = canceledCount  ? `${canceledCount} items`  : "No items";

    // Update hero stats - use today's confirmed count for "Upcoming" 
    document.getElementById("heroActive").textContent    = todayConfirmedCount; // Changed to use confirmed count for today
    document.getElementById("heroCompleted").textContent = completedCount;
    document.getElementById("heroCancelled").textContent = canceledCount;
    
    console.log('renderTables - Updated heroActive with today confirmed count:', todayConfirmedCount);
  }

  async function refreshData(){
    // Don't execute if page is unloading (e.g., during logout)
    if (isPageUnloading) {
      console.log('Skipping refreshData - page is unloading');
      return;
    }
    
    try {
      // Show loading state
      document.getElementById("appointmentsBody").innerHTML = 
        '<tr><td colspan="9" class="px-4 py-8 text-center text-slate-500">Loading appointment and pet details...</td></tr>';
      
      const res = await fetch(BASE, { signal: fetchAbortController.signal });
      const data = await res.json();
      const rawAppointments = Array.isArray(data) ? data : [];
      
      console.log('Raw appointments loaded:', rawAppointments.length);
      console.log('Sample raw appointment:', rawAppointments[0]);
      
      // Enhance appointments with pet data
      APPT_CACHE = await enhanceAppointmentsWithPetData(rawAppointments);
      
      console.log('Enhanced appointments:', APPT_CACHE.length);
      console.log('Sample enhanced appointment:', APPT_CACHE[0]);
      
      renderCalendar();
      renderTables();
      highlightSelectedDay();
      
      // Update analytics after all data is loaded
      updateAnalytics();
      
      // Update database status to connected
      updateDbStatus(true);
    } catch (error) {
      // Silently ignore abort errors (happens during logout/page unload)
      if (error.name === 'AbortError') {
        console.log('Fetch aborted - page is unloading');
        return;
      }
      
      console.error('Failed to refresh data:', error);
      
      let errorMessage = 'Failed to load data. Please try again.';
      let retryAdvice = '';
      
      // Handle specific error types
      if (error.message && error.message.includes('Database connection')) {
        errorMessage = 'Database connection issue detected.';
        retryAdvice = ' The system is attempting to reconnect automatically.';
        updateDbStatus(false, 'Connection Lost');
        // Auto-retry after a short delay (only if page is not unloading)
        setTimeout(() => {
          if (!isPageUnloading) {
            console.log('Auto-retrying data refresh...');
            refreshData();
          }
        }, 5000);
      } else {
        updateDbStatus(false, 'Load Failed');
      }
      
      document.getElementById("appointmentsBody").innerHTML = 
        `<tr><td colspan="9" class="px-4 py-8 text-center text-red-500">${errorMessage}${retryAdvice}</td></tr>`;
      
      // Show a user-friendly notification
      showTemporaryMessage('Unable to load appointment data. ' + (retryAdvice || 'Please refresh the page.'), 'error');
    }
  }

  // ===== Updates & actions =====
  async function api(url, options = {}) {
    const res = await fetch(url, options);
    let payload = null;
    try { payload = await res.json(); } catch {}
    if (!res.ok) {
      const msg = (payload && (payload.error || payload.message)) || res.statusText || 'Request failed';
      throw new Error(msg);
    }
    return payload;
  }

  async function updateStatus(id, newStatus){
    const actionMap = { confirmed: 'confirm', done: 'done', cancelled: 'cancel' };

    const tryPut = async (payload) => {
      const res = await fetch(BASE, {
        method: "PUT",
        headers: { "Content-Type":"application/json" },
        body: JSON.stringify(payload)
      });
      let json = null; try { json = await res.json(); } catch {}
      if (!res.ok) {
        const msg = (json && (json.error || json.message)) || res.statusText || "Request failed";
        throw new Error(msg);
      }
      return json;
    };

    const disableAll = (v) => {
      document.querySelectorAll('#actionModal button, #actionModal a').forEach(el => el.disabled = !!v);
    };

    try {
      disableAll(true);
      try {
        await tryPut({ appointmentId: id, status: newStatus });
      } catch (e1) {
        const action = actionMap[newStatus] || newStatus;
        await tryPut({ appointmentId: id, action });
      }
      try { closeActionModal(); } catch {}
      await refreshData();
    } catch (e) {
      alert("Update failed: " + e.message);
    } finally {
      disableAll(false);
    }
  }

  async function deleteAppointment(id){
    const ok = confirm("Delete this appointment permanently?");
    if (!ok) return;
    try {
      // Close modal first to prevent DOM conflicts
      closeActionModal();
      
      await api(`${BASE}?id=${id}`, { method: "DELETE" });
      await refreshData();
      
      // Show success message
      showTemporaryMessage('Appointment deleted successfully', 'success');
    } catch (e) {
      alert("Failed to delete: " + e.message);
    }
  }

  // In-memory tracking of sent reminders (temporary solution until DB is updated)
  let sentReminders = new Set();

  async function sendReminder(id){
    console.log('sendReminder called for appointment ID:', id);
    console.log('Current appointment data:', CURRENT_APPT);
    console.log('Already sent reminders (in memory):', Array.from(sentReminders));
    
    // Double-check date validation
    if (CURRENT_APPT) {
      const appointmentDate = getAppointmentDate(CURRENT_APPT);
      const tomorrow = getSriLankaDate();
      tomorrow.setDate(tomorrow.getDate() + 1);
      const tomorrowStr = ymd(tomorrow);
      
      if (appointmentDate !== tomorrowStr) {
        alert('Reminders can only be sent the day before the appointment (Sri Lanka time). This appointment is scheduled for ' + appointmentDate + '.');
        return;
      }
    }
    
    // Check if reminder already sent (both database and in-memory)
    const reminderAlreadySent = CURRENT_APPT.reminderSent === true || CURRENT_APPT.reminderSent === 'true' || sentReminders.has(id);
    if (reminderAlreadySent) {
      alert('Reminder has already been sent for this appointment.');
      return;
    }
    
    const ok = confirm("Send appointment reminder email to the pet owner?");
    if (!ok) return;
    
    const disableAll = (v) => {
      document.querySelectorAll('#actionModal button, #actionModal a').forEach(el => el.disabled = !!v);
    };
    
    try {
      disableAll(true);
      
      // Show loading state
      const btnReminder = document.getElementById('btnReminder');
      if (!btnReminder) {
        console.error('Reminder button not found');
        return;
      }
      const originalText = btnReminder.textContent;
      btnReminder.textContent = 'Sending...';
      
      const result = await api(`${BASE}/reminder`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ appointmentId: id })
      });
      
      let message = "Reminder email sent successfully!";
      if (result && result.reminderCount) {
        message += " This is reminder #" + result.reminderCount + " for this appointment.";
      }
      alert(message);
      
      // Add to in-memory tracking (temporary until DB is updated)
      sentReminders.add(id);
      console.log('Added appointment', id, 'to sent reminders. Current set:', Array.from(sentReminders));
      
      // Update the current appointment data if it matches
      if (CURRENT_APPT && CURRENT_APPT.id === id) {
        CURRENT_APPT.reminderSent = true;
        if (result && result.reminderCount) {
          CURRENT_APPT.reminderCount = result.reminderCount;
        }
      }
      
      closeActionModal();
      
      // Refresh data to update button states
      setTimeout(() => {
        refreshData();
      }, 500);
      
    } catch (e) {
      let errorMessage = "Failed to send reminder: " + e.message;
      
      // Handle specific error types
      if (e.message && e.message.includes('Database connection issue')) {
        errorMessage = "Database connection temporarily unavailable. Please try again in a few moments.";
      } else if (e.message && e.message.includes('Service Unavailable')) {
        errorMessage = "Service is temporarily unavailable. Please try again shortly.";
      }
      
      alert(errorMessage);
      console.error('Reminder sending error:', e);
    } finally {
      disableAll(false);
      const btnReminder = document.getElementById('btnReminder');
      if (btnReminder) btnReminder.textContent = 'Send Reminder';
    }
  }

  // ===== Helper Functions =====
  
  // Extract appointment date from appointment object
  function getAppointmentDate(appointment) {
    if (!appointment) return null;
    
    // Try different date field formats
    if (appointment.date) {
      return appointment.date;
    }
    
    if (appointment.scheduledAt) {
      // Handle different datetime formats
      if (appointment.scheduledAt.includes('T')) {
        return appointment.scheduledAt.split('T')[0];
      } else if (appointment.scheduledAt.includes(' ')) {
        return appointment.scheduledAt.split(' ')[0];
      }
      return appointment.scheduledAt;
    }
    
    if (appointment.appointmentDate) {
      return appointment.appointmentDate;
    }
    
    return null;
  }

  // Helper function for safe DOM manipulation
  function safeSetClassName(elementId, newClassName) {
    const element = document.getElementById(elementId);
    if (element) {
      element.className = newClassName;
      return true;
    }
    console.warn(`Element with ID '${elementId}' not found for className update`);
    return false;
  }

  function safeAddClassName(elementId, classesToAdd) {
    const element = document.getElementById(elementId);
    if (element) {
      if (!element.className.includes(classesToAdd)) {
        element.className += ' ' + classesToAdd;
      }
      return true;
    }
    console.warn(`Element with ID '${elementId}' not found for className addition`);
    return false;
  }

  function safeRemoveClassName(elementId, classesToRemove) {
    const element = document.getElementById(elementId);
    if (element) {
      element.className = element.className.replace(new RegExp('\\s*' + classesToRemove.replace(/[.*+?^${}()|[\]\\]/g, '\\$&') + '\\s*', 'g'), '');
      return true;
    }
    console.warn(`Element with ID '${elementId}' not found for className removal`);
    return false;
  }

  // ===== Modal logic =====
  let CURRENT_APPT = null;

  function openActionModal(payloadStr){
    try { CURRENT_APPT = JSON.parse(decodeURIComponent(payloadStr)); } catch { CURRENT_APPT = null; }
    if (!CURRENT_APPT) return;

    const sub   = document.getElementById('actionModalSub');
    const meta  = document.getElementById('actionMeta');
    sub.textContent = `Appointment #${CURRENT_APPT.id}`;
    
    const petDisplay = CURRENT_APPT.petName ? 
      (CURRENT_APPT.petSpecies ? `${CURRENT_APPT.petName} (${CURRENT_APPT.petSpecies})` : CURRENT_APPT.petName) : 
      (CURRENT_APPT.petUid || 'Unknown Pet');
    
    const ownerDisplay = CURRENT_APPT.ownerName || `Owner ID: ${CURRENT_APPT.ownerId || 'Unknown'}`;
    
    meta.innerHTML = `
      <div class="space-y-1">
        <div><span class="text-slate-400">Pet:</span> <span class="font-medium">${petDisplay}</span></div>
        <div><span class="text-slate-400">Pet UID:</span> <span class="font-mono text-xs">${CURRENT_APPT.petUid || '-'}</span></div>
        <div><span class="text-slate-400">Owner:</span> <span class="font-medium">${ownerDisplay}</span></div>
        <div><span class="text-slate-400">Type:</span> ${CURRENT_APPT.type || '-'}</div>
        <div><span class="text-slate-400">Phone:</span> ${CURRENT_APPT.phoneNo || '-'}</div>
        <div><span class="text-slate-400">Fee:</span> ${CURRENT_APPT.fee!=null?('Rs'+CURRENT_APPT.fee):'-'}</div>
      </div>
    `;

    // Wait for DOM to be fully updated before accessing elements
    setTimeout(() => {
      // Check if modal is still visible before proceeding
      const modal = document.getElementById('actionModal');
      if (!modal || modal.classList.contains('hidden')) {
        console.log('Modal closed before button setup could complete');
        return;
      }
      
      const btnConfirm = document.getElementById('btnConfirm');
      const btnReminder = document.getElementById('btnReminder');
      const btnDone    = document.getElementById('btnDone');
      const btnCancel  = document.getElementById('btnCancel');
      const aResched   = document.getElementById('btnReschedule');

      // Null checks for all elements - but continue if some exist
      if (!btnConfirm || !btnReminder || !btnDone || !btnCancel || !aResched) {
        console.warn('Some modal buttons not found:', {
          btnConfirm: !!btnConfirm,
          btnReminder: !!btnReminder,
          btnDone: !!btnDone,
          btnCancel: !!btnCancel,
          aResched: !!aResched
        });
        // Don't return early - continue with available buttons
      }

      if (aResched) {
        aResched.href = `${RES_PAGE}?id=${CURRENT_APPT.id}`;
      }

      if (btnConfirm) {
        btnConfirm.onclick = () => {
          const ok = (String(CURRENT_APPT.method).toLowerCase()==='clinic') ||
                  (String(CURRENT_APPT.status).toLowerCase()==='paid');
          if(!ok){ alert("Cannot confirm until paid or pay-at-clinic is selected."); return; }
          updateStatus(CURRENT_APPT.id, 'confirmed');
        };
      }

      // Date validation for buttons (using Sri Lanka timezone)
      const appointmentDate = getAppointmentDate(CURRENT_APPT);
      const todayStr = getTodayStrSriLanka();
      
      // Calculate tomorrow's date (for reminder logic) using Sri Lanka time
      const tomorrow = getSriLankaDate();
      tomorrow.setDate(tomorrow.getDate() + 1);
      const tomorrowStr = ymd(tomorrow);
      
      console.log('Date validation (Sri Lanka time):', { appointmentDate, todayStr, tomorrowStr });
      
      // Enable/disable reminder button (only day before appointment - today for tomorrow's appointment)
      if (btnReminder) {
        const canSendReminder = appointmentDate === tomorrowStr; // Can send reminder today if appointment is tomorrow
        const reminderAlreadySent = CURRENT_APPT.reminderSent === true || CURRENT_APPT.reminderSent === 'true' || 
                                  sentReminders.has(CURRENT_APPT.id) ||
                                  (CURRENT_APPT.reminderCount && CURRENT_APPT.reminderCount > 0);
        
        console.log('Reminder button logic:', {
          appointmentId: CURRENT_APPT.id,
          appointmentDate,
          tomorrowStr,
          canSendReminder,
          reminderSentValue: CURRENT_APPT.reminderSent,
          reminderCount: CURRENT_APPT.reminderCount,
          inMemoryCheck: sentReminders.has(CURRENT_APPT.id),
          reminderAlreadySent,
          sentRemindersSet: Array.from(sentReminders),
          fullAppointment: CURRENT_APPT
        });
        
        if (canSendReminder && !reminderAlreadySent) {
          // 🟢 State: Available to send
          btnReminder.disabled = false;
          btnReminder.className = 'rounded-xl px-4 py-2 hover:shadow-soft reminder-btn-available';
          btnReminder.onclick = () => sendReminder(CURRENT_APPT.id);
          btnReminder.title = 'Send reminder email to pet owner (day before appointment)';
          btnReminder.textContent = 'Send Reminder';
        } else {
          btnReminder.disabled = true;
          
          if (reminderAlreadySent) {
            // 🔴 State: Already sent
            btnReminder.className = 'rounded-xl px-4 py-2 reminder-btn-sent';
            btnReminder.onclick = () => {
              const count = CURRENT_APPT.reminderCount || 0;
              alert('Reminder has already been sent for this appointment. Count: ' + count + '. Only one reminder per appointment is allowed.');
            };
            btnReminder.title = 'Reminder already sent';
            const count = CURRENT_APPT.reminderCount || 0;
            btnReminder.textContent = count > 0 ? 'Sent (' + count + ')' : 'Sent';
          } else {
            // 🟡 State: Date restricted
            btnReminder.className = 'rounded-xl px-4 py-2 reminder-btn-restricted';
            btnReminder.onclick = () => alert('Reminders can only be sent the day before the appointment. This appointment is scheduled for ' + appointmentDate + '.');
            btnReminder.title = 'Reminders can only be sent the day before the appointment';
            btnReminder.textContent = 'Send Reminder';
          }
        }
      }
      
      // Enable/disable done button (only after the scheduled appointment time)
      if (btnDone) {
        // Parse the appointment date and time
        let canMarkDone = false;
        let appointmentDateTime = null;
        
        if (CURRENT_APPT.scheduledAt) {
          try {
            // Parse the scheduledAt datetime
            appointmentDateTime = new Date(CURRENT_APPT.scheduledAt);
            const now = getSriLankaDate();
            
            // Can mark done only after the scheduled time has passed
            canMarkDone = appointmentDateTime <= now;
            
            console.log('Mark Done validation (Sri Lanka time):', {
              appointmentDateTime: appointmentDateTime.toISOString(),
              currentTime: now.toISOString(),
              canMarkDone
            });
          } catch (e) {
            console.error('Error parsing appointment datetime:', e);
            canMarkDone = false;
          }
        }
        
        if (canMarkDone) {
          btnDone.disabled = false;
          safeRemoveClassName('btnDone', 'opacity-50\\s*cursor-not-allowed');
          btnDone.onclick = () => updateStatus(CURRENT_APPT.id, 'done');
          btnDone.title = 'Mark appointment as completed';
        } else {
          btnDone.disabled = true;
          safeAddClassName('btnDone', 'opacity-50 cursor-not-allowed');
          const timeStr = appointmentDateTime ? appointmentDateTime.toLocaleString('en-US', { timeZone: 'Asia/Colombo' }) : 'unknown time';
          btnDone.onclick = () => alert('Appointments can only be marked as done after the scheduled time (Sri Lanka time). This appointment is scheduled for ' + timeStr + '.');
          btnDone.title = 'Can only mark done after the scheduled appointment time (Sri Lanka time)';
        }
      }
      
      // Show date validation info if any button is disabled
      const dateValidationInfo = document.getElementById('dateValidationInfo');
      if (dateValidationInfo && btnReminder && btnDone) {
        const canSendReminder = appointmentDate === tomorrowStr;
        // Check if done button is disabled (either no datetime or time hasn't passed)
        const canMarkDone = !btnDone.disabled;
        if (!canSendReminder || !canMarkDone) {
          dateValidationInfo.classList.remove('hidden');
        } else {
          dateValidationInfo.classList.add('hidden');
        }
      }
      
      if (btnCancel) {
        btnCancel.onclick = () => updateStatus(CURRENT_APPT.id, 'cancelled');
      }
    }, 50); // Small delay to ensure DOM is updated

    showActionModal();
  }

  function showActionModal(){
    const modal = document.getElementById('actionModal');
    if (!modal) return;
    modal.classList.remove('hidden');
    modal.setAttribute('aria-hidden', 'false');
    const closeBtn = document.getElementById('actionModalClose');
    closeBtn && closeBtn.focus();

    modal._escHandler = (e)=>{ if(e.key==='Escape') closeActionModal(); };
    document.addEventListener('keydown', modal._escHandler);

    modal._backdropHandler = (e)=>{
      const backdrop = modal.querySelector('.absolute.inset-0.bg-slate-900\\/60.backdrop-blur-sm');
      if (e.target === backdrop) closeActionModal();
    };
    modal.addEventListener('click', modal._backdropHandler);

    closeBtn && (closeBtn.onclick = closeActionModal);
  }

  function closeActionModal(){
    const modal = document.getElementById('actionModal');
    if (!modal) return;
    modal.classList.add('hidden');
    modal.setAttribute('aria-hidden', 'true');
    if (modal._escHandler) document.removeEventListener('keydown', modal._escHandler);
    if (modal._backdropHandler) modal.removeEventListener('click', modal._backdropHandler);
    CURRENT_APPT = null;
  }

  // Function to show temporary success messages
  function showTemporaryMessage(message, type = 'success') {
    const messageDiv = document.createElement('div');
    messageDiv.className = `fixed top-4 right-4 z-50 p-4 rounded-lg shadow-lg transition-all duration-300 ${
      type === 'success' ? 'bg-green-500 text-white' : 'bg-red-500 text-white'
    }`;
    messageDiv.textContent = message;
    
    document.body.appendChild(messageDiv);
    
    // Animate in
    setTimeout(() => {
      messageDiv.style.transform = 'translateY(0)';
      messageDiv.style.opacity = '1';
    }, 10);
    
    // Remove after 3 seconds
    setTimeout(() => {
      messageDiv.style.transform = 'translateY(-20px)';
      messageDiv.style.opacity = '0';
      setTimeout(() => messageDiv.remove(), 300);
    }, 3000);
  }

  // boot
  document.addEventListener("DOMContentLoaded", () => {
    const now = getSriLankaDate();
    CAL_YEAR = now.getFullYear();
    CAL_MONTH = now.getMonth();
    updateDatePill();
    
    // Check for success parameters and show messages
    const urlParams = new URLSearchParams(window.location.search);
    const okParam = urlParams.get('ok');
    
    if (okParam === 'walkin-created') {
      // Show success message for new appointment
      showTemporaryMessage('New appointment created successfully! Charts will update automatically.', 'success');
      // Clear URL parameters after showing message
      setTimeout(() => {
        window.history.replaceState({}, document.title, window.location.pathname);
      }, 100);
    }
    
    refreshData();
    initializeCharts();
  });

  // Prevent operations when page is unloading (e.g., during logout)
  window.addEventListener('beforeunload', () => {
    isPageUnloading = true;
    // Abort all ongoing fetch requests
    fetchAbortController.abort();
    console.log('Page is unloading - stopping all operations and aborting fetch requests');
  });

  // Database status functions
  function updateDbStatus(isConnected, message = '') {
    const statusDiv = document.getElementById('dbStatus');
    const iconSpan = document.getElementById('dbStatusIcon');
    const textSpan = document.getElementById('dbStatusText');
    
    // Check if all required elements exist
    if (!statusDiv || !iconSpan || !textSpan) {
      console.warn('Database status elements not found:', {
        statusDiv: !!statusDiv,
        iconSpan: !!iconSpan,
        textSpan: !!textSpan
      });
      return;
    }
    
    if (isConnected) {
      statusDiv.className = 'inline-flex items-center gap-2 px-3 py-1 rounded-full text-xs font-medium border border-green-200 bg-green-50 text-green-700';
      iconSpan.textContent = '🟢';
      textSpan.textContent = 'Database Connected';
    } else {
      statusDiv.className = 'inline-flex items-center gap-2 px-3 py-1 rounded-full text-xs font-medium border border-red-200 bg-red-50 text-red-700';
      iconSpan.textContent = '🔴';
      textSpan.textContent = message || 'Database Issue';
    }
  }

  // Auto-refresh when page becomes visible (user returns from add-appointment page)
  document.addEventListener('visibilitychange', () => {
    if (!document.hidden) {
      console.log('Page became visible, refreshing data...');
      refreshData();
    }
  });

  // Also refresh when window regains focus
  window.addEventListener('focus', () => {
    console.log('Window gained focus, refreshing data...');
    refreshData();
  });

  // Force refresh analytics - called by refresh button
  function forceRefreshAnalytics() {
    console.log('Force refreshing analytics...');
    refreshData();
    showTemporaryMessage('Charts refreshed with latest data!', 'success');
  }

  // ===== Analytics Charts =====
  let statusChart = null;
  let weeklyChart = null;

  function initializeCharts() {
    console.log('Initializing charts...');
    
    // Status Distribution Pie Chart
    const statusCtx = document.getElementById('statusChart');
    console.log('Status chart canvas found:', !!statusCtx);
    
    if (statusCtx && !statusChart) {
      statusChart = new Chart(statusCtx, {
        type: 'doughnut',
        data: {
          labels: ['Active', 'Completed', 'Cancelled'],
          datasets: [{
            data: [0, 0, 0],
            backgroundColor: [
              'rgba(99, 102, 241, 0.8)', // Indigo for active
              'rgba(16, 185, 129, 0.8)', // Emerald for completed  
              'rgba(239, 68, 68, 0.8)'   // Red for cancelled
            ],
            borderColor: [
              'rgba(99, 102, 241, 1)',
              'rgba(16, 185, 129, 1)',
              'rgba(239, 68, 68, 1)'
            ],
            borderWidth: 2
          }]
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          plugins: {
            legend: {
              position: 'bottom',
              labels: {
                padding: 20,
                usePointStyle: true,
                color: '#64748b'
              }
            },
            tooltip: {
              callbacks: {
                label: function(context) {
                  const total = context.dataset.data.reduce((a, b) => a + b, 0);
                  const percentage = total > 0 ? ((context.parsed * 100) / total).toFixed(1) : 0;
                  return `${context.label}: ${context.parsed} (${percentage}%)`;
                }
              }
            }
          },
          cutout: '60%'
        }
      });
    }

    // Weekly Trends Line Chart
    const weeklyCtx = document.getElementById('weeklyChart');
    console.log('Weekly chart canvas found:', !!weeklyCtx);
    
    if (weeklyCtx && !weeklyChart) {
      const last7Days = [];
      const today = getSriLankaDate();
      
      for (let i = 6; i >= 0; i--) {
        const date = new Date(today);
        date.setDate(date.getDate() - i);
        last7Days.push(date.toLocaleDateString('en-US', { weekday: 'short' }));
      }

      weeklyChart = new Chart(weeklyCtx, {
        type: 'line',
        data: {
          labels: last7Days,
          datasets: [{
            label: 'Appointments',
            data: [0, 0, 0, 0, 0, 0, 0],
            borderColor: 'rgba(99, 102, 241, 1)',
            backgroundColor: 'rgba(99, 102, 241, 0.1)',
            borderWidth: 3,
            fill: true,
            tension: 0.4,
            pointBackgroundColor: 'rgba(99, 102, 241, 1)',
            pointBorderColor: '#ffffff',
            pointBorderWidth: 2,
            pointRadius: 6,
            pointHoverRadius: 8
          }]
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          plugins: {
            legend: {
              display: false
            }
          },
          scales: {
            x: {
              grid: {
                display: false
              },
              ticks: {
                color: '#64748b'
              }
            },
            y: {
              beginAtZero: true,
              grid: {
                color: 'rgba(148, 163, 184, 0.1)'
              },
              ticks: {
                color: '#64748b',
                stepSize: 1
              }
            }
          }
        }
      });
    }
  }

  function updateAnalytics() {
    console.log('Updating analytics with APPT_CACHE:', APPT_CACHE.length, 'appointments');
    
    if (!APPT_CACHE || APPT_CACHE.length === 0) {
      console.log('No appointments to analyze');
      return;
    }

    // Calculate status counts
    const active = APPT_CACHE.filter(apt => {
      const status = (apt.status || "").toLowerCase();
      return status !== 'cancelled' && status !== 'done';
    }).length;
    const completed = APPT_CACHE.filter(apt => (apt.status || "").toLowerCase() === 'done').length;
    const cancelled = APPT_CACHE.filter(apt => (apt.status || "").toLowerCase() === 'cancelled').length;
    const total = active + completed + cancelled;

    console.log('Analytics data:', { active, completed, cancelled, total });

    // Update charts with animation to make changes visible
    if (statusChart) {
      statusChart.data.datasets[0].data = [active, completed, cancelled];
      statusChart.update('active'); // Use 'active' animation mode to make updates visible
      console.log('Status chart updated with data:', [active, completed, cancelled]);
    }

    // Calculate metrics
    const completionRate = total > 0 ? ((completed / total) * 100).toFixed(1) : 0;
    const cancellationRate = total > 0 ? ((cancelled / total) * 100).toFixed(1) : 0;

    // Count today's confirmed appointments specifically for "Today Active" metric (using Sri Lanka timezone)
    const todayStr = getTodayStrSriLanka();
    
    console.log('Today date for filtering (Sri Lanka time):', todayStr);
    console.log('All appointments for debugging:', APPT_CACHE);
    
    const todayConfirmed = APPT_CACHE.filter(apt => {
      console.log('Checking appointment:', apt.appointmentId, 'Status:', apt.status, 'ScheduledAt:', apt.scheduledAt);
      
      // Only count confirmed appointments for today (case-insensitive)
      const status = (apt.status || "").toLowerCase().trim();
      if (status !== 'confirmed') {
        console.log('  - Skipped: status is', status, 'not confirmed');
        return false;
      }
      
      // Extract date from scheduledAt in various formats
      let appointmentDate = null;
      if (apt.scheduledAt) {
        // Handle different datetime formats
        if (apt.scheduledAt.includes('T')) {
          appointmentDate = apt.scheduledAt.split('T')[0];
        } else if (apt.scheduledAt.includes(' ')) {
          appointmentDate = apt.scheduledAt.split(' ')[0];
        } else {
          appointmentDate = apt.scheduledAt;
        }
      }
      
      console.log('  - Extracted appointment date:', appointmentDate, 'comparing with today:', todayStr);
      
      if (appointmentDate === todayStr) {
        console.log('  - MATCHED: This is a confirmed appointment for today');
        return true;
      }
      
      console.log('  - Skipped: date does not match today');
      return false;
    });
    
    console.log('Today confirmed appointments count:', todayConfirmed.length);
    console.log('Today confirmed appointments:', todayConfirmed);

    // Update metric displays with null checks
    const completionRateEl = document.getElementById('completionRate');
    const cancellationRateEl = document.getElementById('cancellationRate');
    const todayActiveEl = document.getElementById('todayActive');
    
    if (completionRateEl) completionRateEl.textContent = completionRate + '%';
    if (cancellationRateEl) cancellationRateEl.textContent = cancellationRate + '%';
    if (todayActiveEl) todayActiveEl.textContent = todayConfirmed.length; // Use the array length

    console.log('Metrics updated:', { completionRate, cancellationRate, todayConfirmedCount: todayConfirmed.length });

    // Update weekly trend with real data
    if (weeklyChart) {
      const weeklyData = [];
      const weeklyLabels = [];
      const today = getSriLankaDate();
      
      for (let i = 6; i >= 0; i--) {
        const date = new Date(today);
        date.setDate(date.getDate() - i);
        const dateStr = ymd(date);
        
        // Update label
        weeklyLabels.push(date.toLocaleDateString('en-US', { weekday: 'short', month: 'short', day: 'numeric' }));
        
        // Count appointments for this specific day - check multiple date formats
        const dayCount = APPT_CACHE.filter(apt => {
          // Try different date field formats
          if (apt.date && apt.date === dateStr) return true;
          
          if (apt.scheduledAt) {
            // Handle different datetime formats
            let schedDate;
            if (apt.scheduledAt.includes('T')) {
              schedDate = apt.scheduledAt.split('T')[0];
            } else if (apt.scheduledAt.includes(' ')) {
              schedDate = apt.scheduledAt.split(' ')[0];
            } else {
              schedDate = apt.scheduledAt;
            }
            return schedDate === dateStr;
          }
          
          // Try parsing any date fields that might exist
          if (apt.appointmentDate && apt.appointmentDate === dateStr) return true;
          
          return false;
        }).length;
        
        weeklyData.push(dayCount);
        console.log(`Date ${dateStr}: ${dayCount} appointments`);
      }
      
      // Update labels and data
      weeklyChart.data.labels = weeklyLabels;
      weeklyChart.data.datasets[0].data = weeklyData;
      weeklyChart.update('active');
      console.log('Weekly chart updated - Labels:', weeklyLabels, 'Data:', weeklyData);
    }
  }

  // Update the refreshData function to also refresh analytics
  const originalRefreshData = refreshData;
  refreshData = async function() {
    console.log('RefreshData called - starting data refresh and analytics update');
    try {
      await originalRefreshData();
      // Update analytics after data is loaded
      setTimeout(() => {
        try {
          updateAnalytics();
        } catch (analyticsError) {
          console.error('Error updating analytics:', analyticsError);
        }
      }, 100);
    } catch (refreshError) {
      console.error('Error in refresh data wrapper:', refreshError);
      // Don't rethrow - let the original error handling work
    }
  };
</script>

</body>
</html>

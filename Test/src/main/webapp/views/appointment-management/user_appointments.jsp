<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>My Appointments — Happy Paws PetCare</title>
    <meta name="description" content="View and manage your pet appointments." />

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

<!-- PAGE HEADER -->
<section class="relative overflow-hidden">
    <div class="absolute inset-0 bg-gradient-to-b from-brand-50 via-white to-white dark:from-slate-900 dark:via-slate-950 dark:to-slate-950"></div>
    <div class="absolute inset-0 bg-grid opacity-60 dark:opacity-20"></div>

    <div class="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10 md:py-14">
        <div class="grid md:grid-cols-2 gap-6 items-center reveal">
            <div>
                <h1 class="font-display text-3xl md:text-4xl font-extrabold tracking-tight">My Appointments</h1>
                <p class="mt-2 text-sm text-slate-600 dark:text-slate-300">Review upcoming, completed, or cancelled visits.</p>
                <div class="mt-6 flex items-center gap-2">
                    <a href="<%= request.getContextPath() %>/owner/pets"
                       class="inline-flex items-center px-4 py-2 rounded-xl bg-brand-600 hover:bg-brand-700 text-white shadow-soft">
                        My Pets
                    </a>
                    <button onclick="loadMine()"
                            class="inline-flex items-center px-4 py-2 rounded-xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 hover:shadow-soft">
                        Refresh
                    </button>
                </div>
            </div>

            <!-- KPI Cards -->
            <div class="reveal">
                <div class="relative mx-auto w-full max-w-xl">
                    <div class="absolute -inset-2 rounded-3xl bg-gradient-to-tr from-brand-600/25 via-brand-400/15 to-brand-600/25 blur-2xl"></div>
                    <div class="relative rounded-3xl bg-white/70 dark:bg-slate-900/60 border border-slate-200/70 dark:border-slate-700 p-6 shadow-soft backdrop-blur">
                        <div class="grid grid-cols-3 gap-3">
                            <div class="p-4 rounded-2xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-900 text-center">
                                <p class="text-xs text-slate-500">Upcoming</p>
                                <p id="kpiUpcoming" class="text-2xl font-extrabold tabular-nums text-brand-600">0</p>
                            </div>
                            <div class="p-4 rounded-2xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-900 text-center">
                                <p class="text-xs text-slate-500">Completed</p>
                                <p id="kpiCompleted" class="text-2xl font-extrabold tabular-nums text-emerald-600">0</p>
                            </div>
                            <div class="p-4 rounded-2xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-900 text-center">
                                <p class="text-xs text-slate-500">Cancelled</p>
                                <p id="kpiCancelled" class="text-2xl font-extrabold tabular-nums text-rose-600">0</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- CONTENT -->
<section class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 pb-16">

    <!-- Upcoming -->
    <div class="mt-10">
        <div class="flex items-center justify-between">
            <h2 class="font-semibold">Upcoming</h2>
            <span id="countUpcoming" class="text-xs text-slate-500"></span>
        </div>

        <!-- Improved table wrapper (sticky header, scrollable body, fixed column widths) -->
        <div class="mt-3 rounded-2xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 shadow-soft overflow-hidden">
            <div class="max-h-[560px] overflow-auto">
                <table class="min-w-full text-sm table-fixed">
                    <colgroup>
                        <col class="w-[18rem]" />
                        <col class="w-[16rem]" />
                        <col class="w-[10rem]" />
                        <col class="w-[12rem]" />
                        <col class="w-[10rem]" />
                        <col class="w-[8rem]" />
                        <col class="w-[14rem]" />
                        <col class="w-[16rem]" />
                    </colgroup>
                    <thead class="bg-slate-50/70 dark:bg-slate-800/70 backdrop-blur sticky top-0 z-10 border-b border-slate-200 dark:border-slate-800">
                    <tr class="text-xs font-medium text-slate-500 dark:text-slate-400">
                        <th class="px-4 py-3 text-left">When</th>
                        <th class="px-4 py-3 text-left">Pet Name</th>
                        <th class="px-4 py-3 text-left">Type</th>
                        <th class="px-4 py-3 text-left">Phone</th>
                        <th class="px-4 py-3 text-left">Status</th>
                        <th class="px-4 py-3 text-left">Fee</th>
                        <th class="px-4 py-3 text-left">Payment</th>
                        <th class="px-4 py-3 text-left">Actions</th>
                    </tr>
                    </thead>
                    <tbody id="upcomingBody" class="divide-y divide-slate-200 dark:divide-slate-800"></tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Completed -->
    <div class="mt-10">
        <div class="flex items-center justify-between">
            <h2 class="font-semibold">Completed</h2>
            <span id="countDone" class="text-xs text-slate-500"></span>
        </div>
        <div class="mt-3 rounded-2xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 shadow-soft overflow-hidden">
            <table class="min-w-full text-sm">
                <thead class="bg-slate-50 dark:bg-slate-800/50">
                <tr>
                    <th class="px-4 py-3 text-left">ID</th>
                    <th class="px-4 py-3 text-left">Pet Name</th>
                    <th class="px-4 py-3 text-left">Type</th>
                    <th class="px-4 py-3 text-left">Completed at</th>
                </tr>
                </thead>
                <tbody id="doneBody" class="divide-y divide-slate-200 dark:divide-slate-800"></tbody>
            </table>
        </div>
    </div>

    <!-- Cancelled -->
    <div class="mt-10">
        <div class="flex items-center justify-between">
            <h2 class="font-semibold">Cancelled</h2>
            <span id="countCancelled" class="text-xs text-slate-500"></span>
        </div>
        <div class="mt-3 rounded-2xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 shadow-soft overflow-hidden">
            <table class="min-w-full text-sm">
                <thead class="bg-slate-50 dark:bg-slate-800/50">
                <tr>
                    <th class="px-4 py-3 text-left">ID</th>
                    <th class="px-4 py-3 text-left">Pet Name</th>
                    <th class="px-4 py-3 text-left">Type</th>
                    <th class="px-4 py-3 text-left">Scheduled at</th>
                </tr>
                </thead>
                <tbody id="cancelledBody" class="divide-y divide-slate-200 dark:divide-slate-800"></tbody>
            </table>
        </div>
    </div>
</section>

<!-- Cancel Confirmation Modal -->
<div id="cancelModal" class="fixed inset-0 z-[100] hidden" aria-hidden="true">
    <!-- backdrop -->
    <div class="absolute inset-0 bg-slate-900/60 backdrop-blur-sm"></div>

    <!-- dialog -->
    <div class="absolute inset-0 flex items-center justify-center p-4">
        <div class="w-full max-w-md rounded-2xl bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-700 shadow-soft"
             role="dialog" aria-modal="true" aria-labelledby="cancelModalTitle">
            <div class="flex items-start justify-between gap-4 p-5 border-b border-slate-200 dark:border-slate-800">
                <div>
                    <h4 id="cancelModalTitle" class="font-semibold text-base">Cancel this appointment?</h4>
                    <p id="cancelModalSub" class="mt-0.5 text-xs text-slate-500"></p>
                </div>
                <button id="cancelModalClose"
                        class="px-2.5 py-1.5 rounded-lg border border-slate-300 dark:border-slate-700 hover:shadow-soft"
                        aria-label="Close">✕</button>
            </div>

            <div class="p-5 space-y-3">
                <div id="cancelModalMeta" class="text-xs text-slate-500"></div>

                <div id="refundNote" class="rounded-xl px-3 py-2 text-xs"></div>

                <div class="flex items-center justify-end gap-2 pt-2">
                    <button class="px-4 py-2 rounded-xl border border-slate-300 dark:border-slate-700 hover:shadow-soft"
                            onclick="closeCancelModal()">Keep appointment</button>
                    <button id="confirmCancelBtn"
                            class="px-4 py-2 rounded-xl bg-rose-600 text-white hover:bg-rose-700">
                        Yes, cancel
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>

<script>
    // API endpoints
    const BASE     = "<%= request.getContextPath() %>/my-appointments"; // owner-scoped servlet
    const RES_PAGE = "<%= request.getContextPath() %>/owner/reschedule?id="; // server enforces "confirmed"

    // Pet data cache to avoid repeated API calls
    const PET_CACHE = new Map();

    // Function to fetch pet details by UID
    async function fetchPetByUid(petUid) {
        if (!petUid) return null;
        
        // Check cache first
        if (PET_CACHE.has(petUid)) {
            return PET_CACHE.get(petUid);
        }
        
        try {
            console.log('Fetching pet details for UID:', petUid);
            
            // Try to get all pets first (this might not require authentication)
            const response = await fetch(`<%= request.getContextPath() %>/pets`);
            console.log('Pets endpoint response status:', response.status);
            
            if (response.ok) {
                const allPets = await response.json();
                console.log('All pets response:', allPets.length, 'pets');
                
                // Find the pet with matching UID
                const pet = allPets.find(p => p.petUid === petUid);
                if (pet) {
                    console.log('Found pet by UID:', pet);
                    PET_CACHE.set(petUid, pet);
                    return pet;
                } else {
                    console.log('No pet found with UID:', petUid);
                }
            } else {
                console.error('Pets endpoint failed with status:', response.status);
                // Fallback to search API
                console.log('Trying search API as fallback...');
                const searchResponse = await fetch(`<%= request.getContextPath() %>/api/pets/search?q=${encodeURIComponent(petUid)}`);
                if (searchResponse.ok) {
                    const pets = await searchResponse.json();
                    const pet = pets.find(p => p.petUid === petUid);
                    if (pet) {
                        PET_CACHE.set(petUid, pet);
                        return pet;
                    }
                }
            }
        } catch (error) {
            console.warn('Failed to fetch pet details for', petUid, ':', error);
        }
        
        // Cache null result to avoid repeated failed requests
        PET_CACHE.set(petUid, null);
        return null;
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

    // ---- UI Helpers (improved) ----
    function fmtWhen(iso) {
        if (!iso) return { date: "-", time: "" };
        const d = new Date(iso);
        return {
            date: d.toLocaleDateString(undefined, { year: 'numeric', month: 'short', day: 'numeric' }),
            time: d.toLocaleTimeString(undefined, { hour: 'numeric', minute: '2-digit' })
        };
    }

    function pill(s) {
        const key = (s || 'pending').toLowerCase();
        const styles = {
            pending:   "bg-amber-100 text-amber-700 dark:bg-amber-200/20 dark:text-amber-300",
            confirmed: "bg-emerald-100 text-emerald-700 dark:bg-emerald-200/20 dark:text-emerald-300",
            done:      "bg-slate-100 text-slate-700 dark:bg-slate-200/10 dark:text-slate-300",
            cancelled: "bg-rose-100 text-rose-700 dark:bg-rose-200/20 dark:text-rose-300"
        }[key] || "bg-slate-100 text-slate-700 dark:bg-slate-200/10 dark:text-slate-300";
        const txt = s ? s.charAt(0).toUpperCase() + s.slice(1) : "Pending";
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

    function ownerActionCell(a){
        const s = (a.status || '').toLowerCase();
        if (s === 'confirmed') {
            return `
            <a href="${RES_PAGE}${a.appointmentId}"
               class="px-3 py-1.5 rounded-lg border border-slate-300 dark:border-slate-700 hover:shadow-soft transition">
              Request reschedule
            </a>`;
        }
        return `<span class="text-xs text-slate-500">Request Reschedule</span>`;
    }

    // ---- Row renderers ----
    function rowUpcoming(a){
        const { date, time } = fmtWhen(a.scheduledAt);
        const fee = (a.fee != null) ? `Rs${a.fee}` : "-";
        const petDisplay = formatPetDisplay(a); // Use enhanced pet display function

        // payload for cancel modal
        const payload = encodeURIComponent(JSON.stringify({
            id:a.appointmentId,
            fee:a.fee,
            when: a.scheduledAt,
            paymentMethod: a.paymentMethod || '-',
            paymentStatus: a.paymentStatus || 'UNPAID',
            petName: a.petName || a.petUid || '-'
        }));

        return `<tr class="odd:bg-white even:bg-slate-50/40 dark:odd:bg-slate-900 dark:even:bg-slate-900/60 hover:bg-slate-50/70 dark:hover:bg-slate-800/40 transition">
          <td class="px-4 py-3">
            <div class="font-medium">${date}</div>
            <div class="text-xs text-slate-500">${time}</div>
          </td>

          <td class="px-4 py-3">
            <span class="font-medium">${petDisplay}</span>
          </td>

          <td class="px-4 py-3">
            <div class="inline-flex items-center gap-2">
              <span>${a.type || "-"}</span>
            </div>
          </td>

          <td class="px-4 py-3">
            <span class="tabular-nums">${a.phoneNo || "-"}</span>
          </td>

          <td class="px-4 py-3">
            ${pill(a.status)}
          </td>

          <td class="px-4 py-3">
            <span class="font-medium">${fee}</span>
          </td>

          <td class="px-4 py-3">
            ${paymentPill(a.paymentMethod, a.paymentStatus)}
          </td>

          <td class="px-4 py-3">
            <div class="flex flex-wrap items-center gap-2">
              ${ownerActionCell(a)}
              <button class="px-3 py-1.5 rounded-lg bg-rose-600 text-white hover:bg-rose-700 shadow-soft transition"
                      onclick="openCancelModal('${payload}')">
                Cancel
              </button>
            </div>
          </td>
        </tr>`;
    }

    function rowDone(a){
        const when = a.scheduledAt ? new Date(a.scheduledAt).toLocaleString() : "-";
        const petDisplay = formatPetDisplay(a); // Use enhanced pet display function
        return `<tr>
          <td class="px-4 py-3">${a.appointmentId}</td>
          <td class="px-4 py-3 font-medium">${petDisplay}</td>
          <td class="px-4 py-3">${a.type || "-"}</td>
          <td class="px-4 py-3">${when}</td>
        </tr>`;
    }

    function rowCancelled(a){
        const when = a.scheduledAt ? new Date(a.scheduledAt).toLocaleString() : "-";
        const petDisplay = formatPetDisplay(a); // Use enhanced pet display function
        return `<tr>
          <td class="px-4 py-3">${a.appointmentId}</td>
          <td class="px-4 py-3 font-medium">${petDisplay}</td>
          <td class="px-4 py-3">${a.type || "-"}</td>
          <td class="px-4 py-3">${when}</td>
        </tr>`;
    }

    async function api(url, options = {}){
        const res = await fetch(url, options);
        let payload = null; try { payload = await res.json(); } catch {}
        if(!res.ok){
            const msg = (payload && payload.error) || res.statusText || 'Request failed';
            throw new Error(msg);
        }
        return payload;
    }

    async function loadMine(){
        try {
            // Show loading state
            const up = document.getElementById('upcomingBody');
            const dn = document.getElementById('doneBody');
            const cn = document.getElementById('cancelledBody');
            
            up.innerHTML = '<tr><td colspan="8" class="px-4 py-8 text-center text-slate-500">Loading appointment and pet details...</td></tr>';
            dn.innerHTML = '<tr><td colspan="4" class="px-4 py-8 text-center text-slate-500">Loading...</td></tr>';
            cn.innerHTML = '<tr><td colspan="4" class="px-4 py-8 text-center text-slate-500">Loading...</td></tr>';
            
            const data = await api(BASE);
            const rawAppointments = Array.isArray(data) ? data : [];
            
            // Enhance appointments with pet data
            const enhancedAppointments = await enhanceAppointmentsWithPetData(rawAppointments);
            
            // Clear loading state
            up.innerHTML = dn.innerHTML = cn.innerHTML = "";

            let cUp=0, cDn=0, cCn=0;
            enhancedAppointments.forEach(a=>{
                const s = (a.status||"").toLowerCase();
                if (s === 'done') { dn.insertAdjacentHTML('beforeend', rowDone(a)); cDn++; }
                else if (s === 'cancelled') { cn.insertAdjacentHTML('beforeend', rowCancelled(a)); cCn++; }
                else { up.insertAdjacentHTML('beforeend', rowUpcoming(a)); cUp++; }
            });

            document.getElementById('countUpcoming').textContent  = cUp ? `${cUp} items` : 'No items';
            document.getElementById('countDone').textContent       = cDn ? `${cDn} items` : 'No items';
            document.getElementById('countCancelled').textContent  = cCn ? `${cCn} items` : 'No items';

            // Update KPI cards
            document.getElementById('kpiUpcoming').textContent = cUp;
            document.getElementById('kpiCompleted').textContent = cDn;
            document.getElementById('kpiCancelled').textContent = cCn;
        } catch (error) {
            console.error('Failed to load appointments:', error);
            const up = document.getElementById('upcomingBody');
            const dn = document.getElementById('doneBody');
            const cn = document.getElementById('cancelledBody');
            
            up.innerHTML = '<tr><td colspan="8" class="px-4 py-8 text-center text-red-500">Failed to load data. Please try again.</td></tr>';
            dn.innerHTML = '<tr><td colspan="4" class="px-4 py-8 text-center text-red-500">Failed to load data.</td></tr>';
            cn.innerHTML = '<tr><td colspan="4" class="px-4 py-8 text-center text-red-500">Failed to load data.</td></tr>';
        }
    }

    // ===== Cancel modal logic =====
    let CANCEL_CTX = null;

    function openCancelModal(payloadStr){
        try { CANCEL_CTX = JSON.parse(decodeURIComponent(payloadStr)); } catch { CANCEL_CTX = null; }
        if (!CANCEL_CTX) return;

        const { date, time } = fmtWhen(CANCEL_CTX.when);
        document.getElementById('cancelModalSub').textContent =
            `Appointment #${CANCEL_CTX.id} — ${date} at ${time}`;

        document.getElementById('cancelModalMeta').innerHTML = `
          <div class="space-y-1">
            <div><span class="text-slate-400">Pet Name:</span> <span class="font-medium">${CANCEL_CTX.petName || CANCEL_CTX.petUid || '-'}</span></div>
            <div><span class="text-slate-400">Fee:</span> ${CANCEL_CTX.fee!=null?('Rs'+CANCEL_CTX.fee):'-'}</div>
            <div><span class="text-slate-400">Payment:</span> ${CANCEL_CTX.paymentMethod.toUpperCase()} — ${CANCEL_CTX.paymentStatus.toUpperCase()}</div>
          </div>
        `;

        const paid = String(CANCEL_CTX.paymentStatus||'').toUpperCase() === 'PAID';
        const note = document.getElementById('refundNote');
        if (paid) {
            note.className = "rounded-xl px-3 py-2 text-xs bg-amber-100 text-amber-800 dark:bg-amber-200/20 dark:text-amber-300";
            note.textContent = "Heads up: this appointment is already PAID. Cancelling will NOT trigger a refund.";
        } else {
            note.className = "rounded-xl px-3 py-2 text-xs bg-slate-100 text-slate-700 dark:bg-slate-200/10 dark:text-slate-300";
            note.textContent = "Note: No refund will be issued. If you’ve already paid elsewhere, reschedule instead.";
        }

        showCancelModal();

        const btn = document.getElementById('confirmCancelBtn');
        btn.onclick = async () => {
            btn.disabled = true;
            try{
                await api(BASE, {
                    method:'PUT',
                    headers:{'Content-Type':'application/json'},
                    body: JSON.stringify({ appointmentId:CANCEL_CTX.id, action:'cancel' })
                });
                closeCancelModal();
                await loadMine();
            } catch(e) {
                alert(e.message);
            } finally {
                btn.disabled = false;
            }
        };
    }

    function showCancelModal(){
        const modal = document.getElementById('cancelModal');
        modal.classList.remove('hidden');
        modal.setAttribute('aria-hidden','false');

        const closeBtn = document.getElementById('cancelModalClose');
        closeBtn && closeBtn.focus();

        modal._escHandler = (e)=>{ if(e.key==='Escape') closeCancelModal(); };
        document.addEventListener('keydown', modal._escHandler);

        modal._backdropHandler = (e)=>{
            const backdrop = modal.querySelector('.absolute.inset-0.bg-slate-900\\/60.backdrop-blur-sm');
            if (e.target === backdrop) closeCancelModal();
        };
        modal.addEventListener('click', modal._backdropHandler);

        closeBtn && (closeBtn.onclick = closeCancelModal);
    }

    function closeCancelModal(){
        const modal = document.getElementById('cancelModal');
        if (!modal) return;
        modal.classList.add('hidden');
        modal.setAttribute('aria-hidden','true');
        if (modal._escHandler) document.removeEventListener('keydown', modal._escHandler);
        if (modal._backdropHandler) modal.removeEventListener('click', modal._backdropHandler);
        CANCEL_CTX = null;
    }

    document.addEventListener('DOMContentLoaded', () => {
        loadMine();
        
        // Initialize reveal animations
        const observer = new IntersectionObserver(entries => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('visible');
                    observer.unobserve(entry.target);
                }
            });
        }, { threshold: 0.1 });

        document.querySelectorAll('.reveal').forEach(el => observer.observe(el));
    });
</script>

</body>
</html>

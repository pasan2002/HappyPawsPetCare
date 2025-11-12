<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Reschedule / Edit Model.AppointmentManagement.Appointment — Happy Paws PetCare</title>
  <meta name="description" content="Update appointment details except Pet UID." />

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
  String idParam = request.getParameter("id");
  String apcontext = request.getContextPath();
%>

<!-- PAGE HEADER (theme-aligned hero) -->
<section class="relative overflow-hidden">
  <div class="absolute inset-0 bg-gradient-to-b from-brand-50 via-white to-white dark:from-slate-900 dark:via-slate-950 dark:to-slate-950"></div>
  <div class="absolute inset-0 bg-grid opacity-60 dark:opacity-20"></div>

  <div class="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10 md:py-14">
    <div class="flex items-center justify-between gap-4 reveal">
      <div>
        <h1 class="font-display text-3xl md:text-4xl font-extrabold tracking-tight">Reschedule / Edit Appointment</h1>
        <p class="mt-2 text-sm text-slate-600 dark:text-slate-300">Receptionist can update any details and set appointment status.</p>
        <div class="mt-2 flex items-center gap-2 text-xs text-blue-600 dark:text-blue-400">
          <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
            <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z" clip-rule="evenodd"></path>
          </svg>
          <span>Note: Owner reschedule requests automatically reset status to "pending" for confirmation.</span>
        </div>
      </div>
      <a href="<%= apcontext %>/views/appointment-management/receptionist-dashboard.jsp"
         class="inline-flex items-center px-4 py-2 rounded-xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 hover:shadow-soft">
        ← Back to dashboard
      </a>
    </div>
  </div>
</section>

<!-- CONTENT -->
<section class="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 pb-16">
  <div id="alert" class="hidden mt-6 rounded-xl p-4 text-sm"></div>

  <div class="reveal relative">
    <div class="absolute -inset-2 rounded-3xl bg-gradient-to-tr from-brand-600/20 via-brand-400/10 to-brand-600/20 blur-2xl"></div>

    <form id="form"
          class="relative mt-6 grid grid-cols-1 gap-4 rounded-3xl border border-slate-200 dark:border-slate-800 bg-white/80 dark:bg-slate-900/60 p-6 md:p-7 shadow-soft backdrop-blur"
          onsubmit="event.preventDefault(); saveChanges();">
      <input type="hidden" id="appointmentId" />
      <input type="hidden" id="ownerId" />

      <div class="grid sm:grid-cols-2 gap-4">
        <div class="sm:col-span-2">
          <label class="block text-sm font-medium mb-1">Pet Information</label>
          <div class="flex items-center gap-2">
            <input id="petUid" disabled
                   class="flex-1 rounded-xl border border-slate-300 dark:border-slate-700 bg-slate-50 dark:bg-slate-800/50 px-3 py-2 font-mono text-xs" />
            <div class="w-2 h-2 rounded-full bg-green-500" title="Pet confirmed"></div>
          </div>
          <p class="text-xs text-slate-500 mt-1">Pet UID cannot be changed for existing appointments.</p>
        </div>

        <div>
          <label for="staffSearch" class="block text-sm font-medium mb-1">Assign Staff</label>
          <div class="relative">
            <input type="text" id="staffSearch" name="staffSearch" 
                   placeholder="Search staff by name or role..." 
                   class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-3 py-2" 
                   autocomplete="off" 
                   oninput="onStaffSearchInput()" />
          </div>
          <div id="staffSearchError" class="hidden mt-1 text-sm text-red-500"></div>
          
          <!-- Hidden field for selected staff ID -->
          <input type="hidden" id="staffId" name="staffId" />
          
          <!-- Display selected staff role -->
          <div id="staffRole" class="text-xs text-slate-500 mt-1"></div>
        </div>

        <div>
          <label for="type" class="block text-sm font-medium mb-1">Type <span class="text-rose-600">*</span></label>
          <select id="type" required
                  class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-3 py-2">
            <option value="">Select type…</option>
            <option>Veterinary</option>
            <option>Grooming</option>
          </select>
          <div id="typeError" class="text-red-500 text-sm mt-1 hidden"></div>
        </div>
      </div>

      <div class="bg-slate-50 dark:bg-slate-800/50 rounded-xl p-4 border border-slate-200 dark:border-slate-700">
        <h3 class="text-sm font-medium text-slate-700 dark:text-slate-300 mb-3">Schedule & Status</h3>
        <div class="grid sm:grid-cols-3 gap-4">
          <div>
            <label for="date" class="block text-sm font-medium mb-1">Date <span class="text-rose-600">*</span></label>
            <input id="date" type="date" required
                   class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-3 py-2" />
            <div id="dateError" class="text-red-500 text-sm mt-1 hidden"></div>
          </div>
          <div>
            <label for="time" class="block text-sm font-medium mb-1">Time <span class="text-rose-600">*</span></label>
            <input id="time" type="time" required
                   min="08:00" max="18:00"
                   title="Appointment time must be between 8:00 AM and 6:00 PM"
                   class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-3 py-2" />
            <div id="timeError" class="text-red-500 text-sm mt-1 hidden"></div>
            <p class="text-xs text-slate-500 mt-1">Business hours: 8:00 AM - 6:00 PM</p>
          </div>
          <div>
            <label for="status" class="block text-sm font-medium mb-1">Status <span class="text-rose-600">*</span></label>
            <select id="status" required
                    class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-3 py-2">
              <option value="pending">Pending</option>
              <option value="confirmed">Confirmed</option>
              <option value="done">Done</option>
              <option value="cancelled">Cancelled</option>
            </select>
            <div id="statusError" class="text-red-500 text-sm mt-1 hidden"></div>
            <p class="text-xs text-slate-500 mt-1">Receptionist can set any status. Owner requests set to "pending" automatically.</p>
          </div>
        </div>
      </div>

      <div class="flex items-center gap-3 pt-2">
        <button id="saveBtn"
                class="inline-flex items-center px-5 py-2.5 rounded-xl bg-brand-600 hover:bg-brand-700 text-white font-medium shadow-soft">
          Save changes
        </button>
        <a href="<%= apcontext %>/views/appointment-management/receptionist-dashboard.jsp"
           class="inline-flex items-center px-4 py-2 rounded-xl border border-slate-200 dark:border-slate-800 hover:shadow-soft">
          Cancel
        </a>
      </div>
    </form>
  </div>
</section>

<%@ include file="../common/footer.jsp" %>

<script>
  // Reveal on scroll (matches site behavior)
  const observer = new IntersectionObserver(entries => {
    entries.forEach(e => { if (e.isIntersecting) e.target.classList.add('visible'); });
  }, { threshold: 0.08 });
  document.querySelectorAll('.reveal').forEach(el => observer.observe(el));

  // Optional: keep header theme icon synced if present
  (function syncThemeToggleIcon(){
    const icon = document.getElementById('themeIcon');
    const root = document.documentElement;
    if (!icon) return;
    const isDark = root.classList.contains('dark');
    icon.innerHTML = isDark
            ? '<path d="M12 3.1a1 1 0 0 1 1.1.3 9 9 0 1 0 7.5 7.5 1 1 0 0 1 1.3 1.2A11 11 0 1 1 12 2a1 1 0 0 1 0 1.1Z"/>'
            : '<path d="M21 12.79A9 9 0 1 1 11.21 3a7 7 0 1 0 9.79 9.79Z"/>';
  })();

  // ==== Page logic ====
  const BASE = "<%= apcontext %>/appointments";
  const APPT_ID = <%= (idParam != null && idParam.matches("\\d+")) ? idParam : "null" %>;

  // Staff search functionality
  let staffSearchTimeout;
  
  function createDropdown(inputId, data, onSelect) {
    const input = document.getElementById(inputId);
    const existingDropdown = document.getElementById(inputId + 'Dropdown');
    if (existingDropdown) existingDropdown.remove();

    if (!data || data.length === 0) return;

    const dropdown = document.createElement('div');
    dropdown.id = inputId + 'Dropdown';
    dropdown.className = 'absolute z-50 w-full bg-white dark:bg-slate-800 border border-slate-300 dark:border-slate-600 rounded-lg shadow-lg max-h-48 overflow-y-auto mt-1';

    data.forEach(item => {
      const option = document.createElement('div');
      option.className = 'px-3 py-2 hover:bg-slate-100 dark:hover:bg-slate-700 cursor-pointer text-sm';
      option.textContent = item.fullName + ' (' + item.role + ')';
      option.onclick = () => {
        onSelect(item);
        dropdown.remove();
      };
      dropdown.appendChild(option);
    });

    input.parentNode.style.position = 'relative';
    input.parentNode.appendChild(dropdown);

    // Close dropdown when clicking outside
    setTimeout(() => {
      document.addEventListener('click', function closeDropdown(e) {
        if (!dropdown.contains(e.target) && e.target !== input) {
          dropdown.remove();
          document.removeEventListener('click', closeDropdown);
        }
      });
    }, 100);
  }

  async function searchStaff() {
    const query = document.getElementById('staffSearch').value.trim();
    
    if (!query || query.length < 2) {
      const dropdown = document.getElementById('staffSearchDropdown');
      if (dropdown) dropdown.remove();
      return;
    }

    try {
      const response = await fetch(`<%= apcontext %>/api/staff/search?q=${encodeURIComponent(query)}`);
      if (!response.ok) throw new Error('Failed to search staff');
      
      const staff = await response.json();
      
      createDropdown('staffSearch', staff, (selectedStaff) => {
        document.getElementById('staffSearch').value = selectedStaff.fullName;
        document.getElementById('staffId').value = selectedStaff.staffId;
        document.getElementById('staffRole').textContent = selectedStaff.role;
      });
    } catch (error) {
      console.error('Staff search error:', error);
    }
  }

  function onStaffSearchInput() {
    clearTimeout(staffSearchTimeout);
    staffSearchTimeout = setTimeout(searchStaff, 300);
  }

  function clearStaffSelection() {
    document.getElementById('staffSearch').value = '';
    document.getElementById('staffId').value = '';
    document.getElementById('staffRole').textContent = '';
    const dropdown = document.getElementById('staffSearchDropdown');
    if (dropdown) dropdown.remove();
  }

  function showAlert(type, msg){
    const el = document.getElementById('alert');
    el.className = "mt-6 rounded-xl p-4 text-sm " +
            (type === 'success'
                    ? "bg-emerald-50 text-emerald-800 dark:bg-emerald-900/30 dark:text-emerald-200 border border-emerald-200/50"
                    : "bg-rose-50 text-rose-800 dark:bg-rose-900/30 dark:text-rose-200 border border-rose-200/50");
    el.textContent = msg;
    el.classList.remove('hidden');
  }

  // Enhanced validation functions
  function validateDateTime() {
    const dateInput = document.getElementById('date');
    const timeInput = document.getElementById('time');
    const dateValue = dateInput.value;
    const timeValue = timeInput.value;
    
    // Clear previous errors
    hideError('dateError');
    hideError('timeError');
    
    let valid = true;
    
    // Date validation
    if (!dateValue) {
      showError('dateError', 'Date is required');
      valid = false;
    } else {
      const selectedDate = new Date(dateValue);
      const today = new Date();
      today.setHours(0, 0, 0, 0);
      
      if (selectedDate < today) {
        showError('dateError', 'Cannot schedule appointment in the past');
        valid = false;
      }
    }
    
    // Time validation
    if (!timeValue) {
      showError('timeError', 'Time is required');
      valid = false;
    } else {
      const [hours] = timeValue.split(':').map(Number);
      if (hours < 8 || hours >= 18) {
        showError('timeError', 'Time must be between 8:00 AM and 6:00 PM');
        valid = false;
      }
    }
    
    return valid;
  }
  
  function showError(elementId, message) {
    const errorElement = document.getElementById(elementId);
    if (errorElement) {
      errorElement.textContent = message;
      errorElement.classList.remove('hidden');
    }
  }
  
  function hideError(elementId) {
    const errorElement = document.getElementById(elementId);
    if (errorElement) {
      errorElement.classList.add('hidden');
    }
  }

  function toInputDateTime(iso){
    if (!iso) return { d:"", t:"" };
    const d = new Date(iso);
    const yyyy = d.getFullYear();
    const mm = String(d.getMonth()+1).padStart(2,'0');
    const dd = String(d.getDate()).padStart(2,'0');
    const HH = String(d.getHours()).padStart(2,'0');
    const MM = String(d.getMinutes()).padStart(2,'0');
    return { d: `${yyyy}-${mm}-${dd}`, t: `${HH}:${MM}` };
  }

  async function loadAppointment(){
    if (!APPT_ID){
      showAlert('error', 'No appointment id provided.');
      return;
    }
    try {
      const res = await fetch(`${BASE}?id=${APPT_ID}`);
      if (!res.ok) throw new Error('Failed to load appointment');
      const a = await res.json();

      console.log('Loaded appointment data:', a); // Debug log

      // Set values with error checking
      const appointmentIdEl = document.getElementById('appointmentId');
      const petUidEl = document.getElementById('petUid');
      const ownerIdEl = document.getElementById('ownerId');
      const staffIdEl = document.getElementById('staffId');
      const typeEl = document.getElementById('type');
      const statusEl = document.getElementById('status');

      if (appointmentIdEl) appointmentIdEl.value = a.appointmentId;
      else console.error('appointmentId element not found');

      if (petUidEl) petUidEl.value = a.petUid || '';
      else console.error('petUid element not found');

      if (ownerIdEl) ownerIdEl.value = a.ownerId || '';
      else console.error('ownerId element not found');

      if (staffIdEl) staffIdEl.value = (a.staffId ?? '') === null ? '' : (a.staffId ?? '');
      else console.error('staffId element not found');

      if (typeEl) typeEl.value = a.type || '';
      else console.error('type element not found');

      if (statusEl) statusEl.value = (a.status || 'pending').toLowerCase();
      else console.error('status element not found');

      // Load staff information if staffId exists
      if (a.staffId) {
        try {
          // Try to get staff by ID first
          const staffRes = await fetch(`<%= apcontext %>/api/staff/search?id=${a.staffId}`);
          if (staffRes.ok) {
            const staffData = await staffRes.json();
            if (staffData && staffData.length > 0) {
              const staff = staffData[0];
              const staffSearchEl = document.getElementById('staffSearch');
              const staffRoleEl = document.getElementById('staffRole');
              
              if (staffSearchEl) staffSearchEl.value = staff.fullName;
              if (staffRoleEl) staffRoleEl.textContent = `Role: ${staff.role}`;
            }
          }
        } catch (e) {
          console.warn('Could not load staff details:', e);
          // If staff loading fails, just show the staff ID
          const staffSearchEl = document.getElementById('staffSearch');
          if (staffSearchEl) staffSearchEl.value = `Staff ID: ${a.staffId}`;
        }
      }

      const dt = toInputDateTime(a.scheduledAt);
      const dateEl = document.getElementById('date');
      const timeEl = document.getElementById('time');
      
      if (dateEl) dateEl.value = dt.d;
      else console.error('date element not found');
      
      if (timeEl) timeEl.value = dt.t;
      else console.error('time element not found');

      // min date = today
      const now = new Date();
      const yyyy = now.getFullYear(), mm = String(now.getMonth()+1).padStart(2,'0'), dd = String(now.getDate()).padStart(2,'0');
      if (dateEl) dateEl.min = `${yyyy}-${mm}-${dd}`;
      
      // Setup event listeners for validation
      if (dateEl) dateEl.addEventListener('change', validateDateTime);
      if (timeEl) timeEl.addEventListener('change', validateDateTime);
      
    } catch (e) {
      showAlert('error', e.message);
      console.error('Error loading appointment:', e);
    }
  }

  async function saveChanges(){
    // Validate form before submitting
    if (!validateDateTime()) {
      showAlert('error', 'Please fix the validation errors before saving.');
      return;
    }

    const btn = document.getElementById('saveBtn');
    btn.disabled = true; btn.classList.add('opacity-60','cursor-not-allowed');

    try {
      const payload = {
        appointmentId: Number(document.getElementById('appointmentId').value),
        ownerId: Number(document.getElementById('ownerId').value),
        staffId: document.getElementById('staffId').value ? Number(document.getElementById('staffId').value) : null,
        type: document.getElementById('type').value,
        status: document.getElementById('status').value,
        scheduledAt: document.getElementById('date').value + 'T' + document.getElementById('time').value
      };
      if (payload.staffId === null) delete payload.staffId; // avoid forcing NULL if DAO doesn't expect it

      const res = await fetch(BASE, {
        method: 'PUT',
        headers: { 'Content-Type':'application/json' },
        body: JSON.stringify(payload)
      });

      let data = null; try { data = await res.json(); } catch {}
      if (!res.ok) {
        const msg = (data && data.error) ? data.error : res.statusText || 'Update failed';
        throw new Error(msg);
      }

      showAlert('success', 'Appointment updated successfully! Redirecting to dashboard...');
      
      // success → dashboard with delay to show success message
      setTimeout(() => {
        window.location.replace("<%= apcontext %>/");
      }, 2000);
    } catch (e) {
      showAlert('error', e.message);
    } finally {
      btn.disabled = false; btn.classList.remove('opacity-60','cursor-not-allowed');
    }
  }

  document.addEventListener('DOMContentLoaded', loadAppointment);
</script>

</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Add Model.AppointmentManagement.Appointment — Happy Paws PetCare</title>
  <meta name="description" content="Create a new booking for a pet owner." />

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

<!-- PAGE HEADER (theme-aligned hero) -->
<section class="relative overflow-hidden">
  <div class="absolute inset-0 bg-gradient-to-b from-brand-50 via-white to-white dark:from-slate-900 dark:via-slate-950 dark:to-slate-950"></div>
  <div class="absolute inset-0 bg-grid opacity-60 dark:opacity-20"></div>

  <div class="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10 md:py-14">
    <div class="flex items-center justify-between gap-4 reveal">
      <div>
        <h1 class="font-display text-3xl md:text-4xl font-extrabold tracking-tight">Add Appointment</h1>
        <p class="mt-2 text-sm text-slate-600 dark:text-slate-300">Create a new booking for a pet owner.</p>
      </div>
      <div class="flex items-center gap-2">
        <a href="<%= request.getContextPath() %>/views/appointment-management/receptionist-dashboard.jsp"
           class="inline-flex items-center px-4 py-2 rounded-xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 hover:shadow-soft">
          ← Back to dashboard
        </a>
      </div>
    </div>
  </div>
</section>

<!-- CONTENT -->
<section class="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 pb-16">
  <!-- Flash messages -->
  <%
    String flashError = (String) request.getAttribute("error");
    String flashOk = (String) request.getAttribute("ok");
    if (flashError != null) {
  %>
  <div class="reveal mt-6 rounded-xl p-4 text-sm bg-rose-50 text-rose-800 dark:bg-rose-900/30 dark:text-rose-200 border border-rose-200/50">
    <%= flashError %>
  </div>
  <% } else if (flashOk != null) { %>
  <div class="reveal mt-6 rounded-xl p-4 text-sm bg-emerald-50 text-emerald-800 dark:bg-emerald-900/30 dark:text-emerald-200 border border-emerald-200/50">
    <%= flashOk %>
  </div>
  <% } %>

  <!-- Form card with halo -->
  <div class="reveal relative">
    <div class="absolute -inset-2 rounded-3xl bg-gradient-to-tr from-brand-600/20 via-brand-400/10 to-brand-600/20 blur-2xl"></div>
    <form method="post" action="<%= request.getContextPath() %>/appointments"
          class="relative mt-6 rounded-3xl border border-slate-200 dark:border-slate-800 bg-white/80 dark:bg-slate-900/60 p-8 shadow-soft backdrop-blur overflow-hidden"
          id="appointmentForm">

      <!-- Step 1: Pet Selection -->
      <div class="space-y-6">
        <div class="border-b border-slate-200 dark:border-slate-700 pb-6">
          <h2 class="text-lg font-semibold text-slate-900 dark:text-slate-100 mb-1">1. Select Pet & Owner</h2>
          <p class="text-sm text-slate-600 dark:text-slate-400 mb-4">Search for the pet by name, owner name, or phone number</p>
          
          <div class="relative">
            <input type="text" id="petSearch" name="petSearch" 
                   placeholder="Search by pet name, owner name, or phone..." 
                   class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-4 py-3 text-base" 
                   autocomplete="off" />
            <div class="absolute right-3 top-3 text-slate-400">
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path>
              </svg>
            </div>
            <div id="petSearchResults" class="absolute z-50 w-full max-h-60 overflow-y-auto bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl shadow-lg mt-1 hidden">
              <!-- Search results will be populated here -->
            </div>
          </div>
          <div id="petSearchError" class="hidden mt-2 text-sm text-red-500"></div>
          
          <!-- Hidden fields for selected pet -->
          <input type="hidden" id="petUid" name="petUid" required />
          <input type="hidden" id="ownerId" name="ownerId" required />
          
          <!-- Display selected pet info -->
          <div id="selectedPetInfo" class="hidden mt-4 p-4 bg-green-50 dark:bg-green-900/30 border border-green-200 dark:border-green-800 rounded-xl">
            <div class="flex items-start justify-between">
              <div class="flex-1">
                <div class="font-medium text-green-800 dark:text-green-200" id="selectedPetDisplay"></div>
                <div class="text-sm text-green-600 dark:text-green-400 mt-1" id="selectedOwnerDisplay"></div>
              </div>
              <button type="button" id="clearSelectedPet" class="text-green-600 hover:text-green-800 dark:text-green-400 dark:hover:text-green-200 text-sm font-medium">
                Change
              </button>
            </div>
          </div>
        </div>

        <!-- Step 2: Appointment Details -->
        <div class="border-b border-slate-200 dark:border-slate-700 pb-6">
          <h2 class="text-lg font-semibold text-slate-900 dark:text-slate-100 mb-1">2. Appointment Details</h2>
          <p class="text-sm text-slate-600 dark:text-slate-400 mb-4">Choose the type and schedule for the appointment</p>
          
          <div class="grid md:grid-cols-2 gap-6">
            <div>
              <label for="type" class="block text-sm font-medium mb-2">Appointment Type <span class="text-rose-600">*</span></label>
              <select id="type" name="type" required
                      class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-4 py-3 text-base">
                <option value="">Choose appointment type...</option>
                <option value="Veterinary">Veterinary Check-up</option>
                <option value="Grooming">Pet Grooming</option>
              </select>
              <div id="typeError" class="text-red-500 text-sm mt-1 hidden"></div>
            </div>

            <div>
              <label for="status" class="block text-sm font-medium mb-2">Initial Status <span class="text-rose-600">*</span></label>
              <select id="status" name="status" required
                      class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-4 py-3 text-base">
                <option value="pending">Pending (Default)</option>
                <option value="confirmed">Confirmed</option>
                <option value="done">Completed</option>
                <option value="cancelled">Cancelled</option>
              </select>
              <div id="statusError" class="text-red-500 text-sm mt-1 hidden"></div>
            </div>
          </div>

          <div class="grid md:grid-cols-2 gap-6 mt-4">
            <div>
              <label for="date" class="block text-sm font-medium mb-2">Date <span class="text-rose-600">*</span></label>
              <input id="date" name="date" type="date" required
                     class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-4 py-3 text-base" />
              <div id="dateError" class="text-red-500 text-sm mt-1 hidden"></div>
              <p class="text-xs text-slate-500 mt-2">
                <i class="fas fa-info-circle mr-1"></i>
                Each pet is limited to 1 regular appointment per day. Emergency appointments are exempt from this limit.
              </p>
            </div>
            
            <div>
              <label for="time" class="block text-sm font-medium mb-2">Time <span class="text-rose-600">*</span></label>
              <input id="time" name="time" type="time" required
                     min="08:00" max="18:00"
                     class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-4 py-3 text-base" />
              <div id="timeError" class="text-red-500 text-sm mt-1 hidden"></div>
              <p class="text-xs text-slate-500 mt-2">Business hours: 8:00 AM - 6:00 PM</p>
            </div>
          </div>
        </div>

        <!-- Step 3: Staff Assignment -->
        <div class="border-b border-slate-200 dark:border-slate-700 pb-6">
          <h2 class="text-lg font-semibold text-slate-900 dark:text-slate-100 mb-1">3. Assign Staff Member</h2>
          <p class="text-sm text-slate-600 dark:text-slate-400 mb-4">Select the staff member who will handle this appointment</p>
          
          <div class="relative">
            <input type="text" id="staffSearch" name="staffSearch" 
                   placeholder="Search staff by name or role..." 
                   class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-4 py-3 text-base" 
                   autocomplete="off" />
            <div class="absolute right-3 top-3 text-slate-400">
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
              </svg>
            </div>
            <div id="staffSearchResults" class="absolute z-40 w-full max-h-48 overflow-y-auto bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl shadow-lg mt-1 hidden">
              <!-- Staff search results will be populated here -->
            </div>
          </div>
          <div id="staffSearchError" class="hidden mt-2 text-sm text-red-500"></div>
          
          <!-- Hidden field for selected staff ID -->
          <input type="hidden" id="staffId" name="staffId" required />
          
          <!-- Display selected staff info -->
          <div id="selectedStaffInfo" class="hidden mt-4 p-4 bg-blue-50 dark:bg-blue-900/30 border border-blue-200 dark:border-blue-800 rounded-xl">
            <div class="flex items-start justify-between">
              <div class="flex-1">
                <div class="font-medium text-blue-800 dark:text-blue-200" id="selectedStaffDisplay"></div>
                <div class="text-sm text-blue-600 dark:text-blue-400 mt-1" id="selectedStaffRole"></div>
              </div>
              <button type="button" id="clearSelectedStaff" class="text-blue-600 hover:text-blue-800 dark:text-blue-400 dark:hover:text-blue-200 text-sm font-medium">
                Change
              </button>
            </div>
          </div>
          
          <!-- Quick filter buttons -->
          <div id="staffRoleFilters" class="mt-4 flex flex-wrap gap-2 hidden">
            <span class="text-sm text-slate-600 dark:text-slate-400 mr-2">Quick filters:</span>
            <button type="button" class="staff-filter-btn px-3 py-1 text-sm rounded-lg bg-slate-100 dark:bg-slate-700 text-slate-600 dark:text-slate-300 hover:bg-slate-200 dark:hover:bg-slate-600" data-role="veterinarian">
              Veterinarians
            </button>
            <button type="button" class="staff-filter-btn px-3 py-1 text-sm rounded-lg bg-slate-100 dark:bg-slate-700 text-slate-600 dark:text-slate-300 hover:bg-slate-200 dark:hover:bg-slate-600" data-role="groomer">
              Groomers
            </button>
            <button type="button" class="staff-filter-btn px-3 py-1 text-sm rounded-lg bg-slate-100 dark:bg-slate-700 text-slate-600 dark:text-slate-300 hover:bg-slate-200 dark:hover:bg-slate-600" data-role="">
              All Staff
            </button>
          </div>
        </div>

        <!-- Step 4: Additional Information (Optional) -->
        <div>
          <h2 class="text-lg font-semibold text-slate-900 dark:text-slate-100 mb-1">4. Additional Information</h2>
          <p class="text-sm text-slate-600 dark:text-slate-400 mb-4">Optional details for the appointment</p>
          
          <div class="grid md:grid-cols-2 gap-6">
            <div>
              <label for="phoneNo" class="block text-sm font-medium mb-2">Contact Phone</label>
              <input id="phoneNo" name="phoneNo" type="tel"
                     placeholder="e.g., 0712345678"
                     pattern="^(\+94|0)[0-9]{9}$"
                     class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-4 py-3 text-base" />
              <div id="phoneNoError" class="text-red-500 text-sm mt-1 hidden"></div>
              <p class="text-xs text-slate-500 mt-2">Optional: Alternative contact number</p>
            </div>

            <div>
              <label for="fee" class="block text-sm font-medium mb-2">Appointment Fee (LKR)</label>
              <input id="fee" name="fee" type="number" step="0.01" min="0" max="999999"
                     placeholder="e.g., 2500.00"
                     class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-4 py-3 text-base" />
              <div id="feeError" class="text-red-500 text-sm mt-1 hidden"></div>
              <p class="text-xs text-slate-500 mt-2">Optional: Leave blank for default pricing</p>
            </div>
          </div>
        </div>

        <!-- Action Buttons -->
        <div class="flex flex-col sm:flex-row items-center gap-4 pt-6 border-t border-slate-200 dark:border-slate-700">
          <button type="submit" class="w-full sm:w-auto inline-flex items-center justify-center px-8 py-3 rounded-xl bg-brand-600 hover:bg-brand-700 text-white font-medium shadow-soft text-base">
            <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
            </svg>
            Create Appointment
          </button>
          <a href="<%= request.getContextPath() %>/views/appointment-management/receptionist-dashboard.jsp"
             class="w-full sm:w-auto inline-flex items-center justify-center px-6 py-3 rounded-xl border border-slate-200 dark:border-slate-800 hover:shadow-soft text-base">
            Cancel
          </a>
        </div>
      </div>
    </form>
  </div>
</section>

<%@ include file= "/views/common/footer.jsp" %>

<script>
  // PET SEARCH FUNCTIONALITY
  document.addEventListener('DOMContentLoaded', function() {
    const petSearchInput = document.getElementById('petSearch');
    const petSearchResults = document.getElementById('petSearchResults');
    const petSearchError = document.getElementById('petSearchError');
    const petUidInput = document.getElementById('petUid');
    const ownerIdInput = document.getElementById('ownerId');
    const selectedPetInfo = document.getElementById('selectedPetInfo');
    const selectedPetDisplay = document.getElementById('selectedPetDisplay');
    const selectedOwnerDisplay = document.getElementById('selectedOwnerDisplay');
    const clearSelectedPet = document.getElementById('clearSelectedPet');

    let searchTimeout;

    // Pet search functionality
    petSearchInput.addEventListener('input', function() {
      const searchTerm = this.value.trim();
      
      clearTimeout(searchTimeout);
      petSearchResults.classList.add('hidden');
      
      if (searchTerm.length < 2) {
        return;
      }

      searchTimeout = setTimeout(() => {
        searchPets(searchTerm);
      }, 300);
    });

    // Hide results when clicking outside
    document.addEventListener('click', function(e) {
      if (!petSearchInput.contains(e.target) && !petSearchResults.contains(e.target)) {
        petSearchResults.classList.add('hidden');
      }
    });

    function searchPets(searchTerm) {
      fetch(`<%= request.getContextPath() %>/api/pets/search?q=${encodeURIComponent(searchTerm)}`)
        .then(response => {
          // Check if response is JSON
          const contentType = response.headers.get('content-type');
          if (!response.ok) {
            if (response.status === 401) {
              showSearchError('Please log in to search pets.');
              return null;
            } else if (response.status === 403) {
              showSearchError('You do not have permission to search pets.');
              return null;
            } else {
              showSearchError(`Search failed: ${response.status} ${response.statusText}`);
              return null;
            }
          }
          
          if (!contentType || !contentType.includes('application/json')) {
            console.error('Expected JSON but got:', contentType);
            showSearchError('Server returned unexpected response format.');
            return null;
          }
          
          return response.json();
        })
        .then(data => {
          if (!data) return; // Error already handled above
          
          if (data.error) {
            showSearchError(data.error);
            return;
          }
          
          displaySearchResults(data);
        })
        .catch(error => {
          console.error('Staff search error:', error);
          showSearchError('Search failed. Please try again.');
        });
    }

    function displaySearchResults(pets) {
      petSearchError.classList.add('hidden');
      
      if (pets.length === 0) {
        petSearchResults.innerHTML = '<div class="p-3 text-sm text-slate-500">No pets found</div>';
        petSearchResults.classList.remove('hidden');
        return;
      }

      const resultsHtml = pets.map(pet => `
        <div class="p-3 hover:bg-slate-50 dark:hover:bg-slate-700 cursor-pointer border-b border-slate-100 dark:border-slate-600 last:border-b-0"
             data-pet-uid="${pet.petUid}" 
             data-owner-id="${pet.ownerId}"
             data-pet-name="${pet.name}"
             data-pet-species="${pet.species || ''}"
             data-owner-name="${pet.ownerName || ''}"
             data-owner-phone="${pet.ownerPhone || ''}">
          <div class="font-medium text-sm">${pet.name} ${pet.species ? '(' + pet.species + ')' : ''}</div>
          <div class="text-xs text-slate-500 mt-1">
            Owner: ${pet.ownerName || 'N/A'} ${pet.ownerPhone ? '• ' + pet.ownerPhone : ''}
          </div>
        </div>
      `).join('');

      petSearchResults.innerHTML = resultsHtml;
      petSearchResults.classList.remove('hidden');

      // Add click handlers to results
      petSearchResults.querySelectorAll('[data-pet-uid]').forEach(item => {
        item.addEventListener('click', function() {
          selectPet(this);
        });
      });
    }

    function selectPet(element) {
      const petUid = element.getAttribute('data-pet-uid');
      const ownerId = element.getAttribute('data-owner-id');
      const petName = element.getAttribute('data-pet-name');
      const petSpecies = element.getAttribute('data-pet-species');
      const ownerName = element.getAttribute('data-owner-name');
      const ownerPhone = element.getAttribute('data-owner-phone');

      // Set hidden form values
      petUidInput.value = petUid;
      ownerIdInput.value = ownerId;

      // Display selected pet info
      selectedPetDisplay.textContent = `${petName} ${petSpecies ? '(' + petSpecies + ')' : ''}`;
      selectedOwnerDisplay.textContent = `Owner: ${ownerName} ${ownerPhone ? '• ' + ownerPhone : ''}`;
      
      // Show selection and hide search results
      selectedPetInfo.classList.remove('hidden');
      petSearchResults.classList.add('hidden');
      petSearchInput.value = `${petName} - ${ownerName}`;
      petSearchInput.setAttribute('readonly', true);
      
      // Clear any errors
      petSearchError.classList.add('hidden');
    }

    function showSearchError(message) {
      petSearchError.textContent = message;
      petSearchError.classList.remove('hidden');
      petSearchResults.classList.add('hidden');
    }

    // Clear selected pet
    clearSelectedPet.addEventListener('click', function() {
      petUidInput.value = '';
      ownerIdInput.value = '';
      petSearchInput.value = '';
      petSearchInput.removeAttribute('readonly');
      selectedPetInfo.classList.add('hidden');
      petSearchResults.classList.add('hidden');
      petSearchError.classList.add('hidden');
      petSearchInput.focus();
    });

    // STAFF SEARCH FUNCTIONALITY
    const staffSearchInput = document.getElementById('staffSearch');
    const staffSearchResults = document.getElementById('staffSearchResults');
    const staffSearchError = document.getElementById('staffSearchError');
    const staffIdInput = document.getElementById('staffId');
    const selectedStaffInfo = document.getElementById('selectedStaffInfo');
    const selectedStaffDisplay = document.getElementById('selectedStaffDisplay');
    const selectedStaffRole = document.getElementById('selectedStaffRole');
    const clearSelectedStaff = document.getElementById('clearSelectedStaff');
    const staffRoleFilters = document.getElementById('staffRoleFilters');
    const typeSelect = document.getElementById('type');

    let staffSearchTimeout;

    // Show/hide role filters based on appointment type
    typeSelect.addEventListener('change', function() {
      if (this.value && this.value !== '') {
        staffRoleFilters.classList.remove('hidden');
        // Auto-filter staff based on appointment type
        const selectedType = this.value.toLowerCase();
        if (selectedType === 'veterinary') {
          searchStaffByRole('veterinarian');
          // Highlight the veterinarian filter button
          document.querySelectorAll('.staff-filter-btn').forEach(b => 
            b.classList.remove('bg-blue-100', 'dark:bg-blue-900', 'text-blue-800', 'dark:text-blue-200'));
          document.querySelector('[data-role="veterinarian"]').classList.add('bg-blue-100', 'dark:bg-blue-900', 'text-blue-800', 'dark:text-blue-200');
        } else if (selectedType === 'grooming') {
          searchStaffByRole('groomer');
          // Highlight the groomer filter button
          document.querySelectorAll('.staff-filter-btn').forEach(b => 
            b.classList.remove('bg-blue-100', 'dark:bg-blue-900', 'text-blue-800', 'dark:text-blue-200'));
          document.querySelector('[data-role="groomer"]').classList.add('bg-blue-100', 'dark:bg-blue-900', 'text-blue-800', 'dark:text-blue-200');
        } else {
          searchStaff('');
          // Highlight the all staff button
          document.querySelectorAll('.staff-filter-btn').forEach(b => 
            b.classList.remove('bg-blue-100', 'dark:bg-blue-900', 'text-blue-800', 'dark:text-blue-200'));
          document.querySelector('[data-role=""]').classList.add('bg-blue-100', 'dark:bg-blue-900', 'text-blue-800', 'dark:text-blue-200');
        }
      } else {
        staffRoleFilters.classList.add('hidden');
        // Clear staff search when no type is selected
        staffSearchResults.classList.add('hidden');
      }
    });

    // Staff search functionality
    staffSearchInput.addEventListener('input', function() {
      const searchTerm = this.value.trim();
      
      clearTimeout(staffSearchTimeout);
      staffSearchResults.classList.add('hidden');
      
      if (searchTerm.length < 1) {
        return;
      }

      staffSearchTimeout = setTimeout(() => {
        searchStaff(searchTerm);
      }, 300);
    });

    // Role filter buttons
    document.querySelectorAll('.staff-filter-btn').forEach(btn => {
      btn.addEventListener('click', function() {
        const role = this.getAttribute('data-role');
        // Update button states
        document.querySelectorAll('.staff-filter-btn').forEach(b => 
          b.classList.remove('bg-blue-100', 'dark:bg-blue-900', 'text-blue-800', 'dark:text-blue-200'));
        this.classList.add('bg-blue-100', 'dark:bg-blue-900', 'text-blue-800', 'dark:text-blue-200');
        
        if (role) {
          searchStaffByRole(role);
        } else {
          searchStaff('');
        }
      });
    });

    // Hide staff results when clicking outside
    document.addEventListener('click', function(e) {
      if (!staffSearchInput.contains(e.target) && !staffSearchResults.contains(e.target)) {
        staffSearchResults.classList.add('hidden');
      }
    });

    function searchStaff(searchTerm) {
      const url = searchTerm ? 
        `<%= request.getContextPath() %>/api/staff/search?q=${encodeURIComponent(searchTerm)}` :
        `<%= request.getContextPath() %>/api/staff/search`;
        
      fetch(url)
        .then(response => response.json())
        .then(data => {
          if (data.error) {
            showStaffSearchError(data.error);
            return;
          }
          displayStaffResults(data);
        })
        .catch(error => {
          console.error('Staff search error:', error);
          showStaffSearchError('Staff search failed. Please try again.');
        });
    }

    function searchStaffByRole(role) {
      fetch(`<%= request.getContextPath() %>/api/staff/search?role=${encodeURIComponent(role)}`)
        .then(response => response.json())
        .then(data => {
          if (data.error) {
            showStaffSearchError(data.error);
            return;
          }
          displayStaffResults(data);
          // Show message if specific role has no staff
          if (data.length === 0) {
            const roleDisplay = role.charAt(0).toUpperCase() + role.slice(1);
            showStaffSearchError(`No ${roleDisplay}s found. Try selecting "All Staff" to see available options.`);
          }
        })
        .catch(error => {
          console.error('Staff search error:', error);
          showStaffSearchError('Staff search failed. Please try again.');
        });
    }

    function displayStaffResults(staff) {
      staffSearchError.classList.add('hidden');
      
      if (staff.length === 0) {
        staffSearchResults.innerHTML = '<div class="p-3 text-sm text-slate-500">No staff found</div>';
        staffSearchResults.classList.remove('hidden');
        return;
      }

      const resultsHtml = staff.map(member => `
        <div class="p-3 hover:bg-slate-50 dark:hover:bg-slate-700 cursor-pointer border-b border-slate-100 dark:border-slate-600 last:border-b-0"
             data-staff-id="${member.staffId}" 
             data-staff-name="${member.fullName}"
             data-staff-role="${member.role || ''}"
             data-staff-email="${member.email || ''}"
             data-staff-phone="${member.phone || ''}">
          <div class="font-medium text-sm">${member.fullName}</div>
          <div class="text-xs text-slate-500 mt-1">
            <span class="inline-block px-2 py-0.5 text-xs rounded-full bg-slate-100 dark:bg-slate-700 text-slate-600 dark:text-slate-300 mr-2">
              ${member.role ? member.role.charAt(0).toUpperCase() + member.role.slice(1) : 'Staff'}
            </span>
            ${member.email ? member.email : ''}
            ${member.phone ? (member.email ? ' • ' : '') + member.phone : ''}
          </div>
        </div>
      `).join('');

      staffSearchResults.innerHTML = resultsHtml;
      staffSearchResults.classList.remove('hidden');

      // Add click handlers to results
      staffSearchResults.querySelectorAll('[data-staff-id]').forEach(item => {
        item.addEventListener('click', function() {
          selectStaff(this);
        });
      });
    }

    function selectStaff(element) {
      const staffId = element.getAttribute('data-staff-id');
      const staffName = element.getAttribute('data-staff-name');
      const staffRole = element.getAttribute('data-staff-role');
      const staffEmail = element.getAttribute('data-staff-email');
      const staffPhone = element.getAttribute('data-staff-phone');

      // Set hidden form value
      staffIdInput.value = staffId;

      // Display selected staff info
      selectedStaffDisplay.textContent = staffName;
      selectedStaffRole.textContent = `${staffRole ? staffRole.charAt(0).toUpperCase() + staffRole.slice(1) : 'Staff'} ${staffEmail ? '• ' + staffEmail : ''}`;
      
      // Show selection and hide search results
      selectedStaffInfo.classList.remove('hidden');
      staffSearchResults.classList.add('hidden');
      staffSearchInput.value = `${staffName} (${staffRole || 'Staff'})`;
      staffSearchInput.setAttribute('readonly', true);
      
      // Clear any errors
      staffSearchError.classList.add('hidden');
    }

    function showStaffSearchError(message) {
      staffSearchError.textContent = message;
      staffSearchError.classList.remove('hidden');
      staffSearchResults.classList.add('hidden');
    }

    // Clear selected staff
    clearSelectedStaff.addEventListener('click', function() {
      staffIdInput.value = '';
      staffSearchInput.value = '';
      staffSearchInput.removeAttribute('readonly');
      selectedStaffInfo.classList.add('hidden');
      staffSearchResults.classList.add('hidden');
      staffSearchError.classList.add('hidden');
      staffSearchInput.focus();
    });

    // Initialize staff search - show all staff on focus if no type is selected
    staffSearchInput.addEventListener('focus', function() {
      if (!typeSelect.value && staffSearchInput.value.trim() === '') {
        searchStaff('');
      }
    });

    // FORM VALIDATION VARIABLES AND FUNCTIONS
    const appointmentForm = document.getElementById('appointmentForm');
    const dateInput = document.getElementById('date');
    const timeInput = document.getElementById('time');
    const phoneNoInput = document.getElementById('phoneNo');
    const feeInput = document.getElementById('fee');
    const statusSelect = document.getElementById('status');

    const typeError = document.getElementById('typeError');
    const dateError = document.getElementById('dateError');
    const timeError = document.getElementById('timeError');
    const phoneNoError = document.getElementById('phoneNoError');
    const feeError = document.getElementById('feeError');
    const statusError = document.getElementById('statusError');

    // UUID validation function
    function validateUUID(uuid) {
      const uuidRegex = /^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$/;
      return uuidRegex.test(uuid);
    }

    // Phone validation function (Sri Lankan numbers)
    function validatePhone(phone) {
      if (phone === '') return true; // Optional field
      const phoneRegex = /^(\+94|0)[0-9]{9}$/;
      return phoneRegex.test(phone);
    }

    // Date validation function (not in the past and within 2 weeks)
    function validateDate(dateStr) {
      const inputDate = new Date(dateStr);
      const today = new Date();
      today.setHours(0, 0, 0, 0);
      
      // Calculate max date (2 weeks from today)
      const maxDate = new Date();
      maxDate.setDate(maxDate.getDate() + 14);
      maxDate.setHours(0, 0, 0, 0);
      
      return inputDate >= today && inputDate <= maxDate;
    }

    // Time validation function (business hours 8:00-18:00)
    function validateTime(timeStr) {
      const time = timeStr.split(':');
      const hours = parseInt(time[0], 10);
      return hours >= 8 && hours <= 18;
    }

    // Real-time validation for Type
    typeSelect.addEventListener('change', function() {
      if (this.value === '') {
        typeError.textContent = 'Please select an appointment type';
        typeError.classList.remove('hidden');
        this.classList.add('border-red-500');
      } else {
        typeError.classList.add('hidden');
        this.classList.remove('border-red-500');
      }
    });

    // Real-time validation for Date
    dateInput.addEventListener('blur', function() {
      const dateStr = this.value;
      if (dateStr === '') {
        dateError.textContent = 'Appointment date is required';
        dateError.classList.remove('hidden');
        this.classList.add('border-red-500');
      } else if (!validateDate(dateStr)) {
        const inputDate = new Date(dateStr);
        const today = new Date();
        today.setHours(0, 0, 0, 0);
        
        if (inputDate < today) {
          dateError.textContent = 'Appointment date cannot be in the past';
        } else {
          dateError.textContent = 'Appointment date must be within 2 weeks from today';
        }
        dateError.classList.remove('hidden');
        this.classList.add('border-red-500');
      } else {
        dateError.classList.add('hidden');
        this.classList.remove('border-red-500');
      }
    });

    // Real-time validation for Time
    timeInput.addEventListener('blur', function() {
      const timeStr = this.value;
      if (timeStr === '') {
        timeError.textContent = 'Appointment time is required';
        timeError.classList.remove('hidden');
        this.classList.add('border-red-500');
      } else if (!validateTime(timeStr)) {
        timeError.textContent = 'Appointment time must be between 8:00 AM and 6:00 PM';
        timeError.classList.remove('hidden');
        this.classList.add('border-red-500');
      } else {
        timeError.classList.add('hidden');
        this.classList.remove('border-red-500');
      }
    });

    // Real-time validation for Phone (optional)
    phoneNoInput.addEventListener('blur', function() {
      const phone = this.value.trim();
      if (phone !== '' && !validatePhone(phone)) {
        phoneNoError.textContent = 'Please enter a valid Sri Lankan phone number (e.g., 0712345678)';
        phoneNoError.classList.remove('hidden');
        this.classList.add('border-red-500');
      } else {
        phoneNoError.classList.add('hidden');
        this.classList.remove('border-red-500');
      }
    });

    // Real-time validation for Fee (optional)
    feeInput.addEventListener('blur', function() {
      const fee = this.value;
      if (fee !== '' && (fee < 0 || isNaN(fee))) {
        feeError.textContent = 'Fee must be a positive number';
        feeError.classList.remove('hidden');
        this.classList.add('border-red-500');
      } else {
        feeError.classList.add('hidden');
        this.classList.remove('border-red-500');
      }
    });

    // Form submission validation
    appointmentForm.addEventListener('submit', function(e) {
      let isValid = true;

      // Validate Pet Selection
      const petUid = petUidInput.value.trim();
      const ownerId = ownerIdInput.value.trim();
      if (!petUid || !ownerId) {
        petSearchError.textContent = 'Please select a pet from the search results';
        petSearchError.classList.remove('hidden');
        isValid = false;
      } else {
        petSearchError.classList.add('hidden');
      }

      // Validate Staff Selection
      const staffId = staffIdInput.value.trim();
      if (!staffId) {
        staffSearchError.textContent = 'Please select a staff member';
        staffSearchError.classList.remove('hidden');
        isValid = false;
      } else {
        staffSearchError.classList.add('hidden');
      }

      // Validate Type
      if (typeSelect.value === '') {
        typeError.textContent = 'Please select an appointment type';
        typeError.classList.remove('hidden');
        typeSelect.classList.add('border-red-500');
        isValid = false;
      }

      // Validate Date
      const dateStr = dateInput.value;
      if (!dateStr) {
        dateError.textContent = 'Appointment date is required';
        dateError.classList.remove('hidden');
        dateInput.classList.add('border-red-500');
        isValid = false;
      } else if (!validateDate(dateStr)) {
        const inputDate = new Date(dateStr);
        const today = new Date();
        today.setHours(0, 0, 0, 0);
        
        if (inputDate < today) {
          dateError.textContent = 'Appointment date cannot be in the past';
        } else {
          dateError.textContent = 'Appointment date must be within 2 weeks from today';
        }
        dateError.classList.remove('hidden');
        dateInput.classList.add('border-red-500');
        isValid = false;
      }

      // Validate Time
      const timeStr = timeInput.value;
      if (!timeStr) {
        timeError.textContent = 'Appointment time is required';
        timeError.classList.remove('hidden');
        timeInput.classList.add('border-red-500');
        isValid = false;
      } else if (!validateTime(timeStr)) {
        timeError.textContent = 'Appointment time must be between 8:00 AM and 6:00 PM';
        timeError.classList.remove('hidden');
        timeInput.classList.add('border-red-500');
        isValid = false;
      }

      // Validate Phone (optional)
      const phone = phoneNoInput.value.trim();
      if (phone !== '' && !validatePhone(phone)) {
        phoneNoError.textContent = 'Please enter a valid Sri Lankan phone number';
        phoneNoError.classList.remove('hidden');
        phoneNoInput.classList.add('border-red-500');
        isValid = false;
      }

      // Validate Fee (optional)
      const fee = feeInput.value;
      if (fee !== '' && (fee < 0 || isNaN(fee))) {
        feeError.textContent = 'Fee must be a positive number';
        feeError.classList.remove('hidden');
        feeInput.classList.add('border-red-500');
        isValid = false;
      }

      // Prevent form submission if validation fails
      if (!isValid) {
        e.preventDefault();
      }
    });
  });

  // Reveal on scroll
  const observer = new IntersectionObserver(entries => {
    entries.forEach(e => { if (e.isIntersecting) e.target.classList.add('visible'); });
  }, { threshold: 0.08 });
  document.querySelectorAll('.reveal').forEach(el => observer.observe(el));

  // Optional: keep header's dark toggle icon in sync if present
  (function syncThemeToggleIcon(){
    const icon = document.getElementById('themeIcon');
    const root = document.documentElement;
    if (!icon) return;
    const isDark = root.classList.contains('dark');
    icon.innerHTML = isDark
            ? '<path d="M12 3.1a1 1 0 0 1 1.1.3 9 9 0 1 0 7.5 7.5 1 1 0 0 1 1.3 1.2A11 11 0 1 1 12 2a1 1 0 0 1 0 1.1Z"/>'
            : '<path d="M21 12.79A9 9 0 1 1 11.21 3a7 7 0 1 0 9.79 9.79Z"/>';
  })();

  // Set minimum and maximum date for appointment date picker (2 weeks range)
  (function setDateRange(){
    const today = new Date();
    const yyyy = today.getFullYear();
    const mm = String(today.getMonth()+1).padStart(2,'0');
    const dd = String(today.getDate()).padStart(2,'0');
    document.getElementById('date').min = `${yyyy}-${mm}-${dd}`;
    
    // Set max date to 2 weeks from today
    const maxDate = new Date();
    maxDate.setDate(maxDate.getDate() + 14);
    const maxYyyy = maxDate.getFullYear();
    const maxMm = String(maxDate.getMonth()+1).padStart(2,'0');
    const maxDd = String(maxDate.getDate()).padStart(2,'0');
    document.getElementById('date').max = `${maxYyyy}-${maxMm}-${maxDd}`;
  })();
</script>

</body>
</html>

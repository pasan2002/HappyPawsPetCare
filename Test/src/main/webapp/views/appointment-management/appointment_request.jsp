<%@ page import="com.happypaws.petcare.model.Pet" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
  String cpath = request.getContextPath();
  Pet pet = (Pet) request.getAttribute("pet");
  String today = (String) request.getAttribute("today");
  String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Request Appointment — Happy Paws</title>

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
    <div class="flex items-center justify-between gap-4 reveal">
      <div>
        <h1 class="font-display text-3xl md:text-4xl font-extrabold tracking-tight">Request Appointment</h1>
        <p class="mt-2 text-sm text-slate-600 dark:text-slate-300">Fill in the details to request an appointment.</p>
      </div>
      <a href="<%= cpath %>/views/appointment-management/user_appointments.jsp"
         class="inline-flex items-center px-4 py-2 rounded-xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 hover:shadow-soft">
        ← Back to Appointments
      </a>
    </div>

    <% if (error != null) { %>
    <div class="reveal mt-6 rounded-xl p-4 text-sm bg-rose-50 text-rose-800 dark:bg-rose-900/30 dark:text-rose-200 border border-rose-200/50">
      <%= error %>
    </div>
    <% } %>
  </div>
</section>

<!-- STEP-BY-STEP FORM -->
<section class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 pb-16">
  <div class="reveal relative">
    <div class="absolute -inset-2 rounded-3xl bg-gradient-to-tr from-brand-600/20 via-brand-400/10 to-brand-600/20 blur-2xl"></div>

    <div class="relative rounded-3xl border border-slate-200 dark:border-slate-800 bg-white/80 dark:bg-slate-900/60 shadow-soft backdrop-blur overflow-hidden">
      
      <!-- Step Progress Indicator -->
      <div class="bg-gradient-to-r from-brand-50 to-brand-100 dark:from-slate-800 dark:to-slate-700 px-6 py-4 border-b border-slate-200 dark:border-slate-700">
        <div class="flex items-center justify-between">
          <div class="flex items-center space-x-8">
            <div class="flex items-center text-brand-600">
              <div class="flex items-center justify-center w-8 h-8 rounded-full bg-brand-600 text-white text-sm font-medium">
                1
              </div>
              <span class="ml-2 text-sm font-medium">Pet Details</span>
            </div>
            <div class="flex items-center text-slate-400" id="step2-indicator">
              <div class="flex items-center justify-center w-8 h-8 rounded-full bg-slate-200 dark:bg-slate-600 text-slate-500 text-sm font-medium">
                2
              </div>
              <span class="ml-2 text-sm">Service Type</span>
            </div>
            <div class="flex items-center text-slate-400" id="step3-indicator">
              <div class="flex items-center justify-center w-8 h-8 rounded-full bg-slate-200 dark:bg-slate-600 text-slate-500 text-sm font-medium">
                3
              </div>
              <span class="ml-2 text-sm">Schedule</span>
            </div>
            <div class="flex items-center text-slate-400" id="step4-indicator">
              <div class="flex items-center justify-center w-8 h-8 rounded-full bg-slate-200 dark:bg-slate-600 text-slate-500 text-sm font-medium">
                4
              </div>
              <span class="ml-2 text-sm">Contact & Staff</span>
            </div>
          </div>
        </div>
      </div>

      <form method="post" action="<%= cpath %>/appointments/pending" id="appointmentRequestForm">
        
        <!-- STEP 1: Pet Details -->
        <div class="step-content p-6 md:p-8" id="step1">
          <div class="flex items-start gap-4 mb-6">
            <div class="flex-shrink-0">
              <div class="w-12 h-12 rounded-xl bg-brand-100 dark:bg-brand-900/30 flex items-center justify-center">
                <svg class="w-6 h-6 text-brand-600 dark:text-brand-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.746 0 3.332.477 4.5 1.253v13C19.832 18.477 18.246 18 16.5 18c-1.746 0-3.332.477-4.5 1.253" />
                </svg>
              </div>
            </div>
            <div class="flex-1">
              <h3 class="text-lg font-semibold text-slate-900 dark:text-white mb-2">
                1. Pet Information
              </h3>
              <p class="text-sm text-slate-600 dark:text-slate-300">
                Confirm your pet's details for this appointment request.
              </p>
            </div>
          </div>

          <div class="grid md:grid-cols-2 gap-6">
            <div class="space-y-4">
              <div>
                <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2">Pet Name</label>
                <div class="px-4 py-3 rounded-lg border border-slate-200 dark:border-slate-600 bg-slate-50 dark:bg-slate-700">
                  <div class="font-medium text-slate-900 dark:text-white">
                    <%= pet.getName()!=null? pet.getName():"(Unnamed)" %>
                  </div>
                </div>
              </div>
              
              <div>
                <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2">Pet UID</label>
                <div class="px-4 py-3 rounded-lg border border-slate-200 dark:border-slate-600 bg-slate-50 dark:bg-slate-700">
                  <div class="font-mono text-sm text-slate-600 dark:text-slate-300">
                    <%= pet.getPetUid() %>
                  </div>
                </div>
                <input type="hidden" name="petUid" value="<%= pet.getPetUid() %>">
              </div>
            </div>

            <div class="space-y-4">
              <div>
                <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2">Species & Breed</label>
                <div class="px-4 py-3 rounded-lg border border-slate-200 dark:border-slate-600 bg-slate-50 dark:bg-slate-700">
                  <div class="text-slate-900 dark:text-white">
                    <%= pet.getSpecies()!=null? pet.getSpecies():"Pet" %>
                    <% if (pet.getBreed()!=null) { %>
                      <span class="text-slate-500 dark:text-slate-400"> — <%= pet.getBreed() %></span>
                    <% } %>
                  </div>
                </div>
              </div>

              <div class="p-4 rounded-lg bg-blue-50 dark:bg-blue-900/20 border border-blue-200 dark:border-blue-800">
                <div class="flex items-start gap-3">
                  <svg class="w-5 h-5 text-blue-600 dark:text-blue-400 mt-0.5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                  </svg>
                  <div class="text-sm text-blue-800 dark:text-blue-200">
                    <p class="font-medium mb-1">Pet details confirmed</p>
                    <p>These details will be used for your appointment booking.</p>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <div class="flex justify-end mt-6">
            <button type="button" onclick="nextStep(2)" 
                    class="inline-flex items-center px-6 py-2.5 rounded-lg bg-brand-600 hover:bg-brand-700 text-white font-medium transition-colors">
              Continue to Service Type
              <svg class="w-4 h-4 ml-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
              </svg>
            </button>
          </div>
        </div>

        <!-- STEP 2: Service Type -->
        <div class="step-content p-6 md:p-8 hidden" id="step2">
          <div class="flex items-start gap-4 mb-6">
            <div class="flex-shrink-0">
              <div class="w-12 h-12 rounded-xl bg-emerald-100 dark:bg-emerald-900/30 flex items-center justify-center">
                <svg class="w-6 h-6 text-emerald-600 dark:text-emerald-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2-2v2m8 0V6a2 2 0 012 2v6a2 2 0 01-2 2H8a2 2 0 01-2-2V8a2 2 0 012-2V6" />
                </svg>
              </div>
            </div>
            <div class="flex-1">
              <h3 class="text-lg font-semibold text-slate-900 dark:text-white mb-2">
                2. Service Type
              </h3>
              <p class="text-sm text-slate-600 dark:text-slate-300">
                Choose the type of service your pet needs.
              </p>
            </div>
          </div>

          <div class="space-y-4">
            <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-3">
              Appointment Type <span class="text-red-500">*</span>
            </label>
            
            <div class="grid sm:grid-cols-2 gap-4">
              <div class="service-option" data-value="Veterinary">
                <input type="radio" id="type-veterinary" name="type" value="Veterinary" class="sr-only service-radio" required>
                <label for="type-veterinary" class="service-label cursor-pointer block p-6 rounded-xl border-2 border-slate-200 dark:border-slate-600 hover:border-brand-300 dark:hover:border-brand-500 transition-colors">
                  <div class="flex items-start gap-4">
                    <div class="w-10 h-10 rounded-lg bg-red-100 dark:bg-red-900/30 flex items-center justify-center">
                      <svg class="w-5 h-5 text-red-600 dark:text-red-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.746 0 3.332.477 4.5 1.253v13C19.832 18.477 18.246 18 16.5 18c-1.746 0-3.332.477-4.5 1.253" />
                      </svg>
                    </div>
                    <div class="flex-1">
                      <h4 class="font-semibold text-slate-900 dark:text-white mb-1">Veterinary Care</h4>
                      <p class="text-sm text-slate-600 dark:text-slate-300 mb-2">Medical checkups, treatments, and health consultations</p>
                      <p class="text-lg font-bold text-brand-600 dark:text-brand-400">Rs 3,500</p>
                    </div>
                  </div>
                </label>
              </div>

              <div class="service-option" data-value="Grooming">
                <input type="radio" id="type-grooming" name="type" value="Grooming" class="sr-only service-radio" required>
                <label for="type-grooming" class="service-label cursor-pointer block p-6 rounded-xl border-2 border-slate-200 dark:border-slate-600 hover:border-brand-300 dark:hover:border-brand-500 transition-colors">
                  <div class="flex items-start gap-4">
                    <div class="w-10 h-10 rounded-lg bg-blue-100 dark:bg-blue-900/30 flex items-center justify-center">
                      <svg class="w-5 h-5 text-blue-600 dark:text-blue-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 21a4 4 0 01-4-4V5a2 2 0 012-2h4a2 2 0 012 2v1a2 2 0 002 2h4a2 2 0 012 2v9a4 4 0 01-4 4H7z" />
                      </svg>
                    </div>
                    <div class="flex-1">
                      <h4 class="font-semibold text-slate-900 dark:text-white mb-1">Pet Grooming</h4>
                      <p class="text-sm text-slate-600 dark:text-slate-300 mb-2">Bath, haircut, nail trimming, and styling services</p>
                      <p class="text-lg font-bold text-brand-600 dark:text-brand-400">Rs 3,000</p>
                    </div>
                  </div>
                </label>
              </div>
            </div>
            
            <div id="typeError" class="text-red-500 text-sm mt-2 hidden"></div>
          </div>

          <div class="flex justify-between mt-8">
            <button type="button" onclick="prevStep(1)" 
                    class="inline-flex items-center px-6 py-2.5 rounded-lg border border-slate-300 dark:border-slate-600 text-slate-700 dark:text-slate-300 hover:bg-slate-50 dark:hover:bg-slate-800 font-medium transition-colors">
              <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
              </svg>
              Back to Pet Details
            </button>
            <button type="button" onclick="nextStep(3)" id="step2-continue"
                    class="inline-flex items-center px-6 py-2.5 rounded-lg bg-brand-600 hover:bg-brand-700 text-white font-medium transition-colors opacity-50 cursor-not-allowed" disabled>
              Continue to Schedule
              <svg class="w-4 h-4 ml-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
              </svg>
            </button>
          </div>
        </div>

        <!-- STEP 3: Schedule -->
        <div class="step-content p-6 md:p-8 hidden" id="step3">
          <div class="flex items-start gap-4 mb-6">
            <div class="flex-shrink-0">
              <div class="w-12 h-12 rounded-xl bg-purple-100 dark:bg-purple-900/30 flex items-center justify-center">
                <svg class="w-6 h-6 text-purple-600 dark:text-purple-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                </svg>
              </div>
            </div>
            <div class="flex-1">
              <h3 class="text-lg font-semibold text-slate-900 dark:text-white mb-2">
                3. Preferred Schedule
              </h3>
              <p class="text-sm text-slate-600 dark:text-slate-300">
                Choose your preferred date and time for the appointment.
              </p>
            </div>
          </div>

          <div class="grid md:grid-cols-2 gap-6">
            <div>
              <label for="date" class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2">
                Preferred Date <span class="text-red-500">*</span>
              </label>
              <input id="date" name="date" type="date" min="<%= today %>" required
                     class="w-full px-4 py-3 rounded-lg border border-slate-300 dark:border-slate-600 focus:ring-2 focus:ring-brand-500 focus:border-brand-500 dark:bg-slate-800 dark:text-white">
              <div id="dateError" class="text-red-500 text-sm mt-1 hidden"></div>
            </div>
            
            <div>
              <label for="time" class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2">
                Preferred Time <span class="text-red-500">*</span>
              </label>
              <input id="time" name="time" type="time" required min="08:00" max="18:00"
                     class="w-full px-4 py-3 rounded-lg border border-slate-300 dark:border-slate-600 focus:ring-2 focus:ring-brand-500 focus:border-brand-500 dark:bg-slate-800 dark:text-white">
              <div id="timeError" class="text-red-500 text-sm mt-1 hidden"></div>
              <p class="mt-1 text-xs text-slate-500">Business hours: 8:00 AM to 6:00 PM</p>
            </div>
          </div>

          <div class="mt-6 p-4 rounded-lg bg-amber-50 dark:bg-amber-900/20 border border-amber-200 dark:border-amber-800">
            <div class="flex items-start gap-3">
              <svg class="w-5 h-5 text-amber-600 dark:text-amber-400 mt-0.5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-2.5L13.732 4c-.77-.833-1.964-.833-2.732 0L4.732 15.5c-.77.833.192 2.5 1.732 2.5z" />
              </svg>
              <div class="text-sm text-amber-800 dark:text-amber-200">
                <p class="font-medium mb-1">Please Note</p>
                <p>This is a preferred time request. Our staff will confirm availability and may suggest alternative times if needed.</p>
              </div>
            </div>
          </div>

          <div class="flex justify-between mt-8">
            <button type="button" onclick="prevStep(2)" 
                    class="inline-flex items-center px-6 py-2.5 rounded-lg border border-slate-300 dark:border-slate-600 text-slate-700 dark:text-slate-300 hover:bg-slate-50 dark:hover:bg-slate-800 font-medium transition-colors">
              <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
              </svg>
              Back to Service Type
            </button>
            <button type="button" onclick="nextStep(4)" id="step3-continue"
                    class="inline-flex items-center px-6 py-2.5 rounded-lg bg-brand-600 hover:bg-brand-700 text-white font-medium transition-colors opacity-50 cursor-not-allowed" disabled>
              Continue to Contact
              <svg class="w-4 h-4 ml-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
              </svg>
            </button>
          </div>
        </div>

        <!-- STEP 4: Contact & Staff -->
        <div class="step-content p-6 md:p-8 hidden" id="step4">
          <div class="flex items-start gap-4 mb-6">
            <div class="flex-shrink-0">
              <div class="w-12 h-12 rounded-xl bg-orange-100 dark:bg-orange-900/30 flex items-center justify-center">
                <svg class="w-6 h-6 text-orange-600 dark:text-orange-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                </svg>
              </div>
            </div>
            <div class="flex-1">
              <h3 class="text-lg font-semibold text-slate-900 dark:text-white mb-2">
                4. Contact Information & Staff Preference
              </h3>
              <p class="text-sm text-slate-600 dark:text-slate-300">
                Provide your contact details and optionally choose a preferred staff member.
              </p>
            </div>
          </div>

          <div class="space-y-6">
            <!-- Contact Information -->
            <div>
              <label for="phoneNo" class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2">
                Phone Number <span class="text-red-500">*</span>
              </label>
              <input id="phoneNo" name="phoneNo" type="tel" required
                     placeholder="e.g., 0712345678"
                     value="<%= request.getParameter("phoneNo") != null ? request.getParameter("phoneNo") : "" %>"
                     pattern="^(\+94|0)[0-9]{9}$"
                     class="w-full px-4 py-3 rounded-lg border border-slate-300 dark:border-slate-600 focus:ring-2 focus:ring-brand-500 focus:border-brand-500 dark:bg-slate-800 dark:text-white">
              <div id="phoneNoError" class="text-red-500 text-sm mt-1 hidden"></div>
            </div>

            <!-- Staff Preference -->
            <div>
              <label for="staffSearch" class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2">
                Preferred Staff Member (Optional)
              </label>
              <div class="relative">
                <input type="text" id="staffSearch" name="staffSearch" 
                       placeholder="Search for preferred staff by name or role..." 
                       class="w-full px-4 py-3 rounded-lg border border-slate-300 dark:border-slate-600 focus:ring-2 focus:ring-brand-500 focus:border-brand-500 dark:bg-slate-800 dark:text-white" 
                       autocomplete="off" />
                <div id="staffSearchResults" class="absolute z-40 w-full max-h-48 overflow-y-auto bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-lg shadow-lg mt-1 hidden">
                  <!-- Staff search results will be populated here -->
                </div>
              </div>
              <div id="staffSearchError" class="hidden mt-1 text-sm text-red-500"></div>
              
              <!-- Hidden field for selected staff ID -->
              <input type="hidden" id="staffId" name="staffId" />
              
              <!-- Display selected staff info -->
              <div id="selectedStaffInfo" class="hidden mt-3 p-4 bg-blue-50 dark:bg-blue-900/30 border border-blue-200 dark:border-blue-800 rounded-lg">
                <div class="text-sm text-blue-800 dark:text-blue-200">
                  <div class="font-medium" id="selectedStaffDisplay"></div>
                  <div class="text-xs mt-1" id="selectedStaffRole"></div>
                </div>
                <button type="button" id="clearSelectedStaff" class="mt-2 text-xs text-blue-600 hover:text-blue-800 dark:text-blue-400 dark:hover:text-blue-200">
                  Clear selection
                </button>
              </div>
              
              <!-- Quick filter buttons based on appointment type -->
              <div id="staffRoleFilters" class="mt-3 flex gap-2 hidden">
                <button type="button" class="staff-filter-btn px-3 py-1.5 text-xs rounded-lg bg-slate-100 dark:bg-slate-700 text-slate-600 dark:text-slate-300 hover:bg-slate-200 dark:hover:bg-slate-600" data-role="veterinarian">
                  Veterinarians
                </button>
                <button type="button" class="staff-filter-btn px-3 py-1.5 text-xs rounded-lg bg-slate-100 dark:bg-slate-700 text-slate-600 dark:text-slate-300 hover:bg-slate-200 dark:hover:bg-slate-600" data-role="groomer">
                  Groomers
                </button>
                <button type="button" class="staff-filter-btn px-3 py-1.5 text-xs rounded-lg bg-slate-100 dark:bg-slate-700 text-slate-600 dark:text-slate-300 hover:bg-slate-200 dark:hover:bg-slate-600" data-role="">
                  All Staff
                </button>
              </div>
            </div>
          </div>

          <div class="flex justify-between mt-8">
            <button type="button" onclick="prevStep(3)" 
                    class="inline-flex items-center px-6 py-2.5 rounded-lg border border-slate-300 dark:border-slate-600 text-slate-700 dark:text-slate-300 hover:bg-slate-50 dark:hover:bg-slate-800 font-medium transition-colors">
              <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
              </svg>
              Back to Schedule
            </button>
            <button type="submit" id="step4-submit"
                    class="inline-flex items-center px-8 py-2.5 rounded-lg bg-brand-600 hover:bg-brand-700 text-white font-medium transition-colors opacity-50 cursor-not-allowed" disabled>
              <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
              </svg>
              Submit Appointment Request
            </button>
          </div>
        </div>

      </form>
    </div>
  </div>
</section>

<%@ include file="../common/footer.jsp" %>

<script>
  // STEP-BY-STEP APPOINTMENT REQUEST FORM
  document.addEventListener('DOMContentLoaded', function() {
    let currentStep = 1;
    const appointmentRequestForm = document.getElementById('appointmentRequestForm');

    // Form elements
    const typeInputs = document.querySelectorAll('input[name="type"]');
    const dateInput = document.getElementById('date');
    const timeInput = document.getElementById('time');
    const phoneNoInput = document.getElementById('phoneNo');
    const staffIdInput = document.getElementById('staffId');

    // Set date input max to 2 weeks from today
    const today = new Date();
    const maxDate = new Date();
    maxDate.setDate(maxDate.getDate() + 14);
    const maxDateStr = maxDate.toISOString().split('T')[0];
    dateInput.max = maxDateStr;

    // Error elements
    const typeError = document.getElementById('typeError');
    const dateError = document.getElementById('dateError');
    const timeError = document.getElementById('timeError');
    const phoneNoError = document.getElementById('phoneNoError');

    // Step navigation functions
    window.nextStep = function(step) {
      if (validateCurrentStep()) {
        showStep(step);
      }
    };

    window.prevStep = function(step) {
      showStep(step);
    };

    function showStep(step) {
      // Hide all steps
      document.querySelectorAll('.step-content').forEach(content => {
        content.classList.add('hidden');
      });

      // Show target step
      document.getElementById(`step${step}`).classList.remove('hidden');
      currentStep = step;

      // Update step indicators
      updateStepIndicators(step);

      // Update continue button states
      updateContinueButtons();
    }

    function updateStepIndicators(activeStep) {
      for (let i = 1; i <= 4; i++) {
        const indicator = document.getElementById(`step${i}-indicator`);
        if (!indicator) continue;

        const circle = indicator.querySelector('.w-8.h-8');
        const text = indicator.querySelector('span');

        if (i <= activeStep) {
          // Active or completed
          circle.className = 'flex items-center justify-center w-8 h-8 rounded-full bg-brand-600 text-white text-sm font-medium';
          text.className = 'ml-2 text-sm font-medium text-brand-600';
        } else {
          // Inactive
          circle.className = 'flex items-center justify-center w-8 h-8 rounded-full bg-slate-200 dark:bg-slate-600 text-slate-500 text-sm font-medium';
          text.className = 'ml-2 text-sm text-slate-400';
        }
      }
    }

    function validateCurrentStep() {
      switch (currentStep) {
        case 1:
          return true; // Pet details are read-only, always valid
        case 2:
          return validateServiceType();
        case 3:
          return validateSchedule();
        case 4:
          return validateContact();
        default:
          return true;
      }
    }

    function validateServiceType() {
      const selectedType = document.querySelector('input[name="type"]:checked');
      if (!selectedType) {
        typeError.textContent = 'Please select an appointment type';
        typeError.classList.remove('hidden');
        return false;
      }
      typeError.classList.add('hidden');
      return true;
    }

    function validateSchedule() {
      let isValid = true;

      // Validate date
      const dateStr = dateInput.value;
      if (!dateStr) {
        dateError.textContent = 'Preferred date is required';
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
      } else {
        dateError.classList.add('hidden');
        dateInput.classList.remove('border-red-500');
      }

      // Validate time
      const timeStr = timeInput.value;
      if (!timeStr) {
        timeError.textContent = 'Preferred time is required';
        timeError.classList.remove('hidden');
        timeInput.classList.add('border-red-500');
        isValid = false;
      } else if (!validateTime(timeStr)) {
        timeError.textContent = 'Appointment time must be between 8:00 AM and 6:00 PM';
        timeError.classList.remove('hidden');
        timeInput.classList.add('border-red-500');
        isValid = false;
      } else {
        timeError.classList.add('hidden');
        timeInput.classList.remove('border-red-500');
      }

      return isValid;
    }

    function validateContact() {
      const phone = phoneNoInput.value.trim();
      if (!phone) {
        phoneNoError.textContent = 'Phone number is required';
        phoneNoError.classList.remove('hidden');
        phoneNoInput.classList.add('border-red-500');
        return false;
      } else if (!validatePhone(phone)) {
        phoneNoError.textContent = 'Please enter a valid Sri Lankan phone number';
        phoneNoError.classList.remove('hidden');
        phoneNoInput.classList.add('border-red-500');
        return false;
      } else {
        phoneNoError.classList.add('hidden');
        phoneNoInput.classList.remove('border-red-500');
        return true;
      }
    }

    function updateContinueButtons() {
      // Step 2 continue button
      const step2Continue = document.getElementById('step2-continue');
      if (step2Continue) {
        const hasSelectedType = document.querySelector('input[name="type"]:checked');
        if (hasSelectedType) {
          step2Continue.disabled = false;
          step2Continue.classList.remove('opacity-50', 'cursor-not-allowed');
        } else {
          step2Continue.disabled = true;
          step2Continue.classList.add('opacity-50', 'cursor-not-allowed');
        }
      }

      // Step 3 continue button
      const step3Continue = document.getElementById('step3-continue');
      if (step3Continue) {
        const hasDate = dateInput.value;
        const hasTime = timeInput.value;
        if (hasDate && hasTime) {
          step3Continue.disabled = false;
          step3Continue.classList.remove('opacity-50', 'cursor-not-allowed');
        } else {
          step3Continue.disabled = true;
          step3Continue.classList.add('opacity-50', 'cursor-not-allowed');
        }
      }

      // Step 4 submit button
      const step4Submit = document.getElementById('step4-submit');
      if (step4Submit) {
        const hasPhone = phoneNoInput.value.trim();
        if (hasPhone && validatePhone(hasPhone)) {
          step4Submit.disabled = false;
          step4Submit.classList.remove('opacity-50', 'cursor-not-allowed');
        } else {
          step4Submit.disabled = true;
          step4Submit.classList.add('opacity-50', 'cursor-not-allowed');
        }
      }
    }

    // Service type selection handling
    typeInputs.forEach(input => {
      input.addEventListener('change', function() {
        // Update service selection visual state
        document.querySelectorAll('.service-option').forEach(option => {
          const label = option.querySelector('.service-label');
          if (option.dataset.value === this.value) {
            label.classList.add('border-brand-500', 'bg-brand-50', 'dark:bg-brand-900/20');
            label.classList.remove('border-slate-200', 'dark:border-slate-600');
          } else {
            label.classList.remove('border-brand-500', 'bg-brand-50', 'dark:bg-brand-900/20');
            label.classList.add('border-slate-200', 'dark:border-slate-600');
          }
        });

        // Show/hide role filters based on appointment type
        if (this.value && this.value !== '') {
          staffRoleFilters.classList.remove('hidden');
          // Auto-filter staff based on appointment type
          const selectedType = this.value.toLowerCase();
          if (selectedType === 'veterinary') {
            searchStaffByRole('veterinarian');
            // Highlight the veterinarian filter button
            document.querySelectorAll('.staff-filter-btn').forEach(b => {
              b.classList.remove('bg-blue-100', 'dark:bg-blue-900', 'text-blue-800', 'dark:text-blue-200');
              b.classList.add('bg-slate-100', 'dark:bg-slate-700', 'text-slate-600', 'dark:text-slate-300');
            });
            const vetBtn = document.querySelector('[data-role="veterinarian"]');
            if (vetBtn) {
              vetBtn.classList.remove('bg-slate-100', 'dark:bg-slate-700', 'text-slate-600', 'dark:text-slate-300');
              vetBtn.classList.add('bg-blue-100', 'dark:bg-blue-900', 'text-blue-800', 'dark:text-blue-200');
            }
          } else if (selectedType === 'grooming') {
            searchStaffByRole('groomer');
            // Highlight the groomer filter button
            document.querySelectorAll('.staff-filter-btn').forEach(b => {
              b.classList.remove('bg-blue-100', 'dark:bg-blue-900', 'text-blue-800', 'dark:text-blue-200');
              b.classList.add('bg-slate-100', 'dark:bg-slate-700', 'text-slate-600', 'dark:text-slate-300');
            });
            const groomerBtn = document.querySelector('[data-role="groomer"]');
            if (groomerBtn) {
              groomerBtn.classList.remove('bg-slate-100', 'dark:bg-slate-700', 'text-slate-600', 'dark:text-slate-300');
              groomerBtn.classList.add('bg-blue-100', 'dark:bg-blue-900', 'text-blue-800', 'dark:text-blue-200');
            }
          }
        } else {
          staffRoleFilters.classList.add('hidden');
          staffSearchResults.classList.add('hidden');
        }

        updateContinueButtons();
      });
    });

    // Date and time input listeners
    dateInput.addEventListener('input', updateContinueButtons);
    timeInput.addEventListener('input', updateContinueButtons);
    phoneNoInput.addEventListener('input', updateContinueButtons);

    // STAFF SEARCH FUNCTIONALITY
    const staffSearchInput = document.getElementById('staffSearch');
    const staffSearchResults = document.getElementById('staffSearchResults');
    const staffSearchError = document.getElementById('staffSearchError');
    const selectedStaffInfo = document.getElementById('selectedStaffInfo');
    const selectedStaffDisplay = document.getElementById('selectedStaffDisplay');
    const selectedStaffRole = document.getElementById('selectedStaffRole');
    const clearSelectedStaff = document.getElementById('clearSelectedStaff');
    const staffRoleFilters = document.getElementById('staffRoleFilters');

    let staffSearchTimeout;

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
        // Update button states - remove active styles and restore default styles
        document.querySelectorAll('.staff-filter-btn').forEach(b => {
          b.classList.remove('bg-blue-100', 'dark:bg-blue-900', 'text-blue-800', 'dark:text-blue-200');
          b.classList.add('bg-slate-100', 'dark:bg-slate-700', 'text-slate-600', 'dark:text-slate-300');
        });
        // Add active styles to clicked button and remove default styles
        this.classList.remove('bg-slate-100', 'dark:bg-slate-700', 'text-slate-600', 'dark:text-slate-300');
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
        `<%= cpath %>/api/staff/search?q=${encodeURIComponent(searchTerm)}` :
        `<%= cpath %>/api/staff/search`;
        
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
      fetch(`<%= cpath %>/api/staff/search?role=${encodeURIComponent(role)}`)
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
             data-staff-email="${member.email || ''}">
          <div class="font-medium text-sm">${member.fullName}</div>
          <div class="text-xs text-slate-500 mt-1">
            ${member.role ? member.role.charAt(0).toUpperCase() + member.role.slice(1) : 'Staff'} 
            ${member.email ? '• ' + member.email : ''}
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

    // Validation functions
    function validatePhone(phone) {
      const phoneRegex = /^(\+94|0)[0-9]{9}$/;
      return phoneRegex.test(phone);
    }

    function validateTime(timeStr) {
      const time = timeStr.split(':');
      const hours = parseInt(time[0], 10);
      return hours >= 8 && hours <= 18;
    }

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

    // Real-time validation
    dateInput.addEventListener('blur', function() {
      const dateStr = this.value;
      if (dateStr && !validateDate(dateStr)) {
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

    timeInput.addEventListener('blur', function() {
      const timeStr = this.value;
      if (timeStr && !validateTime(timeStr)) {
        timeError.textContent = 'Appointment time must be between 8:00 AM and 6:00 PM';
        timeError.classList.remove('hidden');
        this.classList.add('border-red-500');
      } else {
        timeError.classList.add('hidden');
        this.classList.remove('border-red-500');
      }
    });

    phoneNoInput.addEventListener('blur', function() {
      const phone = this.value.trim();
      if (phone && !validatePhone(phone)) {
        phoneNoError.textContent = 'Please enter a valid Sri Lankan phone number';
        phoneNoError.classList.remove('hidden');
        this.classList.add('border-red-500');
      } else {
        phoneNoError.classList.add('hidden');
        this.classList.remove('border-red-500');
      }
    });

    // Form submission validation
    appointmentRequestForm.addEventListener('submit', function(e) {
      let isValid = true;

      // Validate all steps
      if (!validateServiceType()) isValid = false;
      if (!validateSchedule()) isValid = false;
      if (!validateContact()) isValid = false;

      // Prevent form submission if validation fails
      if (!isValid) {
        e.preventDefault();
        // Show first step with errors
        showStep(2);
      }
    });

    // Initialize
    updateContinueButtons();
  });

  // Reveal on scroll
  const observer = new IntersectionObserver(entries => {
    entries.forEach(e => { if (e.isIntersecting) e.target.classList.add('visible'); });
  }, { threshold: 0.08 });
  document.querySelectorAll('.reveal').forEach(el => observer.observe(el));
</script>
</body>
</html>

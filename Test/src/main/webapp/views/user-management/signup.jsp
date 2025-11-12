<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Create account — Happy Paws PetCare</title>
    <meta name="description" content="Create your Happy Paws account." />

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
    </style>
</head>
<body class="antialiased text-slate-800 dark:text-slate-100 bg-gray-50 dark:bg-slate-900 min-h-screen">

<%@ include file="../common/header.jsp" %>

<%
    // Read query params from servlet redirects
    String err = request.getParameter("e");
%>

<!-- PAGE CONTENT -->
<section class="relative min-h-screen flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
  <div class="absolute inset-0 bg-gradient-to-b from-blue-50/30 via-white/70 to-white dark:from-slate-900/30 dark:via-slate-950/70 dark:to-slate-950"></div>
  
  <div class="relative max-w-md w-full space-y-8">
    <!-- Header with icon and title -->
    <div class="text-center">
      <div class="mx-auto h-12 w-12 flex items-center justify-center rounded-full bg-brand-100 dark:bg-brand-900/30">
        <svg class="h-6 w-6 text-brand-600 dark:text-brand-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18 9v3m0 0v3m0-3h3m-3 0h-3m-2-5a4 4 0 11-8 0 4 4 0 018 0zM3 20a6 6 0 0112 0v1H3v-1z"></path>
        </svg>
      </div>
      <h2 class="mt-6 text-center text-3xl font-extrabold text-slate-900 dark:text-white">
        Create your account
      </h2>
      <p class="mt-2 text-center text-sm text-slate-600 dark:text-slate-400">
        Join Happy Paws PetCare today
      </p>
    </div>

    <!-- Server messages -->
    <div aria-live="polite">
      <% if (err != null) { %>
      <div class="rounded-md bg-red-50 dark:bg-red-900/20 p-4 border border-red-200 dark:border-red-800">
        <div class="flex">
          <div class="flex-shrink-0">
            <svg class="h-5 w-5 text-red-400" viewBox="0 0 20 20" fill="currentColor">
              <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd"/>
            </svg>
          </div>
          <div class="ml-3">
            <p class="text-sm font-medium text-red-800 dark:text-red-200">
              <%= err %>
            </p>
          </div>
        </div>
      </div>
      <% } %>
    </div>

    <!-- Signup Form -->
    <div class="bg-white dark:bg-slate-800 py-8 px-6 shadow-lg rounded-xl border border-slate-200 dark:border-slate-700">
      <form method="post" action="<%= request.getContextPath() %>/owner-signup" id="signupForm" novalidate class="space-y-6">
        <div>
          <label for="fullName" class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2">Full name</label>
          <input name="fullName" required 
                 minlength="2"
                 maxlength="50"
                 pattern="^[a-zA-Z\s]+$"
                 title="Full name should only contain letters and spaces"
                 class="appearance-none relative block w-full px-3 py-3 border border-slate-300 dark:border-slate-600 placeholder-slate-500 dark:placeholder-slate-400 text-slate-900 dark:text-white rounded-lg focus:outline-none focus:ring-2 focus:ring-brand-500 focus:border-brand-500 dark:bg-slate-700 sm:text-sm"
                 id="fullName" placeholder="Enter your full name"/>
          <div id="fullNameError" class="text-red-500 text-sm mt-1 hidden"></div>
        </div>

        <div>
          <label for="email" class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2">Email address</label>
          <input name="email" type="email" required 
                 pattern="[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$"
                 title="Please enter a valid email address"
                 class="appearance-none relative block w-full px-3 py-3 border border-slate-300 dark:border-slate-600 placeholder-slate-500 dark:placeholder-slate-400 text-slate-900 dark:text-white rounded-lg focus:outline-none focus:ring-2 focus:ring-brand-500 focus:border-brand-500 dark:bg-slate-700 sm:text-sm"
                 id="email" placeholder="Enter your email"/>
          <div id="emailError" class="text-red-500 text-sm mt-1 hidden"></div>
        </div>

        <div>
          <label for="phone" class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2">Phone number</label>
          <input name="phone" required 
                 type="tel"
                 pattern="^(\+94|0)[0-9]{9}$"
                 title="Please enter a valid Sri Lankan phone number (e.g., 0712345678 or +94712345678)"
                 placeholder="0712345678"
                 class="appearance-none relative block w-full px-3 py-3 border border-slate-300 dark:border-slate-600 placeholder-slate-500 dark:placeholder-slate-400 text-slate-900 dark:text-white rounded-lg focus:outline-none focus:ring-2 focus:ring-brand-500 focus:border-brand-500 dark:bg-slate-700 sm:text-sm"
                 id="phone"/>
          <div id="phoneError" class="text-red-500 text-sm mt-1 hidden"></div>
        </div>

        <div>
          <label for="password" class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2">Password</label>
          <input name="password" type="password" minlength="8" required 
                 pattern="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$"
                 title="Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, one number, and one special character"
                 class="appearance-none relative block w-full px-3 py-3 border border-slate-300 dark:border-slate-600 placeholder-slate-500 dark:placeholder-slate-400 text-slate-900 dark:text-white rounded-lg focus:outline-none focus:ring-2 focus:ring-brand-500 focus:border-brand-500 dark:bg-slate-700 sm:text-sm"
                 id="password" placeholder="Enter your password"/>
          <div id="passwordError" class="text-red-500 text-sm mt-1 hidden"></div>
        </div>

        <div>
          <label for="confirm" class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2">Confirm password</label>
          <input name="confirm" type="password" minlength="8" required 
                 title="Please confirm your password"
                 class="appearance-none relative block w-full px-3 py-3 border border-slate-300 dark:border-slate-600 placeholder-slate-500 dark:placeholder-slate-400 text-slate-900 dark:text-white rounded-lg focus:outline-none focus:ring-2 focus:ring-brand-500 focus:border-brand-500 dark:bg-slate-700 sm:text-sm"
                 id="confirm" placeholder="Confirm your password"/>
          <div id="confirmError" class="text-red-500 text-sm mt-1 hidden"></div>
        </div>

        <div>
          <button type="submit"
                  class="group relative w-full flex justify-center py-3 px-4 border border-transparent text-sm font-medium rounded-lg text-white bg-brand-600 hover:bg-brand-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-brand-500 transition-colors duration-200">
            <span class="absolute left-0 inset-y-0 flex items-center pl-3">
              <svg class="h-5 w-5 text-brand-500 group-hover:text-brand-400" fill="currentColor" viewBox="0 0 20 20">
                <path fill-rule="evenodd" d="M10 1a4.5 4.5 0 00-4.5 4.5V9H5a2 2 0 00-2 2v6a2 2 0 002 2h10a2 2 0 002-2v-6a2 2 0 00-2-2h-.5V5.5A4.5 4.5 0 0010 1zm3 8V5.5a3 3 0 10-6 0V9h6z" clip-rule="evenodd"/>
              </svg>
            </span>
            Create your account
          </button>
        </div>
      </form>
    </div>

    <!-- Login link -->
    <div class="text-center">
      <p class="text-sm text-slate-600 dark:text-slate-400">
        Already have an account?
        <a href="<%= request.getContextPath() %>/login"
           class="font-medium text-brand-600 hover:text-brand-500 dark:text-brand-400 dark:hover:text-brand-300 transition-colors duration-200">
          Sign in to your account
        </a>
      </p>
    </div>

  </div>
</section>

    <script>
        // SIGNUP FORM VALIDATION SCRIPT
        document.addEventListener('DOMContentLoaded', function() {
            const signupForm = document.getElementById('signupForm');
            const fullNameInput = document.getElementById('fullName');
            const emailInput = document.getElementById('email');
            const phoneInput = document.getElementById('phone');
            const passwordInput = document.getElementById('password');
            const confirmInput = document.getElementById('confirm');
            
            const fullNameError = document.getElementById('fullNameError');
            const emailError = document.getElementById('emailError');
            const phoneError = document.getElementById('phoneError');
            const passwordError = document.getElementById('passwordError');
            const confirmError = document.getElementById('confirmError');

            // Full name validation function
            function validateFullName(name) {
                const nameRegex = /^[a-zA-Z\s]+$/;
                return name.length >= 2 && name.length <= 50 && nameRegex.test(name);
            }

            // Email validation function
            function validateEmail(email) {
                const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
                return emailRegex.test(email);
            }

            // Phone validation function (Sri Lankan numbers)
            function validatePhone(phone) {
                const phoneRegex = /^(\+94|0)[0-9]{9}$/;
                return phoneRegex.test(phone);
            }

            // Password strength validation function
            function validatePassword(password) {
                // At least 8 characters, 1 uppercase, 1 lowercase, 1 digit, 1 special character
                const passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;
                return passwordRegex.test(password);
            }

            // Real-time validation for full name
            fullNameInput.addEventListener('blur', function() {
                const name = this.value.trim();
                if (name === '') {
                    fullNameError.textContent = 'Full name is required';
                    fullNameError.classList.remove('hidden');
                    this.classList.add('border-red-500');
                } else if (!validateFullName(name)) {
                    fullNameError.textContent = 'Full name should be 2-50 characters and contain only letters and spaces';
                    fullNameError.classList.remove('hidden');
                    this.classList.add('border-red-500');
                } else {
                    fullNameError.classList.add('hidden');
                    this.classList.remove('border-red-500');
                }
            });

            // Real-time validation for email
            emailInput.addEventListener('blur', function() {
                const email = this.value.trim();
                if (email === '') {
                    emailError.textContent = 'Email is required';
                    emailError.classList.remove('hidden');
                    this.classList.add('border-red-500');
                } else if (!validateEmail(email)) {
                    emailError.textContent = 'Please enter a valid email address';
                    emailError.classList.remove('hidden');
                    this.classList.add('border-red-500');
                } else {
                    emailError.classList.add('hidden');
                    this.classList.remove('border-red-500');
                }
            });

            // Real-time validation for phone
            phoneInput.addEventListener('blur', function() {
                const phone = this.value.trim();
                if (phone === '') {
                    phoneError.textContent = 'Phone number is required';
                    phoneError.classList.remove('hidden');
                    this.classList.add('border-red-500');
                } else if (!validatePhone(phone)) {
                    phoneError.textContent = 'Please enter a valid Sri Lankan phone number (e.g., 0712345678)';
                    phoneError.classList.remove('hidden');
                    this.classList.add('border-red-500');
                } else {
                    phoneError.classList.add('hidden');
                    this.classList.remove('border-red-500');
                }
            });

            // Real-time validation for password
            passwordInput.addEventListener('blur', function() {
                const password = this.value;
                if (password === '') {
                    passwordError.textContent = 'Password is required';
                    passwordError.classList.remove('hidden');
                    this.classList.add('border-red-500');
                } else if (!validatePassword(password)) {
                    passwordError.textContent = 'Password must be at least 8 characters with uppercase, lowercase, number, and special character';
                    passwordError.classList.remove('hidden');
                    this.classList.add('border-red-500');
                } else {
                    passwordError.classList.add('hidden');
                    this.classList.remove('border-red-500');
                }
            });

            // Real-time validation for confirm password
            confirmInput.addEventListener('blur', function() {
                const confirm = this.value;
                const password = passwordInput.value;
                if (confirm === '') {
                    confirmError.textContent = 'Please confirm your password';
                    confirmError.classList.remove('hidden');
                    this.classList.add('border-red-500');
                } else if (confirm !== password) {
                    confirmError.textContent = 'Passwords do not match';
                    confirmError.classList.remove('hidden');
                    this.classList.add('border-red-500');
                } else {
                    confirmError.classList.add('hidden');
                    this.classList.remove('border-red-500');
                }
            });

            // Form submission validation
            signupForm.addEventListener('submit', function(e) {
                let isValid = true;

                // Validate full name
                const name = fullNameInput.value.trim();
                if (!name) {
                    fullNameError.textContent = 'Full name is required';
                    fullNameError.classList.remove('hidden');
                    fullNameInput.classList.add('border-red-500');
                    isValid = false;
                } else if (!validateFullName(name)) {
                    fullNameError.textContent = 'Full name should be 2-50 characters and contain only letters and spaces';
                    fullNameError.classList.remove('hidden');
                    fullNameInput.classList.add('border-red-500');
                    isValid = false;
                }

                // Validate email
                const email = emailInput.value.trim();
                if (!email) {
                    emailError.textContent = 'Email is required';
                    emailError.classList.remove('hidden');
                    emailInput.classList.add('border-red-500');
                    isValid = false;
                } else if (!validateEmail(email)) {
                    emailError.textContent = 'Please enter a valid email address';
                    emailError.classList.remove('hidden');
                    emailInput.classList.add('border-red-500');
                    isValid = false;
                }

                // Validate phone
                const phone = phoneInput.value.trim();
                if (!phone) {
                    phoneError.textContent = 'Phone number is required';
                    phoneError.classList.remove('hidden');
                    phoneInput.classList.add('border-red-500');
                    isValid = false;
                } else if (!validatePhone(phone)) {
                    phoneError.textContent = 'Please enter a valid Sri Lankan phone number';
                    phoneError.classList.remove('hidden');
                    phoneInput.classList.add('border-red-500');
                    isValid = false;
                }

                // Validate password
                const password = passwordInput.value;
                if (!password) {
                    passwordError.textContent = 'Password is required';
                    passwordError.classList.remove('hidden');
                    passwordInput.classList.add('border-red-500');
                    isValid = false;
                } else if (!validatePassword(password)) {
                    passwordError.textContent = 'Password must meet security requirements';
                    passwordError.classList.remove('hidden');
                    passwordInput.classList.add('border-red-500');
                    isValid = false;
                }

                // Validate confirm password
                const confirm = confirmInput.value;
                if (!confirm) {
                    confirmError.textContent = 'Please confirm your password';
                    confirmError.classList.remove('hidden');
                    confirmInput.classList.add('border-red-500');
                    isValid = false;
                } else if (confirm !== password) {
                    confirmError.textContent = 'Passwords do not match';
                    confirmError.classList.remove('hidden');
                    confirmInput.classList.add('border-red-500');
                    isValid = false;
                }

                // Prevent form submission if validation fails
                if (!isValid) {
                    e.preventDefault();
                }
            });
        });
    </script>

<%@ include file="../common/footer.jsp" %>

<script>
    // Initialize reveal animations - simplified for modern layout
    document.addEventListener('DOMContentLoaded', function() {
        // Simple fade-in effect for better performance
        const elements = document.querySelectorAll('.reveal');
        elements.forEach(el => {
            el.style.opacity = '1';
            el.style.transform = 'translateY(0)';
        });
    });
</script>

</body>
</html>

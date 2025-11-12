<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Sign in — Happy Paws PetCare</title>
  <meta name="description" content="Sign in to your Happy Paws account." />

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
  String ok  = request.getParameter("ok");
  String nextParam = request.getParameter("next");
  // Preserve typed email on error so user doesn't retype
  String emailPrefill = request.getParameter("email") != null ? request.getParameter("email") : "";
%>

<!-- MAIN CONTENT -->
<section class="min-h-screen flex items-center justify-center px-4 sm:px-6 lg:px-8 py-12">
  <div class="max-w-md w-full space-y-8">
    
    <!-- Header Content -->
    <div class="text-center">
      <div class="mx-auto h-16 w-16 rounded-full bg-brand-100 dark:bg-brand-900/30 flex items-center justify-center mb-6">
        <svg class="h-8 w-8 text-brand-600 dark:text-brand-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
        </svg>
      </div>
      <h1 class="text-3xl font-bold text-slate-900 dark:text-white">Welcome back</h1>
      <p class="mt-2 text-sm text-slate-600 dark:text-slate-400">Sign in to your Happy Paws account</p>
    </div>

    <!-- Server Messages -->
    <div aria-live="polite">
      <% if (err != null) { %>
      <div class="rounded-lg p-4 bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800">
        <div class="flex">
          <div class="flex-shrink-0">
            <svg class="h-5 w-5 text-red-400" viewBox="0 0 20 20" fill="currentColor">
              <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd"/>
            </svg>
          </div>
          <div class="ml-3">
            <p class="text-sm text-red-800 dark:text-red-200"><%= err %></p>
          </div>
        </div>
      </div>
      <% } else if (ok != null) { %>
      <div class="rounded-lg p-4 bg-green-50 dark:bg-green-900/20 border border-green-200 dark:border-green-800">
        <div class="flex">
          <div class="flex-shrink-0">
            <svg class="h-5 w-5 text-green-400" viewBox="0 0 20 20" fill="currentColor">
              <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/>
            </svg>
          </div>
          <div class="ml-3">
            <p class="text-sm text-green-800 dark:text-green-200"><%= ok %></p>
          </div>
        </div>
      </div>
      <% } %>
    </div>

    <!-- Login Form -->
    <div class="bg-white dark:bg-slate-800 py-8 px-6 shadow-lg rounded-xl border border-slate-200 dark:border-slate-700">
      <form method="post" action="<%= request.getContextPath() %>/login" id="loginForm" novalidate class="space-y-6">
        <input type="hidden" name="next" value="<%= nextParam == null ? "" : nextParam %>"/>

        <div>
          <label for="loginEmail" class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2">Email address</label>
          <input name="email" type="email" required
                 pattern="[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
                 title="Please enter a valid email address"
                 class="appearance-none relative block w-full px-3 py-3 border border-slate-300 dark:border-slate-600 placeholder-slate-500 dark:placeholder-slate-400 text-slate-900 dark:text-white rounded-lg focus:outline-none focus:ring-2 focus:ring-brand-500 focus:border-brand-500 dark:bg-slate-700 sm:text-sm"
                 id="loginEmail" autocomplete="username" autofocus placeholder="Enter your email"
                 value="<%= emailPrefill %>"/>
          <div id="emailError" class="text-red-500 text-sm mt-1 hidden"></div>
        </div>

        <div>
          <label for="loginPassword" class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2">Password</label>
          <input name="password" type="password" required minlength="6"
                 title="Password must be at least 6 characters long"
                 class="appearance-none relative block w-full px-3 py-3 border border-slate-300 dark:border-slate-600 placeholder-slate-500 dark:placeholder-slate-400 text-slate-900 dark:text-white rounded-lg focus:outline-none focus:ring-2 focus:ring-brand-500 focus:border-brand-500 dark:bg-slate-700 sm:text-sm"
                 id="loginPassword" autocomplete="current-password" placeholder="Enter your password"/>
          <div id="passwordError" class="text-red-500 text-sm mt-1 hidden"></div>
        </div>

        <div>
          <button type="submit"
                  class="group relative w-full flex justify-center py-3 px-4 border border-transparent text-sm font-medium rounded-lg text-white bg-brand-600 hover:bg-brand-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-brand-500 transition-colors duration-200">
            <span class="absolute left-0 inset-y-0 flex items-center pl-3">
              <svg class="h-5 w-5 text-brand-500 group-hover:text-brand-400" fill="currentColor" viewBox="0 0 20 20">
                <path fill-rule="evenodd" d="M5 9V7a5 5 0 0110 0v2a2 2 0 012 2v5a2 2 0 01-2 2H5a2 2 0 01-2-2v-5a2 2 0 012-2zm8-2v2H7V7a3 3 0 016 0z" clip-rule="evenodd"/>
              </svg>
            </span>
            Sign in to your account
          </button>
        </div>
      </form>
    </div>

    <!-- Sign up link -->
    <div class="text-center">
      <p class="text-sm text-slate-600 dark:text-slate-400">
        Don't have an account?
        <a href="<%= request.getContextPath() %>/owner-signup"
           class="font-medium text-brand-600 hover:text-brand-500 dark:text-brand-400 dark:hover:text-brand-300 transition-colors duration-200">
          Create your account
        </a>
      </p>
    </div>

  </div>
</section>

<%@ include file="../common/footer.jsp" %>

<script>
    // Client-side validation (doesn't replace server checks)
    document.addEventListener('DOMContentLoaded', function() {
      const form = document.getElementById('loginForm');
      const emailInput = document.getElementById('loginEmail');
      const passInput  = document.getElementById('loginPassword');
      const emailErr = document.getElementById('emailError');
      const passErr  = document.getElementById('passwordError');

      const validateEmail = (v) => /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/.test(v);
      const validatePass  = (v) => v && v.length >= 6;

      emailInput.addEventListener('blur', () => {
        const v = emailInput.value.trim();
        if (!v) {
          emailErr.textContent = 'Email is required';
          emailErr.classList.remove('hidden'); emailInput.classList.add('border-red-500');
        } else if (!validateEmail(v)) {
          emailErr.textContent = 'Please enter a valid email address';
          emailErr.classList.remove('hidden'); emailInput.classList.add('border-red-500');
        } else {
          emailErr.classList.add('hidden'); emailInput.classList.remove('border-red-500');
        }
      });

      passInput.addEventListener('blur', () => {
        const v = passInput.value;
        if (!v) {
          passErr.textContent = 'Password is required';
          passErr.classList.remove('hidden'); passInput.classList.add('border-red-500');
        } else if (!validatePass(v)) {
          passErr.textContent = 'Password must be at least 6 characters long';
          passErr.classList.remove('hidden'); passInput.classList.add('border-red-500');
        } else {
          passErr.classList.add('hidden'); passInput.classList.remove('border-red-500');
        }
      });

      form.addEventListener('submit', (e) => {
        let ok = true;
        const vEmail = emailInput.value.trim();
        const vPass  = passInput.value;

        if (!vEmail || !validateEmail(vEmail)) {
          emailErr.textContent = !vEmail ? 'Email is required' : 'Please enter a valid email address';
          emailErr.classList.remove('hidden'); emailInput.classList.add('border-red-500');
          ok = false;
        }
        if (!vPass || !validatePass(vPass)) {
          passErr.textContent = !vPass ? 'Password is required' : 'Password must be at least 6 characters long';
          passErr.classList.remove('hidden'); passInput.classList.add('border-red-500');
          ok = false;
        }
        if (!ok) e.preventDefault();
      });

      // Reveal on scroll
      const observer = new IntersectionObserver(entries => {
        entries.forEach(e => { if (e.isIntersecting) e.target.classList.add('visible'); });
      }, { threshold: 0.08 });
      document.querySelectorAll('.reveal').forEach(el => observer.observe(el));
    });
</script>
</body>
</html>

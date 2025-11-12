<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Staff - Happy Paws PetCare</title>

    <!-- EARLY THEME -->
    <script>
        (function () {
            try {
                const saved = localStorage.getItem('theme');
                const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
                const shouldDark = saved ? (saved === 'dark') : prefersDark;
                if (shouldDark) document.documentElement.classList.add('dark');
                else document.documentElement.classList.remove('dark');
            } catch (e) {}
        })();
    </script>

    <!-- Fonts + Tailwind -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Sora:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    fontFamily: {
                        sans: ['Inter','system-ui','sans-serif'],
                        display: ['Sora','Inter','system-ui','sans-serif']
                    },
                    colors: {
                        brand: {
                            50:'#effaff',100:'#d7f0ff',200:'#b2e1ff',300:'#84cdff',400:'#53b2ff',
                            500:'#2f97ff',600:'#1679e6',700:'#0f5fba',800:'#0f4c91',900:'#113e75'
                        }
                    },
                    boxShadow: {
                        soft:'0 10px 30px rgba(0,0,0,.06)',
                        glow:'0 0 0 6px rgba(47,151,255,.10)'
                    }
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
        .form-input:focus {
            box-shadow: 0 0 0 3px rgba(47,151,255,.15);
        }
        .input-error {
            border-color: #f87171;
        }
        .input-success {
            border-color: #4ade80;
        }
        .btn-animate { position: relative; transition: box-shadow .25s ease, transform .2s ease, background-color .2s ease, color .2s ease; }
        .btn-animate::before {
            content: "";
            position: absolute; inset: 0; border-radius: inherit; z-index: -1;
            background: rgba(47,151,255,0.12); transform: scale(0.96); opacity: 0;
            transition: transform .25s ease, opacity .25s ease;
        }
        .dark .btn-animate::before { background: rgba(47,151,255,0.16); }
        .btn-animate:hover::before { opacity: 1; transform: scale(1); }
        .btn-animate:hover { box-shadow: 0 8px 20px rgba(47,151,255,0.15); }
    </style>
</head>
<body class="antialiased text-slate-800 dark:text-slate-100 bg-slate-50 dark:bg-slate-950">

<div class="min-h-screen flex flex-col">
    <%@ include file="../common/header.jsp" %>

    <main class="flex-1 py-8">
        <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="mb-8">
                <div class="flex items-center justify-between">
                    <div>
                        <h1 class="font-display text-3xl font-bold text-slate-900 dark:text-white">Add New Staff Member</h1>
                        <p class="mt-2 text-slate-600 dark:text-slate-300">Register a new team member to your organization</p>
                    </div>
                    <a href="<%= request.getContextPath() %>/staff/management" class="inline-flex items-center px-4 py-2 border border-slate-300 dark:border-slate-600 rounded-lg text-slate-700 dark:text-slate-200 hover:bg-slate-50 dark:hover:bg-slate-800 transition-colors">
                        <i class="fas fa-arrow-left mr-2"></i>
                        Back to Staff Management
                    </a>
                </div>
            </div>

            <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-soft border border-slate-200 dark:border-slate-700 overflow-hidden">
                <div class="px-6 py-5 border-b border-slate-200 dark:border-slate-700 bg-slate-50 dark:bg-slate-700/50">
                    <div class="flex items-center">
                        <div class="flex items-center justify-center w-10 h-10 rounded-lg bg-brand-100 dark:bg-brand-900/30 text-brand-600 dark:text-brand-400 mr-3">
                            <i class="fas fa-user-plus"></i>
                        </div>
                        <div>
                            <h2 class="text-lg font-semibold">Staff Information</h2>
                            <p class="text-sm text-slate-600 dark:text-slate-400">Fill in the details for the new staff member</p>
                        </div>
                    </div>
                </div>

                <div id="errorAlert" class="hidden mx-6 mt-4 p-4 bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800 rounded-lg">
                    <div class="flex items-center">
                        <i class="fas fa-exclamation-circle text-red-500 mr-3"></i>
                        <span id="errorMessage" class="text-red-700 dark:text-red-400 text-sm"></span>
                    </div>
                </div>

                <form action="<%= request.getContextPath() %>/staff/add" method="post" class="p-6" id="staffForm">
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">

                        <div class="md:col-span-2">
                            <h3 class="text-lg font-medium text-slate-900 dark:text-white mb-4 flex items-center">
                                <i class="fas fa-user-circle mr-2 text-brand-500"></i>
                                Personal Information
                            </h3>
                        </div>

                        <!-- Full Name -->
                        <div class="space-y-2">
                            <label for="fullName" class="block text-sm font-medium text-slate-700 dark:text-slate-300">
                                Full Name <span class="text-red-500">*</span>
                            </label>
                            <div class="relative">
                                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                    <i class="fas fa-user text-slate-400"></i>
                                </div>
                                <input type="text" id="fullName" name="fullName"
                                       class="form-input block w-full pl-10 pr-3 py-2 border border-slate-300 dark:border-slate-600 rounded-lg bg-white dark:bg-slate-700 focus:outline-none focus:ring-2 focus:ring-brand-500 focus:border-brand-500 transition-colors"
                                       placeholder="Enter full name" required>
                            </div>
                            <p class="text-xs text-slate-500 dark:text-slate-400">Enter the complete name of the staff member</p>
                        </div>

                        <!-- Email -->
                        <div class="space-y-2">
                            <label for="email" class="block text-sm font-medium text-slate-700 dark:text-slate-300">
                                Email Address <span class="text-red-500">*</span>
                            </label>
                            <div class="relative">
                                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                    <i class="fas fa-envelope text-slate-400"></i>
                                </div>
                                <input type="email" id="email" name="email"
                                       class="form-input block w-full pl-10 pr-3 py-2 border border-slate-300 dark:border-slate-600 rounded-lg bg-white dark:bg-slate-700 focus:outline-none focus:ring-2 focus:ring-brand-500 focus:border-brand-500 transition-colors"
                                       placeholder="Enter email address" required>
                            </div>
                            <p class="text-xs text-slate-500 dark:text-slate-400">We'll use this for official communication</p>
                        </div>

                        <!-- Phone -->
                        <div class="space-y-2">
                            <label for="phone" class="block text-sm font-medium text-slate-700 dark:text-slate-300">
                                Phone Number <span class="text-red-500">*</span>
                            </label>
                            <div class="relative">
                                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                    <i class="fas fa-phone text-slate-400"></i>
                                </div>
                                <input type="tel" id="phone" name="phone"
                                       class="form-input block w-full pl-10 pr-3 py-2 border border-slate-300 dark:border-slate-600 rounded-lg bg-white dark:bg-slate-700 focus:outline-none focus:ring-2 focus:ring-brand-500 focus:border-brand-500 transition-colors"
                                       placeholder="Enter 10-digit phone number"
                                       maxlength="10" pattern="[0-9]{10}" required>
                            </div>
                            <p class="text-xs text-slate-500 dark:text-slate-400">Exactly 10 digits required</p>
                        </div>

                        <!-- Role -->
                        <div class="space-y-2">
                            <label for="role" class="block text-sm font-medium text-slate-700 dark:text-slate-300">
                                Position / Role <span class="text-red-500">*</span>
                            </label>
                            <div class="relative">
                                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                    <i class="fas fa-briefcase text-slate-400"></i>
                                </div>
                                <select id="role" name="role"
                                        class="form-input block w-full pl-10 pr-3 py-2 border border-slate-300 dark:border-slate-600 rounded-lg bg-white dark:bg-slate-700 focus:outline-none focus:ring-2 focus:ring-brand-500 focus:border-brand-500 transition-colors appearance-none"
                                        required>
                                    <option value="">Select a role</option>
                                    <option value="manager">General Manager</option>
                                    <option value="veterinarian">Veterinarian</option>
                                    <option value="pharmacist">Pharmacist</option>
                                    <option value="receptionist">Receptionist</option>
                                    <option value="groomer">Groomer</option>
                                </select>
                                <div class="absolute inset-y-0 right-0 flex items-center pr-3 pointer-events-none">
                                    <i class="fas fa-chevron-down text-slate-400"></i>
                                </div>
                            </div>
                            <p class="text-xs text-slate-500 dark:text-slate-400">Select the appropriate position</p>
                        </div>

                        <!-- Security Section -->
                        <div class="md:col-span-2 mt-6 pt-6 border-t border-slate-200 dark:border-slate-700">
                            <h3 class="text-lg font-medium text-slate-900 dark:text-white mb-4 flex items-center">
                                <i class="fas fa-lock mr-2 text-brand-500"></i>
                                Security & Access
                            </h3>
                        </div>

                        <!-- Password -->
                        <div class="space-y-2">
                            <label for="password" class="block text-sm font-medium text-slate-700 dark:text-slate-300">
                                Initial Password <span class="text-red-500">*</span>
                            </label>
                            <div class="relative">
                                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                    <i class="fas fa-key text-slate-400"></i>
                                </div>
                                <input type="password" id="password" name="password"
                                       class="form-input block w-full pl-10 pr-3 py-2 border border-slate-300 dark:border-slate-600 rounded-lg bg-white dark:bg-slate-700 focus:outline-none focus:ring-2 focus:ring-brand-500 focus:border-brand-500 transition-colors"
                                       placeholder="Create a secure password"
                                       minlength="6" required>
                            </div>
                            <p class="text-xs text-slate-500 dark:text-slate-400">Minimum 6 characters required</p>
                        </div>

                        <!-- Confirm Password -->
                        <div class="space-y-2">
                            <label for="confirmPassword" class="block text-sm font-medium text-slate-700 dark:text-slate-300">
                                Confirm Password <span class="text-red-500">*</span>
                            </label>
                            <div class="relative">
                                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                    <i class="fas fa-key text-slate-400"></i>
                                </div>
                                <input type="password" id="confirmPassword"
                                       class="form-input block w-full pl-10 pr-3 py-2 border border-slate-300 dark:border-slate-600 rounded-lg bg-white dark:bg-slate-700 focus:outline-none focus:ring-2 focus:ring-brand-500 focus:border-brand-500 transition-colors"
                                       placeholder="Re-enter the password" required>
                            </div>
                            <p id="confirmHelp" class="text-xs text-slate-500 dark:text-slate-400">Please re-enter the password to confirm</p>
                        </div>
                    </div>

                    <!-- Form Actions -->
                    <div class="mt-8 pt-6 border-t border-slate-200 dark:border-slate-700 flex flex-wrap gap-3">
                        <button type="submit" class="relative btn-animate inline-flex items-center px-5 py-2.5 bg-brand-600 hover:bg-brand-700 text-white font-medium rounded-lg transition-colors shadow-soft">
                            <i class="fas fa-user-plus mr-2"></i>
                            Add Staff Member
                        </button>
                        <button type="reset" class="relative btn-animate inline-flex items-center px-5 py-2.5 border border-slate-300 dark:border-slate-600 text-slate-700 dark:text-slate-200 font-medium rounded-lg hover:bg-slate-50 dark:hover:bg-slate-800 transition-colors">
                            <i class="fas fa-redo mr-2"></i>
                            Reset Form
                        </button>
                        <a href="<%= request.getContextPath() %>/staff/management" class="relative btn-animate inline-flex items-center px-5 py-2.5 border border-slate-300 dark:border-slate-600 text-slate-700 dark:text-slate-200 font-medium rounded-lg hover:bg-slate-50 dark:hover:bg-slate-800 transition-colors">
                            <i class="fas fa-times mr-2"></i>
                            Cancel
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </main>

    <%@ include file="../common/footer.jsp" %>
</div>


<script>
    // Form validation functions
    function validateField(field) {
        const isValid = field.value.trim() !== '';
        updateFieldStatus(field, isValid);
        return isValid;
    }

    function validateEmail(field) {
        const email = field.value.trim();
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        const isValid = email === '' || emailRegex.test(email);
        updateFieldStatus(field, isValid);

        if (!isValid && email !== '') {
            field.setCustomValidity('Please enter a valid email address');
        } else {
            field.setCustomValidity('');
        }
        return isValid;
    }

    function validatePhone(field) {
        const phone = field.value.trim();
        const phoneRegex = /^[0-9]{10}$/;
        const isValid = phone === '' || phoneRegex.test(phone);
        updateFieldStatus(field, isValid);

        if (!isValid && phone !== '') {
            field.setCustomValidity('Please enter exactly 10 digits');
        } else {
            field.setCustomValidity('');
        }
        return isValid;
    }

    function validatePassword(field) {
        const password = field.value;
        const hasMinLength = password.length >= 6;
        const isValid = hasMinLength;
        updateFieldStatus(field, isValid);

        if (!isValid && password !== '') {
            field.setCustomValidity('Password must be at least 6 characters long');
        } else {
            field.setCustomValidity('');
        }
        return isValid;
    }

    function validateConfirmPassword(field) {
        const password = document.getElementById('password').value;
        const confirmPassword = field.value;
        const isValid = confirmPassword === password;
        updateFieldStatus(field, isValid);

        if (!isValid && confirmPassword !== '') {
            field.setCustomValidity('Passwords do not match');
            document.getElementById('confirmHelp').classList.add('text-red-500');
        } else {
            field.setCustomValidity('');
            document.getElementById('confirmHelp').classList.remove('text-red-500');
        }
        return isValid;
    }

    function updateFieldStatus(field, isValid) {
        if (!field) return;

        if (field.value.trim() === '' && !field.hasAttribute('required')) {
            field.classList.remove('input-success', 'input-error');
        } else if (isValid) {
            field.classList.add('input-success');
            field.classList.remove('input-error');
        } else {
            field.classList.add('input-error');
            field.classList.remove('input-success');
        }
    }

    // Form submission validation
    document.addEventListener('DOMContentLoaded', function() {
        const form = document.getElementById('staffForm');
        const errorAlert = document.getElementById('errorAlert');
        const errorMessage = document.getElementById('errorMessage');

        // Filter numeric input for phone field
        const phoneField = document.getElementById('phone');
        if (phoneField) {
            phoneField.addEventListener('input', function() {
                this.value = this.value.replace(/[^0-9]/g, '');
            });
        }

        if (form) {
            form.addEventListener('submit', function(e) {
                const requiredFields = this.querySelectorAll('[required]');
                let isValid = true;

                // Validate all required fields
                requiredFields.forEach(field => {
                    if (field.type === 'email') {
                        if (!validateEmail(field)) isValid = false;
                    } else if (field.type === 'tel') {
                        if (!validatePhone(field)) isValid = false;
                    } else if (field.id === 'password') {
                        if (!validatePassword(field)) isValid = false;
                    } else if (field.id === 'confirmPassword') {
                        if (!validateConfirmPassword(field)) isValid = false;
                    } else {
                        if (!validateField(field)) isValid = false;
                    }
                });

                if (!isValid) {
                    e.preventDefault();
                    // Show error alert
                    errorAlert.classList.remove('hidden');
                    errorMessage.textContent = 'Please fix the errors in the form before submitting.';

                    // Scroll to first error
                    const firstError = this.querySelector('.input-error');
                    if (firstError) {
                        firstError.scrollIntoView({ behavior: 'smooth', block: 'center' });
                        firstError.focus();
                    }
                } else {
                    errorAlert.classList.add('hidden');
                }
            });
        }

        // Hide error alert when user starts correcting errors
        const inputs = form.querySelectorAll('input, select');
        inputs.forEach(input => {
            input.addEventListener('input', function() {
                errorAlert.classList.add('hidden');
            });
        });

        // Footer functionality
        function handleSubscribe() {
            const email = document.getElementById('emailSub').value;
            if (email) {
                document.getElementById('subMsg').classList.remove('hidden');
                document.getElementById('emailSub').value = '';
            }
        }

        // Set current year
        document.getElementById('year').textContent = new Date().getFullYear();
    });
</script>
</body>
</html>

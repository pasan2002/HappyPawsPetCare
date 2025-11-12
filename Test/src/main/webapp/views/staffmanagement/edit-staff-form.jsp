<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.happypaws.petcare.model.Staff" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
    Staff staff = (Staff) request.getAttribute("staff");
    String error = request.getParameter("error");

    String formattedDate = "";
    if (staff != null && staff.getCreatedAt() != null) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMM dd, yyyy 'at' HH:mm");
        formattedDate = staff.getCreatedAt().format(formatter);
    }

    String[] roles = {"manager", "veterinarian", "pharmacist", "receptionist", "groomer"};
%>
<html>
<head>
    <meta charset="UTF-8" />
    <title>Edit Staff - StaffManager Pro</title>
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
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Sora:wght@400;600;700&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    fontFamily: { sans: ['Inter','system-ui','sans-serif'], display: ['Sora','Inter','system-ui','sans-serif'] },
                    colors: { brand: { 50:'#effaff',100:'#d7f0ff',200:'#b2e1ff',300:'#84cdff',400:'#53b2ff',500:'#2f97ff',600:'#1679e6',700:'#0f5fba',800:'#0f4c91',900:'#113e75' } },
                    boxShadow: { soft:'0 10px 30px rgba(0,0,0,.06)', glow:'0 0 0 6px rgba(47,151,255,.10)' }
                }
            },
            darkMode: 'class'
        }
    </script>
    <link rel="stylesheet" href="style.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
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
            <!-- Page Header -->
            <div class="mb-8 flex items-center justify-between">
                <div>
                    <h1 class="font-display text-3xl font-bold text-slate-900 dark:text-white">Edit Staff Member</h1>
                    <p class="mt-2 text-slate-600 dark:text-slate-300">Update staff information and role</p>
                </div>
                <a href="<%= request.getContextPath() %>/staff/management" class="relative btn-animate inline-flex items-center px-4 py-2 border border-slate-300 dark:border-slate-600 rounded-lg text-slate-700 dark:text-slate-200 hover:bg-slate-50 dark:hover:bg-slate-800 transition-colors">
                    <i class="fas fa-arrow-left mr-2"></i>
                    Back to Staff Management
                </a>
            </div>

            <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-soft border border-slate-200 dark:border-slate-700 overflow-hidden">
                <div class="px-6 py-5 border-b border-slate-200 dark:border-slate-700 bg-slate-50 dark:bg-slate-700/50">
                    <div class="flex items-center">
                        <div class="flex items-center justify-center w-10 h-10 rounded-lg bg-brand-100 dark:bg-brand-900/30 text-brand-600 dark:text-brand-400 mr-3">
                            <i class="fas fa-user-edit"></i>
                        </div>
                        <div>
                            <h2 class="text-lg font-semibold">Staff Information</h2>
                            <p class="text-sm text-slate-600 dark:text-slate-400">Modify the details for this staff member</p>
                        </div>
                    </div>
                </div>

            <!-- Enhanced Error Messages -->
            <% if (error != null) { %>
            <div class="mx-6 mt-4 p-4 bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800 rounded-lg flex items-center gap-3 text-red-700 dark:text-red-300">
                <i class="fas fa-exclamation-circle"></i>
                <%
                    switch(error) {
                        case "validation": out.print("Please check all required fields."); break;
                        case "invalid_email": out.print("Please enter a valid email address."); break;
                        case "duplicate_email": out.print("This email is already registered by another staff member."); break;
                        case "weak_password": out.print("Password must be at least 6 characters."); break;
                        case "update_failed": out.print("Failed to update staff. Please try again."); break;
                        case "staff_not_found": out.print("Staff member not found."); break;
                        case "missing_parameters": out.print("Required information is missing."); break;
                        case "invalid_id_format": out.print("Invalid staff ID format."); break;
                        case "server_error": out.print("Server error occurred. Please try again."); break;
                        default: out.print("An error occurred. Please try again.");
                    }
                %>
            </div>
            <% } %>

            <!-- Success Message -->
            <% if ("updated".equals(request.getParameter("success"))) { %>
            <div class="mx-6 mt-4 p-4 bg-emerald-50 dark:bg-emerald-900/20 border border-emerald-200 dark:border-emerald-800 rounded-lg flex items-center gap-3 text-emerald-700 dark:text-emerald-300">
                <i class="fas fa-check-circle"></i>
                <span>Staff member updated successfully!</span>
            </div>
            <% } %>

            <% if (staff != null) { %>
            <form action="<%= request.getContextPath() %>/staff/management" method="post" class="p-6" id="staffForm">
                <input type="hidden" name="staffId" value="<%= staff.getStaffId() %>">

                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div class="space-y-2">
                        <label for="fullName" class="block text-sm font-medium text-slate-700 dark:text-slate-300">
                            Full Name <span class="text-red-500">*</span>
                        </label>
                        <div class="relative">
                            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                <i class="fas fa-user text-slate-400"></i>
                            </div>
                            <input type="text" id="fullName" name="fullName"
                                   value="<%= staff.getFullName() != null ? staff.getFullName() : "" %>"
                                   class="form-input block w-full pl-10 pr-3 py-2 border border-slate-300 dark:border-slate-600 rounded-lg bg-white dark:bg-slate-700 focus:outline-none focus:ring-2 focus:ring-brand-500 focus:border-brand-500 transition-colors"
                                   placeholder="Enter full name"
                                   required aria-required="true" aria-describedby="fullNameHelp" maxlength="100"
                                   oninput="debouncedValidateField(this)">
                        </div>
                        <p class="text-xs text-slate-500 dark:text-slate-400" id="fullNameHelp">Legal name as per official records</p>
                    </div>

                    <div class="space-y-2">
                        <label for="role" class="block text-sm font-medium text-slate-700 dark:text-slate-300">
                            Role <span class="text-red-500">*</span>
                        </label>
                        <div class="relative">
                            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                <i class="fas fa-briefcase text-slate-400"></i>
                            </div>
                            <select id="role" name="role"
                                    class="form-input block w-full pl-10 pr-3 py-2 border border-slate-300 dark:border-slate-600 rounded-lg bg-white dark:bg-slate-700 focus:outline-none focus:ring-2 focus:ring-brand-500 focus:border-brand-500 transition-colors appearance-none"
                                    required aria-required="true" aria-describedby="roleHelp"
                                    onchange="validateField(this)">
                                <option value="">Select Role</option>
                                <%
                                    for (String role : roles) {
                                        String selected = role.equals(staff.getRole()) ? "selected" : "";
                                %>
                                <option value="<%= role %>" <%= selected %>><%= role %></option>
                                <% } %>
                            </select>
                            <div class="absolute inset-y-0 right-0 flex items-center pr-3 pointer-events-none">
                                <i class="fas fa-chevron-down text-slate-400"></i>
                            </div>
                        </div>
                        <p class="text-xs text-slate-500 dark:text-slate-400" id="roleHelp">Current position in the organization</p>
                    </div>

                    <div class="space-y-2">
                        <label for="email" class="block text-sm font-medium text-slate-700 dark:text-slate-300">
                            Email <span class="text-red-500">*</span>
                        </label>
                        <div class="relative">
                            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                <i class="fas fa-envelope text-slate-400"></i>
                            </div>
                            <input type="email" id="email" name="email"
                                   value="<%= staff.getEmail() != null ? staff.getEmail() : "" %>"
                                   class="form-input block w-full pl-10 pr-3 py-2 border border-slate-300 dark:border-slate-600 rounded-lg bg-white dark:bg-slate-700 focus:outline-none focus:ring-2 focus:ring-brand-500 focus:border-brand-500 transition-colors"
                                   placeholder="Enter email address" required aria-required="true"
                                   aria-describedby="emailHelp" maxlength="100"
                                   oninput="debouncedValidateEmail(this)">
                        </div>
                        <p class="text-xs text-slate-500 dark:text-slate-400" id="emailHelp">Official company email address</p>
                    </div>

                    <div class="space-y-2">
                        <label for="phone" class="block text-sm font-medium text-slate-700 dark:text-slate-300">
                            Phone <span class="text-red-500">*</span>
                        </label>
                        <div class="relative">
                            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                <i class="fas fa-phone text-slate-400"></i>
                            </div>
                            <input type="tel" id="phone" name="phone"
                                   value="<%= staff.getPhone() != null ? staff.getPhone() : "" %>"
                                   class="form-input block w-full pl-10 pr-3 py-2 border border-slate-300 dark:border-slate-600 rounded-lg bg-white dark:bg-slate-700 focus:outline-none focus:ring-2 focus:ring-brand-500 focus:border-brand-500 transition-colors"
                                   placeholder="Enter 10-digit phone number" required aria-required="true"
                                   aria-describedby="phoneHelp" maxlength="10" pattern="[0-9]{10}"
                                   oninput="filterNumericInput(this); validatePhone(this)">
                        </div>
                        <p class="text-xs text-slate-500 dark:text-slate-400" id="phoneHelp">Exactly 10 digits required</p>
                    </div>
                </div>

                <div class="mt-6 pt-6 border-t border-slate-200 dark:border-slate-700">
                    <h3 class="text-lg font-medium text-slate-900 dark:text-white mb-4 flex items-center">
                        <i class="fas fa-lock mr-2 text-brand-500"></i>
                        Password Settings
                    </h3>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div class="space-y-2">
                            <label for="password" class="block text-sm font-medium text-slate-700 dark:text-slate-300">New Password (leave blank to keep current)</label>
                            <div class="relative">
                                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                    <i class="fas fa-key text-slate-400"></i>
                                </div>
                                <input type="password" id="password" name="password"
                                       class="form-input block w-full pl-10 pr-3 py-2 border border-slate-300 dark:border-slate-600 rounded-lg bg-white dark:bg-slate-700 focus:outline-none focus:ring-2 focus:ring-brand-500 focus:border-brand-500 transition-colors"
                                       placeholder="Enter new password" aria-describedby="passwordHelp"
                                       minlength="6" maxlength="50" oninput="debouncedValidatePassword(this)">
                            </div>
                            <div class="space-y-1">
                                <div class="w-full h-2 bg-slate-200 dark:bg-slate-700 rounded overflow-hidden">
                                    <div class="h-2 rounded transition-all" id="strengthFill"></div>
                                </div>
                                <small class="text-xs text-slate-500 dark:text-slate-400" id="passwordHelp">Minimum 6 characters recommended (optional)</small>
                            </div>
                        </div>

                        <div class="space-y-2">
                            <label for="confirmPassword" class="block text-sm font-medium text-slate-700 dark:text-slate-300">Confirm New Password</label>
                            <div class="relative">
                                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                    <i class="fas fa-key text-slate-400"></i>
                                </div>
                                <input type="password" id="confirmPassword"
                                       class="form-input block w-full pl-10 pr-3 py-2 border border-slate-300 dark:border-slate-600 rounded-lg bg-white dark:bg-slate-700 focus:outline-none focus:ring-2 focus:ring-brand-500 focus:border-brand-500 transition-colors"
                                       placeholder="Confirm new password" aria-describedby="confirmHelp"
                                       maxlength="50" oninput="validateConfirmPassword(this)">
                            </div>
                            <small class="text-xs text-slate-500 dark:text-slate-400" id="confirmHelp">Re-enter the password to confirm</small>
                        </div>
                    </div>
                </div>

                <div class="mt-6 bg-slate-50 dark:bg-slate-800/40 rounded-xl p-4 border border-slate-200 dark:border-slate-700">
                    <h4 class="font-semibold text-slate-900 dark:text-white mb-3 flex items-center gap-2">
                        <i class="fas fa-info-circle"></i>
                        Staff Information
                    </h4>
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-4 text-sm">
                        <div>
                            <span class="text-slate-500 dark:text-slate-400">Staff ID:</span>
                            <div class="font-medium text-slate-900 dark:text-white">#EMP<%= String.format("%04d", staff.getStaffId()) %></div>
                        </div>
                        <div>
                            <span class="text-slate-500 dark:text-slate-400">Member Since:</span>
                            <div class="font-medium text-slate-900 dark:text-white"><%= formattedDate %></div>
                        </div>
                        <div>
                            <span class="text-slate-500 dark:text-slate-400">Status:</span>
                            <div class="font-medium text-emerald-600 dark:text-emerald-400 flex items-center gap-2">
                                <i class="fas fa-circle text-[10px]"></i>
                                Active
                            </div>
                        </div>
                    </div>
                </div>

                <div class="mt-8 pt-6 border-t border-slate-200 dark:border-slate-700 flex flex-wrap gap-3">
                    <button type="submit" class="relative btn-animate inline-flex items-center px-5 py-2.5 bg-brand-600 hover:bg-brand-700 text-white font-medium rounded-lg transition-colors shadow-soft" id="submitBtn">
                        <i class="fas fa-save mr-2"></i>
                        Update Staff
                    </button>
                    <a href="ListStaffServlet" class="relative btn-animate inline-flex items-center px-5 py-2.5 border border-slate-300 dark:border-slate-600 text-slate-700 dark:text-slate-200 font-medium rounded-lg hover:bg-slate-50 dark:hover:bg-slate-800 transition-colors">
                        <i class="fas fa-times mr-2"></i>
                        Cancel
                    </a>
                    <a href="DeleteStaffServlet?id=<%= staff.getStaffId() %>"
                       class="relative btn-animate inline-flex items-center px-5 py-2.5 border border-red-300 dark:border-red-700 text-red-700 dark:text-red-300 font-medium rounded-lg hover:bg-red-50 dark:hover:bg-red-900/20 transition-colors"
                       data-staff-name="<%= staff.getFullName() != null ? staff.getFullName().replace("\"", "&quot;") : "" %>"
                       onclick="return confirmDeletion(this.getAttribute('data-staff-name'))">
                        <i class="fas fa-trash mr-2"></i>
                        Delete Staff
                    </a>
                </div>

            </form>
            <% } else { %>
            <div class="no-data text-center p-10">
                <i class="fas fa-user-slash text-3xl text-slate-400 mb-4"></i>
                <h3 class="text-xl font-semibold mb-2">Staff Member Not Found</h3>
                <p class="mb-6 text-slate-600 dark:text-slate-300">The staff member you're trying to edit doesn't exist or has been removed.</p>
                <div class="flex gap-3 justify-center">
                    <a href="<%= request.getContextPath() %>/staff/management" class="btn btn-primary inline-flex items-center gap-2 px-4 py-2 rounded-xl border border-slate-300 dark:border-slate-600 hover:bg-slate-50 dark:hover:bg-slate-800 transition-colors">
                        <i class="fas fa-arrow-left"></i>
                        Back to Staff Management
                    </a>
                    <a href="<%= request.getContextPath() %>/staff/add" class="btn btn-secondary inline-flex items-center gap-2 px-4 py-2 rounded-xl bg-brand-600 hover:bg-brand-700 text-white transition-colors">
                        <i class="fas fa-user-plus"></i>
                        Add New Staff
                    </a>
                </div>
            </div>
            <% } %>
        </div>
    </main>
    <%@ include file="../common/footer.jsp" %>
</div>

<script>
    function debounce(func, wait) {
        let timeout;
        return function executedFunction(...args) {
            const later = () => { clearTimeout(timeout); func(...args); };
            clearTimeout(timeout);
            timeout = setTimeout(later, wait);
        };
    }

    const debouncedValidateField = debounce(validateField, 300);
    const debouncedValidateEmail = debounce(validateEmail, 300);
    const debouncedValidatePassword = debounce(validatePassword, 300);

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
        field.setCustomValidity((!isValid && email !== '') ? 'Please enter a valid email address' : '');
        return isValid;
    }

    function validatePhone(field) {
        const phone = field.value.trim();
        const phoneRegex = /^[0-9]{10}$/;
        const isValid = phone === '' || phoneRegex.test(phone);
        updateFieldStatus(field, isValid);
        field.setCustomValidity((!isValid && phone !== '') ? 'Please enter exactly 10 digits' : '');
        return isValid;
    }

    function filterNumericInput(field) { field.value = field.value.replace(/[^0-9]/g, ''); }

    function validatePassword(field) {
        const password = field.value;
        if (password === '') {
            updateFieldStatus(field, true);
            updatePasswordStrength(0);
            field.setCustomValidity('');
            validateConfirmPassword(document.getElementById('confirmPassword'));
            return true;
        }
        const hasMinLength = password.length >= 6;
        updatePasswordStrength(calculatePasswordStrength(password));
        updateFieldStatus(field, hasMinLength);
        field.setCustomValidity(hasMinLength ? '' : 'Password must be at least 6 characters long');
        validateConfirmPassword(document.getElementById('confirmPassword'));
        return hasMinLength;
    }

    function validateConfirmPassword(field) {
        const password = document.getElementById('password').value;
        const confirmPassword = field.value;
        if (password === '' && confirmPassword === '') {
            updateFieldStatus(field, true);
            field.setCustomValidity('');
            return true;
        }
        const isValid = password === confirmPassword;
        updateFieldStatus(field, isValid);
        field.setCustomValidity((!isValid && confirmPassword !== '') ? 'Passwords do not match' : '');
        return isValid;
    }

    function updateFieldStatus(field, isValid) {
        if (!field) return;
        if (field.value.trim() === '' && !field.hasAttribute('required')) {
            field.classList.remove('valid', 'error');
        } else if (isValid) {
            field.classList.add('valid'); field.classList.remove('error');
        } else {
            field.classList.add('error'); field.classList.remove('valid');
        }
    }

    function calculatePasswordStrength(password) {
        if (password === '') return 0;
        let strength = 0;
        if (password.length >= 6) strength += 20;
        if (password.length >= 8) strength += 20;
        if (/[a-z]/.test(password)) strength += 15;
        if (/[A-Z]/.test(password)) strength += 15;
        if (/[0-9]/.test(password)) strength += 15;
        if (/[^a-zA-Z0-9]/.test(password)) strength += 15;
        return Math.min(strength, 100);
    }

    function updatePasswordStrength(strength) {
        const fill = document.getElementById('strengthFill');
        const help = document.getElementById('passwordHelp');
        if (!fill || !help) return;
        fill.style.width = strength + '%';
        if (strength === 0) { fill.style.background = 'transparent'; help.textContent = 'Minimum 6 characters recommended (optional)'; help.style.color = ''; }
        else if (strength < 40) { fill.style.background = 'var(--danger)'; help.textContent = 'Weak password'; help.style.color = 'var(--danger)'; }
        else if (strength < 70) { fill.style.background = 'var(--warning)'; help.textContent = 'Good password'; help.style.color = 'var(--warning)'; }
        else { fill.style.background = 'var(--success)'; help.textContent = 'Strong password'; help.style.color = 'var(--success)'; }
    }

    function confirmDeletion(staffName) {
        return confirm(`Are you sure you want to delete ${staffName}? This action cannot be undone.`);
    }

    var staffFormEl = document.getElementById('staffForm');
    if (staffFormEl) staffFormEl.addEventListener('submit', function(e) {
        const requiredFields = this.querySelectorAll('[required]');
        let isValid = true;
        requiredFields.forEach(field => {
            if (field.type === 'email') { if (!validateEmail(field)) isValid = false; }
            else if (field.type === 'tel') { if (!validatePhone(field)) isValid = false; }
            else { if (!validateField(field)) isValid = false; }
        });
        const pwdEl = document.getElementById('password');
        const confEl = document.getElementById('confirmPassword');
        if (pwdEl.value && !validatePassword(pwdEl)) isValid = false;
        if ((pwdEl.value || confEl.value) && !validateConfirmPassword(confEl)) isValid = false;

        if (!isValid) {
            e.preventDefault();
            const firstError = this.querySelector('.error');
            if (firstError) { firstError.scrollIntoView({ behavior: 'smooth', block: 'center' }); firstError.focus(); }
            alert('Please fix the errors in the form before submitting.');
        } else {
            const submitBtn = document.getElementById('submitBtn');
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Updating...';
            submitBtn.disabled = true;
            this.classList.add('submitting');
        }
    });

    document.addEventListener('DOMContentLoaded', function() {
        const fields = document.querySelectorAll('#staffForm input, #staffForm select');
        fields.forEach(field => {
            if (field.type === 'email') validateEmail(field);
            else if (field.id === 'password') validatePassword(field);
            else if (field.id === 'confirmPassword') validateConfirmPassword(field);
            else if (field.type === 'tel') validatePhone(field);
            else if (field.hasAttribute('required')) validateField(field);

            field.addEventListener('blur', function() {
                if (this.type === 'email') validateEmail(this);
                else if (this.id === 'password') validatePassword(this);
                else if (this.id === 'confirmPassword') validateConfirmPassword(this);
                else if (this.type === 'tel') validatePhone(this);
                else if (this.hasAttribute('required')) validateField(this);
            });
        });

        const phoneField = document.getElementById('phone');
        if (phoneField && phoneField.value) validatePhone(phoneField);
    });

    if (window.history.replaceState) window.history.replaceState(null, null, window.location.href);

    function handleSubscribe() {
        const email = document.getElementById('emailSub')?.value;
        if (email) {
            document.getElementById('subMsg')?.classList.remove('hidden');
            document.getElementById('emailSub').value = '';
        }
    }
    document.getElementById('year')?.textContent = new Date().getFullYear();
</script>
</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String cpath = request.getContextPath();
    HttpSession userSession = request.getSession(false);
    String ownerName = userSession != null ? (String) userSession.getAttribute("ownerName") : "Pet Owner";
    if (ownerName == null) ownerName = "Pet Owner";
%>
<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Change Password — Happy Paws PetCare</title>
    <meta name="description" content="Update your account password." />

    <!-- Early theme init -->
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
        <div class="flex items-center justify-between gap-4 reveal">
            <div>
                <h1 class="font-display text-3xl md:text-4xl font-extrabold tracking-tight">Change Password</h1>
                <p class="mt-2 text-sm text-slate-600 dark:text-slate-300">Update your account password for security.</p>
            </div>
            <div class="flex items-center gap-2">
                <a href="<%= cpath %>/owner-profile"
                   class="inline-flex items-center px-4 py-2 rounded-xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 hover:shadow-soft">
                    ← Back to Profile
                </a>
            </div>
        </div>
    </div>
</section>

<!-- CONTENT -->
<section class="max-w-2xl mx-auto px-4 sm:px-6 lg:px-8 pb-16">

    <!-- Flash Messages -->
    <%
        String error = (String) request.getAttribute("error");
        String success = (String) request.getAttribute("success");
        if (error != null) {
    %>
    <div class="mt-6 rounded-xl p-4 text-sm bg-rose-50 text-rose-800 dark:bg-rose-900/30 dark:text-rose-200 border border-rose-200/50">
        <%= error %>
    </div>
    <% } else if (success != null) { %>
    <div class="mt-6 rounded-xl p-4 text-sm bg-emerald-50 text-emerald-800 dark:bg-emerald-900/30 dark:text-emerald-200 border border-emerald-200/50">
        <%= success %>
    </div>
    <% } %>

    <!-- Change Password Form -->
    <div class="mt-8">
        <div class="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 shadow-soft p-6">
            <h2 class="text-xl font-semibold mb-6">Update Password</h2>
            
            <form method="post" action="<%= cpath %>/owner-change-password" class="space-y-6" onsubmit="return validatePassword()">
                
                <!-- Current Password -->
                <div>
                    <label for="currentPassword" class="block text-sm font-medium mb-2">Current Password <span class="text-rose-600">*</span></label>
                    <input type="password" id="currentPassword" name="currentPassword" required
                           class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-3 py-2"
                           placeholder="Enter your current password" />
                </div>

                <!-- New Password -->
                <div>
                    <label for="newPassword" class="block text-sm font-medium mb-2">New Password <span class="text-rose-600">*</span></label>
                    <input type="password" id="newPassword" name="newPassword" required minlength="8"
                           class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-3 py-2"
                           placeholder="Enter your new password" />
                    <p class="mt-1 text-xs text-slate-600 dark:text-slate-400">Password must be at least 8 characters long</p>
                </div>

                <!-- Confirm New Password -->
                <div>
                    <label for="confirmPassword" class="block text-sm font-medium mb-2">Confirm New Password <span class="text-rose-600">*</span></label>
                    <input type="password" id="confirmPassword" name="confirmPassword" required minlength="8"
                           class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-3 py-2"
                           placeholder="Confirm your new password" />
                    <div id="passwordMatch" class="mt-1 text-xs hidden"></div>
                </div>

                <!-- Password Requirements -->
                <div class="p-4 rounded-xl bg-slate-50 dark:bg-slate-800/50">
                    <h3 class="text-sm font-medium mb-2">Password Requirements:</h3>
                    <ul class="text-xs text-slate-600 dark:text-slate-400 space-y-1">
                        <li>• At least 8 characters long</li>
                        <li>• Include both uppercase and lowercase letters (recommended)</li>
                        <li>• Include at least one number (recommended)</li>
                        <li>• Include at least one special character (recommended)</li>
                    </ul>
                </div>

                <!-- Submit Button -->
                <div class="flex items-center gap-3 pt-4">
                    <button type="submit" 
                            class="inline-flex items-center px-6 py-3 rounded-xl bg-brand-600 hover:bg-brand-700 text-white font-medium shadow-soft">
                        Update Password
                    </button>
                    <a href="<%= cpath %>/owner-profile"
                       class="inline-flex items-center px-4 py-3 rounded-xl border border-slate-200 dark:border-slate-800 hover:shadow-soft">
                        Cancel
                    </a>
                </div>
            </form>
        </div>
    </div>

</section>

<%@ include file="../common/footer.jsp" %>

<script>
    // Reveal on scroll
    const observer = new IntersectionObserver(entries => {
        entries.forEach(e => { if (e.isIntersecting) e.target.classList.add('visible'); });
    }, { threshold: 0.08 });
    document.querySelectorAll('.reveal').forEach(el => observer.observe(el));

    // Password validation
    function validatePassword() {
        const newPassword = document.getElementById('newPassword').value;
        const confirmPassword = document.getElementById('confirmPassword').value;
        const matchDiv = document.getElementById('passwordMatch');

        if (newPassword !== confirmPassword) {
            matchDiv.textContent = 'Passwords do not match';
            matchDiv.className = 'mt-1 text-xs text-rose-600 block';
            return false;
        }

        if (newPassword.length < 8) {
            matchDiv.textContent = 'Password must be at least 8 characters long';
            matchDiv.className = 'mt-1 text-xs text-rose-600 block';
            return false;
        }

        matchDiv.className = 'mt-1 text-xs hidden';
        return true;
    }

    // Real-time password confirmation check
    document.getElementById('confirmPassword').addEventListener('input', function() {
        const newPassword = document.getElementById('newPassword').value;
        const confirmPassword = this.value;
        const matchDiv = document.getElementById('passwordMatch');

        if (confirmPassword && newPassword !== confirmPassword) {
            matchDiv.textContent = 'Passwords do not match';
            matchDiv.className = 'mt-1 text-xs text-rose-600 block';
        } else if (confirmPassword && newPassword === confirmPassword) {
            matchDiv.textContent = 'Passwords match';
            matchDiv.className = 'mt-1 text-xs text-emerald-600 block';
        } else {
            matchDiv.className = 'mt-1 text-xs hidden';
        }
    });
</script>

</body>
</html>
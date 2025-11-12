<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.happypaws.petcare.model.Staff" %>
<%
    List<Staff> staffList = (List<Staff>) request.getAttribute("staffList");
    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>
<html>
<head>
    <meta charset="UTF-8" />
    <title>Staff List</title>

    <!-- EARLY THEME -->
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
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
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
    <style>
        .focus-ring:focus { outline: 2px solid #2f97ff; outline-offset: 2px; }
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

<div>
    <%@ include file="../common/header.jsp" %>

    <main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">

        <div class="mb-8">
            <h1 class="font-display text-3xl md:text-4xl font-bold text-slate-900 dark:text-white">Staff Members</h1>
            <p class="mt-2 text-slate-600 dark:text-slate-300">Manage your team members efficiently</p>
        </div>

        <% if (success != null) { %>
        <div class="mb-6 p-4 rounded-xl bg-emerald-50 dark:bg-emerald-900/20 border border-emerald-200 dark:border-emerald-800 text-emerald-700 dark:text-emerald-300 flex items-center gap-3">
            <i class="fas fa-check-circle"></i>
            <span>
                <%
                    if ("added".equals(success)) {
                        out.print("Staff added successfully!");
                    } else if ("updated".equals(success)) {
                        out.print("Staff updated successfully!");
                    } else if ("deleted".equals(success)) {
                        out.print("Staff deleted successfully!");
                    } else {
                        out.print("Operation completed successfully!");
                    }
                %>
            </span>
        </div>
        <% } %>

        <% if (error != null) { %>
        <div class="mb-6 p-4 rounded-xl bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800 text-red-700 dark:text-red-300 flex items-center gap-3">
            <i class="fas fa-exclamation-circle"></i>
            <span>Operation failed. Please try again.</span>
        </div>
        <% } %>

        <div class="bg-white dark:bg-slate-900 rounded-2xl p-6 border border-slate-200 dark:border-slate-800 shadow-soft mb-6">
            <div class="flex flex-col sm:flex-row gap-3 justify-between items-start sm:items-center">
                <a href="add-staff-form.jsp" class="relative btn-animate inline-flex items-center gap-2 px-4 py-2.5 rounded-xl bg-brand-600 hover:bg-brand-700 text-white font-medium shadow-soft transition-colors">
                    <i class="fas fa-user-plus"></i>
                    Add New Staff
                </a>
                <div class="relative w-full sm:w-80">
                    <input type="text" placeholder="Search staff..." id="searchInput" class="w-full pl-10 pr-3 py-2.5 rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-800 placeholder-slate-500 dark:placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-brand-500">
                    <i class="fas fa-search absolute left-3 top-1/2 -translate-y-1/2 text-slate-400"></i>
                </div>
            </div>
        </div>

        <div class="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 shadow-soft overflow-hidden">
            <div class="overflow-x-auto">
            <table id="staffTable" class="w-full">
                <thead class="bg-slate-50 dark:bg-slate-800/50">
                <tr>
                    <th class="px-6 py-3 text-left text-xs font-medium text-slate-500 dark:text-slate-400 uppercase tracking-wider">ID</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-slate-500 dark:text-slate-400 uppercase tracking-wider">Full Name</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-slate-500 dark:text-slate-400 uppercase tracking-wider">Role</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-slate-500 dark:text-slate-400 uppercase tracking-wider">Email</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-slate-500 dark:text-slate-400 uppercase tracking-wider">Phone</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-slate-500 dark:text-slate-400 uppercase tracking-wider">Created Date</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-slate-500 dark:text-slate-400 uppercase tracking-wider">Actions</th>
                </tr>
                </thead>
                <tbody class="divide-y divide-slate-200 dark:divide-slate-800">
                <% if (staffList != null && !staffList.isEmpty()) {
                    for (Staff staff : staffList) { %>
                <tr class="hover:bg-slate-50 dark:hover:bg-slate-800/50 transition-colors">
                    <td class="px-6 py-4 whitespace-nowrap text-sm font-mono text-slate-600 dark:text-slate-300">#<%= staff.getStaffId() %></td>
                    <td class="px-6 py-4 whitespace-nowrap">
                        <div class="flex items-center gap-3">
                            <div class="h-8 w-8 rounded-full bg-gradient-to-br from-brand-500 to-blue-600 text-white flex items-center justify-center text-sm font-medium">
                                <%= staff.getFullName() != null && staff.getFullName().length() > 0 ? staff.getFullName().substring(0,1).toUpperCase() : "?" %>
                            </div>
                            <div class="text-sm font-medium text-slate-900 dark:text-white"><%= staff.getFullName() %></div>
                        </div>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap">
                        <span class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-xs font-medium bg-slate-100 text-slate-700 dark:bg-slate-800 dark:text-slate-300">
                            <i class="fas fa-briefcase text-xs"></i>
                            <%= staff.getRole() %>
                        </span>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm">
                        <a href="mailto:<%= staff.getEmail() %>" class="text-slate-600 dark:text-slate-300 hover:text-brand-600 dark:hover:text-brand-400"><%= staff.getEmail() %></a>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm">
                        <a href="tel:<%= staff.getPhone() %>" class="text-slate-600 dark:text-slate-300 hover:text-brand-600 dark:hover:text-brand-400"><%= staff.getPhone() %></a>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-slate-500 dark:text-slate-400">
                        <i class="far fa-calendar mr-2"></i>
                        <%= staff.getCreatedAt() %>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap">
                        <div class="flex items-center gap-2">
                            <a href="EditStaffServlet?id=<%= staff.getStaffId() %>" class="p-2 rounded-lg text-slate-400 hover:text-blue-600 hover:bg-blue-50 dark:hover:bg-blue-900/20 transition-colors" title="Edit">
                                <i class="fas fa-edit"></i>
                            </a>
                            <a href="DeleteStaffServlet?id=<%= staff.getStaffId() %>" class="p-2 rounded-lg text-slate-400 hover:text-red-600 hover:bg-red-50 dark:hover:bg-red-900/20 transition-colors" onclick="return confirm('Are you sure you want to delete <%= staff.getFullName() %>?')" title="Delete">
                                <i class="fas fa-trash"></i>
                            </a>
                        </div>
                    </td>
                </tr>
                <% }
                } else { %>
                <tr>
                    <td colspan="7" class="px-6 py-12 text-center">
                        <div class="text-slate-400 dark:text-slate-500">
                            <i class="fas fa-users-slash text-4xl mb-4"></i>
                            <h3 class="text-lg font-medium text-slate-900 dark:text-white mb-2">No Staff Members Found</h3>
                            <p class="mb-4">Get started by adding your first team member</p>
                            <a href="add-staff-form.jsp" class="relative btn-animate inline-flex items-center gap-2 px-4 py-2 rounded-xl bg-brand-600 hover:bg-brand-700 text-white font-medium shadow-soft transition-colors">
                                <i class="fas fa-user-plus"></i>
                                Add Staff Member
                            </a>
                        </div>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
            </div>
        </div>
    </main>
    <%@ include file="../common/footer.jsp" %>
</div>

<script>
    document.getElementById('searchInput').addEventListener('input', function(e) {
        const searchTerm = e.target.value.toLowerCase();
        const rows = document.querySelectorAll('#staffTable tbody tr');
        rows.forEach(row => {
            const isNoDataRow = row.querySelector('td[colspan]') !== null;
            if (isNoDataRow) return;
            const text = row.textContent.toLowerCase();
            row.style.display = text.includes(searchTerm) ? '' : 'none';
        });
    });

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

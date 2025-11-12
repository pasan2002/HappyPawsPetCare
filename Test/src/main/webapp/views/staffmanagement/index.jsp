<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.happypaws.petcare.model.Staff" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
    List<Staff> staffList = (List<Staff>) request.getAttribute("staffList");
    String success = request.getParameter("success");
    String error = request.getParameter("error");
    String searchTerm = (String) request.getAttribute("searchTerm");
    String roleFilter = (String) request.getAttribute("roleFilter");
    String sortBy = (String) request.getAttribute("sortBy");
    String sortOrder = (String) request.getAttribute("sortOrder");

    Integer totalStaffCount = (Integer) request.getAttribute("totalStaffCount");
    Integer uniqueRolesCount = (Integer) request.getAttribute("uniqueRolesCount");

    if (staffList == null) {
        staffList = new java.util.ArrayList<>();
    }

    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("MMM dd, yyyy");
    DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("MMM dd, yyyy 'at' HH:mm");
%>
<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Staff Management - Happy Paws PetCare</title>
    <meta name="description" content="Manage your veterinary and grooming staff with Happy Paws PetCare's modern staff management system." />

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
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    fontFamily: { sans: ['Inter','system-ui','sans-serif'], display: ['Sora','Inter','system-ui','sans-serif'] },
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
        }
        .reveal { opacity: 0; transform: translateY(12px); transition: opacity .6s ease, transform .6s ease; }
        .reveal.visible { opacity: 1; transform: translateY(0); }
        .focus-ring:focus {
            outline: 2px solid #2f97ff;
            outline-offset: 2px;
        }

        /* Custom animations */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .animate-fade-in { animation: fadeIn 0.5s ease-out; }

        /* Role badge colors */
        .role-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.375rem;
            padding: 0.25rem 0.625rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 500;
        }
        .role-manager { background-color: rgb(243 232 255); color: rgb(107 33 168); }
        .role-veterinarian { background-color: rgb(209 250 229); color: rgb(6 120 73); }
        .role-pharmacist { background-color: rgb(219 234 254); color: rgb(30 64 175); }
        .role-receptionist { background-color: rgb(254 243 199); color: rgb(146 64 14); }
        .role-groomer { background-color: rgb(252 231 243); color: rgb(157 23 77); }

        /* Dark mode role badge colors */
        .dark .role-manager { background-color: rgba(168, 85, 247, 0.3); color: rgb(196 181 253); }
        .dark .role-veterinarian { background-color: rgba(16, 185, 129, 0.3); color: rgb(110 231 183); }
        .dark .role-pharmacist { background-color: rgba(59, 130, 246, 0.3); color: rgb(147 197 253); }
        .dark .role-receptionist { background-color: rgba(245, 158, 11, 0.3); color: rgb(252 211 77); }
        .dark .role-groomer { background-color: rgba(236, 72, 153, 0.3); color: rgb(244 114 182); }
    </style>
</head>
<body class="antialiased text-slate-800 dark:text-slate-100 bg-slate-50 dark:bg-slate-950 min-h-screen">

<!-- NAV -->
<%@ include file="../common/header.jsp" %>

<main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
    <!-- Page Header -->
    <div class="mb-8 reveal">
        <h1 class="font-display text-3xl md:text-4xl font-bold text-slate-900 dark:text-white">Staff Management</h1>
        <p class="mt-2 text-slate-600 dark:text-slate-300">Manage your veterinary and grooming team members</p>
    </div>

    <!-- Stats Cards -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
        <div class="reveal bg-white dark:bg-slate-900 rounded-2xl p-6 border border-slate-200 dark:border-slate-800 shadow-soft">
            <div class="flex items-center gap-4">
                <div class="h-12 w-12 rounded-xl bg-brand-500 text-white grid place-items-center">
                    <i class="fas fa-users text-lg"></i>
                </div>
                <div>
                    <p class="text-2xl font-bold text-slate-900 dark:text-white"><%= totalStaffCount != null ? totalStaffCount : 0 %></p>
                    <p class="text-sm text-slate-600 dark:text-slate-300">Total Staff</p>
                </div>
            </div>
        </div>

        <div class="reveal bg-white dark:bg-slate-900 rounded-2xl p-6 border border-slate-200 dark:border-slate-800 shadow-soft">
            <div class="flex items-center gap-4">
                <div class="h-12 w-12 rounded-xl bg-emerald-500 text-white grid place-items-center">
                    <i class="fas fa-user-check text-lg"></i>
                </div>
                <div>
                    <p class="text-2xl font-bold text-slate-900 dark:text-white"><%= staffList != null ? staffList.size() : 0 %></p>
                    <p class="text-sm text-slate-600 dark:text-slate-300">Displayed</p>
                </div>
            </div>
        </div>

        <div class="reveal bg-white dark:bg-slate-900 rounded-2xl p-6 border border-slate-200 dark:border-slate-800 shadow-soft">
            <div class="flex items-center gap-4">
                <div class="h-12 w-12 rounded-xl bg-amber-500 text-white grid place-items-center">
                    <i class="fas fa-briefcase text-lg"></i>
                </div>
                <div>
                    <p class="text-2xl font-bold text-slate-900 dark:text-white"><%= uniqueRolesCount != null ? uniqueRolesCount : 0 %></p>
                    <p class="text-sm text-slate-600 dark:text-slate-300">Roles</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Alerts -->
    <% if (success != null) { %>
    <div class="reveal mb-6 p-4 rounded-xl bg-emerald-50 dark:bg-emerald-900/20 border border-emerald-200 dark:border-emerald-800 text-emerald-700 dark:text-emerald-300 flex items-center justify-between">
        <div class="flex items-center gap-3">
            <i class="fas fa-check-circle"></i>
            <span>
                <% switch(success) {
                    case "added": out.print("Staff member added successfully!"); break;
                    case "updated": out.print("Staff member updated successfully!"); break;
                    case "deleted": out.print("Staff member deleted successfully!"); break;
                    default: out.print("Operation completed successfully!");
                } %>
            </span>
        </div>
        <button onclick="this.parentElement.style.display='none'" class="text-emerald-600 dark:text-emerald-400 hover:text-emerald-800 dark:hover:text-emerald-200">
            <i class="fas fa-times"></i>
        </button>
    </div>
    <% } %>

    <% if (error != null) { %>
    <div class="reveal mb-6 p-4 rounded-xl bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800 text-red-700 dark:text-red-300 flex items-center justify-between">
        <div class="flex items-center gap-3">
            <i class="fas fa-exclamation-circle"></i>
            <span>
                <% switch(error) {
                    case "invalid_id": out.print("Invalid staff ID provided."); break;
                    case "invalid_id_format": out.print("Invalid staff ID format."); break;
                    case "invalid_id_range": out.print("Staff ID must be a positive number."); break;
                    case "staff_not_found": out.print("Staff member not found."); break;
                    case "delete_failed": out.print("Failed to delete staff member."); break;
                    case "server_error": out.print("Server error occurred. Please try again."); break;
                    default: out.print("Operation failed. Please try again.");
                } %>
            </span>
        </div>
        <button onclick="this.parentElement.style.display='none'" class="text-red-600 dark:text-red-400 hover:text-red-800 dark:hover:text-red-200">
            <i class="fas fa-times"></i>
        </button>
    </div>
    <% } %>

    <!-- Action Bar -->
    <div class="reveal bg-white dark:bg-slate-900 rounded-2xl p-6 border border-slate-200 dark:border-slate-800 shadow-soft mb-6">
        <div class="flex flex-col lg:flex-row gap-4 justify-between items-start lg:items-center">
            <div class="flex flex-col sm:flex-row gap-3">
                <a href="<%= request.getContextPath() %>/staff/add" class="focus-ring inline-flex items-center gap-2 px-4 py-2.5 rounded-xl bg-brand-600 hover:bg-brand-700 text-white font-medium shadow-soft transition-colors">
                    <i class="fas fa-user-plus"></i>
                    Add Staff Member
                </a>
                <button onclick="exportToCSV()" class="focus-ring inline-flex items-center gap-2 px-4 py-2.5 rounded-xl border border-slate-300 dark:border-slate-700 hover:shadow-soft transition-all">
                    <i class="fas fa-download"></i>
                    Export CSV
                </button>
            </div>

            <div class="flex flex-col sm:flex-row gap-3 w-full lg:w-auto">
                <div class="relative flex-1 sm:w-80">
                    <input
                        type="text"
                        placeholder="Search staff..."
                        id="searchInput"
                        value="<%= searchTerm != null ? searchTerm : "" %>"
                        class="focus-ring w-full pl-10 pr-10 py-2.5 rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-800 placeholder-slate-500 dark:placeholder-slate-400">
                    <i class="fas fa-search absolute left-3 top-1/2 transform -translate-y-1/2 text-slate-400"></i>
                    <button id="searchClear" class="absolute right-3 top-1/2 transform -translate-y-1/2 text-slate-400 hover:text-slate-600 dark:hover:text-slate-300" style="display: none;">
                        <i class="fas fa-times"></i>
                    </button>
                </div>

                <select id="roleFilter" class="focus-ring px-4 py-2.5 rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-800">
                    <option value="">All Roles</option>
                    <option value="manager" <%= "manager".equals(roleFilter) ? "selected" : "" %>>General Manager</option>
                    <option value="veterinarian" <%= "veterinarian".equals(roleFilter) ? "selected" : "" %>>Veterinarian</option>
                    <option value="pharmacist" <%= "pharmacist".equals(roleFilter) ? "selected" : "" %>>Pharmacist</option>
                    <option value="receptionist" <%= "receptionist".equals(roleFilter) ? "selected" : "" %>>Receptionist</option>
                    <option value="groomer" <%= "groomer".equals(roleFilter) ? "selected" : "" %>>Groomer</option>
                </select>

                <button onclick="clearFilters()" class="focus-ring px-4 py-2.5 rounded-xl border border-slate-300 dark:border-slate-700 hover:shadow-soft transition-all">
                    <i class="fas fa-redo"></i>
                    Reset
                </button>
            </div>
        </div>
    </div>

    <!-- Staff Table -->
    <div class="reveal bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 shadow-soft overflow-hidden">
        <div class="px-6 py-4 border-b border-slate-200 dark:border-slate-800 flex justify-between items-center">
            <div class="text-sm text-slate-600 dark:text-slate-300">
                Showing <strong id="visibleCount"><%= staffList != null ? staffList.size() : 0 %></strong>
                of <strong><%= totalStaffCount != null ? totalStaffCount : 0 %></strong> staff members
            </div>
            <div class="flex items-center gap-2">
                <button class="view-option active p-2 rounded-lg bg-brand-50 dark:bg-brand-900/20 text-brand-600 dark:text-brand-400" data-view="table" title="Table View">
                    <i class="fas fa-table"></i>
                </button>
                <button class="view-option p-2 rounded-lg text-slate-400 hover:bg-slate-100 dark:hover:bg-slate-800" data-view="grid" title="Grid View">
                    <i class="fas fa-th-large"></i>
                </button>
            </div>
        </div>

        <!-- Table View -->
        <div class="view-container table-view active overflow-x-auto">
            <table class="w-full staff-table">
                <thead class="bg-slate-50 dark:bg-slate-800/50">
                <tr>
                    <th class="px-6 py-3 text-left text-xs font-medium text-slate-500 dark:text-slate-400 uppercase tracking-wider cursor-pointer hover:bg-slate-100 dark:hover:bg-slate-700" onclick="sortTable('id')">
                        <div class="flex items-center gap-1">
                            Staff ID
                            <i class="fas fa-sort text-slate-400"></i>
                        </div>
                    </th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-slate-500 dark:text-slate-400 uppercase tracking-wider cursor-pointer hover:bg-slate-100 dark:hover:bg-slate-700" onclick="sortTable('name')">
                        <div class="flex items-center gap-1">
                            Name
                            <i class="fas fa-sort text-slate-400"></i>
                        </div>
                    </th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-slate-500 dark:text-slate-400 uppercase tracking-wider cursor-pointer hover:bg-slate-100 dark:hover:bg-slate-700" onclick="sortTable('role')">
                        <div class="flex items-center gap-1">
                            Role
                            <i class="fas fa-sort text-slate-400"></i>
                        </div>
                    </th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-slate-500 dark:text-slate-400 uppercase tracking-wider">Contact</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-slate-500 dark:text-slate-400 uppercase tracking-wider cursor-pointer hover:bg-slate-100 dark:hover:bg-slate-700" onclick="sortTable('date')">
                        <div class="flex items-center gap-1">
                            Join Date
                            <i class="fas fa-sort text-slate-400"></i>
                        </div>
                    </th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-slate-500 dark:text-slate-400 uppercase tracking-wider">Actions</th>
                </tr>
                </thead>
                <tbody class="divide-y divide-slate-200 dark:divide-slate-800">
                <% if (staffList != null && !staffList.isEmpty()) {
                    for (Staff staff : staffList) { %>
                <tr class="hover:bg-slate-50 dark:hover:bg-slate-800/50 transition-colors animate-fade-in">
                    <td class="px-6 py-4 whitespace-nowrap">
                        <span class="text-sm font-mono text-slate-600 dark:text-slate-300">#<%= String.format("%04d", staff.getStaffId()) %></span>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap">
                        <div class="flex items-center gap-3">
                            <div class="h-8 w-8 rounded-full bg-gradient-to-br from-brand-500 to-blue-600 text-white flex items-center justify-center text-sm font-medium">
                                <%= staff.getFullName().substring(0, 1).toUpperCase() %>
                            </div>
                            <div>
                                <div class="text-sm font-medium text-slate-900 dark:text-white"><%= staff.getFullName() %></div>
                                <div class="text-xs text-slate-500 dark:text-slate-400">ID: #<%= staff.getStaffId() %></div>
                            </div>
                        </div>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap">
                        <span class="role-badge role-<%= staff.getRole().toLowerCase().replace(" ", "-") %>">
                            <i class="fas fa-<%= getRoleIcon(staff.getRole()) %> text-xs"></i>
                            <%= staff.getRole() %>
                        </span>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap">
                        <div class="space-y-1">
                            <a href="mailto:<%= staff.getEmail() %>" class="flex items-center gap-2 text-sm text-slate-600 dark:text-slate-300 hover:text-brand-600 dark:hover:text-brand-400 transition-colors">
                                <i class="fas fa-envelope text-xs"></i>
                                <%= staff.getEmail() %>
                            </a>
                            <a href="tel:<%= staff.getPhone() %>" class="flex items-center gap-2 text-sm text-slate-600 dark:text-slate-300 hover:text-brand-600 dark:hover:text-brand-400 transition-colors">
                                <i class="fas fa-phone text-xs"></i>
                                <%= staff.getPhone() %>
                            </a>
                        </div>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-slate-500 dark:text-slate-400">
                        <i class="far fa-calendar mr-2"></i>
                        <%= staff.getCreatedAt().format(dateTimeFormatter) %>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap">
                        <div class="flex items-center gap-2">
                            <a href="<%= request.getContextPath() %>/staff/management?action=edit&id=<%= staff.getStaffId() %>"
                               class="focus-ring p-2 rounded-lg text-slate-400 hover:text-blue-600 hover:bg-blue-50 dark:hover:bg-blue-900/20 transition-colors"
                               title="Edit">
                                <i class="fas fa-edit"></i>
                            </a>
                            <a href="<%= request.getContextPath() %>/staff/delete?id=<%= staff.getStaffId() %>"
                               class="focus-ring p-2 rounded-lg text-slate-400 hover:text-red-600 hover:bg-red-50 dark:hover:bg-red-900/20 transition-colors"
                               onclick="return confirm('Are you sure you want to delete this staff member?')"
                               title="Delete">
                                <i class="fas fa-trash"></i>
                            </a>
                            <button onclick="showStaffDetails(<%= staff.getStaffId() %>)"
                                    class="focus-ring p-2 rounded-lg text-slate-400 hover:text-emerald-600 hover:bg-emerald-50 dark:hover:bg-emerald-900/20 transition-colors"
                                    title="View Details" type="button">
                                <i class="fas fa-eye"></i>
                            </button>
                        </div>
                    </td>
                </tr>
                <% }
                } else { %>
                <tr class="no-data">
                    <td colspan="6" class="px-6 py-12 text-center">
                        <div class="text-slate-400 dark:text-slate-500">
                            <i class="fas fa-users-slash text-4xl mb-4"></i>
                            <h3 class="text-lg font-medium text-slate-900 dark:text-white mb-2">No Staff Members Found</h3>
                            <p class="mb-4"><%= (searchTerm != null && !searchTerm.isEmpty()) || (roleFilter != null && !roleFilter.isEmpty()) ?
                                    "Try adjusting your search or filter criteria." :
                                    "Get started by adding your first team member." %>
                            </p>
                            <div class="flex gap-3 justify-center">
                                <a href="<%= request.getContextPath() %>/staff/add" class="focus-ring inline-flex items-center gap-2 px-4 py-2 rounded-xl bg-brand-600 hover:bg-brand-700 text-white font-medium shadow-soft transition-colors">
                                    <i class="fas fa-user-plus"></i>
                                    Add Staff Member
                                </a>
                                <% if ((searchTerm != null && !searchTerm.isEmpty()) || (roleFilter != null && !roleFilter.isEmpty())) { %>
                                <button onclick="clearFilters()" class="focus-ring inline-flex items-center gap-2 px-4 py-2 rounded-xl border border-slate-300 dark:border-slate-700 hover:shadow-soft transition-all">
                                    <i class="fas fa-redo"></i>
                                    Clear Filters
                                </button>
                                <% } %>
                            </div>
                        </div>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>

        <!-- Grid View -->
        <div class="view-container grid-view hidden p-6">
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 staff-grid" id="staffGrid">
                <% if (staffList != null && !staffList.isEmpty()) {
                    for (Staff staff : staffList) { %>
                <div class="bg-slate-50 dark:bg-slate-800/30 rounded-xl p-6 border border-slate-200 dark:border-slate-700 hover:shadow-soft transition-all animate-fade-in">
                    <div class="flex items-start justify-between mb-4">
                        <div class="flex items-center gap-3">
                            <div class="h-12 w-12 rounded-xl bg-gradient-to-br from-brand-500 to-blue-600 text-white flex items-center justify-center text-lg font-medium">
                                <%= staff.getFullName().substring(0, 1).toUpperCase() %>
                            </div>
                            <div>
                                <h4 class="font-semibold text-slate-900 dark:text-white"><%= staff.getFullName() %></h4>
                                <p class="text-sm text-slate-500 dark:text-slate-400">#<%= String.format("%04d", staff.getStaffId()) %></p>
                            </div>
                        </div>
                        <div class="flex gap-1">
                            <a href="<%= request.getContextPath() %>/staff/management?action=edit&id=<%= staff.getStaffId() %>"
                               class="focus-ring p-1.5 rounded-lg text-slate-400 hover:text-blue-600 hover:bg-blue-50 dark:hover:bg-blue-900/20 transition-colors" title="Edit">
                                <i class="fas fa-edit text-sm"></i>
                            </a>
                            <a href="<%= request.getContextPath() %>/staff/delete?id=<%= staff.getStaffId() %>"
                               class="focus-ring p-1.5 rounded-lg text-slate-400 hover:text-red-600 hover:bg-red-50 dark:hover:bg-red-900/20 transition-colors"
                               onclick="return confirm('Are you sure you want to delete this staff member?')"
                               title="Delete">
                                <i class="fas fa-trash text-sm"></i>
                            </a>
                        </div>
                    </div>

                    <div class="space-y-3">
                        <div>
                            <span class="role-badge role-<%= staff.getRole().toLowerCase().replace(" ", "-") %>">
                                <i class="fas fa-<%= getRoleIcon(staff.getRole()) %>"></i>
                                <%= staff.getRole() %>
                            </span>
                        </div>

                        <div class="space-y-2 text-sm">
                            <a href="mailto:<%= staff.getEmail() %>" class="flex items-center gap-2 text-slate-600 dark:text-slate-300 hover:text-brand-600 dark:hover:text-brand-400 transition-colors">
                                <i class="fas fa-envelope text-xs"></i>
                                <%= staff.getEmail() %>
                            </a>
                            <a href="tel:<%= staff.getPhone() %>" class="flex items-center gap-2 text-slate-600 dark:text-slate-300 hover:text-brand-600 dark:hover:text-brand-400 transition-colors">
                                <i class="fas fa-phone text-xs"></i>
                                <%= staff.getPhone() %>
                            </a>
                        </div>

                        <div class="pt-3 border-t border-slate-200 dark:border-slate-700 flex justify-between items-center">
                            <span class="text-xs text-slate-500 dark:text-slate-400">
                                <i class="far fa-calendar mr-1"></i>
                                <%= staff.getCreatedAt().format(dateFormatter) %>
                            </span>
                            <button onclick="showStaffDetails(<%= staff.getStaffId() %>)"
                                    class="focus-ring text-xs px-3 py-1.5 rounded-lg border border-slate-300 dark:border-slate-600 hover:shadow-soft transition-all"
                                    type="button">
                                View Details
                            </button>
                        </div>
                    </div>
                </div>
                <% }
                } %>
            </div>
        </div>
    </div>

    <!-- Footer Actions -->
    <div class="reveal mt-6 flex justify-between items-center">
        <div class="text-sm text-slate-600 dark:text-slate-300">
            Showing <strong><%= staffList != null ? staffList.size() : 0 %></strong> entries
        </div>
        <div class="flex gap-3">
            <button onclick="printTable()" class="focus-ring inline-flex items-center gap-2 px-4 py-2 rounded-xl border border-slate-300 dark:border-slate-700 hover:shadow-soft transition-all">
                <i class="fas fa-print"></i>
                Print
            </button>
        </div>
    </div>
</main>

<%@ include file="../common/footer.jsp" %>

<!-- Staff Details Modal -->
<div id="staffModal" class="fixed inset-0 z-50 hidden">
    <div class="absolute inset-0 bg-black/50 backdrop-blur-sm" onclick="closeModal()"></div>
    <div class="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 w-full max-w-md max-h-[90vh] overflow-y-auto">
        <div class="bg-white dark:bg-slate-900 rounded-2xl shadow-xl border border-slate-200 dark:border-slate-700 m-4">
            <div class="flex items-center justify-between p-6 border-b border-slate-200 dark:border-slate-700">
                <h3 class="text-lg font-semibold text-slate-900 dark:text-white">Staff Details</h3>
                <button onclick="closeModal()" class="focus-ring p-2 rounded-lg text-slate-400 hover:text-slate-600 dark:hover:text-slate-300">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <div class="p-6" id="modalBody">
                <!-- Content loaded via JavaScript -->
            </div>
        </div>
    </div>
</div>

<script>
    // Enhanced search with debouncing
    let searchTimeout;
    document.getElementById('searchInput').addEventListener('input', function(e) {
        const searchTerm = e.target.value;
        const searchClear = document.getElementById('searchClear');

        searchClear.style.display = searchTerm ? 'block' : 'none';

        clearTimeout(searchTimeout);
        searchTimeout = setTimeout(() => {
            performSearch(searchTerm);
        }, 300);
    });

    document.getElementById('searchClear').addEventListener('click', function() {
        document.getElementById('searchInput').value = '';
        this.style.display = 'none';
        performSearch('');
    });

    document.getElementById('roleFilter').addEventListener('change', function() {
        applyFilters();
    });

    function performSearch(searchTerm) {
        const roleFilter = document.getElementById('roleFilter').value;
        applyFilters(searchTerm, roleFilter);
    }

    function applyFilters(searchTerm = '', roleFilter = '') {
        const rows = document.querySelectorAll('.staff-table tbody tr:not(.no-data)');
        const cards = document.querySelectorAll('.staff-grid > div');
        let visibleCount = 0;

        rows.forEach(row => {
            const text = row.textContent.toLowerCase();
            const role = row.querySelector('.role-badge')?.textContent.toLowerCase() || '';
            const matchesSearch = text.includes(searchTerm.toLowerCase());
            const matchesRole = !roleFilter || role.includes(roleFilter.toLowerCase());

            if (matchesSearch && matchesRole) {
                row.style.display = '';
                visibleCount++;
            } else {
                row.style.display = 'none';
            }
        });

        cards.forEach(card => {
            const text = card.textContent.toLowerCase();
            const role = card.querySelector('.role-badge')?.textContent.toLowerCase() || '';
            const matchesSearch = text.includes(searchTerm.toLowerCase());
            const matchesRole = !roleFilter || role.includes(roleFilter.toLowerCase());

            card.style.display = (matchesSearch && matchesRole) ? 'block' : 'none';
        });

        document.getElementById('visibleCount').textContent = visibleCount;
    }

    function clearFilters() {
        document.getElementById('searchInput').value = '';
        document.getElementById('roleFilter').value = '';
        document.getElementById('searchClear').style.display = 'none';
        applyFilters();
    }

    function sortTable(column) {
        const currentSort = '<%= sortBy != null ? sortBy : "" %>';
        const currentOrder = '<%= sortOrder != null ? sortOrder : "" %>';
        let newOrder = 'asc';

        if (currentSort === column) {
            newOrder = currentOrder === 'asc' ? 'desc' : 'asc';
        }

        window.location.href = '<%= request.getContextPath() %>/staff/management?sort=' + column + '&order=' + newOrder;
    }

    function confirmDeletion(staffName) {
        return confirm(`Are you sure you want to delete ${staffName}? This action cannot be undone.`);
    }

    // View switching
    document.querySelectorAll('.view-option').forEach(option => {
        option.addEventListener('click', function() {
            const view = this.getAttribute('data-view');

            document.querySelectorAll('.view-option').forEach(opt => {
                opt.classList.toggle('active', opt === this);
                opt.classList.toggle('bg-brand-50', opt === this);
                opt.classList.toggle('dark:bg-brand-900/20', opt === this);
                opt.classList.toggle('text-brand-600', opt === this);
                opt.classList.toggle('dark:text-brand-400', opt === this);
                opt.classList.toggle('text-slate-400', opt !== this);
            });

            document.querySelectorAll('.view-container').forEach(container => {
                container.classList.toggle('hidden', !container.classList.contains(`${view}-view`));
                container.classList.toggle('active', container.classList.contains(`${view}-view`));
            });
        });
    });

    // Modal functions
    function showStaffDetails(staffId) {
        const modal = document.getElementById('staffModal');
        const modalBody = document.getElementById('modalBody');

        modalBody.innerHTML = `
            <div class="text-center py-8">
                <i class="fas fa-spinner fa-spin text-2xl text-brand-600 mb-4"></i>
                <p class="text-slate-600 dark:text-slate-300">Loading staff details...</p>
            </div>
        `;

        modal.classList.remove('hidden');

        setTimeout(() => {
            const randomLetter = String.fromCharCode(65 + Math.floor(Math.random() * 26));
            modalBody.innerHTML = `
                <div class="space-y-4">
                    <div class="text-center">
                        <div class="h-16 w-16 rounded-full bg-gradient-to-br from-brand-500 to-blue-600 text-white flex items-center justify-center text-xl font-medium mx-auto mb-4">
                            ${randomLetter}
                        </div>
                        <h4 class="text-lg font-semibold text-slate-900 dark:text-white">Staff Member #${staffId}</h4>
                    </div>
                    <div class="text-center pt-4">
                        <a href="<%= request.getContextPath() %>/staff/management?action=edit&id=${staffId}" class="focus-ring inline-flex items-center gap-2 px-4 py-2 rounded-xl bg-brand-600 hover:bg-brand-700 text-white font-medium shadow-soft transition-colors">
                            <i class="fas fa-edit"></i> Edit Staff
                        </a>
                    </div>
                </div>
            `;
        }, 1000);
    }

    function closeModal() {
        document.getElementById('staffModal').classList.add('hidden');
    }

    // Export functions
    function exportToCSV() {
        // Get all visible staff rows (not filtered out)
        const visibleRows = Array.from(document.querySelectorAll('.staff-table tbody tr:not(.no-data)'))
            .filter(row => row.style.display !== 'none');
        
        if (visibleRows.length === 0) {
            alert('No staff data to export');
            return;
        }

        // CSV headers
        const headers = ['Staff ID', 'Full Name', 'Role', 'Email', 'Phone', 'Join Date'];
        let csvContent = headers.join(',') + '\n';

        // Extract data from each visible row
        visibleRows.forEach(row => {
            const cells = row.querySelectorAll('td');
            if (cells.length >= 5) {
                // Extract staff ID (remove # and format)
                const staffId = cells[0].textContent.trim().replace('#', '');
                
                // Extract name (from the div structure)
                const nameContainer = cells[1].querySelector('.flex.items-center.gap-3 > div:last-child');
                const nameDiv = nameContainer ? nameContainer.querySelector('.text-sm.font-medium') : null;
                const fullName = nameDiv ? nameDiv.textContent.trim() : '';
                
                // Extract role (from role badge)
                const roleSpan = cells[2].querySelector('.role-badge');
                const role = roleSpan ? roleSpan.textContent.trim() : '';
                
                // Extract email and phone (from contact links)
                const emailLink = cells[3].querySelector('a[href^="mailto:"]');
                const phoneLink = cells[3].querySelector('a[href^="tel:"]');
                const email = emailLink ? emailLink.textContent.trim() : '';
                const phone = phoneLink ? phoneLink.textContent.trim() : '';
                
                // Extract join date (remove calendar icon)
                const joinDate = cells[4].textContent.trim().replace(/^\s*\S+\s*/, ''); // Remove first icon/word
                
                // Escape quotes and commas in data
                const escapeCSV = (str) => {
                    if (str.includes(',') || str.includes('"') || str.includes('\n')) {
                        return '"' + str.replace(/"/g, '""') + '"';
                    }
                    return str;
                };
                
                // Create CSV row
                const row = [
                    escapeCSV(staffId),
                    escapeCSV(fullName),
                    escapeCSV(role),
                    escapeCSV(email),
                    escapeCSV(phone),
                    escapeCSV(joinDate)
                ].join(',');
                
                csvContent += row + '\n';
            }
        });

        // Create and download the file
        const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
        const link = document.createElement('a');
        
        if (link.download !== undefined) {
            // Generate filename with current date
            const today = new Date();
            const dateStr = today.getFullYear() + '-' + 
                          String(today.getMonth() + 1).padStart(2, '0') + '-' + 
                          String(today.getDate()).padStart(2, '0');
            const filename = `staff-export-${dateStr}.csv`;
            
            // Create download link
            const url = URL.createObjectURL(blob);
            link.setAttribute('href', url);
            link.setAttribute('download', filename);
            link.style.visibility = 'hidden';
            
            // Trigger download
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
            
            // Show success message
            alert(`Successfully exported ${visibleRows.length} staff records to ${filename}`);
        } else {
            alert('CSV export is not supported in this browser');
        }
    }

    function printTable() {
        window.print();
    }

    // Initialize on page load
    document.addEventListener('DOMContentLoaded', function() {
        const searchTerm = '<%= searchTerm != null ? searchTerm : "" %>';
        const role = '<%= roleFilter != null ? roleFilter : "" %>';

        if (searchTerm || role) {
            applyFilters(searchTerm, role);
        }

        // Initialize reveal animations
        const observer = new IntersectionObserver(entries => {
            entries.forEach(e => {
                if (e.isIntersecting) e.target.classList.add('visible');
            });
        }, { threshold: 0.08 });

        document.querySelectorAll('.reveal').forEach(el => observer.observe(el));
    });

    // Close modal on escape key
    document.addEventListener('keydown', function(event) {
        if (event.key === 'Escape') {
            closeModal();
        }
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
    const yearEl = document.getElementById('year');
    if (yearEl) yearEl.textContent = new Date().getFullYear();
</script>
</body>
</html>

<%!
    private String getRoleIcon(String role) {
        switch(role.toLowerCase()) {
            case "manager": return "user-tie";
            case "veterinarian": return "user-md";
            case "pharmacist": return "pills";
            case "receptionist": return "headset";
            case "groomer": return "cut";
            default: return "user";
        }
    }
%>

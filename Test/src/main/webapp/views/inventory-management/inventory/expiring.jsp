<%--
    Expiring Products View
    Location: src/main/webapp/WEB-INF/views/inventory/expiring.jsp
--%>
<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Expiring Products - Happy Paws Pet Care</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Sora:wght@400;600;700&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    fontFamily: { sans: ['Inter', 'system-ui', 'sans-serif'], display: ['Sora','Inter','system-ui','sans-serif'] },
                    colors: {
                        brand: {
                            50: '#effaff', 100: '#d7f0ff', 200: '#b2e1ff', 300: '#84cdff', 400: '#53b2ff',
                            500: '#2f97ff', 600: '#1679e6', 700: '#0f5fba', 800: '#0f4c91', 900: '#113e75'
                        }
                    },
                    boxShadow: {
                        soft: '0 10px 30px rgba(0,0,0,.06)',
                        glow: '0 0 0 6px rgba(47,151,255,.10)'
                    }
                }
            },
            darkMode: 'class'
        }
    </script>
    <style>
        .toast {
            min-width: 300px;
            padding: 1rem 1.25rem;
            border-radius: 0.75rem;
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
            display: flex;
            align-items: center;
            gap: 0.75rem;
            animation: slideIn 0.3s ease-out;
            border: 2px solid;
        }
        .toast-success {
            background-color: #f0fdf4;
            border-color: #86efac;
            color: #166534;
        }
        .toast-error {
            background-color: #fef2f2;
            border-color: #fca5a5;
            color: #991b1b;
        }
        @keyframes slideIn {
            from { transform: translateY(100%); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }
        @keyframes slideOut {
            from { transform: translateY(0); opacity: 1; }
            to { transform: translateY(100%); opacity: 0; }
        }
        .toast-icon { flex-shrink: 0; width: 20px; height: 20px; }
        .toast-message { flex: 1; font-weight: 500; font-size: 0.9rem; }
        .toast-close {
            flex-shrink: 0; cursor: pointer; opacity: 0.7;
            background: none; border: none; padding: 0;
            width: 20px; height: 20px;
        }
        .toast-close:hover { opacity: 1; }
    </style>
</head>
<body class="antialiased text-slate-800 dark:text-slate-100 bg-white dark:bg-slate-950">
<!-- Toast Container -->
<div id="toast-container" class="fixed bottom-4 right-4 z-50 space-y-3"></div>
<!-- Include Header -->
<%@ include file="/views/common/header.jsp" %>
<!-- Main Content -->
<main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
    <!-- Page Header -->
    <div class="mb-8">
        <div class="flex items-center gap-3 mb-4">
            <div class="h-10 w-10 rounded-lg bg-red-100 text-red-700 grid place-items-center">
                <svg class="h-5 w-5" viewBox="0 0 24 24" fill="currentColor">
                    <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-2h2v2zm0-4h-2V7h2v6z"/>
                </svg>
            </div>
            <div>
                <h1 class="font-display text-3xl font-bold text-slate-900 dark:text-slate-100">Expiring Products</h1>
                <p class="text-slate-600 dark:text-slate-300">Products expiring soon or already expired</p>
            </div>
        </div>
    </div>
    <!-- Alert Banner -->
    <%
        java.util.List<com.happypaws.petcare.model.Product> products = 
            (java.util.List<com.happypaws.petcare.model.Product>) request.getAttribute("products");
        Integer days = (Integer) request.getAttribute("days");
        if (days == null) days = 30;
        
        if (products != null && !products.isEmpty()) {
    %>
        <div class="mb-6 p-4 bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800 rounded-xl">
            <div class="flex items-center gap-3">
                <svg class="h-5 w-5 text-red-600" viewBox="0 0 24 24" fill="currentColor">
                    <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-2h2v2zm0-4h-2V7h2v6z"/>
                </svg>
                <p class="text-red-800 dark:text-red-200 font-medium">
                    <%= products.size() %> product<%= products.size() > 1 ? "s are" : " is" %> expiring within <%= days %> days
                </p>
            </div>
        </div>
    <% } %>
    <!-- Days Filter -->
    <div class="bg-white dark:bg-slate-900 rounded-xl border border-slate-200 dark:border-slate-800 p-4 mb-6 shadow-soft">
        <form method="get" class="flex flex-wrap gap-4 items-end">
            <div>
                <label for="days" class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2">
                    Expiring Within
                </label>
                <select name="days" id="days" onchange="this.form.submit()"
                        class="border border-slate-300 dark:border-slate-700 rounded-lg px-3 py-2 bg-white dark:bg-slate-800 text-slate-900 dark:text-slate-100">
                    <option value="10" <%= (days != null && days == 10) ? "selected" : "" %>>10 days</option>
                    <option value="30" <%= (days != null && days == 30) ? "selected" : "" %>>30 days</option>
                    <option value="60" <%= (days != null && days == 60) ? "selected" : "" %>>60 days</option>
                    <option value="90" <%= (days != null && days == 90) ? "selected" : "" %>>90 days</option>
                </select>
            </div>
            <div class="flex gap-2">
                <a href="<%= request.getContextPath() %>/inventory/list"
                   class="px-4 py-2 border border-slate-300 dark:border-slate-700 rounded-lg hover:bg-slate-50 dark:hover:bg-slate-800 text-slate-700 dark:text-slate-300">
                    View All Products
                </a>
            </div>
        </form>
    </div>
    <!-- Expiring Products Table -->
    <div class="bg-white dark:bg-slate-900 rounded-xl border border-slate-200 dark:border-slate-800 shadow-soft overflow-hidden">
        <div class="overflow-x-auto">
            <table class="w-full">
                <thead class="bg-slate-50 dark:bg-slate-800/50 border-b border-slate-200 dark:border-slate-800">
                <tr>
                    <th class="px-6 py-4 text-left text-xs font-semibold text-slate-600 dark:text-slate-300 uppercase tracking-wider">Status</th>
                    <th class="px-6 py-4 text-left text-xs font-semibold text-slate-600 dark:text-slate-300 uppercase tracking-wider">Product</th>
                    <th class="px-6 py-4 text-left text-xs font-semibold text-slate-600 dark:text-slate-300 uppercase tracking-wider">Category</th>
                    <th class="px-6 py-4 text-left text-xs font-semibold text-slate-600 dark:text-slate-300 uppercase tracking-wider">Stock</th>
                    <th class="px-6 py-4 text-left text-xs font-semibold text-slate-600 dark:text-slate-300 uppercase tracking-wider">Price</th>
                    <th class="px-6 py-4 text-left text-xs font-semibold text-slate-600 dark:text-slate-300 uppercase tracking-wider">Expiry Date</th>
                    <th class="px-6 py-4 text-right text-xs font-semibold text-slate-600 dark:text-slate-300 uppercase tracking-wider">Actions</th>
                </tr>
                </thead>
                <tbody class="divide-y divide-slate-200 dark:divide-slate-800">
                <%
                    if (products == null || products.isEmpty()) {
                %>
                        <tr>
                            <td colspan="7" class="px-6 py-12 text-center">
                                <svg class="h-16 w-16 mx-auto mb-4 text-emerald-300 dark:text-emerald-600" viewBox="0 0 24 24" fill="currentColor">
                                    <path d="M9 16.2 4.8 12l-1.4 1.4L9 19 21 7l-1.4-1.4z"/>
                                </svg>
                                <p class="text-lg font-medium text-emerald-700 dark:text-emerald-300">No products expiring soon!</p>
                                <p class="text-sm text-slate-600 dark:text-slate-400 mt-1">No items are expiring within <%= days %> days</p>
                                <div class="mt-4">
                                    <a href="<%= request.getContextPath() %>/inventory/list"
                                       class="inline-flex items-center px-4 py-2 rounded-lg bg-brand-600 hover:bg-brand-700 text-white font-medium">
                                        View All Products
                                    </a>
                                </div>
                            </td>
                        </tr>
                <%
                    } else {
                        for (com.happypaws.petcare.model.Product product : products) {
                %>
                            <tr class="hover:bg-slate-50 dark:hover:bg-slate-800/50">
                                <td class="px-6 py-4">
                                    <%
                                        // Check if product is expired
                                        boolean isExpired = false;
                                        if (product.getExpiryDate() != null) {
                                            java.time.LocalDate today = java.time.LocalDate.now();
                                            java.time.LocalDate expiryDate = product.getExpiryDate();
                                            isExpired = expiryDate.isBefore(today);
                                        }
                                        
                                        if (isExpired) {
                                    %>
                                        <span class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-xs font-semibold bg-red-100 text-red-800 dark:bg-red-900/20 dark:text-red-300">
                                            <span class="h-1.5 w-1.5 rounded-full bg-red-600"></span>
                                            Expired
                                        </span>
                                    <%
                                        } else {
                                    %>
                                        <span class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-xs font-semibold bg-amber-100 text-amber-800 dark:bg-amber-900/20 dark:text-amber-300">
                                            <span class="h-1.5 w-1.5 rounded-full bg-amber-600"></span>
                                            Expiring Soon
                                        </span>
                                    <% } %>
                                </td>
                                <td class="px-6 py-4">
                                    <div class="font-medium text-slate-900 dark:text-slate-100"><%= product.getName() %></div>
                                    <div class="text-xs text-slate-500 dark:text-slate-400">ID: #<%= product.getProductId() %></div>
                                </td>
                                <td class="px-6 py-4">
                                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium
                                        <%
                                            String categoryClass = "bg-gray-100 text-gray-800";
                                            if ("Vaccine".equals(product.getCategory())) {
                                                categoryClass = "bg-blue-100 text-blue-800";
                                            } else if ("Medicine".equals(product.getCategory())) {
                                                categoryClass = "bg-green-100 text-green-800";
                                            } else if ("Food".equals(product.getCategory())) {
                                                categoryClass = "bg-purple-100 text-purple-800";
                                            } else if ("Accessory".equals(product.getCategory())) {
                                                categoryClass = "bg-yellow-100 text-yellow-800";
                                            } else if ("Grooming".equals(product.getCategory())) {
                                                categoryClass = "bg-pink-100 text-pink-800";
                                            }
                                        %><%= categoryClass %>">
                                            <%= product.getCategory() %>
                                    </span>
                                </td>
                                <td class="px-6 py-4">
                                    <span class="font-medium
                                        <%
                                            String stockClass = "text-slate-900 dark:text-slate-100";
                                            if (product.getStockQty() <= 5) {
                                                stockClass = "text-red-600";
                                            } else if (product.getStockQty() <= 10) {
                                                stockClass = "text-amber-600";
                                            }
                                        %><%= stockClass %>">
                                            <%= product.getStockQty() %>
                                    </span>
                                    <% if (product.getStockQty() <= 10) { %>
                                        <span class="ml-2 inline-flex items-center px-1.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800">
                                            Low Stock
                                        </span>
                                    <% } %>
                                </td>
                                <td class="px-6 py-4 font-medium text-slate-900 dark:text-slate-100">
                                    LKR <%= java.text.NumberFormat.getInstance().format(product.getUnitPrice()) %>
                                </td>
                                <td class="px-6 py-4">
                                    <span class="<%= isExpired ? "text-red-600 font-semibold" : "text-amber-600" %>">
                                        <%= product.getExpiryDate() != null ? product.getExpiryDate() : "No expiry" %>
                                    </span>
                                    <% if (isExpired) { %>
                                        <div class="text-xs text-red-500 mt-1">Product has expired!</div>
                                    <% } %>
                                </td>
                                <td class="px-6 py-4 text-right">
                                    <a href="<%= request.getContextPath() %>/inventory/edit?id=<%= product.getProductId() %>"
                                       class="inline-flex items-center px-4 py-2 rounded-lg bg-brand-600 hover:bg-brand-700 text-white text-sm font-medium">
                                        <svg class="h-4 w-4 mr-1.5" viewBox="0 0 24 24" fill="currentColor">
                                            <path d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zM20.71 7.04c.39-.39.39-1.02 0-1.41l-2.34-2.34c-.39-.39-1.02-.39-1.41 0l-1.83 1.83 3.75 3.75 1.83-1.83z"/>
                                        </svg>
                                        Edit
                                    </a>
                                </td>
                            </tr>
                <%
                        }
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>
    <!-- Summary Card -->
    <% if (products != null && !products.isEmpty()) { %>
        <div class="mt-6 bg-gradient-to-r from-brand-600 to-brand-700 rounded-xl p-6 text-white">
            <div class="flex flex-col sm:flex-row items-center justify-between gap-4">
                <div>
                    <h3 class="text-xl font-semibold">Need to manage <%= products.size() %> expiring product<%= products.size() > 1 ? "s" : "" %>?</h3>
                    <p class="text-brand-100 mt-1">Update or remove products to keep your inventory safe</p>
                </div>
                <a href="<%= request.getContextPath() %>/inventory/add"
                   class="inline-flex items-center px-4 py-2 rounded-lg bg-white text-brand-700 font-medium hover:bg-brand-50">
                    Add New Products
                </a>
            </div>
        </div>
    <% } %>
</main>
<!-- Include Footer -->
<%@ include file="/views/common/footer.jsp" %>
<script>
    // Toast notification system
    function showToast(message, type = 'success', duration = 3000) {
        const container = document.getElementById('toast-container');
        const toast = document.createElement('div');
        toast.className = 'toast toast-' + type;
        const icons = {
            success: '<svg class="toast-icon" viewBox="0 0 24 24" fill="currentColor"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/></svg>',
            error: '<svg class="toast-icon" viewBox="0 0 24 24" fill="currentColor"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-2h2v2zm0-4h-2V7h2v6z"/></svg>'
        };
        toast.innerHTML = icons[type] +
            '<span class="toast-message">' + message + '</span>' +
            '<button class="toast-close" onclick="this.parentElement.remove()">' +
            '<svg viewBox="0 0 24 24" fill="currentColor">' +
            '<path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/>' +
            '</svg>' +
            '</button>';
        container.appendChild(toast);
        setTimeout(function() {
            toast.style.animation = 'slideOut 0.3s ease-out';
            setTimeout(function() { toast.remove(); }, 300);
        }, duration);
    }
    // Check for session messages on page load
    window.addEventListener('DOMContentLoaded', function() {
        <%
        String successMsg = (String) session.getAttribute("successMessage");
        String errorMsg = (String) session.getAttribute("errorMessage");
        if (successMsg != null) {
            session.removeAttribute("successMessage");
        %>
        showToast('<%= successMsg %>', 'success');
        <%
        } else if (errorMsg != null) {
            session.removeAttribute("errorMessage");
        %>
        showToast('<%= errorMsg %>', 'error');
        <% } %>
    });
</script>
</body>
</html>
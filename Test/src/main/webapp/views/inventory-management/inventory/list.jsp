<%--
    Inventory List View
    Location: src/main/webapp/WEB-INF/views/inventory/list.jsp
--%>
<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Inventory Management - Happy Paws Pet Care</title>
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
    <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 mb-8">
        <div>
            <h1 class="font-display text-3xl font-bold text-slate-900 dark:text-slate-100">Inventory Management</h1>
            <p class="text-slate-600 dark:text-slate-300 mt-1">Manage your product inventory, stock levels, and categories</p>
        </div>
        <div class="flex flex-wrap gap-3">
            <a href="<%= request.getContextPath() %>/inventory/add"
               class="inline-flex items-center justify-center px-4 py-2 rounded-xl bg-brand-600 hover:bg-brand-700 text-white font-medium shadow-soft">
                <svg class="h-4 w-4 mr-2" viewBox="0 0 24 24" fill="currentColor">
                    <path d="M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z"/>
                </svg>
                Add Product
            </a>
            <a href="<%= request.getContextPath() %>/inventory/low-stock"
               class="inline-flex items-center justify-center px-4 py-2 rounded-xl border border-amber-300 text-amber-700 hover:bg-amber-50">
                Low Stock Alerts
            </a>
            <a href="<%= request.getContextPath() %>/inventory/expiring"
               class="inline-flex items-center justify-center px-4 py-2 rounded-xl border border-red-300 text-red-700 hover:bg-red-50">
                Expiring Products
            </a>
        </div>
    </div>

    <!-- Filters -->
    <div class="bg-white dark:bg-slate-900 rounded-xl border border-slate-200 dark:border-slate-800 p-6 mb-6 shadow-soft">
        <form method="get" class="flex flex-wrap gap-4 items-end">
            <div class="flex-1 min-w-[200px]">
                <label for="search" class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2">Search Products</label>
                <input type="text" id="search" name="search"
                       placeholder="Search by name, ID, or category..."
                       class="w-full border border-slate-300 dark:border-slate-700 rounded-lg px-3 py-2 bg-white dark:bg-slate-800 text-slate-900 dark:text-slate-100 focus:ring-2 focus:ring-brand-500 focus:border-brand-500">
            </div>
            <div>
                <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2">Category</label>
                <select name="category" class="border border-slate-300 dark:border-slate-700 rounded-lg px-3 py-2 bg-white dark:bg-slate-800 text-slate-900 dark:text-slate-100">
                    <option value="">All Categories</option>
                    <option value="Vaccine" ${selectedCategory == 'Vaccine' ? 'selected' : ''}>Vaccine</option>
                    <option value="Medicine" ${selectedCategory == 'Medicine' ? 'selected' : ''}>Medicine</option>
                    <option value="Food" ${selectedCategory == 'Food' ? 'selected' : ''}>Food</option>
                    <option value="Accessory" ${selectedCategory == 'Accessory' ? 'selected' : ''}>Accessory</option>
                    <option value="Grooming" ${selectedCategory == 'Grooming' ? 'selected' : ''}>Grooming</option>
                </select>
            </div>
            <div>
                <label for="days" class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2">Expiring Within</label>
                <select name="days" id="days"
                        class="border border-slate-300 dark:border-slate-700 rounded-lg px-3 py-2 bg-white dark:bg-slate-800 text-slate-900 dark:text-slate-100">
                    <option value="">All Products</option>
                    <option value="10" ${selectedDays == 10 ? 'selected' : ''}>10 days</option>
                    <option value="30" ${selectedDays == 30 ? 'selected' : ''}>30 days</option>
                    <option value="60" ${selectedDays == 60 ? 'selected' : ''}>60 days</option>
                    <option value="90" ${selectedDays == 90 ? 'selected' : ''}>90 days</option>
                </select>
            </div>
            <div class="flex gap-2">
                <button type="submit" class="px-4 py-2 bg-brand-600 hover:bg-brand-700 text-white rounded-lg font-medium flex items-center gap-2">
                    <svg class="h-4 w-4" viewBox="0 0 24 24" fill="currentColor">
                        <path d="M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.11 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"/>
                    </svg>
                    Search
                </button>
                <a href="<%= request.getContextPath() %>/inventory/list" class="px-4 py-2 border border-slate-300 dark:border-slate-700 rounded-lg hover:bg-slate-50 dark:hover:bg-slate-800 flex items-center gap-2">
                    <svg class="h-4 w-4" viewBox="0 0 24 24" fill="currentColor">
                        <path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/>
                    </svg>
                    Clear
                </a>
            </div>
        </form>
    </div>

    <!-- Alert Banner for Expiring Products -->
    <%
        java.util.List<com.happypaws.petcare.model.Product> alertProducts = 
            (java.util.List<com.happypaws.petcare.model.Product>) request.getAttribute("products");
        String selectedDays = (String) request.getParameter("days");
        if (alertProducts != null && !alertProducts.isEmpty() && selectedDays != null && !selectedDays.isEmpty()) {
    %>
        <div class="mb-6 p-4 bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800 rounded-xl">
            <div class="flex items-center gap-3">
                <svg class="h-5 w-5 text-red-600" viewBox="0 0 24 24" fill="currentColor">
                    <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-2h2v2zm0-4h-2V7h2v6z"/>
                </svg>
                <p class="text-red-800 dark:text-red-200 font-medium">
                    <%= alertProducts.size() %> product<%= alertProducts.size() > 1 ? "s are" : " is" %> expiring within <%= selectedDays %> days
                </p>
            </div>
        </div>
    <% } %>

    <!-- Products Table -->
    <div class="bg-white dark:bg-slate-900 rounded-xl border border-slate-200 dark:border-slate-800 shadow-soft overflow-hidden">
        <div class="overflow-x-auto">
            <table class="w-full">
                <thead class="bg-slate-50 dark:bg-slate-800/50 border-b border-slate-200 dark:border-slate-800">
                <tr>
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
                    java.util.List<com.happypaws.petcare.model.Product> productsList = 
                        (java.util.List<com.happypaws.petcare.model.Product>) request.getAttribute("products");
                    if (productsList == null || productsList.isEmpty()) { 
                %>
                        <tr>
                            <td colspan="6" class="px-6 py-12 text-center text-slate-500 dark:text-slate-400">
                                <svg class="h-12 w-12 mx-auto mb-4 text-slate-300 dark:text-slate-600" viewBox="0 0 24 24" fill="currentColor">
                                    <path d="M7 4V2C7 1.45 7.45 1 8 1H16C16.55 1 17 1.45 17 2V4H20V6H19V19C19 20.1 18.1 21 17 21H7C5.9 21 5 20.1 5 19V6H4V4H7ZM9 3V4H15V3H9ZM7 6V19H17V6H7Z"/>
                                </svg>
                                <p class="text-lg font-medium">No products found</p>
                                <p class="text-sm">Start by adding your first product to the inventory.</p>
                            </td>
                        </tr>
                    <% } else { %>
                        <%
                            java.util.List<com.happypaws.petcare.model.Product> products = 
                                (java.util.List<com.happypaws.petcare.model.Product>) request.getAttribute("products");
                            if (products != null) {
                                for (com.happypaws.petcare.model.Product product : products) {
                        %>
                            <tr class="hover:bg-slate-50 dark:hover:bg-slate-800/50">
                                <td class="px-6 py-4">
                                    <div class="font-medium text-slate-900 dark:text-slate-100"><%= product.getName() %></div>
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
                                    <% if (product.getExpiryDate() != null) { %>
                                        <span class="text-slate-900 dark:text-slate-100">
                                            <%= product.getExpiryDate() %>
                                        </span>
                                    <% } else { %>
                                        <span class="text-slate-500 dark:text-slate-400">No expiry</span>
                                    <% } %>
                                </td>
                                <td class="px-6 py-4 text-right space-x-2">
                                    <a href="<%= request.getContextPath() %>/inventory/edit?id=<%= product.getProductId() %>"
                                       class="inline-flex items-center px-3 py-1 rounded-lg bg-blue-50 text-blue-700 hover:bg-blue-100 text-sm font-medium">
                                        Edit
                                    </a>
                                    <button onclick="confirmDelete(<%= product.getProductId() %>, '<%= product.getName() %>')"
                                            class="inline-flex items-center px-3 py-1 rounded-lg bg-red-50 text-red-700 hover:bg-red-100 text-sm font-medium">
                                        Delete
                                    </button>
                                </td>
                            </tr>
                        <%
                                }
                            }
                        %>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</main>

<!-- Include Footer -->
<%@ include file="/views/common/footer.jsp" %>

<script>
    function confirmDelete(productId, productName) {
        if (confirm('Are you sure you want to delete "' + productName + '"? This action cannot be undone.')) {
            window.location.href = '<%= request.getContextPath() %>/inventory/delete?id=' + productId;
        }
    }

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
            '<path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.5 19 12 13.41 17.59 19 19 17.59 13.41 12z"/>' +
            '</svg>' +
            '</button>';

        container.appendChild(toast);

        setTimeout(function() {
            toast.style.animation = 'slideOut 0.3s ease-out';
            setTimeout(function() { toast.remove(); }, 300);
        }, duration);
    }

    <!-- Check for session messages on page load -->
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

        // Initialize real-time search
        initializeSearch();
    });

    // Real-time search functionality
    function initializeSearch() {
        const searchInput = document.getElementById('search');
        let searchTimeout;

        // Real-time search with debouncing
        searchInput.addEventListener('input', function() {
            clearTimeout(searchTimeout);
            searchTimeout = setTimeout(() => {
                filterProductsClientSide(this.value);
            }, 300);
        });
    }

    // Client-side product filtering
    function filterProductsClientSide(searchTerm) {
        const rows = document.querySelectorAll('tbody tr');
        let visibleCount = 0;

        searchTerm = searchTerm.toLowerCase().trim();

        rows.forEach(row => {
            // Skip the "no products" row
            if (row.cells.length === 1 && row.cells[0].colSpan > 1) {
                return;
            }

            const productName = row.cells[0]?.textContent?.toLowerCase() || '';
            const category = row.cells[1]?.textContent?.toLowerCase() || '';

            const matches = !searchTerm || 
                           productName.includes(searchTerm) ||
                           category.includes(searchTerm);

            if (matches) {
                row.style.display = '';
                visibleCount++;
            } else {
                row.style.display = 'none';
            }
        });

        // Show message if no results found
        updateNoResultsMessage(visibleCount, searchTerm);
    }

    function updateNoResultsMessage(visibleCount, searchTerm) {
        const tbody = document.querySelector('tbody');
        let noResultsRow = document.getElementById('no-results-row');

        if (visibleCount === 0 && searchTerm) {
            if (!noResultsRow) {
                noResultsRow = document.createElement('tr');
                noResultsRow.id = 'no-results-row';
                noResultsRow.innerHTML = `
                    <td colspan="6" class="px-6 py-12 text-center text-slate-500 dark:text-slate-400">
                        <svg class="h-8 w-8 mx-auto mb-3 text-slate-300 dark:text-slate-600" viewBox="0 0 24 24" fill="currentColor">
                            <path d="M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.11 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"/>
                        </svg>
                        <p class="font-medium">No products match your search</p>
                        <p class="text-sm">Try adjusting your search terms or clear the search to see all products.</p>
                    </td>
                `;
                tbody.appendChild(noResultsRow);
            }
            noResultsRow.style.display = '';
        } else if (noResultsRow) {
            noResultsRow.style.display = 'none';
        }
    }
</script>

</body>
</html>
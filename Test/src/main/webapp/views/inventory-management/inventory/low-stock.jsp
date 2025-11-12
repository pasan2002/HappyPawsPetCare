<%--
    Low Stock Alerts View
    Location: src/main/webapp/WEB-INF/views/inventory/low-stock.jsp
--%>
<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Low Stock Alerts - Happy Paws Pet Care</title>
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
</head>
<body class="antialiased text-slate-800 dark:text-slate-100 bg-white dark:bg-slate-950">

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
                <h1 class="font-display text-3xl font-bold text-slate-900 dark:text-slate-100">Low Stock Alerts</h1>
                <p class="text-slate-600 dark:text-slate-300">Products that need restocking</p>
            </div>
        </div>
    </div>

    <!-- Alert Banner -->
    <%
        java.util.List<com.happypaws.petcare.model.Product> products = 
            (java.util.List<com.happypaws.petcare.model.Product>) request.getAttribute("products");
        Integer threshold = (Integer) request.getAttribute("threshold");
        if (threshold == null) threshold = 10;
        
        if (products != null && !products.isEmpty()) {
    %>
        <div class="mb-6 p-4 bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800 rounded-xl">
            <div class="flex items-center gap-3">
                <svg class="h-5 w-5 text-red-600" viewBox="0 0 24 24" fill="currentColor">
                    <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-2h2v2zm0-4h-2V7h2v6z"/>
                </svg>
                <p class="text-red-800 dark:text-red-200 font-medium">
                    <%= products.size() %> product<%= products.size() > 1 ? "s are" : " is" %> below the stock threshold of <%= threshold %> units
                </p>
            </div>
        </div>
    <% } %>

    <!-- Threshold Filter -->
    <div class="bg-white dark:bg-slate-900 rounded-xl border border-slate-200 dark:border-slate-800 p-4 mb-6 shadow-soft">
        <form method="get" class="flex flex-wrap gap-4 items-end">
            <div>
                <label for="threshold" class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2">
                    Stock Threshold
                </label>
                <select name="threshold" id="threshold" onchange="this.form.submit()"
                        class="border border-slate-300 dark:border-slate-700 rounded-lg px-3 py-2 bg-white dark:bg-slate-800 text-slate-900 dark:text-slate-100">
                    <option value="5" <%= (threshold != null && threshold == 5) ? "selected" : "" %>>5 units or less</option>
                    <option value="10" <%= (threshold != null && threshold == 10) ? "selected" : "" %>>10 units or less</option>
                    <option value="15" <%= (threshold != null && threshold == 15) ? "selected" : "" %>>15 units or less</option>
                    <option value="20" <%= (threshold != null && threshold == 20) ? "selected" : "" %>>20 units or less</option>
                    <option value="30" <%= (threshold != null && threshold == 30) ? "selected" : "" %>>30 units or less</option>
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

    <!-- Low Stock Products -->
    <div class="bg-white dark:bg-slate-900 rounded-xl border border-slate-200 dark:border-slate-800 shadow-soft overflow-hidden">
        <div class="overflow-x-auto">
            <table class="w-full">
                <thead class="bg-slate-50 dark:bg-slate-800/50 border-b border-slate-200 dark:border-slate-800">
                <tr>
                    <th class="px-6 py-4 text-left text-xs font-semibold text-slate-600 dark:text-slate-300 uppercase tracking-wider">Status</th>
                    <th class="px-6 py-4 text-left text-xs font-semibold text-slate-600 dark:text-slate-300 uppercase tracking-wider">Product</th>
                    <th class="px-6 py-4 text-left text-xs font-semibold text-slate-600 dark:text-slate-300 uppercase tracking-wider">Category</th>
                    <th class="px-6 py-4 text-left text-xs font-semibold text-slate-600 dark:text-slate-300 uppercase tracking-wider">Current Stock</th>
                    <th class="px-6 py-4 text-left text-xs font-semibold text-slate-600 dark:text-slate-300 uppercase tracking-wider">Unit Price</th>
                    <th class="px-6 py-4 text-right text-xs font-semibold text-slate-600 dark:text-slate-300 uppercase tracking-wider">Actions</th>
                </tr>
                </thead>
                <tbody class="divide-y divide-slate-200 dark:divide-slate-800">
                <%
                    if (products == null || products.isEmpty()) {
                %>
                        <tr>
                            <td colspan="6" class="px-6 py-12 text-center">
                                <svg class="h-16 w-16 mx-auto mb-4 text-emerald-300 dark:text-emerald-600" viewBox="0 0 24 24" fill="currentColor">
                                    <path d="M9 16.2 4.8 12l-1.4 1.4L9 19 21 7l-1.4-1.4z"/>
                                </svg>
                                <p class="text-lg font-medium text-emerald-700 dark:text-emerald-300">All products are well stocked!</p>
                                <p class="text-sm text-slate-600 dark:text-slate-400 mt-1">No items are below the threshold of <%= threshold %> units</p>
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
                                <!-- Status Indicator -->
                                <td class="px-6 py-4">
                                    <%
                                        if (product.getStockQty() == 0) {
                                    %>
                                            <span class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-xs font-semibold bg-red-100 text-red-800">
                                                <span class="h-1.5 w-1.5 rounded-full bg-red-600"></span>
                                                Out of Stock
                                            </span>
                                    <%
                                        } else if (product.getStockQty() <= 5) {
                                    %>
                                            <span class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-xs font-semibold bg-red-100 text-red-800">
                                                <span class="h-1.5 w-1.5 rounded-full bg-red-600"></span>
                                                Critical
                                            </span>
                                    <%
                                        } else {
                                    %>
                                            <span class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-xs font-semibold bg-amber-100 text-amber-800">
                                                <span class="h-1.5 w-1.5 rounded-full bg-amber-600"></span>
                                                Low
                                            </span>
                                    <% } %>
                                </td>

                                <!-- Product Name -->
                                <td class="px-6 py-4">
                                    <div class="font-medium text-slate-900 dark:text-slate-100"><%= product.getName() %></div>
                                    <div class="text-xs text-slate-500 dark:text-slate-400">ID: #<%= product.getProductId() %></div>
                                </td>

                                <!-- Category -->
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

                                <!-- Current Stock -->
                                <td class="px-6 py-4">
                                        <span class="text-lg font-bold
                                            <%
                                                String stockClass = "text-amber-600 dark:text-amber-500";
                                                if (product.getStockQty() == 0) {
                                                    stockClass = "text-red-700 dark:text-red-400";
                                                } else if (product.getStockQty() <= 5) {
                                                    stockClass = "text-red-600 dark:text-red-500";
                                                }
                                            %><%= stockClass %>">
                                                <%= product.getStockQty() %>
                                        </span>
                                    <span class="text-sm text-slate-500 dark:text-slate-400"> units</span>
                                </td>

                                <!-- Unit Price -->
                                <td class="px-6 py-4 font-medium text-slate-900 dark:text-slate-100">
                                    LKR <%= java.text.NumberFormat.getInstance().format(product.getUnitPrice()) %>
                                </td>

                                <!-- Actions -->
                                <td class="px-6 py-4 text-right">
                                    <a href="<%= request.getContextPath() %>/inventory/edit?id=<%= product.getProductId() %>"
                                       class="inline-flex items-center px-4 py-2 rounded-lg bg-brand-600 hover:bg-brand-700 text-white text-sm font-medium">
                                        <svg class="h-4 w-4 mr-1.5" viewBox="0 0 24 24" fill="currentColor">
                                            <path d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zM20.71 7.04c.39-.39.39-1.02 0-1.41l-2.34-2.34c-.39-.39-1.02-.39-1.41 0l-1.83 1.83 3.75 3.75 1.83-1.83z"/>
                                        </svg>
                                        Restock
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
                    <h3 class="text-xl font-semibold">Need to restock <%= products.size() %> product<%= products.size() > 1 ? "s" : "" %>?</h3>
                    <p class="text-brand-100 mt-1">Update stock levels to keep your inventory healthy</p>
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

</body>
</html>
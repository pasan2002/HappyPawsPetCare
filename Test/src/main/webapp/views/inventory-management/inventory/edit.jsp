<%--
    Edit Product Form View
    Location: src/main/webapp/WEB-INF/views/inventory/edit.jsp
--%>
<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Edit Product - Happy Paws Pet Care</title>
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
<main class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
    <!-- Page Header -->
    <div class="mb-8">
        <nav class="flex items-center gap-2 text-sm text-slate-600 dark:text-slate-300 mb-4">
            <a href="<%= request.getContextPath() %>/inventory/list" class="hover:text-brand-600">Inventory</a>
            <svg class="h-4 w-4" viewBox="0 0 24 24" fill="currentColor">
                <path d="M8.59 16.59L13.17 12L8.59 7.41L10 6L16 12L10 18L8.59 16.59Z"/>
            </svg>
            <span class="text-slate-900 dark:text-slate-100">Edit Product</span>
        </nav>
        <h1 class="font-display text-3xl font-bold text-slate-900 dark:text-slate-100">Edit Product</h1>
        <p class="text-slate-600 dark:text-slate-300 mt-1">Update product information and stock levels</p>
    </div>

    <!-- Edit Product Form -->
    <div class="bg-white dark:bg-slate-900 rounded-xl border border-slate-200 dark:border-slate-800 shadow-soft">
        <div class="p-6 border-b border-slate-200 dark:border-slate-800">
            <h2 class="text-xl font-semibold text-slate-900 dark:text-slate-100">Product Information</h2>
        </div>

        <form method="post" action="<%= request.getContextPath() %>/inventory/edit" class="p-6 space-y-6">
            <!-- Hidden Product ID -->
            <%
                com.happypaws.petcare.model.Product product = 
                    (com.happypaws.petcare.model.Product) request.getAttribute("product");
            %>
            <input type="hidden" name="productId" value="<%= product != null ? product.getProductId() : "" %>">

            <div class="grid md:grid-cols-2 gap-6">
                <!-- Product Name -->
                <div>
                    <label for="name" class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2">
                        Product Name <span class="text-red-500">*</span>
                    </label>
                    <input type="text" id="name" name="name" required
                           value="<%= product != null ? product.getName() : "" %>"
                           class="w-full border border-slate-300 dark:border-slate-700 rounded-lg px-4 py-2 bg-white dark:bg-slate-800 text-slate-900 dark:text-slate-100 focus:ring-2 focus:ring-brand-500 focus:border-brand-500"
                           placeholder="Enter product name">
                </div>

                <!-- Category -->
                <div>
                    <label for="category" class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2">
                        Category <span class="text-red-500">*</span>
                    </label>
                    <select id="category" name="category" required
                            class="w-full border border-slate-300 dark:border-slate-700 rounded-lg px-4 py-2 bg-white dark:bg-slate-800 text-slate-900 dark:text-slate-100 focus:ring-2 focus:ring-brand-500 focus:border-brand-500">
                        <option value="">Select Category</option>
                        <option value="Vaccine" <%= product != null && "Vaccine".equals(product.getCategory()) ? "selected" : "" %>>Vaccine</option>
                        <option value="Medicine" <%= product != null && "Medicine".equals(product.getCategory()) ? "selected" : "" %>>Medicine</option>
                        <option value="Food" <%= product != null && "Food".equals(product.getCategory()) ? "selected" : "" %>>Food</option>
                        <option value="Accessory" <%= product != null && "Accessory".equals(product.getCategory()) ? "selected" : "" %>>Accessory</option>
                        <option value="Grooming" <%= product != null && "Grooming".equals(product.getCategory()) ? "selected" : "" %>>Grooming</option>
                    </select>
                </div>

                <!-- Stock Quantity -->
                <div>
                    <label for="stockQty" class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2">
                        Stock Quantity <span class="text-red-500">*</span>
                    </label>
                    <input type="number" id="stockQty" name="stockQty" required min="0"
                           value="<%= product != null ? product.getStockQty() : "" %>"
                           class="w-full border border-slate-300 dark:border-slate-700 rounded-lg px-4 py-2 bg-white dark:bg-slate-800 text-slate-900 dark:text-slate-100 focus:ring-2 focus:ring-brand-500 focus:border-brand-500"
                           placeholder="Enter quantity">
                    <% if (product != null && product.getStockQty() <= 10) { %>
                        <p class="mt-1 text-xs text-red-600">⚠️ Stock is running low!</p>
                    <% } %>
                </div>

                <!-- Unit Price -->
                <div>
                    <label for="unitPrice" class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2">
                        Unit Price (LKR) <span class="text-red-500">*</span>
                    </label>
                    <input type="number" id="unitPrice" name="unitPrice" required min="0" step="0.01"
                           value="<%= product != null ? product.getUnitPrice() : "" %>"
                           class="w-full border border-slate-300 dark:border-slate-700 rounded-lg px-4 py-2 bg-white dark:bg-slate-800 text-slate-900 dark:text-slate-100 focus:ring-2 focus:ring-brand-500 focus:border-brand-500"
                           placeholder="0.00">
                </div>

                <!-- Expiry Date -->
                <div class="md:col-span-2">
                    <label for="expiryDate" class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2">
                        Expiry Date <span class="text-slate-500">(optional)</span>
                    </label>
                    <input type="date" id="expiryDate" name="expiryDate"
                           value="<%= product != null && product.getExpiryDate() != null ? product.getExpiryDate().toString() : "" %>"
                           class="w-full border border-slate-300 dark:border-slate-700 rounded-lg px-4 py-2 bg-white dark:bg-slate-800 text-slate-900 dark:text-slate-100 focus:ring-2 focus:ring-brand-500 focus:border-brand-500">
                    <p class="mt-1 text-xs text-slate-500 dark:text-slate-400">Leave blank for products without expiry dates</p>
                </div>
            </div>

            <!-- Product Info Display -->
            <div class="p-4 bg-slate-50 dark:bg-slate-800/50 rounded-lg border border-slate-200 dark:border-slate-700">
                <div class="grid grid-cols-2 gap-4 text-sm">
                    <div>
                        <p class="text-slate-600 dark:text-slate-400">Product ID</p>
                        <p class="font-medium text-slate-900 dark:text-slate-100">#<%= product != null ? product.getProductId() : "" %></p>
                    </div>
                    <div>
                        <p class="text-slate-600 dark:text-slate-400">Created At</p>
                        <p class="font-medium text-slate-900 dark:text-slate-100">
                            <%= product != null && product.getCreatedAt() != null ? product.getCreatedAt().toString() : "N/A" %>
                        </p>
                    </div>
                </div>
            </div>

            <!-- Form Actions -->
            <div class="flex flex-col sm:flex-row justify-between gap-3 pt-6 border-t border-slate-200 dark:border-slate-800">
                <button type="button" onclick="confirmDelete()"
                        class="w-full sm:w-auto inline-flex items-center justify-center px-6 py-3 rounded-xl border border-red-300 text-red-700 hover:bg-red-50 dark:hover:bg-red-900/20 font-medium">
                    <svg class="h-4 w-4 mr-2" viewBox="0 0 24 24" fill="currentColor">
                        <path d="M6 19c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V7H6v12zM19 4h-3.5l-1-1h-5l-1 1H5v2h14V4z"/>
                    </svg>
                    Delete Product
                </button>
                <div class="flex gap-3">
                    <a href="<%= request.getContextPath() %>/inventory/list"
                       class="w-full sm:w-auto inline-flex items-center justify-center px-6 py-3 rounded-xl border border-slate-300 dark:border-slate-700 text-slate-700 dark:text-slate-300 hover:bg-slate-50 dark:hover:bg-slate-800 font-medium">
                        Cancel
                    </a>
                    <button type="submit"
                            class="w-full sm:w-auto inline-flex items-center justify-center px-6 py-3 rounded-xl bg-brand-600 hover:bg-brand-700 text-white font-medium shadow-soft">
                        <svg class="h-4 w-4 mr-2" viewBox="0 0 24 24" fill="currentColor">
                            <path d="M17 3H5c-1.11 0-2 .9-2 2v14c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2V7l-4-4zm-5 16c-1.66 0-3-1.34-3-3s1.34-3 3-3 3 1.34 3 3-1.34 3-3 3zm3-10H5V5h10v4z"/>
                        </svg>
                        Update Product
                    </button>
                </div>
            </div>
        </form>
    </div>
</main>

<!-- Include Footer -->
<%@ include file="/views/common/footer.jsp" %>

<script>
    function confirmDelete() {
        <% if (product != null) { %>
            if (confirm('Are you sure you want to delete "<%= product.getName() %>"? This action cannot be undone.')) {
                window.location.href = '<%= request.getContextPath() %>/inventory/delete?id=<%= product.getProductId() %>';
            }
        <% } %>
    }

    // Form validation
    document.querySelector('form').addEventListener('submit', function(e) {
        const stockQty = document.getElementById('stockQty').value;
        const unitPrice = document.getElementById('unitPrice').value;

        if (parseFloat(unitPrice) < 0) {
            e.preventDefault();
            alert('Unit price cannot be negative.');
            return;
        }

        if (parseInt(stockQty) < 0) {
            e.preventDefault();
            alert('Stock quantity cannot be negative.');
            return;
        }
    });
</script>

</body>
</html>
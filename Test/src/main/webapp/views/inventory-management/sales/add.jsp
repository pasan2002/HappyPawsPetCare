<%--
    Add Sale Form View (Scriptlet version)
    Location: src/main/webapp/WEB-INF/views/sales/add.jsp
--%>
<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%@ page import="java.util.*, java.text.*, java.math.*, com.happypaws.petcare.model.SaleItem, com.happypaws.petcare.model.Product" %>
<%
    // Data provided by controller
    @SuppressWarnings("unchecked")
    List<SaleItem> cartItems = (List<SaleItem>) request.getAttribute("cartItems");
    BigDecimal total = (BigDecimal) request.getAttribute("total");

    @SuppressWarnings("unchecked")
    List<Product> products = (List<Product>) request.getAttribute("products");

    String searchQuery = (String) request.getAttribute("searchQuery");
    DecimalFormat moneyFmt = new DecimalFormat("#,##0.00");
%>
<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Add Sale - Happy Paws Pet Care</title>
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
                    boxShadow: { soft:'0 10px 30px rgba(0,0,0,.06)', glow:'0 0 0 6px rgba(47,151,255,.10)' }
                }
            },
            darkMode: 'class'
        }
    </script>
    <style>
        .toast { min-width:300px; padding:1rem 1.25rem; border-radius:.75rem; box-shadow:0 10px 30px rgba(0,0,0,0.15); display:flex; align-items:center; gap:.75rem; animation:slideIn .3s ease-out; border:2px solid; }
        .toast-success { background:#f0fdf4; border-color:#86efac; color:#166534; }
        .toast-error { background:#fef2f2; border-color:#fca5a5; color:#991b1b; }
        @keyframes slideIn { from{ transform:translateY(100%); opacity:0 } to{ transform:translateY(0); opacity:1 } }
        @keyframes slideOut { from{ transform:translateY(0); opacity:1 } to{ transform:translateY(100%); opacity:0 } }
        .toast-icon{ width:20px; height:20px; }
        .toast-message{ flex:1; font-weight:500; font-size:.9rem; }
        .toast-close{ cursor:pointer; opacity:.7; background:none; border:0; width:20px; height:20px; }
        .toast-close:hover{ opacity:1; }
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
        <nav class="flex items-center gap-2 text-sm text-slate-600 dark:text-slate-300 mb-4">
            <a href="<%= request.getContextPath() %>/sales/add" class="hover:text-brand-600">Sales</a>
            <svg class="h-4 w-4" viewBox="0 0 24 24" fill="currentColor">
                <path d="M8.59 16.59L13.17 12L8.59 7.41L10 6L16 12L10 18L8.59 16.59Z"/>
            </svg>
            <span class="text-slate-900 dark:text-slate-100">Add New Sale</span>
        </nav>
        <h1 class="font-display text-3xl font-bold text-slate-900 dark:text-slate-100">Add New Sale</h1>
        <p class="text-slate-600 dark:text-slate-300 mt-1">Process in-shop customer purchase</p>
    </div>

    <!-- Add Item to Sale Form -->
    <div class="bg-white dark:bg-slate-900 rounded-xl border border-slate-200 dark:border-slate-800 shadow-soft mb-8">
        <div class="p-6 border-b border-slate-200 dark:border-slate-800">
            <h2 class="text-xl font-semibold text-slate-900 dark:text-slate-100">Add Item to Sale</h2>
        </div>
        <form method="post" action="<%= request.getContextPath() %>/sales/addItem" class="p-6 grid md:grid-cols-4 gap-6">
            <div>
                <label for="productId" class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2">Product ID <span class="text-red-500">*</span></label>
                <input type="number" id="productId" name="productId" required min="1"
                       class="w-full border border-slate-300 dark:border-slate-700 rounded-lg px-4 py-2 bg-white dark:bg-slate-800 text-slate-900 dark:text-slate-100 focus:ring-2 focus:ring-brand-500 focus:border-brand-500"
                       placeholder="Enter ID">
            </div>
            <div>
                <label for="productName" class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2">Name</label>
                <input type="text" id="productName" readonly
                       class="w-full border border-slate-300 dark:border-slate-700 rounded-lg px-4 py-2 bg-slate-100 dark:bg-slate-700 text-slate-900 dark:text-slate-100">
            </div>
            <div>
                <label for="unitPrice" class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2">Price (LKR)</label>
                <input type="text" id="unitPrice" readonly
                       class="w-full border border-slate-300 dark:border-slate-700 rounded-lg px-4 py-2 bg-slate-100 dark:bg-slate-700 text-slate-900 dark:text-slate-100">
            </div>
            <div>
                <label for="quantity" class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2">Quantity <span class="text-red-500">*</span></label>
                <input type="number" id="quantity" name="quantity" required min="1"
                       class="w-full border border-slate-300 dark:border-slate-700 rounded-lg px-4 py-2 bg-white dark:bg-slate-800 text-slate-900 dark:text-slate-100 focus:ring-2 focus:ring-brand-500 focus:border-brand-500"
                       placeholder="Enter qty">
            </div>
            <div class="md:col-span-4 flex justify-end">
                <button type="submit" class="px-6 py-3 rounded-xl bg-brand-600 hover:bg-brand-700 text-white font-medium shadow-soft">
                    Add Item
                </button>
            </div>
        </form>
    </div>

    <!-- Sale Cart Table -->
    <div class="bg-white dark:bg-slate-900 rounded-xl border border-slate-200 dark:border-slate-800 shadow-soft mb-8">
        <div class="p-6 border-b border-slate-200 dark:border-slate-800">
            <h2 class="text-xl font-semibold text-slate-900 dark:text-slate-100">Sale Cart</h2>
        </div>
        <div class="overflow-x-auto">
            <table class="w-full">
                <thead class="bg-slate-50 dark:bg-slate-800/50 border-b border-slate-200 dark:border-slate-800">
                <tr>
                    <th class="px-6 py-4 text-left text-xs font-semibold text-slate-600 dark:text-slate-300 uppercase tracking-wider">Product</th>
                    <th class="px-6 py-4 text-left text-xs font-semibold text-slate-600 dark:text-slate-300 uppercase tracking-wider">Quantity</th>
                    <th class="px-6 py-4 text-left text-xs font-semibold text-slate-600 dark:text-slate-300 uppercase tracking-wider">Price</th>
                    <th class="px-6 py-4 text-left text-xs font-semibold text-slate-600 dark:text-slate-300 uppercase tracking-wider">Subtotal</th>
                    <th class="px-6 py-4 text-right text-xs font-semibold text-slate-600 dark:text-slate-300 uppercase tracking-wider">Actions</th>
                </tr>
                </thead>
                <tbody class="divide-y divide-slate-200 dark:divide-slate-800">
                <%
                    if (cartItems != null && !cartItems.isEmpty()) {
                        for (int i = 0; i < cartItems.size(); i++) {
                            SaleItem item = cartItems.get(i);
                %>
                    <tr>
                        <td class="px-6 py-4"><%= item.getProductName() %> (#<%= item.getProductId() %>)</td>
                        <td class="px-6 py-4"><%= item.getQuantity() %></td>
                        <td class="px-6 py-4">LKR <%= moneyFmt.format(item.getUnitPrice()) %></td>
                        <td class="px-6 py-4">LKR <%= moneyFmt.format(item.getSubtotal()) %></td>
                        <td class="px-6 py-4 text-right">
                            <a href="<%= request.getContextPath() %>/sales/removeItem?index=<%= i %>"
                               class="text-red-600 hover:text-red-800 font-medium">Delete</a>
                        </td>
                    </tr>
                <%
                        }
                    } else {
                %>
                    <tr><td colspan="5" class="px-6 py-4 text-center text-slate-600 dark:text-slate-300">Cart is empty</td></tr>
                <%
                    }
                %>
                </tbody>
                <tfoot>
                <tr class="border-t border-slate-200 dark:border-slate-800">
                    <td colspan="4" class="px-6 py-4 text-right font-semibold">Total:</td>
                    <td class="px-6 py-4 font-bold">LKR <%= (total != null) ? moneyFmt.format(total) : "0.00" %></td>
                </tr>
                </tfoot>
            </table>
        </div>
        <div class="p-6 flex justify-end">
            <form method="post" action="<%= request.getContextPath() %>/sales/complete">
                <button type="submit" class="px-6 py-3 rounded-xl bg-emerald-600 hover:bg-emerald-700 text-white font-medium shadow-soft">
                    Complete Sale
                </button>
            </form>
        </div>
    </div>

    <!-- Search Inventory Section -->
    <div class="bg-white dark:bg-slate-900 rounded-xl border border-slate-200 dark:border-slate-800 shadow-soft">
        <div class="p-6 border-b border-slate-200 dark:border-slate-800">
            <h2 class="text-xl font-semibold text-slate-900 dark:text-slate-100">Search Inventory</h2>
            <p class="text-sm text-slate-600 dark:text-slate-300">Search products by name to find IDs</p>
        </div>
        <div class="p-6">
            <form method="get" action="<%= request.getContextPath() %>/sales/add" class="mb-6">
                <div class="flex gap-3">
                    <input type="text" id="searchInput" name="search" value="<%= (searchQuery != null) ? searchQuery : "" %>" placeholder="Search by product name, category, or ID"
                           class="flex-1 border border-slate-300 dark:border-slate-700 rounded-lg px-4 py-2 bg-white dark:bg-slate-800 text-slate-900 dark:text-slate-100 focus:ring-2 focus:ring-brand-500 focus:border-brand-500">
                    <button type="submit" class="px-6 py-2 rounded-lg bg-brand-600 hover:bg-brand-700 text-white font-medium">
                        Search
                    </button>
                    <button type="button" onclick="clearSearch()" class="px-4 py-2 rounded-lg border border-slate-300 dark:border-slate-700 hover:bg-slate-50 dark:hover:bg-slate-800 text-slate-700 dark:text-slate-300">
                        Clear
                    </button>
                </div>
            </form>

            <!-- Inventory Table (with expiry date) -->
            <div class="overflow-x-auto">
                <table class="w-full" id="productTable">
                    <thead class="bg-slate-50 dark:bg-slate-800/50 border-b border-slate-200 dark:border-slate-800">
                    <tr>
                        <th class="px-6 py-4 text-left text-xs font-semibold text-slate-600 dark:text-slate-300 uppercase tracking-wider">ID</th>
                        <th class="px-6 py-4 text-left text-xs font-semibold text-slate-600 dark:text-slate-300 uppercase tracking-wider">Name</th>
                        <th class="px-6 py-4 text-left text-xs font-semibold text-slate-600 dark:text-slate-300 uppercase tracking-wider">Category</th>
                        <th class="px-6 py-4 text-left text-xs font-semibold text-slate-600 dark:text-slate-300 uppercase tracking-wider">Stock</th>
                        <th class="px-6 py-4 text-left text-xs font-semibold text-slate-600 dark:text-slate-300 uppercase tracking-wider">Price (LKR)</th>
                        <th class="px-6 py-4 text-left text-xs font-semibold text-slate-600 dark:text-slate-300 uppercase tracking-wider">Expiry Date</th>
                        <th class="px-6 py-4 text-left text-xs font-semibold text-slate-600 dark:text-slate-300 uppercase tracking-wider">Actions</th>
                    </tr>
                    </thead>
                    <tbody class="divide-y divide-slate-200 dark:divide-slate-800" id="productTableBody">
                    <%
                        if (products != null && !products.isEmpty()) {
                            for (Product product : products) {
                    %>
                        <tr class="hover:bg-slate-50 dark:hover:bg-slate-800/50 product-row" 
                            data-product-id="<%= product.getProductId() %>"
                            data-product-name="<%= product.getName().toLowerCase() %>"
                            data-product-category="<%= product.getCategory().toLowerCase() %>">
                            <td class="px-6 py-4 font-medium text-slate-900 dark:text-slate-100"><%= product.getProductId() %></td>
                            <td class="px-6 py-4"><%= product.getName() %></td>
                            <td class="px-6 py-4"><%= product.getCategory() %></td>
                            <td class="px-6 py-4">
                                <span class="<%= product.getStockQty() <= 5 ? "text-red-600 font-semibold" : "" %>">
                                    <%= product.getStockQty() %>
                                </span>
                            </td>
                            <td class="px-6 py-4">LKR <%= moneyFmt.format(product.getUnitPrice()) %></td>
                            <td class="px-6 py-4">
                                <%
                                    String exp = product.getFormattedExpiryDate();
                                    out.print(exp != null ? exp : "No expiry");
                                %>
                            </td>
                            <td class="px-6 py-4">
                                <button onclick="selectProduct(<%= product.getProductId() %>, '<%= product.getName().replace("'", "\\'") %>', <%= product.getUnitPrice() %>)"
                                        class="px-3 py-1 rounded-lg bg-brand-600 hover:bg-brand-700 text-white text-sm font-medium">
                                    Select
                                </button>
                            </td>
                        </tr>
                    <%
                            }
                        } else {
                    %>
                        <tr id="noProductsRow"><td colspan="7" class="px-6 py-4 text-center text-slate-600 dark:text-slate-300">No products found</td></tr>
                    <%
                        }
                    %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</main>

<!-- Include Footer -->
<%@ include file="/views/common/footer.jsp" %>

<script>
    // Auto-fill product name and price on ID change
    document.getElementById('productId').addEventListener('change', function() {
        const id = this.value;
        console.log('Product ID changed to:', id);
        if (id) {
            const base = '<%= request.getContextPath() %>';
            const url = `${base}/sales/api/product?id=${id}`;
            console.log('Fetching from URL:', url);
            
            fetch(url)
                .then(response => {
                    console.log('Response status:', response.status);
                    if (!response.ok) {
                        throw new Error(`HTTP error! status: ${response.status}`);
                    }
                    return response.json();
                })
                .then(product => {
                    console.log('Product received:', product);
                    console.log('Product structure:', JSON.stringify(product, null, 2));
                    if (product && !product.error) {
                        console.log('Product name:', product.name);
                        console.log('Product unitPrice:', product.unitPrice);
                        console.log('Product unit_price:', product.unit_price);
                        document.getElementById('productName').value = product.name || '';
                        document.getElementById('unitPrice').value = product.unitPrice || product.unit_price || '';
                        console.log('Fields updated with name:', product.name, 'price:', (product.unitPrice || product.unit_price));
                    } else {
                        console.error('Product error:', product);
                        alert('Product not found: ' + (product.error || 'Unknown error'));
                        document.getElementById('productName').value = '';
                        document.getElementById('unitPrice').value = '';
                    }
                })
                .catch(error => {
                    console.error('Error fetching product:', error);
                    alert('Error fetching product: ' + error.message);
                    document.getElementById('productName').value = '';
                    document.getElementById('unitPrice').value = '';
                });
        } else {
            document.getElementById('productName').value = '';
            document.getElementById('unitPrice').value = '';
        }
    });

    // Toast notifications
    function showToast(message, type = 'success', duration = 3000) {
        const container = document.getElementById('toast-container');
        const toast = document.createElement('div');
        toast.className = 'toast toast-' + type;
        const icons = {
            success: '<svg class="toast-icon" viewBox="0 0 24 24" fill="currentColor"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/></svg>',
            error:   '<svg class="toast-icon" viewBox="0 0 24 24" fill="currentColor"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-2h2v2zm0-4h-2V7h2v6z"/></svg>'
        };
        toast.innerHTML = icons[type] +
            '<span class="toast-message">' + message + '</span>' +
            '<button class="toast-close" onclick="this.parentElement.remove()">' +
            '<svg viewBox="0 0 24 24" fill="currentColor"><path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/></svg>' +
            '</button>';
        container.appendChild(toast);
        setTimeout(function() {
            toast.style.animation = 'slideOut 0.3s ease-out';
            setTimeout(function() { toast.remove(); }, 300);
        }, duration);
    }

    // Session messages on load
    window.addEventListener('DOMContentLoaded', function() {
        <% 
            String successMsg = (String) session.getAttribute("successMessage");
            String errorMsg   = (String) session.getAttribute("errorMessage");
            if (successMsg != null) { session.removeAttribute("successMessage"); 
        %>
        showToast('<%= successMsg.replace("'", "\\'") %>', 'success');
        <% } else if (errorMsg != null) { session.removeAttribute("errorMessage"); %>
        showToast('<%= errorMsg.replace("'", "\\'") %>', 'error');
        <% } %>
        
        // Initialize real-time search
        initializeSearch();
    });

    // Enhanced search functionality
    function initializeSearch() {
        const searchInput = document.getElementById('searchInput');
        let searchTimeout;

        // Real-time search with debouncing
        searchInput.addEventListener('input', function() {
            clearTimeout(searchTimeout);
            searchTimeout = setTimeout(() => {
                filterProducts(this.value);
            }, 300);
        });
    }

    // Client-side product filtering
    function filterProducts(searchTerm) {
        const rows = document.querySelectorAll('.product-row');
        const noProductsRow = document.getElementById('noProductsRow');
        let visibleCount = 0;

        searchTerm = searchTerm.toLowerCase().trim();

        rows.forEach(row => {
            const productId = row.getAttribute('data-product-id');
            const productName = row.getAttribute('data-product-name');
            const productCategory = row.getAttribute('data-product-category');

            const matches = !searchTerm || 
                           productId.includes(searchTerm) ||
                           productName.includes(searchTerm) ||
                           productCategory.includes(searchTerm);

            if (matches) {
                row.style.display = '';
                visibleCount++;
            } else {
                row.style.display = 'none';
            }
        });

        // Show/hide no results message
        if (noProductsRow) {
            if (visibleCount === 0 && searchTerm) {
                noProductsRow.style.display = '';
                noProductsRow.innerHTML = '<td colspan="7" class="px-6 py-4 text-center text-slate-600 dark:text-slate-300">No products match your search</td>';
            } else {
                noProductsRow.style.display = 'none';
            }
        }
    }

    // Clear search function
    function clearSearch() {
        document.getElementById('searchInput').value = '';
        filterProducts('');
    }

    // Select product function for quick selection
    function selectProduct(productId, productName, unitPrice) {
        document.getElementById('productId').value = productId;
        document.getElementById('productName').value = productName;
        document.getElementById('unitPrice').value = unitPrice;
        document.getElementById('quantity').focus();
        showToast('Product selected: ' + productName, 'success', 2000);
    }
</script>

</body>
</html>

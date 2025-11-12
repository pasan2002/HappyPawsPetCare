<%--
    Sales Reports View (Scriptlet version)
    Location: src/main/webapp/WEB-INF/views/sales/reports.jsp
--%>
<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%@ page import="java.util.*, java.text.*, com.happypaws.petcare.model.Sale" %>
<%
    // Pull attributes the controller set
    String startDate = (String) request.getAttribute("startDate");
    String endDate   = (String) request.getAttribute("endDate");

    // Totals (could be BigDecimal/Double/etc.)
    Object totalAllObj   = request.getAttribute("totalAll");
    Object totalTodayObj = request.getAttribute("totalToday");
    Object totalMonthObj = request.getAttribute("totalMonth");

    // Sales list
    @SuppressWarnings("unchecked")
    List<Sale> sales = (List<Sale>) request.getAttribute("sales");

    // Number formatter to mimic <fmt:formatNumber pattern="#,##0.00">
    DecimalFormat moneyFmt = new DecimalFormat("#,##0.00");
%>
<%!
    String fmt(Object n) {
        DecimalFormat moneyFmt = new DecimalFormat("#,##0.00");
        if (n == null) return "0.00";
        if (n instanceof Number) return moneyFmt.format(((Number)n).doubleValue());
        try { return moneyFmt.format(Double.parseDouble(n.toString())); } catch (Exception e) { return "0.00"; }
    }
%>
<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Sales Reports - Happy Paws Pet Care</title>
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
                    boxShadow: { soft: '0 10px 30px rgba(0,0,0,.06)', glow: '0 0 0 6px rgba(47,151,255,.10)' }
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
            <span class="text-slate-900 dark:text-slate-100">Reports</span>
        </nav>
        <h1 class="font-display text-3xl font-bold text-slate-900 dark:text-slate-100">Sales Reports</h1>
        <p class="text-slate-600 dark:text-slate-300 mt-1">View sales history and summaries</p>
    </div>

    <!-- Date Range Filter -->
    <div class="bg-white dark:bg-slate-900 rounded-xl border border-slate-200 dark:border-slate-800 shadow-soft mb-8">
        <div class="p-6 border-b border-slate-200 dark:border-slate-800">
            <h2 class="text-xl font-semibold text-slate-900 dark:text-slate-100">Filter Sales</h2>
            <p class="text-sm text-slate-600 dark:text-slate-300">Select date range to filter sales</p>
        </div>
        <form method="get" action="<%= request.getContextPath() %>/sales/reports" class="p-6 grid md:grid-cols-4 gap-6">
            <div>
                <label for="startDate" class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2">Start Date</label>
                <input type="date" id="startDate" name="startDate" value="<%= startDate != null ? startDate : "" %>"
                       class="w-full border border-slate-300 dark:border-slate-700 rounded-lg px-4 py-2 bg-white dark:bg-slate-800 text-slate-900 dark:text-slate-100 focus:ring-2 focus:ring-brand-500 focus:border-brand-500">
            </div>
            <div>
                <label for="endDate" class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2">End Date</label>
                <input type="date" id="endDate" name="endDate" value="<%= endDate != null ? endDate : "" %>"
                       class="w-full border border-slate-300 dark:border-slate-700 rounded-lg px-4 py-2 bg-white dark:bg-slate-800 text-slate-900 dark:text-slate-100 focus:ring-2 focus:ring-brand-500 focus:border-brand-500">
            </div>
            <div class="flex items-end gap-3">
                <button type="submit" class="px-6 py-2 rounded-lg bg-brand-600 hover:bg-brand-700 text-white font-medium">
                    Apply Filter
                </button>
                <button type="button" onclick="window.location.href='<%= request.getContextPath() %>/sales/clear'"
                        class="px-6 py-2 rounded-lg bg-slate-600 hover:bg-slate-700 text-white font-medium">
                    Clear Filters
                </button>
            </div>
        </form>
    </div>

    <!-- Summaries -->
    <div class="grid md:grid-cols-3 gap-6 mb-8">
        <div class="bg-white dark:bg-slate-900 rounded-xl border border-slate-200 dark:border-slate-800 p-6 shadow-soft">
            <h3 class="text-lg font-semibold text-slate-900 dark:text-slate-100">Total Sales (Filtered)</h3>
            <p class="text-3xl font-bold text-brand-600 mt-2">LKR <%= fmt(totalAllObj) %></p>
        </div>
        <div class="bg-white dark:bg-slate-900 rounded-xl border border-slate-200 dark:border-slate-800 p-6 shadow-soft">
            <h3 class="text-lg font-semibold text-slate-900 dark:text-slate-100">Total Sales Today</h3>
            <p class="text-3xl font-bold text-brand-600 mt-2">LKR <%= fmt(totalTodayObj) %></p>
        </div>
        <div class="bg-white dark:bg-slate-900 rounded-xl border border-slate-200 dark:border-slate-800 p-6 shadow-soft">
            <h3 class="text-lg font-semibold text-slate-900 dark:text-slate-100">Total Sales This Month</h3>
            <p class="text-3xl font-bold text-brand-600 mt-2">LKR <%= fmt(totalMonthObj) %></p>
        </div>
    </div>

    <!-- Sales Table -->
    <div class="bg-white dark:bg-slate-900 rounded-xl border border-slate-200 dark:border-slate-800 shadow-soft overflow-hidden">
        <div class="p-6 border-b border-slate-200 dark:border-slate-800">
            <h2 class="text-xl font-semibold text-slate-900 dark:text-slate-100">Sales History</h2>
            <!-- Export to CSV button -->
            <div class="mt-4">
                <form method="get" action="<%= request.getContextPath() %>/sales/export">
                    <input type="hidden" name="startDate" value="<%= startDate != null ? startDate : "" %>">
                    <input type="hidden" name="endDate" value="<%= endDate != null ? endDate : "" %>">
                    <button type="submit" class="px-4 py-2 rounded-lg bg-green-600 hover:bg-green-700 text-white font-medium">
                        Export to CSV
                    </button>
                </form>
            </div>
        </div>
        <div class="overflow-x-auto">
            <table class="w-full">
                <thead class="bg-slate-50 dark:bg-slate-800/50 border-b border-slate-200 dark:border-slate-800">
                <tr>
                    <th class="px-6 py-4 text-left text-xs font-semibold text-slate-600 dark:text-slate-300 uppercase tracking-wider">Sale ID</th>
                    <th class="px-6 py-4 text-left text-xs font-semibold text-slate-600 dark:text-slate-300 uppercase tracking-wider">Date</th>
                    <th class="px-6 py-4 text-left text-xs font-semibold text-slate-600 dark:text-slate-300 uppercase tracking-wider">Total (LKR)</th>
                    <th class="px-6 py-4 text-right text-xs font-semibold text-slate-600 dark:text-slate-300 uppercase tracking-wider">Actions</th>
                </tr>
                </thead>
                <tbody class="divide-y divide-slate-200 dark:divide-slate-800">
                <%
                    if (sales != null && !sales.isEmpty()) {
                    for (Sale sale : sales) {
                %>
                <tr class="hover:bg-slate-50 dark:hover:bg-slate-800/50">
                    <td class="px-6 py-4">#<%= sale.getSaleId() %></td>
                    <td class="px-6 py-4"><%= sale.getFormattedSaleDate() %></td>
                    <td class="px-6 py-4 font-medium"><%= fmt(sale.getTotalAmount()) %></td>
                    <td class="px-6 py-4 text-right">
                        <button onclick="viewSaleItems(<%= sale.getSaleId() %>)" class="text-brand-600 hover:text-brand-700 font-medium">
                            View Items
                        </button>
                    </td>
                </tr>
                <tr id="items-<%= sale.getSaleId() %>" class="hidden">
                    <td colspan="4" class="px-6 py-4 bg-slate-50 dark:bg-slate-800/50">
                        <table class="w-full">
                            <thead>
                            <tr>
                                <th class="text-left text-sm font-medium px-4 py-2">Product ID</th>
                                <th class="text-left text-sm font-medium px-4 py-2">Product Name</th>
                                <th class="text-left text-sm font-medium px-4 py-2">Quantity</th>
                                <th class="text-left text-sm font-medium px-4 py-2">Unit Price (LKR)</th>
                                <th class="text-left text-sm font-medium px-4 py-2">Subtotal (LKR)</th>
                            </tr>
                            </thead>
                            <tbody id="items-body-<%= sale.getSaleId() %>" class="divide-y divide-slate-200 dark:divide-slate-800">
                            <!-- Items loaded via JS -->
                            </tbody>
                        </table>
                    </td>
                </tr>
                <%
                    }
                    } else {
                %>
                <tr><td colspan="4" class="px-6 py-4 text-center text-slate-600 dark:text-slate-300">No sales found</td></tr>
                <%
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>
</main>

<!-- Include Footer -->
<%@ include file="/views/common/footer.jsp" %>

<script>
    function viewSaleItems(saleId) {
        const row = document.getElementById(`items-${saleId}`);
        const body = document.getElementById(`items-body-${saleId}`);
        if (!row || !body) {
            showToast('Error: Unable to load items (element not found)', 'error');
            return;
        }

        if (row.classList.contains('hidden')) {
            const contextPath = '<%= request.getContextPath() %>';
            fetch(`${contextPath}/sales/api/sale-items?saleId=${saleId}`, { method: 'GET', headers: { 'Accept': 'application/json' } })
                .then(r => { if (!r.ok) throw new Error(`HTTP error! status: ${r.status}`); return r.json(); })
                .then(items => {
                    body.innerHTML = '';
                    if (!items || items.length === 0) {
                        body.innerHTML = '<tr><td colspan="5" class="px-4 py-2 text-center text-slate-600 dark:text-slate-300">No items found for this sale</td></tr>';
                    } else {
                        items.forEach(item => {
                            body.innerHTML += `
                                <tr>
                                    <td class="px-4 py-2">${item.productId || 'N/A'}</td>
                                    <td class="px-4 py-2">${item.productName || 'Unknown'}</td>
                                    <td class="px-4 py-2">${item.quantity || '0'}</td>
                                    <td class="px-4 py-2">${(item.unitPrice && item.unitPrice.toFixed) ? item.unitPrice.toFixed(2) : '0.00'}</td>
                                    <td class="px-4 py-2">${(item.subtotal && item.subtotal.toFixed) ? item.subtotal.toFixed(2) : '0.00'}</td>
                                </tr>`;
                        });
                    }
                    row.classList.remove('hidden');
                })
                .catch(err => showToast('Error loading sale items: ' + err.message, 'error'));
        } else {
            row.classList.add('hidden');
        }
    }

    function showToast(message, type = 'success', duration = 3000) {
        const container = document.getElementById('toast-container');
        const toast = document.createElement('div');
        toast.className = 'toast toast-' + type;
        const icons = {
            success: '<svg class="toast-icon" viewBox="0 0 24 24" fill="currentColor"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/></svg>',
            error:   '<svg class="toast-icon" viewBox="0 0 24 24" fill="currentColor"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-2h2v2zm0-4h-2V7h2v6z"/></svg>'
        };
        toast.innerHTML = icons[type] + '<span class="toast-message">' + message + '</span>' +
            '<button class="toast-close" onclick="this.parentElement.remove()">' +
            '<svg viewBox="0 0 24 24" fill="currentColor"><path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/></svg>' +
            '</button>';
        container.appendChild(toast);
        setTimeout(function() {
            toast.style.animation = 'slideOut 0.3s ease-out';
            setTimeout(function() { toast.remove(); }, 300);
        }, duration);
    }

    // Show session messages
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
    });
</script>

</body>
</html>

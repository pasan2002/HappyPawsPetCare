<%--
    Main Dashboard for Happy Paws Pet Care System
    Location: src/main/webapp/index.jsp
--%>
<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Happy Paws Pet Care — Inventory Management Dashboard</title>
  <meta name="description" content="Manage inventory, track sales, and monitor stock levels for Happy Paws Pet Care Center." />
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

<!-- Include Header -->
<%@ include file="/views/common/header.jsp" %>

<!-- HERO SECTION -->
<section class="relative overflow-hidden">
  <div class="absolute inset-0 bg-gradient-to-b from-brand-50 via-white to-white dark:from-slate-900 dark:via-slate-950 dark:to-slate-950"></div>
  <div class="absolute inset-0 bg-grid opacity-60 dark:opacity-20"></div>
  <div class="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
    <div class="text-center mb-12 reveal">
      <h1 class="font-display text-4xl sm:text-5xl font-extrabold leading-tight tracking-tight text-slate-900 dark:text-slate-100">
        Inventory Management
        <span class="text-brand-700">Dashboard</span>
      </h1>
      <p class="mt-4 text-lg text-slate-600 dark:text-slate-300 max-w-2xl mx-auto">
        Comprehensive inventory control, sales tracking, and financial reporting for Happy Paws Pet Care
      </p>
      <button onclick="loadDashboardData()" 
              class="mt-4 inline-flex items-center px-4 py-2 bg-brand-600 hover:bg-brand-700 text-white rounded-lg font-medium transition-colors">
        <svg class="h-4 w-4 mr-2" viewBox="0 0 24 24" fill="currentColor">
          <path d="M17.65 6.35C16.2 4.9 14.21 4 12 4c-4.42 0-7.99 3.58-7.99 8s3.57 8 7.99 8c3.73 0 6.84-2.55 7.73-6h-2.08c-.82 2.33-3.04 4-5.65 4-3.31 0-6-2.69-6-6s2.69-6 6-6c1.66 0 3.14.69 4.22 1.78L13 11h7V4l-2.35 2.35z"/>
        </svg>
        Refresh Data
      </button>
    </div>

    <!-- Quick Stats -->
    <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-12 reveal">
      <div class="bg-white dark:bg-slate-900 rounded-xl border border-slate-200 dark:border-slate-800 p-6 shadow-soft text-center">
        <div class="h-12 w-12 rounded-lg bg-blue-100 text-blue-700 grid place-items-center mx-auto mb-3">
          <svg class="h-6 w-6" viewBox="0 0 24 24" fill="currentColor">
            <path d="M4 6H2v14c0 1.1.9 2 2 2h14v-2H4V6zm16-4H8c-1.1 0-2 .9-2 2v12c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zm-1 9H9V9h10v2zm-4 4H9v-2h6v2zm4-8H9V5h10v2z"/>
          </svg>
        </div>
        <p class="text-2xl font-bold text-slate-900 dark:text-slate-100" id="totalProducts">
          <span class="animate-pulse bg-slate-200 dark:bg-slate-700 rounded w-8 h-6 inline-block"></span>
        </p>
        <p class="text-sm text-slate-600 dark:text-slate-400">Total Products</p>
      </div>

      <div class="bg-white dark:bg-slate-900 rounded-xl border border-slate-200 dark:border-slate-800 p-6 shadow-soft text-center">
        <div class="h-12 w-12 rounded-lg bg-red-100 text-red-700 grid place-items-center mx-auto mb-3">
          <svg class="h-6 w-6" viewBox="0 0 24 24" fill="currentColor">
            <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/>
          </svg>
        </div>
        <p class="text-2xl font-bold text-red-600" id="lowStockCount">
          <span class="animate-pulse bg-slate-200 dark:bg-slate-700 rounded w-8 h-6 inline-block"></span>
        </p>
        <p class="text-sm text-slate-600 dark:text-slate-400">Low Stock Items</p>
      </div>

      <div class="bg-white dark:bg-slate-900 rounded-xl border border-slate-200 dark:border-slate-800 p-6 shadow-soft text-center">
        <div class="h-12 w-12 rounded-lg bg-emerald-100 text-emerald-700 grid place-items-center mx-auto mb-3">
          <svg class="h-6 w-6" viewBox="0 0 24 24" fill="currentColor">
            <path d="M11.8 10.9c-2.27-.59-3-1.2-3-2.15 0-1.09 1.01-1.85 2.7-1.85 1.78 0 2.44.85 2.5 2.1h2.21c-.07-1.72-1.12-3.3-3.21-3.81V3h-3v2.16c-1.94.42-3.5 1.68-3.5 3.61 0 2.31 1.91 3.46 4.7 4.13 2.5.6 3 1.48 3 2.41 0 .69-.49 1.79-2.7 1.79-2.06 0-2.87-.92-2.98-2.1h-2.2c.12 2.19 1.76 3.42 3.68 3.83V21h3v-2.15c1.95-.37 3.5-1.5 3.5-3.55 0-2.84-2.43-3.81-4.7-4.4z"/>
          </svg>
        </div>
        <p class="text-2xl font-bold text-emerald-600" id="todaySales">
          <span class="animate-pulse bg-slate-200 dark:bg-slate-700 rounded w-20 h-6 inline-block"></span>
        </p>
        <p class="text-sm text-slate-600 dark:text-slate-400">Today's Sales</p>
      </div>

      <div class="bg-white dark:bg-slate-900 rounded-xl border border-slate-200 dark:border-slate-800 p-6 shadow-soft text-center">
        <div class="h-12 w-12 rounded-lg bg-purple-100 text-purple-700 grid place-items-center mx-auto mb-3">
          <svg class="h-6 w-6" viewBox="0 0 24 24" fill="currentColor">
            <path d="M19 3h-1V1h-2v2H8V1H6v2H5c-1.11 0-1.99.9-1.99 2L3 19c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm0 16H5V8h14v11zM7 10h5v5H7z"/>
          </svg>
        </div>
        <p class="text-2xl font-bold text-purple-600" id="monthSales">
          <span class="animate-pulse bg-slate-200 dark:bg-slate-700 rounded w-20 h-6 inline-block"></span>
        </p>
        <p class="text-sm text-slate-600 dark:text-slate-400">This Month</p>
      </div>
    </div>

    <!-- Quick Actions -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 reveal">
      <a href="<%= request.getContextPath() %>/inventory/list"
         class="group p-6 bg-white dark:bg-slate-900 rounded-xl border border-slate-200 dark:border-slate-800 shadow-soft hover:shadow-lg transition-all duration-200">
        <div class="flex items-center gap-4">
          <div class="h-12 w-12 rounded-lg bg-brand-100 text-brand-700 grid place-items-center group-hover:bg-brand-600 group-hover:text-white transition-colors">
            <svg class="h-6 w-6" viewBox="0 0 24 24" fill="currentColor">
              <path d="M4 6H2v14c0 1.1.9 2 2 2h14v-2H4V6zm16-4H8c-1.1 0-2 .9-2 2v12c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zm-1 9H9V9h10v2zm-4 4H9v-2h6v2zm4-8H9V5h10v2z"/>
            </svg>
          </div>
          <div>
            <h3 class="font-semibold text-slate-900 dark:text-slate-100 group-hover:text-brand-600">View Inventory</h3>
            <p class="text-sm text-slate-600 dark:text-slate-400">Manage products & stock</p>
          </div>
        </div>
      </a>

      <a href="<%= request.getContextPath() %>/sales/add"
         class="group p-6 bg-white dark:bg-slate-900 rounded-xl border border-slate-200 dark:border-slate-800 shadow-soft hover:shadow-lg transition-all duration-200">
        <div class="flex items-center gap-4">
          <div class="h-12 w-12 rounded-lg bg-emerald-100 text-emerald-700 grid place-items-center group-hover:bg-emerald-600 group-hover:text-white transition-colors">
            <svg class="h-6 w-6" viewBox="0 0 24 24" fill="currentColor">
              <path d="M7 18c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2zM1 2v2h2l3.6 7.59-1.35 2.45c-.16.28-.25.61-.25.96 0 1.1.9 2 2 2h12v-2H7.42c-.14 0-.25-.11-.25-.25l.03-.12L8.1 13h7.45c.75 0 1.41-.41 1.75-1.03L21.7 4H5.21l-.94-2H1zm16 16c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2z"/>
            </svg>
          </div>
          <div>
            <h3 class="font-semibold text-slate-900 dark:text-slate-100 group-hover:text-emerald-600">Record Sale</h3>
            <p class="text-sm text-slate-600 dark:text-slate-400">Process customer purchase</p>
          </div>
        </div>
      </a>

      <a href="<%= request.getContextPath() %>/sales/reports"
         class="group p-6 bg-white dark:bg-slate-900 rounded-xl border border-slate-200 dark:border-slate-800 shadow-soft hover:shadow-lg transition-all duration-200">
        <div class="flex items-center gap-4">
          <div class="h-12 w-12 rounded-lg bg-purple-100 text-purple-700 grid place-items-center group-hover:bg-purple-600 group-hover:text-white transition-colors">
            <svg class="h-6 w-6" viewBox="0 0 24 24" fill="currentColor">
              <path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zM9 17H7v-7h2v7zm4 0h-2V7h2v10zm4 0h-2v-4h2v4z"/>
            </svg>
          </div>
          <div>
            <h3 class="font-semibold text-slate-900 dark:text-slate-100 group-hover:text-purple-600">View Reports</h3>
            <p class="text-sm text-slate-600 dark:text-slate-400">Sales & financial analytics</p>
          </div>
        </div>
      </a>

      <a href="<%= request.getContextPath() %>/inventory/add"
         class="group p-6 bg-white dark:bg-slate-900 rounded-xl border border-slate-200 dark:border-slate-800 shadow-soft hover:shadow-lg transition-all duration-200">
        <div class="flex items-center gap-4">
          <div class="h-12 w-12 rounded-lg bg-amber-100 text-amber-700 grid place-items-center group-hover:bg-amber-600 group-hover:text-white transition-colors">
            <svg class="h-6 w-6" viewBox="0 0 24 24" fill="currentColor">
              <path d="M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z"/>
            </svg>
          </div>
          <div>
            <h3 class="font-semibold text-slate-900 dark:text-slate-100 group-hover:text-amber-600">Add Product</h3>
            <p class="text-sm text-slate-600 dark:text-slate-400">Add new inventory item</p>
          </div>
        </div>
      </a>
    </div>

    <!-- Low Stock Alert Banner -->
    <div id="lowStockBanner" class="hidden mt-8 p-6 bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800 rounded-xl">
      <div class="flex items-start gap-4">
        <div class="h-6 w-6 text-red-600 mt-0.5">
          <svg viewBox="0 0 24 24" fill="currentColor">
            <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/>
          </svg>
        </div>
        <div class="flex-1">
          <h3 class="font-semibold text-red-800 dark:text-red-200">Low Stock Alert</h3>
          <p class="text-red-700 dark:text-red-300 mt-1" id="lowStockMessage">Some products are running low on stock.</p>
          <a href="<%= request.getContextPath() %>/inventory/low-stock"
             class="inline-flex items-center mt-2 text-sm font-medium text-red-600 hover:text-red-800">
            View Details →
          </a>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- Include Footer -->
<%@ include file="/views/common/footer.jsp" %>

<script>
  // Load dashboard data
  document.addEventListener('DOMContentLoaded', function() {
    loadDashboardData();

    // Reveal animations
    const observer = new IntersectionObserver(entries => {
      entries.forEach(e => { if (e.isIntersecting) e.target.classList.add('visible'); });
    }, { threshold: 0.08 });
    document.querySelectorAll('.reveal').forEach(el => observer.observe(el));
  });

  async function loadDashboardData() {
    try {
      // Load products data
      const productsResponse = await fetch('<%= request.getContextPath() %>/inventory/api/products');
      if (productsResponse.ok) {
        const products = await productsResponse.json();
        document.getElementById('totalProducts').innerHTML = products.length;

        // Count low stock items
        const lowStockItems = products.filter(p => p.stockQty <= 10);
        const lowStockCount = lowStockItems.length;
        document.getElementById('lowStockCount').innerHTML = lowStockCount;

        // Show low stock banner if needed
        if (lowStockCount > 0) {
          const banner = document.getElementById('lowStockBanner');
          const message = document.getElementById('lowStockMessage');
          banner.classList.remove('hidden');
          message.textContent = `${lowStockCount} product${lowStockCount > 1 ? 's are' : ' is'} running low on stock and need${lowStockCount > 1 ? '' : 's'} restocking.`;
        }
      }

      // Load low stock data for more detailed count
      const lowStockResponse = await fetch('<%= request.getContextPath() %>/inventory/api/low-stock?threshold=10');
      if (lowStockResponse.ok) {
        const lowStockProducts = await lowStockResponse.json();
        document.getElementById('lowStockCount').innerHTML = lowStockProducts.length;
      }

      // Load sales statistics
      const salesResponse = await fetch('<%= request.getContextPath() %>/sales/api/stats');
      if (salesResponse.ok) {
        const salesData = await salesResponse.json();
        console.log('Sales data received:', salesData);
        
        // Format and display sales data
        const formatter = new Intl.NumberFormat('en-LK', {
          style: 'currency',
          currency: 'LKR',
          minimumFractionDigits: 2
        });
        
        document.getElementById('todaySales').innerHTML = formatter.format(salesData.todaySales || 0);
        document.getElementById('monthSales').innerHTML = formatter.format(salesData.monthSales || 0);
      } else {
        console.error('Failed to load sales data:', salesResponse.status);
        // Set fallback sales values
        document.getElementById('todaySales').innerHTML = 'LKR 0.00';
        document.getElementById('monthSales').innerHTML = 'LKR 0.00';
      }

    } catch (error) {
      console.error('Error loading dashboard data:', error);
      // Set fallback values
      document.getElementById('totalProducts').innerHTML = '0';
      document.getElementById('lowStockCount').innerHTML = '0';
      document.getElementById('todaySales').innerHTML = 'LKR 0.00';
      document.getElementById('monthSales').innerHTML = 'LKR 0.00';
    }
  }
</script>

</body>
</html>
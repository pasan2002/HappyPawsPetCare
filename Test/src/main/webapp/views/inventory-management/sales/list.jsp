<%--&lt;%&ndash;&lt;%&ndash;&ndash;%&gt;--%>
<%--&lt;%&ndash;    Sales List View&ndash;%&gt;--%>
<%--&lt;%&ndash;    Location: src/main/webapp/WEB-INF/views/sales/list.jsp&ndash;%&gt;--%>
<%--&lt;%&ndash;&ndash;%&gt;&ndash;%&gt;--%>
<%--&lt;%&ndash;<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>&ndash;%&gt;--%>
<%--&lt;%&ndash;<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>&ndash;%&gt;--%>
<%--&lt;%&ndash;<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>&ndash;%&gt;--%>
<%--&lt;%&ndash;<!DOCTYPE html>&ndash;%&gt;--%>
<%--&lt;%&ndash;<html lang="en" class="scroll-smooth">&ndash;%&gt;--%>
<%--&lt;%&ndash;<head>&ndash;%&gt;--%>
<%--&lt;%&ndash;    <meta charset="UTF-8" />&ndash;%&gt;--%>
<%--&lt;%&ndash;    <meta name="viewport" content="width=device-width, initial-scale=1.0" />&ndash;%&gt;--%>
<%--&lt;%&ndash;    <title>Sales History - Happy Paws Pet Care</title>&ndash;%&gt;--%>
<%--&lt;%&ndash;    <link rel="preconnect" href="https://fonts.googleapis.com">&ndash;%&gt;--%>
<%--&lt;%&ndash;    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>&ndash;%&gt;--%>
<%--&lt;%&ndash;    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Sora:wght@400;600;700&display=swap" rel="stylesheet">&ndash;%&gt;--%>
<%--&lt;%&ndash;    <script src="https://cdn.tailwindcss.com"></script>&ndash;%&gt;--%>
<%--&lt;%&ndash;    <script>&ndash;%&gt;--%>
<%--&lt;%&ndash;        tailwind.config = {&ndash;%&gt;--%>
<%--&lt;%&ndash;            theme: {&ndash;%&gt;--%>
<%--&lt;%&ndash;                extend: {&ndash;%&gt;--%>
<%--&lt;%&ndash;                    fontFamily: { sans: ['Inter', 'system-ui', 'sans-serif'], display: ['Sora','Inter','system-ui','sans-serif'] },&ndash;%&gt;--%>
<%--&lt;%&ndash;                    colors: {&ndash;%&gt;--%>
<%--&lt;%&ndash;                        brand: {&ndash;%&gt;--%>
<%--&lt;%&ndash;                            50: '#effaff', 100: '#d7f0ff', 200: '#b2e1ff', 300: '#84cdff', 400: '#53b2ff',&ndash;%&gt;--%>
<%--&lt;%&ndash;                            500: '#2f97ff', 600: '#1679e6', 700: '#0f5fba', 800: '#0f4c91', 900: '#113e75'&ndash;%&gt;--%>
<%--&lt;%&ndash;                        }&ndash;%&gt;--%>
<%--&lt;%&ndash;                    },&ndash;%&gt;--%>
<%--&lt;%&ndash;                    boxShadow: {&ndash;%&gt;--%>
<%--&lt;%&ndash;                        soft: '0 10px 30px rgba(0,0,0,.06)',&ndash;%&gt;--%>
<%--&lt;%&ndash;                        glow: '0 0 0 6px rgba(47,151,255,.10)'&ndash;%&gt;--%>
<%--&lt;%&ndash;                    }&ndash;%&gt;--%>
<%--&lt;%&ndash;                }&ndash;%&gt;--%>
<%--&lt;%&ndash;            },&ndash;%&gt;--%>
<%--&lt;%&ndash;            darkMode: 'class'&ndash;%&gt;--%>
<%--&lt;%&ndash;        }&ndash;%&gt;--%>
<%--&lt;%&ndash;    </script>&ndash;%&gt;--%>
<%--&lt;%&ndash;</head>&ndash;%&gt;--%>
<%--&lt;%&ndash;<body class="antialiased text-slate-800 dark:text-slate-100 bg-white dark:bg-slate-950">&ndash;%&gt;--%>

<%--&lt;%&ndash;<!-- Include Header -->&ndash;%&gt;--%>
<%--&lt;%&ndash;<%@ include file="/WEB-INF/includes/header.jsp" %>&ndash;%&gt;--%>

<%--&lt;%&ndash;<!-- Main Content -->&ndash;%&gt;--%>
<%--&lt;%&ndash;<main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">&ndash;%&gt;--%>
<%--&lt;%&ndash;    <!-- Page Header -->&ndash;%&gt;--%>
<%--&lt;%&ndash;    <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 mb-8">&ndash;%&gt;--%>
<%--&lt;%&ndash;        <div>&ndash;%&gt;--%>
<%--&lt;%&ndash;            <h1 class="font-display text-3xl font-bold text-slate-900 dark:text-slate-100">Sales History</h1>&ndash;%&gt;--%>
<%--&lt;%&ndash;            <p class="text-slate-600 dark:text-slate-300 mt-1">View all customer purchase transactions</p>&ndash;%&gt;--%>
<%--&lt;%&ndash;        </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;        <div class="flex flex-wrap gap-3">&ndash;%&gt;--%>
<%--&lt;%&ndash;            <a href="${pageContext.request.contextPath}/sales/add"&ndash;%&gt;--%>
<%--&lt;%&ndash;               class="inline-flex items-center justify-center px-4 py-2 rounded-xl bg-brand-600 hover:bg-brand-700 text-white font-medium shadow-soft">&ndash;%&gt;--%>
<%--&lt;%&ndash;                <svg class="h-4 w-4 mr-2" viewBox="0 0 24 24" fill="currentColor">&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <path d="M7 18c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2zM1 2v2h2l3.6 7.59-1.35 2.45c-.16.28-.25.61-.25.96 0 1.1.9 2 2 2h12v-2H7.42c-.14 0-.25-.11-.25-.25l.03-.12L8.1 13h7.45c.75 0 1.41-.41 1.75-1.03L21.7 4H5.21l-.94-2H1zm16 16c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2z"/>&ndash;%&gt;--%>
<%--&lt;%&ndash;                </svg>&ndash;%&gt;--%>
<%--&lt;%&ndash;                Record Sale&ndash;%&gt;--%>
<%--&lt;%&ndash;            </a>&ndash;%&gt;--%>
<%--&lt;%&ndash;            <a href="${pageContext.request.contextPath}/sales/reports"&ndash;%&gt;--%>
<%--&lt;%&ndash;               class="inline-flex items-center justify-center px-4 py-2 rounded-xl border border-slate-300 dark:border-slate-700 hover:bg-slate-50 dark:hover:bg-slate-800">&ndash;%&gt;--%>
<%--&lt;%&ndash;                View Reports&ndash;%&gt;--%>
<%--&lt;%&ndash;            </a>&ndash;%&gt;--%>
<%--&lt;%&ndash;        </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;    </div>&ndash;%&gt;--%>

<%--&lt;%&ndash;    <!-- Quick Stats -->&ndash;%&gt;--%>
<%--&lt;%&ndash;    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-6">&ndash;%&gt;--%>
<%--&lt;%&ndash;        <div class="bg-white dark:bg-slate-900 rounded-xl border border-slate-200 dark:border-slate-800 p-6 shadow-soft">&ndash;%&gt;--%>
<%--&lt;%&ndash;            <div class="flex items-center justify-between">&ndash;%&gt;--%>
<%--&lt;%&ndash;                <div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <p class="text-sm text-slate-600 dark:text-slate-300">Total Sales</p>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <p class="text-2xl font-bold text-slate-900 dark:text-slate-100">${sales.size()}</p>&ndash;%&gt;--%>
<%--&lt;%&ndash;                </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                <div class="h-12 w-12 rounded-lg bg-blue-100 text-blue-700 grid place-items-center">&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <svg class="h-6 w-6" viewBox="0 0 24 24" fill="currentColor">&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <path d="M7 18c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2zM1 2v2h2l3.6 7.59-1.35 2.45c-.16.28-.25.61-.25.96 0 1.1.9 2 2 2h12v-2H7.42c-.14 0-.25-.11-.25-.25l.03-.12L8.1 13h7.45c.75 0 1.41-.41 1.75-1.03L21.7 4H5.21l-.94-2H1zm16 16c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2z"/>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    </svg>&ndash;%&gt;--%>
<%--&lt;%&ndash;                </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;            </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;        </div>&ndash;%&gt;--%>

<%--&lt;%&ndash;        <div class="bg-white dark:bg-slate-900 rounded-xl border border-slate-200 dark:border-slate-800 p-6 shadow-soft">&ndash;%&gt;--%>
<%--&lt;%&ndash;            <div class="flex items-center justify-between">&ndash;%&gt;--%>
<%--&lt;%&ndash;                <div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <p class="text-sm text-slate-600 dark:text-slate-300">Total Revenue</p>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <p class="text-2xl font-bold text-emerald-600">&ndash;%&gt;--%>
<%--&lt;%&ndash;                        LKR <fmt:formatNumber value="${totalRevenue}" pattern="#,##0.00"/>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    </p>&ndash;%&gt;--%>
<%--&lt;%&ndash;                </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                <div class="h-12 w-12 rounded-lg bg-emerald-100 text-emerald-700 grid place-items-center">&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <svg class="h-6 w-6" viewBox="0 0 24 24" fill="currentColor">&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <path d="M11.8 10.9c-2.27-.59-3-1.2-3-2.15 0-1.09 1.01-1.85 2.7-1.85 1.78 0 2.44.85 2.5 2.1h2.21c-.07-1.72-1.12-3.3-3.21-3.81V3h-3v2.16c-1.94.42-3.5 1.68-3.5 3.61 0 2.31 1.91 3.46 4.7 4.13 2.5.6 3 1.48 3 2.41 0 .69-.49 1.79-2.7 1.79-2.06 0-2.87-.92-2.98-2.1h-2.2c.12 2.19 1.76 3.42 3.68 3.83V21h3v-2.15c1.95-.37 3.5-1.5 3.5-3.55 0-2.84-2.43-3.81-4.7-4.4z"/>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    </svg>&ndash;%&gt;--%>
<%--&lt;%&ndash;                </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;            </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;        </div>&ndash;%&gt;--%>

<%--&lt;%&ndash;        <div class="bg-white dark:bg-slate-900 rounded-xl border border-slate-200 dark:border-slate-800 p-6 shadow-soft">&ndash;%&gt;--%>
<%--&lt;%&ndash;            <div class="flex items-center justify-between">&ndash;%&gt;--%>
<%--&lt;%&ndash;                <div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <p class="text-sm text-slate-600 dark:text-slate-300">Avg. Transaction</p>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <p class="text-2xl font-bold text-purple-600">&ndash;%&gt;--%>
<%--&lt;%&ndash;                        LKR <fmt:formatNumber value="${avgTransaction}" pattern="#,##0.00"/>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    </p>&ndash;%&gt;--%>
<%--&lt;%&ndash;                </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                <div class="h-12 w-12 rounded-lg bg-purple-100 text-purple-700 grid place-items-center">&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <svg class="h-6 w-6" viewBox="0 0 24 24" fill="currentColor">&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zM9 17H7v-7h2v7zm4 0h-2V7h2v10zm4 0h-2v-4h2v4z"/>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    </svg>&ndash;%&gt;--%>
<%--&lt;%&ndash;                </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;            </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;        </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;    </div>&ndash;%&gt;--%>

<%--&lt;%&ndash;    <!-- Sales Table -->&ndash;%&gt;--%>
<%--&lt;%&ndash;    <div class="bg-white dark:bg-slate-900 rounded-xl border border-slate-200 dark:border-slate-800 shadow-soft overflow-hidden">&ndash;%&gt;--%>
<%--&lt;%&ndash;        <div class="overflow-x-auto">&ndash;%&gt;--%>
<%--&lt;%&ndash;            <table class="w-full">&ndash;%&gt;--%>
<%--&lt;%&ndash;                <thead class="bg-slate-50 dark:bg-slate-800/50 border-b border-slate-200 dark:border-slate-800">&ndash;%&gt;--%>
<%--&lt;%&ndash;                <tr>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <th class="px-6 py-4 text-left text-xs font-semibold text-slate-600 dark:text-slate-300 uppercase tracking-wider">Sale ID</th>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <th class="px-6 py-4 text-left text-xs font-semibold text-slate-600 dark:text-slate-300 uppercase tracking-wider">Date & Time</th>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <th class="px-6 py-4 text-left text-xs font-semibold text-slate-600 dark:text-slate-300 uppercase tracking-wider">Product</th>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <th class="px-6 py-4 text-left text-xs font-semibold text-slate-600 dark:text-slate-300 uppercase tracking-wider">Quantity</th>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <th class="px-6 py-4 text-left text-xs font-semibold text-slate-600 dark:text-slate-300 uppercase tracking-wider">Total Price</th>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <th class="px-6 py-4 text-left text-xs font-semibold text-slate-600 dark:text-slate-300 uppercase tracking-wider">Staff</th>&ndash;%&gt;--%>
<%--&lt;%&ndash;                </tr>&ndash;%&gt;--%>
<%--&lt;%&ndash;                </thead>&ndash;%&gt;--%>
<%--&lt;%&ndash;                <tbody class="divide-y divide-slate-200 dark:divide-slate-800">&ndash;%&gt;--%>
<%--&lt;%&ndash;                <c:choose>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <c:when test="${empty sales}">&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <tr>&ndash;%&gt;--%>
<%--&lt;%&ndash;                            <td colspan="6" class="px-6 py-12 text-center text-slate-500 dark:text-slate-400">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                <svg class="h-12 w-12 mx-auto mb-4 text-slate-300 dark:text-slate-600" viewBox="0 0 24 24" fill="currentColor">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                    <path d="M7 18c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2zM1 2v2h2l3.6 7.59-1.35 2.45c-.16.28-.25.61-.25.96 0 1.1.9 2 2 2h12v-2H7.42c-.14 0-.25-.11-.25-.25l.03-.12L8.1 13h7.45c.75 0 1.41-.41 1.75-1.03L21.7 4H5.21l-.94-2H1zm16 16c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2z"/>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                </svg>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                <p class="text-lg font-medium">No sales recorded yet</p>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                <p class="text-sm">Start by recording your first sale.</p>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                <div class="mt-4">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                    <a href="${pageContext.request.contextPath}/sales/add"&ndash;%&gt;--%>
<%--&lt;%&ndash;                                       class="inline-flex items-center px-4 py-2 rounded-lg bg-brand-600 hover:bg-brand-700 text-white font-medium">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                        Record First Sale&ndash;%&gt;--%>
<%--&lt;%&ndash;                                    </a>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                            </td>&ndash;%&gt;--%>
<%--&lt;%&ndash;                        </tr>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    </c:when>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <c:otherwise>&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <c:forEach var="sale" items="${sales}">&ndash;%&gt;--%>
<%--&lt;%&ndash;                            <tr class="hover:bg-slate-50 dark:hover:bg-slate-800/50">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                <td class="px-6 py-4">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                    <span class="font-medium text-slate-900 dark:text-slate-100">#${sale.saleId}</span>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                </td>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                <td class="px-6 py-4">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                    <div class="text-sm text-slate-900 dark:text-slate-100">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                        <fmt:formatDate value="${sale.soldAt}" pattern="MMM dd, yyyy"/>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                    </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                    <div class="text-xs text-slate-500 dark:text-slate-400">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                        <fmt:formatDate value="${sale.soldAt}" pattern="hh:mm a"/>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                    </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                </td>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                <td class="px-6 py-4">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                    <div class="font-medium text-slate-900 dark:text-slate-100">${sale.productName}</div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                    <div class="text-xs text-slate-500 dark:text-slate-400">Product ID: #${sale.productId}</div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                </td>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                <td class="px-6 py-4">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                        <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-blue-100 text-blue-800">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                            ${sale.quantity} units&ndash;%&gt;--%>
<%--&lt;%&ndash;                                        </span>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                </td>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                <td class="px-6 py-4">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                        <span class="font-semibold text-emerald-600 dark:text-emerald-400">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                            LKR <fmt:formatNumber value="${sale.totalPrice}" pattern="#,##0.00"/>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                        </span>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                </td>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                <td class="px-6 py-4">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                    <div class="flex items-center gap-2">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                        <div class="h-8 w-8 rounded-full bg-brand-100 text-brand-700 grid place-items-center text-xs font-semibold">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                                ${sale.staffName.substring(0, 2).toUpperCase()}&ndash;%&gt;--%>
<%--&lt;%&ndash;                                        </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                        <div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                            <div class="text-sm font-medium text-slate-900 dark:text-slate-100">${sale.staffName}</div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                            <div class="text-xs text-slate-500 dark:text-slate-400">ID: #${sale.staffId}</div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                        </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                    </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                </td>&ndash;%&gt;--%>
<%--&lt;%&ndash;                            </tr>&ndash;%&gt;--%>
<%--&lt;%&ndash;                        </c:forEach>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    </c:otherwise>&ndash;%&gt;--%>
<%--&lt;%&ndash;                </c:choose>&ndash;%&gt;--%>
<%--&lt;%&ndash;                </tbody>&ndash;%&gt;--%>
<%--&lt;%&ndash;            </table>&ndash;%&gt;--%>
<%--&lt;%&ndash;        </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;    </div>&ndash;%&gt;--%>

<%--&lt;%&ndash;    <!-- Pagination Info (Optional - for future implementation) -->&ndash;%&gt;--%>
<%--&lt;%&ndash;    <c:if test="${not empty sales}">&ndash;%&gt;--%>
<%--&lt;%&ndash;        <div class="mt-6 flex items-center justify-between text-sm text-slate-600 dark:text-slate-300">&ndash;%&gt;--%>
<%--&lt;%&ndash;            <p>Showing <span class="font-medium">${sales.size()}</span> sales transactions</p>&ndash;%&gt;--%>
<%--&lt;%&ndash;            <div class="flex gap-2">&ndash;%&gt;--%>
<%--&lt;%&ndash;                <a href="${pageContext.request.contextPath}/sales/daily"&ndash;%&gt;--%>
<%--&lt;%&ndash;                   class="px-3 py-2 border border-slate-300 dark:border-slate-700 rounded-lg hover:bg-slate-50 dark:hover:bg-slate-800">&ndash;%&gt;--%>
<%--&lt;%&ndash;                    Daily View&ndash;%&gt;--%>
<%--&lt;%&ndash;                </a>&ndash;%&gt;--%>
<%--&lt;%&ndash;                <a href="${pageContext.request.contextPath}/sales/reports"&ndash;%&gt;--%>
<%--&lt;%&ndash;                   class="px-3 py-2 border border-slate-300 dark:border-slate-700 rounded-lg hover:bg-slate-50 dark:hover:bg-slate-800">&ndash;%&gt;--%>
<%--&lt;%&ndash;                    View Reports&ndash;%&gt;--%>
<%--&lt;%&ndash;                </a>&ndash;%&gt;--%>
<%--&lt;%&ndash;            </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;        </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;    </c:if>&ndash;%&gt;--%>
<%--&lt;%&ndash;</main>&ndash;%&gt;--%>

<%--&lt;%&ndash;<!-- Include Footer -->&ndash;%&gt;--%>
<%--&lt;%&ndash;<%@ include file="/WEB-INF/includes/footer.jsp" %>&ndash;%&gt;--%>

<%--&lt;%&ndash;<script>&ndash;%&gt;--%>
<%--&lt;%&ndash;    // Calculate stats on page load&ndash;%&gt;--%>
<%--&lt;%&ndash;    document.addEventListener('DOMContentLoaded', function() {&ndash;%&gt;--%>
<%--&lt;%&ndash;        // You can add JavaScript here to calculate and display statistics dynamically&ndash;%&gt;--%>
<%--&lt;%&ndash;        // For now, these will be calculated in the servlet&ndash;%&gt;--%>
<%--&lt;%&ndash;    });&ndash;%&gt;--%>
<%--&lt;%&ndash;</script>&ndash;%&gt;--%>

<%--&lt;%&ndash;</body>&ndash;%&gt;--%>
<%--&lt;%&ndash;</html>&ndash;%&gt;--%>


<%--<%@ page contentType="text/html;charset=UTF-8" language="java" %>--%>
<%--<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>--%>
<%--<html>--%>
<%--<head>--%>
<%--    <title>Sales List</title>--%>
<%--    <style>--%>
<%--        table { border-collapse: collapse; width: 100%; margin: 20px 0; }--%>
<%--        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }--%>
<%--        th { background-color: #f2f2f2; }--%>
<%--    </style>--%>
<%--</head>--%>
<%--<body>--%>
<%--<h2>Sales List</h2>--%>
<%--<a href="${pageContext.request.contextPath}/sales/new">New Sale</a>--%>
<%--<a href="${pageContext.request.contextPath}/sales/report">Reports</a>--%>
<%--<table>--%>
<%--    <thead>--%>
<%--    <tr>--%>
<%--        <th>Invoice ID</th>--%>
<%--        <th>Total Amount</th>--%>
<%--        <th>Paid</th>--%>
<%--        <th>Created At</th>--%>
<%--        <th>Staff</th>--%>
<%--        <th>Items</th>--%>
<%--        <th>Action</th>--%>
<%--    </tr>--%>
<%--    </thead>--%>
<%--    <tbody>--%>
<%--    <c:forEach var="invoice" items="${invoices}">--%>
<%--        <tr>--%>
<%--            <td>${invoice.invoiceId}</td>--%>
<%--            <td>${invoice.totalAmount}</td>--%>
<%--            <td>${invoice.paid ? 'Yes' : 'No'}</td>--%>
<%--            <td>${invoice.createdAt}</td>--%>
<%--            <td>${invoice.staffFullName}</td>--%>
<%--            <td>--%>
<%--                <c:if test="${not empty invoice.items}">--%>
<%--                    <c:forEach var="item" items="${invoice.items}">--%>
<%--                        ${item.productId} (Qty: ${item.quantity}, Price: ${item.unitPrice})<br>--%>
<%--                    </c:forEach>--%>
<%--                </c:if>--%>
<%--                <c:if test="${empty invoice.items}">No items</c:if>--%>
<%--            </td>--%>
<%--            <td>--%>
<%--                <c:if test="${!invoice.paid}">--%>
<%--                    <form action="${pageContext.request.contextPath}/sales/pay" method="post">--%>
<%--                        <input type="hidden" name="invoiceId" value="${invoice.invoiceId}">--%>
<%--                        <input type="submit" value="Mark Paid">--%>
<%--                    </form>--%>
<%--                </c:if>--%>
<%--            </td>--%>
<%--        </tr>--%>
<%--    </c:forEach>--%>
<%--    </tbody>--%>
<%--</table>--%>
<%--</body>--%>
<%--</html>--%>
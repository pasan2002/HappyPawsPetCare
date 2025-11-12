<%@ page import="com.happypaws.petcare.model.Appointment" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
  String c = request.getContextPath();
  Appointment appt = (Appointment) request.getAttribute("appt");
  boolean isPaid = appt != null && "paid".equalsIgnoreCase(appt.getPaymentStatus());
%>
<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Payment Confirmation â€” Happy Paws</title>
  <meta name="description" content="Your payment confirmation for the appointment."/>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Sora:wght@400;600;700&display=swap" rel="stylesheet">
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
      mask-image: radial-gradient(ellipse 70% 60% at 50% -10%, black 40%, transparent 60%);
    }
    .reveal { opacity: 0; transform: translateY(12px); transition: opacity .6s ease, transform .6s ease; }
    .reveal.visible { opacity: 1; transform: translateY(0); }
  </style>
</head>
<body class="antialiased text-slate-800 dark:text-slate-100 bg-white dark:bg-slate-950">

<%@ include file="../common/header.jsp" %>

<!-- PAGE HEADER -->
<section class="relative overflow-hidden">
  <div class="absolute inset-0 bg-gradient-to-b from-brand-50 via-white to-white dark:from-slate-900 dark:via-slate-950 dark:to-slate-950"></div>
  <div class="absolute inset-0 bg-grid opacity-60 dark:opacity-20"></div>

  <div class="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10 md:py-14">
    <div class="flex items-center justify-between gap-4 reveal">
      <div>
        <h1 class="font-display text-3xl md:text-4xl font-extrabold tracking-tight">
          Payment <%= isPaid ? "Successful" : "Recorded" %>
        </h1>
        <p class="mt-2 text-sm text-slate-600 dark:text-slate-300">
          <% if (appt != null) { %>
          Appointment <b>#<%= appt.getAppointmentId() %></b>
          <% if (appt.getFee()!=null) { %>  Amount: <b>Rs <%= appt.getFee() %></b><% } %>
          <% } else { %>
          Appointment details unavailable.
          <% } %>
        </p>
      </div>
      <a href="<%= c %>/views/appointment-management/user_appointments.jsp"
         class="inline-flex items-center px-4 py-2 rounded-xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 hover:shadow-soft">
        ← Back to Appointments
      </a>
    </div>
  </div>
</section>

<!-- CARD -->
<section class="max-w-2xl mx-auto px-4 sm:px-6 lg:px-8 pb-16">
  <div class="reveal relative">
    <div class="absolute -inset-2 rounded-3xl bg-gradient-to-tr from-brand-600/20 via-brand-400/10 to-brand-600/20 blur-2xl"></div>

    <div class="relative rounded-3xl border border-slate-200 dark:border-slate-800 bg-white/80 dark:bg-slate-900/60 p-6 md:p-7 shadow-soft backdrop-blur">
      <div class="flex items-start gap-4">
        <div class="h-12 w-12 rounded-2xl <%= isPaid ? "bg-emerald-600" : "bg-amber-500" %> text-white grid place-items-center shadow-soft">
          <!-- check icon -->
          <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" viewBox="0 0 24 24" fill="currentColor">
            <path d="M9 16.17 4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/>
          </svg>
        </div>
        <div>
          <h2 class="text-xl font-bold">
            <%= isPaid ? "Thanks! Your payment is confirmed." : "Payment recorded. Awaiting confirmation." %>
          </h2>
          <p class="mt-1 text-sm text-slate-600 dark:text-slate-300">
            Keep this page or your email receipt for reference.
          </p>
        </div>
      </div>

      <!-- Details -->
      <div class="mt-6 grid sm:grid-cols-2 gap-4">
        <div class="p-4 rounded-2xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-900">
          <p class="text-xs text-slate-500">Status</p>
          <p class="mt-1 font-semibold capitalize"><%= appt != null ? appt.getPaymentStatus() : "-" %></p>
        </div>
        <div class="p-4 rounded-2xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-900">
          <p class="text-xs text-slate-500">Method</p>
          <p class="mt-1 font-semibold capitalize">
            <%= appt != null ? (appt.getPaymentMethod()!=null?appt.getPaymentMethod():"online") : "-" %>
          </p>
        </div>
        <div class="p-4 rounded-2xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-900 sm:col-span-2">
          <p class="text-xs text-slate-500">Reference</p>
          <p class="mt-1 font-mono text-sm">
            <%= (appt != null && appt.getPaymentRef()!=null) ? appt.getPaymentRef() : "-" %>
          </p>
        </div>
      </div>

      <% if (!isPaid) { %>
      <div class="mt-6 rounded-2xl bg-amber-50 dark:bg-amber-900/20 border border-amber-200 dark:border-amber-800 p-4 text-amber-800 dark:text-amber-200">
        We haven't confirmed the payment yet. If you just paid, please refresh in a moment, or contact support with your reference.
      </div>
      <% } %>

      <div class="mt-7 flex flex-wrap gap-3">
        <a href="<%= c %>/views/appointment-management/user_appointments.jsp"
           class="inline-flex items-center px-5 py-2.5 rounded-xl bg-emerald-600 hover:bg-emerald-700 text-white font-medium shadow-soft">
          Go to My Appointments
        </a>
        <a href="<%= c %>/"
           class="inline-flex items-center px-5 py-2.5 rounded-xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 hover:shadow-soft">
          Home
        </a>
      </div>

      <p class="mt-5 text-xs text-slate-500 dark:text-slate-400">
        If you selected to Pay at clinic, please bring your preferred payment method on the day.
      </p>
    </div>
  </div>
</section>

<%@ include file="../common/footer.jsp" %>

<script>
  // Reveal on scroll
  const observer = new IntersectionObserver(entries => {
    entries.forEach(e => { if (e.isIntersecting) e.target.classList.add('visible'); });
  }, { threshold: 0.08 });
  document.querySelectorAll('.reveal').forEach(el => observer.observe(el));
</script>
</body>
</html>




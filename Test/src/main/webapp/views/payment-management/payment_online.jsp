<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String c = request.getContextPath();
    String pk = (String) request.getAttribute("publishableKey");
    String clientSecret = (String) request.getAttribute("clientSecret");
    Integer appointmentId = (Integer) request.getAttribute("appointmentId");
    java.math.BigDecimal amount = (java.math.BigDecimal) request.getAttribute("amount");
%>
<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Secure Payment â€” Happy Paws</title>
    <meta name="description" content="Pay securely for your appointment."/>
    <script src="https://js.stripe.com/v3/"></script>
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
        
        /* Ensure proper text color for form inputs in both light and dark modes */
        .form-input {
            color: #1e293b !important;
        }
        .dark .form-input {
            color: #ffffff !important;
        }
        
        /* Stripe elements styling container */
        #card-number, #card-expiry, #card-cvc {
            background-color: white;
        }
        .dark #card-number, .dark #card-expiry, .dark #card-cvc {
            background-color: #0f172a;
        }
    </style>
</head>
<body class="antialiased text-slate-800 dark:text-slate-100 bg-white dark:bg-slate-950">

<%@ include file="../common/header.jsp" %>

<!-- HEADER -->
<section class="relative overflow-hidden">
    <div class="absolute inset-0 bg-gradient-to-b from-brand-50 via-white to-white dark:from-slate-900 dark:via-slate-950 dark:to-slate-950"></div>
    <div class="absolute inset-0 bg-grid opacity-60 dark:opacity-20"></div>

    <div class="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10 md:py-14">
        <div class="flex items-center justify-between gap-4 reveal">
            <div>
                <h1 class="font-display text-3xl md:text-4xl font-extrabold tracking-tight">Secure Payment</h1>
                <p class="mt-2 text-sm text-slate-600 dark:text-slate-300">Pay to confirm your booking.</p>
            </div>
            <a href="<%= c %>/views/appointment-management/user_appointments.jsp"
               class="inline-flex items-center px-4 py-2 rounded-xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 hover:shadow-soft">
                ← Back
            </a>
        </div>
    </div>
</section>

<!-- CONTENT -->
<section class="max-w-xl mx-auto px-4 sm:px-6 lg:px-8 pb-16">
    <div class="reveal relative">
        <div class="absolute -inset-2 rounded-3xl bg-gradient-to-tr from-brand-600/20 via-brand-400/10 to-brand-600/20 blur-2xl"></div>

        <div class="relative rounded-3xl border border-slate-200 dark:border-slate-800 bg-white/80 dark:bg-slate-900/60 p-6 md:p-7 shadow-soft backdrop-blur">
            <div class="p-4 mb-6 rounded-2xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-900 flex items-center justify-between">
                <span class="text-sm text-slate-600 dark:text-slate-300">Amount due</span>
                <span class="text-xl font-extrabold">Rs <%= amount %></span>
            </div>

            <!-- Separate Stripe fields -->
            <!-- Payment form with validation -->
            <form id="paymentForm" class="space-y-4">
                <div>
                    <div class="block text-sm font-medium mb-1">Card Number <span class="text-rose-600">*</span></div>
                    <div id="card-number" class="rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-3 py-3"></div>
                    <!-- Card number validation error message -->
                    <div id="cardNumberError" class="text-red-500 text-sm mt-1 hidden"></div>
                </div>

                <div class="grid sm:grid-cols-2 gap-4">
                    <div>
                        <div class="block text-sm font-medium mb-1">Expiry <span class="text-rose-600">*</span></div>
                        <div id="card-expiry" class="rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-3 py-3"></div>
                        <!-- Card expiry validation error message -->
                        <div id="cardExpiryError" class="text-red-500 text-sm mt-1 hidden"></div>
                    </div>

                    <div>
                        <div class="block text-sm font-medium mb-1">CVC <span class="text-rose-600">*</span></div>
                        <div id="card-cvc" class="rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-3 py-3"></div>
                        <!-- Card CVC validation error message -->
                        <div id="cardCvcError" class="text-red-500 text-sm mt-1 hidden"></div>
                    </div>
                </div>

                <!-- Billing Information -->
                <div class="border-t border-slate-200 dark:border-slate-700 pt-4 mt-6">
                    <h3 class="text-sm font-medium mb-4">Billing Information</h3>
                    <div class="grid sm:grid-cols-2 gap-4">
                        <div>
                            <label for="billingName" class="block text-sm font-medium mb-1">Full Name <span class="text-rose-600">*</span></label>
                            <input type="text" id="billingName" name="billingName" required
                                   pattern="^[a-zA-Z\s]+$"
                                   title="Full name should only contain letters and spaces"
                                   placeholder="John Doe"
                                   class="form-input w-full px-3 py-2 rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900">
                            <!-- Billing name validation error message -->
                            <div id="billingNameError" class="text-red-500 text-sm mt-1 hidden"></div>
                        </div>

                        <div>
                            <label for="billingEmail" class="block text-sm font-medium mb-1">Email <span class="text-rose-600">*</span></label>
                            <input type="email" id="billingEmail" name="billingEmail" required
                                   pattern="[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$"
                                   title="Please enter a valid email address"
                                   placeholder="john@example.com"
                                   class="form-input w-full px-3 py-2 rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900">
                            <!-- Billing email validation error message -->
                            <div id="billingEmailError" class="text-red-500 text-sm mt-1 hidden"></div>
                        </div>
                    </div>
                </div>

                <!-- Payment consent -->
                <div class="flex items-start space-x-3 pt-2">
                    <input type="checkbox" id="paymentConsent" required
                           class="mt-0.5 h-4 w-4 text-brand-600 focus:ring-brand-500 border-gray-300 rounded">
                    <label for="paymentConsent" class="text-sm text-slate-600 dark:text-slate-300">
                        I confirm that the payment information is correct and authorize the payment of <strong>Rs <%= amount %></strong> for this appointment. <span class="text-rose-600">*</span>
                    </label>
                </div>
                <!-- Payment consent validation error message -->
                <div id="paymentConsentError" class="text-red-500 text-sm mt-1 hidden"></div>
            </form>

            <div id="msg" class="mt-3 text-sm text-rose-600"></div>

            <div class="mt-6 flex items-center gap-3">
                <button id="payBtn" type="button"
                        class="inline-flex items-center px-5 py-2.5 rounded-xl bg-brand-600 hover:bg-brand-700 text-white font-medium shadow-soft disabled:opacity-60 disabled:cursor-not-allowed">
                    Pay now
                </button>
                <a href="<%= c %>/views/user_appointments.jsp"
                   class="inline-flex items-center px-4 py-2 rounded-xl border border-slate-200 dark:border-slate-800 hover:shadow-soft">
                    Cancel
                </a>
            </div>
        </div>
    </div>
</section>

<%@ include file="../common/footer.jsp" %>

<script>
    // PAYMENT FORM VALIDATION SCRIPT
    document.addEventListener('DOMContentLoaded', function() {
        const paymentForm = document.getElementById('paymentForm');
        const billingNameInput = document.getElementById('billingName');
        const billingEmailInput = document.getElementById('billingEmail');
        const paymentConsentInput = document.getElementById('paymentConsent');
        
        const billingNameError = document.getElementById('billingNameError');
        const billingEmailError = document.getElementById('billingEmailError');
        const paymentConsentError = document.getElementById('paymentConsentError');
        const cardNumberError = document.getElementById('cardNumberError');
        const cardExpiryError = document.getElementById('cardExpiryError');
        const cardCvcError = document.getElementById('cardCvcError');

        // Validation functions
        function validateName(name) {
            const nameRegex = /^[a-zA-Z\s]+$/;
            return name.length >= 2 && name.length <= 50 && nameRegex.test(name);
        }

        function validateEmail(email) {
            const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
            return emailRegex.test(email);
        }

        // Real-time validation for billing name
        billingNameInput.addEventListener('blur', function() {
            const name = this.value.trim();
            if (name === '') {
                billingNameError.textContent = 'Full name is required';
                billingNameError.classList.remove('hidden');
                this.classList.add('border-red-500');
            } else if (!validateName(name)) {
                billingNameError.textContent = 'Full name should be 2-50 characters and contain only letters and spaces';
                billingNameError.classList.remove('hidden');
                this.classList.add('border-red-500');
            } else {
                billingNameError.classList.add('hidden');
                this.classList.remove('border-red-500');
            }
        });

        // Real-time validation for billing email
        billingEmailInput.addEventListener('blur', function() {
            const email = this.value.trim();
            if (email === '') {
                billingEmailError.textContent = 'Email is required';
                billingEmailError.classList.remove('hidden');
                this.classList.add('border-red-500');
            } else if (!validateEmail(email)) {
                billingEmailError.textContent = 'Please enter a valid email address';
                billingEmailError.classList.remove('hidden');
                this.classList.add('border-red-500');
            } else {
                billingEmailError.classList.add('hidden');
                this.classList.remove('border-red-500');
            }
        });

        // Real-time validation for payment consent
        paymentConsentInput.addEventListener('change', function() {
            if (!this.checked) {
                paymentConsentError.textContent = 'You must agree to authorize the payment';
                paymentConsentError.classList.remove('hidden');
            } else {
                paymentConsentError.classList.add('hidden');
            }
        });

        // Client-side form validation before Stripe processing
        function validatePaymentForm() {
            let isValid = true;

            // Validate billing name
            const name = billingNameInput.value.trim();
            if (!name) {
                billingNameError.textContent = 'Full name is required';
                billingNameError.classList.remove('hidden');
                billingNameInput.classList.add('border-red-500');
                isValid = false;
            } else if (!validateName(name)) {
                billingNameError.textContent = 'Full name should contain only letters and spaces';
                billingNameError.classList.remove('hidden');
                billingNameInput.classList.add('border-red-500');
                isValid = false;
            }

            // Validate billing email
            const email = billingEmailInput.value.trim();
            if (!email) {
                billingEmailError.textContent = 'Email is required';
                billingEmailError.classList.remove('hidden');
                billingEmailInput.classList.add('border-red-500');
                isValid = false;
            } else if (!validateEmail(email)) {
                billingEmailError.textContent = 'Please enter a valid email address';
                billingEmailError.classList.remove('hidden');
                billingEmailInput.classList.add('border-red-500');
                isValid = false;
            }

            // Validate payment consent
            if (!paymentConsentInput.checked) {
                paymentConsentError.textContent = 'You must agree to authorize the payment';
                paymentConsentError.classList.remove('hidden');
                isValid = false;
            }

            return isValid;
        }

        // Reveal animation observer
        const observer = new IntersectionObserver(entries => {
            entries.forEach(e => { if (e.isIntersecting) e.target.classList.add('visible'); });
        }, { threshold: 0.08 });
        document.querySelectorAll('.reveal').forEach(el => observer.observe(el));

        // Stripe setup and validation
        const stripe = Stripe("<%= pk %>");
        const elements = stripe.elements();

        // Dynamic styling based on theme
        const isDarkMode = document.documentElement.classList.contains('dark');
        const style = {
            base: { 
                fontSize: '16px', 
                color: isDarkMode ? '#ffffff' : '#1e293b', 
                '::placeholder': { color: isDarkMode ? '#9ca3af' : '#64748b' }
            },
            invalid: { color: '#ef4444' }
        };

        const cardNumber = elements.create('cardNumber', { style });
        cardNumber.mount('#card-number');

        const cardExpiry = elements.create('cardExpiry', { style });
        cardExpiry.mount('#card-expiry');

        const cardCvc = elements.create('cardCvc', { style });
        cardCvc.mount('#card-cvc');

        // Function to update Stripe element styles based on theme
        function updateStripeStyles() {
            const isDarkMode = document.documentElement.classList.contains('dark');
            const newStyle = {
                base: { 
                    fontSize: '16px', 
                    color: isDarkMode ? '#ffffff' : '#1e293b', 
                    '::placeholder': { color: isDarkMode ? '#9ca3af' : '#64748b' }
                },
                invalid: { color: '#ef4444' }
            };
            
            cardNumber.update({ style: newStyle });
            cardExpiry.update({ style: newStyle });
            cardCvc.update({ style: newStyle });
        }

        // Listen for theme changes
        const themeObserver = new MutationObserver(function(mutations) {
            mutations.forEach(function(mutation) {
                if (mutation.type === 'attributes' && mutation.attributeName === 'class') {
                    updateStripeStyles();
                }
            });
        });

        themeObserver.observe(document.documentElement, {
            attributes: true,
            attributeFilter: ['class']
        });

        const payBtn = document.getElementById('payBtn');
        const msg = document.getElementById('msg');

        // Stripe field validation
        cardNumber.addEventListener('change', function(event) {
            if (event.error) {
                cardNumberError.textContent = event.error.message;
                cardNumberError.classList.remove('hidden');
            } else {
                cardNumberError.classList.add('hidden');
            }
        });

        cardExpiry.addEventListener('change', function(event) {
            if (event.error) {
                cardExpiryError.textContent = event.error.message;
                cardExpiryError.classList.remove('hidden');
            } else {
                cardExpiryError.classList.add('hidden');
            }
        });

        cardCvc.addEventListener('change', function(event) {
            if (event.error) {
                cardCvcError.textContent = event.error.message;
                cardCvcError.classList.remove('hidden');
            } else {
                cardCvcError.classList.add('hidden');
            }
        });

        // Payment processing with validation
        payBtn.addEventListener('click', async function() {
            msg.textContent = '';

            // First validate the form
            if (!validatePaymentForm()) {
                msg.textContent = 'Please correct the errors above before proceeding.';
                return;
            }

            payBtn.disabled = true;
            payBtn.textContent = 'Processing...';

            const { error, paymentIntent } = await stripe.confirmCardPayment("<%= clientSecret %>", {
                payment_method: { 
                    card: cardNumber,
                    billing_details: {
                        name: billingNameInput.value.trim(),
                        email: billingEmailInput.value.trim()
                    }
                }
            });

            if (error) {
                msg.textContent = error.message || 'Payment failed. Please try again.';
                payBtn.disabled = false;
                payBtn.textContent = 'Pay now';
                return;
            }

            if (paymentIntent && paymentIntent.status === 'succeeded') {
                try {
                    // Use JSP variable directly in JSON
                    const response = await fetch("<%= c %>/pay/online/confirm", {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({ 
                            appointmentId: <%= appointmentId != null ? appointmentId : 0 %>, 
                            paymentIntentId: paymentIntent.id 
                        })
                    });
                    
                    if (response.ok) {
                        window.location = "<%= c %>/pay/success?appointmentId=<%= appointmentId %>";
                    } else {
                        msg.textContent = 'Payment succeeded but server update failed.';
                        payBtn.disabled = false;
                        payBtn.textContent = 'Pay now';
                    }
                } catch (e) {
                    msg.textContent = 'Payment succeeded, but a server error occurred.';
                    payBtn.disabled = false;
                    payBtn.textContent = 'Pay now';
                }
            }
        });
    });
</script>
</body>
</html>




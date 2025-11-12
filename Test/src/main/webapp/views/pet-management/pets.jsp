<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.happypaws.petcare.model.Pet" %>

<%
    List<Pet> pets = (List<Pet>) request.getAttribute("pets");
    String cpath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>My Pets — Happy Paws PetCare</title>
    <meta name="description" content="Manage your pets and book appointments." />

    <script>
        (function() {
            'use strict';

            const saved = localStorage.getItem('theme');
            const prefersDark = window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches;
            const shouldDark = saved ? (saved === 'dark') : prefersDark;

            if (shouldDark) {
                document.documentElement.classList.add('dark');
            } else {
                document.documentElement.classList.remove('dark');
            }
        })();
    </script>

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
                        brand: { 50:'#effaff',100:'#d7f0ff',200:'#b2e1ff',300:'#84cdff',400:'#53b2ff',500:'#2f97ff',600:'#1679e6',700:'#0f5fba',800:'#0f4c91',900:'#113e75' }
                    },
                    boxShadow: { soft:'0 10px 30px rgba(0,0,0,.06)', glow:'0 0 0 6px rgba(47,151,255,.10)' }
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
        .soft-card { transition: box-shadow .2s ease, transform .08s ease; }
        .soft-card:hover { transform: translateY(-1px); box-shadow: 0 10px 30px rgba(0,0,0,.08); }
        .fade-in { opacity: 0; transform: translateY(10px); transition: opacity 0.3s ease, transform 0.3s ease; }
        .fade-in.show { opacity: 1; transform: translateY(0); }
        /* Styles for validation */
        .error-message { color: #e53e3e; /* text-rose-600 */ font-size: 0.75rem; /* text-xs */ margin-top: 0.25rem; /* mt-1 */ }
        .is-invalid { border-color: #e53e3e !important; /* border-rose-600 */ }
    </style>
</head>
<body class="antialiased text-slate-800 dark:text-slate-100 bg-white dark:bg-slate-950">

<%@ include file="../common/header.jsp" %>

<section class="relative overflow-hidden">
    <div class="absolute inset-0 bg-gradient-to-b from-brand-50 via-white to-white dark:from-slate-900 dark:via-slate-950 dark:to-slate-950"></div>
    <div class="absolute inset-0 bg-grid opacity-60 dark:opacity-20"></div>

    <div class="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10 md:py-14">
        <div class="flex items-center justify-between gap-4 reveal">
            <div>
                <h1 class="font-display text-3xl md:text-4xl font-extrabold tracking-tight">My Pets</h1>
                <p class="mt-2 text-sm text-slate-600 dark:text-slate-300">Manage your pets and book appointments.</p>
            </div>
            <div class="flex items-center gap-2">
                <button onclick="toggleAddPetForm()" id="addPetBtn"
                        class="inline-flex items-center px-4 py-2 rounded-xl bg-brand-600 hover:bg-brand-700 text-white shadow-soft">
                    Add New Pet
                </button>
                <a href="<%= cpath %>/owner/dashboard"
                   class="inline-flex items-center px-4 py-2 rounded-xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 hover:shadow-soft">
                    Back to Dashboard
                </a>
            </div>
        </div>
    </div>
</section>

<section class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 pb-16">

    <%
        String error = (String) request.getAttribute("error");
        String success = (String) request.getAttribute("success");
        if (error != null) {
    %>
    <div id="errorMessage" class="mt-6 rounded-xl p-4 text-sm bg-rose-50 text-rose-800 dark:bg-rose-900/30 dark:text-rose-200 border border-rose-200/50 transition-opacity duration-500 relative">
        <div class="flex items-center justify-between">
            <span><%= error %></span>
            <button onclick="closeErrorMessage()" class="ml-4 text-rose-600 hover:text-rose-800 dark:text-rose-400 dark:hover:text-rose-200">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                </svg>
            </button>
        </div>
    </div>
    <% } else if (success != null) { %>
    <div id="successMessage" class="mt-6 rounded-xl p-4 text-sm bg-emerald-50 text-emerald-800 dark:bg-emerald-900/30 dark:text-emerald-200 border border-emerald-200/50 transition-opacity duration-500 relative">
        <div class="flex items-center justify-between">
            <span><%= success %></span>
            <button onclick="closeSuccessMessage()" class="ml-4 text-emerald-600 hover:text-emerald-800 dark:text-emerald-400 dark:hover:text-emerald-200">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                </svg>
            </button>
        </div>
    </div>
    <% } %>

    <div id="addPetForm" class="mt-8 fade-in" style="display: none;">
        <div class="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 shadow-soft p-6">
            <div class="flex items-center justify-between mb-6">
                <h2 class="text-xl font-semibold">Register New Pet</h2>
                <button onclick="toggleAddPetForm()" class="text-slate-400 hover:text-slate-600 dark:hover:text-slate-300">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                    </svg>
                </button>
            </div>

            <form id="petForm" method="post" action="<%= cpath %>/owner/pets" class="space-y-6" novalidate>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div>
                        <label for="name" class="block text-sm font-medium mb-2">Pet Name <span class="text-rose-600">*</span></label>
                        <input type="text" id="name" name="name" required
                               class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-3 py-2"
                               placeholder="Enter pet's name" />
                        <div class="error-message"></div>
                    </div>

                    <div>
                        <label for="species" class="block text-sm font-medium mb-2">Species <span class="text-rose-600">*</span></label>
                        <select id="species" name="species" required
                                class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-3 py-2">
                            <option value="">Select species</option>
                            <option value="Dog">Dog</option>
                            <option value="Cat">Cat</option>
                            <option value="Bird">Bird</option>
                            <option value="Rabbit">Rabbit</option>
                            <option value="Hamster">Hamster</option>
                            <option value="Fish">Fish</option>
                            <option value="Other">Other</option>
                        </select>
                        <div class="error-message"></div>
                    </div>

                    <div>
                        <label for="breed" class="block text-sm font-medium mb-2">Breed</label>
                        <input type="text" id="breed" name="breed"
                               class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-3 py-2"
                               placeholder="Enter breed" />
                        <div class="error-message"></div>
                    </div>

                    <div>
                        <label for="dob" class="block text-sm font-medium mb-2">Date of Birth</label>
                        <input type="date" id="dob" name="dob"
                               class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-3 py-2" />
                        <div class="error-message"></div>
                    </div>

                    <div>
                        <label for="sex" class="block text-sm font-medium mb-2">Sex</label>
                        <select id="sex" name="sex"
                                class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-3 py-2">
                            <option value="">Select sex</option>
                            <option value="Male">Male</option>
                            <option value="Female">Female</option>
                            <option value="Unknown">Unknown</option>
                        </select>
                        <div class="error-message"></div>
                    </div>

                    <div>
                        <label for="microchipNo" class="block text-sm font-medium mb-2">Microchip Number</label>
                        <input type="text" id="microchipNo" name="microchipNo"
                               class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-3 py-2"
                               placeholder="Enter microchip number (optional)" />
                        <div class="error-message"></div>
                    </div>
                </div>

                <div class="flex items-center gap-3 pt-4">
                    <button type="submit"
                            class="inline-flex items-center px-6 py-3 rounded-xl bg-brand-600 hover:bg-brand-700 text-white font-medium shadow-soft">
                        Register Pet
                    </button>
                    <button type="button" onclick="toggleAddPetForm()"
                            class="inline-flex items-center px-4 py-3 rounded-xl border border-slate-200 dark:border-slate-800 hover:shadow-soft">
                        Cancel
                    </button>
                </div>
            </form>
        </div>
    </div>

    <div class="mt-8 grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
        <% if (pets != null && !pets.isEmpty()) {
            for (Pet p : pets) { %>
        <article class="reveal soft-card rounded-2xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 shadow-soft p-5">
            <div class="flex items-start justify-between">
                <div class="min-w-0">
                    <div class="mb-1">
                        <span class="inline-flex items-center px-2 py-0.5 rounded-lg text-xs bg-slate-50 dark:bg-slate-800/50 text-slate-600 dark:text-slate-300">
                            <%= p.getSpecies()!=null? p.getSpecies() : "Pet" %>
                        </span>
                    </div>
                    <h3 class="text-lg font-semibold truncate"><%= p.getName()!=null? p.getName() : "(Unnamed)" %></h3>
                </div>
            </div>

            <dl class="mt-4 text-sm space-y-2">
                <div class="flex items-center justify-between gap-3">
                    <dt class="text-slate-500">Breed</dt>
                    <dd class="text-right truncate"><%= p.getBreed()!=null? p.getBreed():"—" %></dd>
                </div>
                <div class="flex items-center justify-between gap-3">
                    <dt class="text-slate-500">Sex</dt>
                    <dd class="text-right"><%= p.getSex()!=null? p.getSex():"—" %></dd>
                </div>
                <div class="flex items-center justify-between gap-3">
                    <dt class="text-slate-500">DOB</dt>
                    <dd class="text-right"><%= p.getDob()!=null? p.getDob():"—" %></dd>
                </div>
                <div class="flex items-center justify-between gap-3 font-mono text-xs">
                    <dt class="text-slate-500">UID</dt>
                    <dd class="text-right break-all"><%= p.getPetUid() %></dd>
                </div>
            </dl>

            <div class="mt-5 flex flex-wrap gap-2">
                <a href="<%= cpath %>/appointments/new?petUid=<%= p.getPetUid() %>"
                   class="inline-flex items-center px-3 py-1.5 rounded-xl bg-brand-600 hover:bg-brand-700 text-white">
                    Add appointment
                </a>

                <button type="button" onclick="openRecordsModal('<%= p.getPetUid() %>', '<%= p.getName() %>')"
                        class="inline-flex items-center px-3 py-1.5 rounded-xl bg-emerald-600 hover:bg-emerald-700 text-white">
                    Records
                </button>

                <a href="<%= cpath %>/owner/pets/edit?uid=<%= p.getPetUid() %>"
                   class="inline-flex items-center px-3 py-1.5 rounded-xl border border-slate-200 dark:border-slate-800 hover:shadow-soft">
                    Edit
                </a>

                <button type="button" onclick="deletePet('<%= p.getPetUid() %>')"
                        class="inline-flex items-center px-3 py-1.5 rounded-xl bg-rose-600 text-white hover:bg-rose-700">
                    Delete
                </button>
            </div>
        </article>
        <% } } else { %>

        <div class="reveal col-span-full">
            <div class="rounded-2xl border-2 border-dashed border-slate-200 dark:border-slate-800 p-10 text-center bg-white dark:bg-slate-900">
                <div class="mx-auto h-12 w-12 rounded-2xl bg-brand-50 dark:bg-slate-800 flex items-center justify-center mb-3">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-brand-600" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                        <path d="M12 6v12m6-6H6" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                    </svg>
                </div>
                <h3 class="font-semibold">No pets yet</h3>
                <p class="mt-1 text-sm text-slate-500 dark:text-slate-400">Add your first pet to start booking appointments.</p>
                <div class="mt-4">
                    <button onclick="toggleAddPetForm()"
                            class="inline-flex items-center px-4 py-2 rounded-xl bg-brand-600 hover:bg-brand-700 text-white shadow-soft">
                        Add New Pet
                    </button>
                </div>
            </div>
        </div>
        <% } %>
    </div>
</section>

<div id="recordsModal" class="hidden fixed inset-0 bg-black/50 dark:bg-black/70 z-50 flex items-center justify-center p-4" onclick="closeRecordsModal(event)">
    <div class="bg-white dark:bg-slate-900 rounded-2xl shadow-2xl max-w-md w-full p-6" onclick="event.stopPropagation()">
        <div class="flex items-center justify-between mb-6">
            <h3 class="text-xl font-semibold" id="modalPetName">Pet Records</h3>
            <button onclick="closeRecordsModal()" class="text-slate-400 hover:text-slate-600 dark:hover:text-slate-300">
                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                </svg>
            </button>
        </div>

        <p class="text-sm text-slate-600 dark:text-slate-400 mb-6">Choose which records you'd like to view:</p>

        <div class="space-y-3">
            <a id="medicalRecordsLink" href="#"
               class="block w-full px-4 py-3 rounded-xl border-2 border-emerald-200 dark:border-emerald-800 bg-emerald-50 dark:bg-emerald-900/20 hover:bg-emerald-100 dark:hover:bg-emerald-900/30 transition-colors">
                <div class="flex items-center gap-3">
                    <div class="flex-shrink-0 w-10 h-10 rounded-lg bg-emerald-600 flex items-center justify-center">
                        <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path>
                        </svg>
                    </div>
                    <div class="flex-1 text-left">
                        <div class="font-semibold text-emerald-900 dark:text-emerald-100">Medical Records</div>
                        <div class="text-xs text-emerald-700 dark:text-emerald-300">View veterinary visit history</div>
                    </div>
                    <svg class="w-5 h-5 text-emerald-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
                    </svg>
                </div>
            </a>

            <a id="groomingSessionsLink" href="#"
               class="block w-full px-4 py-3 rounded-xl border-2 border-purple-200 dark:border-purple-800 bg-purple-50 dark:bg-purple-900/20 hover:bg-purple-100 dark:hover:bg-purple-900/30 transition-colors">
                <div class="flex items-center gap-3">
                    <div class="flex-shrink-0 w-10 h-10 rounded-lg bg-purple-600 flex items-center justify-center">
                        <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14.828 14.828a4 4 0 01-5.656 0M9 10h.01M15 10h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                        </svg>
                    </div>
                    <div class="flex-1 text-left">
                        <div class="font-semibold text-purple-900 dark:text-purple-100">Grooming History</div>
                        <div class="text-xs text-purple-700 dark:text-purple-300">View grooming sessions</div>
                    </div>
                    <svg class="w-5 h-5 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
                    </svg>
                </div>
            </a>
        </div>

        <button onclick="closeRecordsModal()"
                class="mt-6 w-full px-4 py-2 rounded-xl border border-slate-200 dark:border-slate-800 hover:bg-slate-50 dark:hover:bg-slate-800 transition-colors">
            Cancel
        </button>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>

<script>
    // Reveal on scroll (same micro-interaction feel)
    const observer = new IntersectionObserver(entries => {
        entries.forEach(e => { if (e.isIntersecting) e.target.classList.add('visible'); });
    }, { threshold: 0.08 });
    document.querySelectorAll('.reveal').forEach(el => observer.observe(el));

    // Open Records Modal
    function openRecordsModal(petUid, petName) {
        const modal = document.getElementById('recordsModal');
        const modalTitle = document.getElementById('modalPetName');
        const medicalLink = document.getElementById('medicalRecordsLink');
        const groomingLink = document.getElementById('groomingSessionsLink');

        modalTitle.textContent = petName + ' - Records';
        medicalLink.href = '<%= cpath %>/owner/pets/medical-records?petUid=' + petUid;
        groomingLink.href = '<%= cpath %>/owner/pets/grooming-sessions?petUid=' + petUid;

        modal.classList.remove('hidden');
        document.body.style.overflow = 'hidden'; // Prevent background scrolling
    }

    // Close Records Modal
    function closeRecordsModal(event) {
        // Only close if clicking the backdrop or close button (not the modal content)
        if (!event || event.target.id === 'recordsModal' || event.type === 'click') {
            const modal = document.getElementById('recordsModal');
            modal.classList.add('hidden');
            document.body.style.overflow = ''; // Restore scrolling
        }
    }

    // Close modal on Escape key
    document.addEventListener('keydown', function(event) {
        if (event.key === 'Escape') {
            const modal = document.getElementById('recordsModal');
            if (!modal.classList.contains('hidden')) {
                closeRecordsModal();
            }
        }
    });

    // Toggle Add Pet Form
    function toggleAddPetForm() {
        const form = document.getElementById('addPetForm');
        const btn = document.getElementById('addPetBtn');

        if (form.style.display === 'none' || form.style.display === '') {
            form.style.display = 'block';
            setTimeout(() => form.classList.add('show'), 10);
            btn.textContent = 'Cancel';
            btn.classList.remove('bg-brand-600', 'hover:bg-brand-700');
            btn.classList.add('bg-slate-600', 'hover:bg-slate-700');

            form.scrollIntoView({ behavior: 'smooth', block: 'start' });
        } else {
            form.classList.remove('show');
            setTimeout(() => form.style.display = 'none', 300);
            btn.textContent = 'Add New Pet';
            btn.classList.remove('bg-slate-600', 'hover:bg-slate-700');
            btn.classList.add('bg-brand-600', 'hover:bg-brand-700');
        }
    }

    // Close success message manually
    function closeSuccessMessage() {
        const successMessage = document.getElementById('successMessage');
        if (successMessage) {
            successMessage.style.opacity = '0';
            setTimeout(function() {
                successMessage.style.display = 'none';
            }, 500);
        }
    }

    // Close error message manually
    function closeErrorMessage() {
        const errorMessage = document.getElementById('errorMessage');
        if (errorMessage) {
            errorMessage.style.opacity = '0';
            setTimeout(function() {
                errorMessage.style.display = 'none';
            }, 500);
        }
    }

    async function deletePet(uid){
        if(!confirm("Delete this pet? This will archive the pet UID and keep past appointments intact.")) return;

        try {
            const res = await fetch("<%= cpath %>/owner/pets/delete", {
                method:"POST",
                headers:{ "Content-Type":"application/json" },
                body: JSON.stringify({ uid })
            });

            if(res.ok){
                window.location.href = "<%= cpath %>/owner/pets?success=Pet+deleted+successfully";
            } else {
                let msg = "Failed to delete pet";
                try {
                    const j = await res.json();
                    msg = j.error || msg;
                } catch(e){
                    msg = `Failed to delete pet (HTTP ${res.status})`;
                }
                alert(msg);
            }
        } catch(error) {
            console.error('Error deleting pet:', error);
            alert("Network error: Could not delete pet. Please try again.");
        }
    }
</script>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const form = document.getElementById('petForm');
        if (!form) return;

        const nameInput = document.getElementById('name');
        const speciesInput = document.getElementById('species');
        const dobInput = document.getElementById('dob');
        const microchipInput = document.getElementById('microchipNo');

        // Set max date for DOB input to today to disable future dates
        const today = new Date().toISOString().split('T')[0];
        dobInput.setAttribute('max', today);

        // Prevent typing numbers in the name field
        nameInput.addEventListener('keydown', (e) => {
            // Allow control keys like backspace, tab, arrows, etc.
            if (e.ctrlKey || e.altKey || e.metaKey || e.key.length > 1) {
                return;
            }
            // Prevent default action if the key is a digit
            if (/\d/.test(e.key)) {
                e.preventDefault();
            }
        });

        const showError = (input, message) => {
            const formField = input.parentElement;
            input.classList.add('is-invalid');
            const error = formField.querySelector('.error-message');
            error.textContent = message;
        };

        const clearError = (input) => {
            const formField = input.parentElement;
            input.classList.remove('is-invalid');
            const error = formField.querySelector('.error-message');
            error.textContent = '';
        };

        const checkName = () => {
            let valid = false;
            const min = 2, max = 50;
            const name = nameInput.value.trim();

            if (!name) {
                showError(nameInput, 'Pet name is required.');
            } else if (/\d/.test(name)) { // Check for pasted numbers
                showError(nameInput, 'Name cannot contain numbers.');
            } else if (name.length < min || name.length > max) {
                showError(nameInput, `Name must be between ${min} and ${max} characters.`);
            } else {
                clearError(nameInput);
                valid = true;
            }
            return valid;
        };

        const checkSpecies = () => {
            let valid = false;
            if (speciesInput.value === "") {
                showError(speciesInput, 'Please select a species.');
            } else {
                clearError(speciesInput);
                valid = true;
            }
            return valid;
        };

        const checkDob = () => {
            // The `max` attribute handles future date validation, so this just clears errors
            clearError(dobInput);
            return true;
        };

        const checkMicrochip = () => {
            let valid = true; // Optional field
            const microchipValue = microchipInput.value.trim();
            if (microchipValue) {
                const regex = /^[a-zA-Z0-9]{9,15}$/;
                if (!regex.test(microchipValue)) {
                    showError(microchipInput, 'Must be 9-15 alphanumeric characters.');
                    valid = false;
                } else {
                    clearError(microchipInput);
                }
            } else {
                clearError(microchipInput);
            }
            return valid;
        };

        form.addEventListener('submit', function(e) {
            e.preventDefault();
            let isFormValid = checkName() && checkSpecies() && checkDob() && checkMicrochip();
            if (isFormValid) {
                form.submit();
            }
        });
    });
</script>

<% if (error != null) { %>
<script>
    window.addEventListener('DOMContentLoaded', function() {
        toggleAddPetForm();
        const errorMessage = document.getElementById('errorMessage');
        if (errorMessage) {
            setTimeout(function() {
                errorMessage.style.opacity = '0';
                setTimeout(function() { errorMessage.style.display = 'none'; }, 500);
            }, 5000);
        }
    });
</script>
<% } %>

<% if (success != null) { %>
<script>
    window.addEventListener('DOMContentLoaded', function() {
        const successMessage = document.getElementById('successMessage');
        if (successMessage) {
            setTimeout(function() {
                successMessage.style.opacity = '0';
                setTimeout(function() { successMessage.style.display = 'none'; }, 500);
            }, 3000);
        }
    });
</script>
<% } %>

</body>
</html>
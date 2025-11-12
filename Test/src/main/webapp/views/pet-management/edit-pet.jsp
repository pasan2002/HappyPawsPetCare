<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.happypaws.petcare.model.Pet" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<%
    Pet pet = (Pet) request.getAttribute("pet");
    String error = request.getParameter("error");
    String cpath = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="en" class="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Pet - HappyPaws Pet Care</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            darkMode: 'class',
            theme: {
                extend: {
                    colors: {
                        brand: {
                            50: '#f0f9ff', 100: '#e0f2fe', 200: '#bae6fd', 300: '#7dd3fc', 400: '#38bdf8',
                            500: '#0ea5e9', 600: '#0284c7', 700: '#0369a1', 800: '#075985', 900: '#0c4a6e',
                        }
                    }
                }
            }
        }
    </script>
    <style>
        /* Styles for validation */
        .error-message { color: #e53e3e; font-size: 0.875rem; margin-top: 0.25rem; }
        .is-invalid { border-color: #e53e3e !important; }
    </style>
</head>
<body class="bg-slate-50 dark:bg-slate-900 text-slate-900 dark:text-slate-100 min-h-screen">
<div class="min-h-screen bg-slate-50 dark:bg-slate-900">
    <!-- Header -->
    <header class="bg-white dark:bg-slate-800 shadow-sm border-b border-slate-200 dark:border-slate-700">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between items-center py-4">
                <a href="<%= cpath %>/owner/pets" class="text-2xl font-bold text-slate-900 dark:text-white">HappyPaws</a>
                <nav>
                    <a href="<%= cpath %>/owner/pets" class="text-slate-600 dark:text-slate-300 hover:text-slate-900 dark:hover:text-white">Back to Pets</a>
                </nav>
            </div>
        </div>
    </header>

    <!-- Main Content -->
    <main class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div class="bg-white dark:bg-slate-800 rounded-xl shadow-sm border border-slate-200 dark:border-slate-700 p-6">
            <div class="mb-6">
                <h1 class="text-2xl font-bold text-slate-900 dark:text-white">Edit Pet</h1>
                <p class="text-slate-600 dark:text-slate-400 mt-1">Update your pet's information</p>
            </div>

            <% if (error != null) { %>
            <div class="mb-6 p-4 bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800 rounded-lg">
                <p class="text-red-600 dark:text-red-400"><%= error %></p>
            </div>
            <% } %>

            <form id="editPetForm" method="POST" action="<%= cpath %>/owner/pets/edit" class="space-y-6" novalidate>
                <input type="hidden" name="uid" value="<%= pet.getPetUid() %>">

                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <!-- Pet Name -->
                    <div>
                        <label for="name" class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2">Pet Name *</label>
                        <input type="text" id="name" name="name" value="<%= pet.getName() != null ? pet.getName() : "" %>" required
                               class="w-full px-3 py-2 border border-slate-300 dark:border-slate-600 rounded-lg focus:ring-2 focus:ring-brand-500 focus:border-brand-500 dark:bg-slate-700 dark:text-white">
                        <div class="error-message"></div>
                    </div>

                    <!-- Species -->
                    <div>
                        <label for="species" class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2">Species *</label>
                        <select id="species" name="species" required
                                class="w-full px-3 py-2 border border-slate-300 dark:border-slate-600 rounded-lg focus:ring-2 focus:ring-brand-500 focus:border-brand-500 dark:bg-slate-700 dark:text-white">
                            <option value="">Select species</option>
                            <option value="Dog" <%= "Dog".equals(pet.getSpecies()) ? "selected" : "" %>>Dog</option>
                            <option value="Cat" <%= "Cat".equals(pet.getSpecies()) ? "selected" : "" %>>Cat</option>
                            <option value="Bird" <%= "Bird".equals(pet.getSpecies()) ? "selected" : "" %>>Bird</option>
                            <option value="Rabbit" <%= "Rabbit".equals(pet.getSpecies()) ? "selected" : "" %>>Rabbit</option>
                            <option value="Hamster" <%= "Hamster".equals(pet.getSpecies()) ? "selected" : "" %>>Hamster</option>
                            <option value="Fish" <%= "Fish".equals(pet.getSpecies()) ? "selected" : "" %>>Fish</option>
                            <option value="Other" <%= "Other".equals(pet.getSpecies()) ? "selected" : "" %>>Other</option>
                        </select>
                        <div class="error-message"></div>
                    </div>

                    <!-- Breed -->
                    <div>
                        <label for="breed" class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2">Breed</label>
                        <input type="text" id="breed" name="breed" value="<%= pet.getBreed() != null ? pet.getBreed() : "" %>" placeholder="e.g., Labrador, Persian, etc."
                               class="w-full px-3 py-2 border border-slate-300 dark:border-slate-600 rounded-lg focus:ring-2 focus:ring-brand-500 focus:border-brand-500 dark:bg-slate-700 dark:text-white">
                        <div class="error-message"></div>
                    </div>

                    <!-- Date of Birth -->
                    <div>
                        <label for="dob" class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2">Date of Birth</label>
                        <input type="date" id="dob" name="dob" value="<%= pet.getDob() != null ? pet.getDob().format(DateTimeFormatter.ISO_LOCAL_DATE) : "" %>"
                               class="w-full px-3 py-2 border border-slate-300 dark:border-slate-600 rounded-lg focus:ring-2 focus:ring-brand-500 focus:border-brand-500 dark:bg-slate-700 dark:text-white">
                        <div class="error-message"></div>
                    </div>

                    <!-- Sex -->
                    <div>
                        <label for="sex" class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2">Sex</label>
                        <select id="sex" name="sex"
                                class="w-full px-3 py-2 border border-slate-300 dark:border-slate-600 rounded-lg focus:ring-2 focus:ring-brand-500 focus:border-brand-500 dark:bg-slate-700 dark:text-white">
                            <option value="">Select sex</option>
                            <option value="Male" <%= "Male".equals(pet.getSex()) ? "selected" : "" %>>Male</option>
                            <option value="Female" <%= "Female".equals(pet.getSex()) ? "selected" : "" %>>Female</option>
                            <option value="Unknown" <%= "Unknown".equals(pet.getSex()) ? "selected" : "" %>>Unknown</option>
                        </select>
                        <div class="error-message"></div>
                    </div>

                    <!-- Microchip Number -->
                    <div>
                        <label for="microchipNo" class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-2">Microchip Number</label>
                        <input type="text" id="microchipNo" name="microchipNo" value="<%= pet.getMicrochipNo() != null ? pet.getMicrochipNo() : "" %>" placeholder="e.g., 981020035678123"
                               class="w-full px-3 py-2 border border-slate-300 dark:border-slate-600 rounded-lg focus:ring-2 focus:ring-brand-500 focus:border-brand-500 dark:bg-slate-700 dark:text-white">
                        <div class="error-message"></div>
                    </div>
                </div>

                <!-- Pet UID (Read-only) -->
                <div class="bg-slate-100 dark:bg-slate-700/50 p-4 rounded-lg border border-slate-200 dark:border-slate-700">
                    <label class="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-1">Pet UID (Unique Identifier)</label>
                    <p class="text-sm text-slate-800 dark:text-slate-200 font-mono tracking-wider"><%= pet.getPetUid() %></p>
                    <p class="text-xs text-slate-500 dark:text-slate-400 mt-1">This unique identifier cannot be changed.</p>
                </div>

                <!-- Action Buttons -->
                <div class="flex justify-end space-x-4 pt-6 border-t border-slate-200 dark:border-slate-700">
                    <a href="<%= cpath %>/owner/pets" class="px-6 py-2 border border-slate-300 dark:border-slate-600 text-slate-700 dark:text-slate-300 rounded-lg hover:bg-slate-100 dark:hover:bg-slate-700 transition-colors">Cancel</a>
                    <button type="submit" class="px-6 py-2 bg-brand-600 hover:bg-brand-700 text-white rounded-lg transition-colors font-medium">Update Pet</button>
                </div>
            </form>
        </div>
    </main>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        const form = document.getElementById('editPetForm');
        if (!form) return;

        const nameInput = document.getElementById('name');
        const speciesInput = document.getElementById('species');
        const breedInput = document.getElementById('breed');
        const dobInput = document.getElementById('dob');
        const microchipInput = document.getElementById('microchipNo');

        // Set max date for DOB input to today to disable future dates
        const today = new Date().toISOString().split('T')[0];
        dobInput.setAttribute('max', today);

        // Helper function to prevent typing invalid characters
        const filterInput = (element, regex) => {
            element.addEventListener('keydown', (e) => {
                // Allow control keys like backspace, tab, arrows, etc.
                if (e.ctrlKey || e.altKey || e.metaKey || e.key.length > 1) {
                    return;
                }
                // Block input if it doesn't match the allowed character set
                if (!regex.test(e.key)) {
                    e.preventDefault();
                }
            });
        };

        // Apply input filters
        filterInput(nameInput, /^[a-zA-Z\s'-]$/); // Allow letters, space, hyphen, apostrophe
        filterInput(breedInput, /^[a-zA-Z\s'-]$/); // Allow letters, space, hyphen, apostrophe
        filterInput(microchipInput, /^[0-9]$/); // UPDATED: Allow only numbers

        // --- Validation Logic ---
        const showError = (input, message) => {
            const container = input.parentElement;
            input.classList.add('is-invalid');
            const errorDiv = container.querySelector('.error-message');
            if (errorDiv) {
                errorDiv.textContent = message;
            }
        };

        const clearError = (input) => {
            const container = input.parentElement;
            input.classList.remove('is-invalid');
            const errorDiv = container.querySelector('.error-message');
            if (errorDiv) {
                errorDiv.textContent = '';
            }
        };

        const checkName = () => {
            clearError(nameInput);
            const name = nameInput.value.trim();
            if (!name) {
                showError(nameInput, 'Pet name is required.');
                return false;
            }
            if (!/^[a-zA-Z\s'-]+$/.test(name)) {
                showError(nameInput, 'Name can only contain letters, spaces, hyphens, and apostrophes.');
                return false;
            }
            if (name.length < 2 || name.length > 50) {
                showError(nameInput, 'Name must be between 2 and 50 characters.');
                return false;
            }
            return true;
        };

        const checkBreed = () => {
            clearError(breedInput);
            const breed = breedInput.value.trim();
            if (breed && !/^[a-zA-Z\s'-]+$/.test(breed)) {
                showError(breedInput, 'Breed can only contain letters, spaces, hyphens, and apostrophes.');
                return false;
            }
            return true;
        };

        const checkSpecies = () => {
            clearError(speciesInput);
            if (speciesInput.value === "") {
                showError(speciesInput, 'Please select a species.');
                return false;
            }
            return true;
        };

        // UPDATED checkMicrochip function
        const checkMicrochip = () => {
            clearError(microchipInput);
            const value = microchipInput.value.trim();
            // Check if field is empty (optional field)
            if (!value) {
                return true;
            }
            // Check if it contains only numbers and is between 9 and 15 digits
            if (!/^[0-9]{9,15}$/.test(value)) {
                showError(microchipInput, 'Microchip must be 9-15 numbers.');
                return false;
            }
            return true;
        };

        form.addEventListener('submit', function (e) {
            e.preventDefault();

            // Run all validation checks
            const isNameValid = checkName();
            const isSpeciesValid = checkSpecies();
            const isBreedValid = checkBreed();
            const isMicrochipValid = checkMicrochip();

            // If all checks pass, submit the form
            if (isNameValid && isSpeciesValid && isBreedValid && isMicrochipValid) {
                form.submit();
            }
        });
    });
</script>
</body>
</html>
<%@ page import="java.util.List" %>
<%@ page import="com.happypaws.petcare.model.MedicalRecord" %>
<%@ page import="com.happypaws.petcare.model.Pet" %>
<%@ page import="com.happypaws.petcare.model.Staff" %>

<%
    List<MedicalRecord> records = (List<MedicalRecord>) request.getAttribute("records");
    List<Pet> pets = (List<Pet>) request.getAttribute("pets");
    List<Staff> staffList = (List<Staff>) request.getAttribute("staffList");
    MedicalRecord editRecord = (MedicalRecord) request.getAttribute("editRecord");
    String cpath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Medical Records Management — Happy Paws PetCare</title>
    <meta name="description" content="Manage medical records for pets." />

    <!-- Early theme init (prevents flash of wrong theme) -->
    <script>
        (function () {
            try {
                const saved = localStorage.getItem('theme');
                const sysDark = window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches;
                if (saved === 'dark' || (!saved && sysDark)) {
                    document.documentElement.classList.add('dark');
                } else {
                    document.documentElement.classList.remove('dark');
                }
            } catch (e) {}
        })();
    </script>

    <!-- Fonts + Tailwind -->
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
                <h1 class="font-display text-3xl md:text-4xl font-extrabold tracking-tight">Medical Records</h1>
                <p class="mt-2 text-sm text-slate-600 dark:text-slate-300">Manage medical records for pets.</p>
            </div>
            <div class="flex items-center gap-2">
                <button onclick="toggleAddRecordForm()" id="addRecordBtn"
                   class="inline-flex items-center px-4 py-2 rounded-xl bg-brand-600 hover:bg-brand-700 text-white shadow-soft">
                    Add New Record
                </button>
            </div>
        </div>
    </div>
</section>

<!-- CONTENT -->
<section class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 pb-16">

    <!-- Flash Messages -->
    <%
        String error = (String) request.getAttribute("error");
        String success = (String) request.getAttribute("success");
        if (error != null) {
    %>
    <div class="mt-6 rounded-xl p-4 text-sm bg-rose-50 text-rose-800 dark:bg-rose-900/30 dark:text-rose-200 border border-rose-200/50">
        <%= error %>
    </div>
    <% } else if (success != null) { %>
    <div class="mt-6 rounded-xl p-4 text-sm bg-emerald-50 text-emerald-800 dark:bg-emerald-900/30 dark:text-emerald-200 border border-emerald-200/50">
        <%= success %>
    </div>
    <% } %>

    <!-- Add/Edit Medical Record Form (Initially Hidden) -->
    <div id="addRecordForm" class="mt-8 fade-in" style="<%= editRecord != null ? "" : "display: none;" %>">
        <div class="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 shadow-soft p-6">
            <div class="flex items-center justify-between mb-6">
                <h2 class="text-xl font-semibold"><%= editRecord != null ? "Edit Medical Record" : "Add New Medical Record" %></h2>
                <button onclick="toggleAddRecordForm()" class="text-slate-400 hover:text-slate-600 dark:hover:text-slate-300">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                    </svg>
                </button>
            </div>
            
            <form method="post" action="<%= cpath %>/medical/records" class="space-y-6">
                <% if (editRecord != null) { %>
                <input type="hidden" name="action" value="update" />
                <input type="hidden" name="recordId" value="<%= editRecord.getRecordId() %>" />
                <% } %>
                
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <!-- Pet Selection -->
                    <div>
                        <label for="petUid" class="block text-sm font-medium mb-2">Pet <span class="text-rose-600">*</span></label>
                        <select id="petUid" name="petUid" required
                                class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-3 py-2">
                            <option value="">Select a pet</option>
                            <% if (pets != null) {
                                for (Pet pet : pets) { %>
                            <option value="<%= pet.getPetUid() %>" 
                                <%= editRecord != null && editRecord.getPetUid() != null && editRecord.getPetUid().equals(pet.getPetUid()) ? "selected" : "" %>>
                                <%= pet.getName() %> (<%= pet.getSpecies() %>)
                            </option>
                            <% } } %>
                        </select>
                    </div>

                    <!-- Staff Selection -->
                    <div>
                        <label for="staffId" class="block text-sm font-medium mb-2">Veterinarian/Staff <span class="text-rose-600">*</span></label>
                        <select id="staffId" name="staffId" required
                                class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-3 py-2">
                            <option value="">Select staff</option>
                            <% if (staffList != null) {
                                for (Staff staff : staffList) { %>
                            <option value="<%= staff.getStaffId() %>"
                                <%= editRecord != null && editRecord.getStaffId() == staff.getStaffId() ? "selected" : "" %>>
                                <%= staff.getFullName() %> - <%= staff.getRole() %>
                            </option>
                            <% } } %>
                        </select>
                    </div>

                    <!-- Visit Time -->
                    <div>
                        <label for="visitTime" class="block text-sm font-medium mb-2">Visit Date & Time</label>
                        <input type="datetime-local" id="visitTime" name="visitTime"
                               value="<%= editRecord != null && editRecord.getVisitTime() != null ? editRecord.getVisitTime().toString().substring(0, 16) : "" %>"
                               class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-3 py-2" />
                    </div>

                    <!-- Weight -->
                    <div>
                        <label for="weightKg" class="block text-sm font-medium mb-2">Weight (kg)</label>
                        <input type="number" id="weightKg" name="weightKg" step="0.01" min="0"
                               value="<%= editRecord != null && editRecord.getWeightKg() != null ? editRecord.getWeightKg() : "" %>"
                               class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-3 py-2"
                               placeholder="Enter weight in kg" />
                    </div>
                </div>

                <!-- Notes -->
                <div>
                    <label for="notes" class="block text-sm font-medium mb-2">Medical Notes</label>
                    <textarea id="notes" name="notes" rows="4"
                              class="w-full rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-3 py-2"
                              placeholder="Enter diagnosis, treatment, prescription, and other medical notes..."><%= editRecord != null && editRecord.getNotes() != null ? editRecord.getNotes() : "" %></textarea>
                </div>

                <!-- Submit Button -->
                <div class="flex items-center gap-3 pt-4">
                    <button type="submit" 
                            class="inline-flex items-center px-6 py-3 rounded-xl bg-brand-600 hover:bg-brand-700 text-white font-medium shadow-soft">
                        <%= editRecord != null ? "Update Record" : "Create Record" %>
                    </button>
                    <button type="button" onclick="toggleAddRecordForm()"
                            class="inline-flex items-center px-4 py-3 rounded-xl border border-slate-200 dark:border-slate-800 hover:shadow-soft">
                        Cancel
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Medical Records Table -->
    <div class="mt-8">
        <% if (records != null && !records.isEmpty()) { %>
        <div class="bg-white dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 shadow-soft overflow-hidden">
            <div class="overflow-x-auto">
                <table class="w-full">
                    <thead class="bg-slate-50 dark:bg-slate-800/50 border-b border-slate-200 dark:border-slate-700">
                        <tr>
                            <th class="px-6 py-3 text-left text-xs font-medium uppercase tracking-wider">Record ID</th>
                            <th class="px-6 py-3 text-left text-xs font-medium uppercase tracking-wider">Pet</th>
                            <th class="px-6 py-3 text-left text-xs font-medium uppercase tracking-wider">Species</th>
                            <th class="px-6 py-3 text-left text-xs font-medium uppercase tracking-wider">Staff</th>
                            <th class="px-6 py-3 text-left text-xs font-medium uppercase tracking-wider">Visit Time</th>
                            <th class="px-6 py-3 text-left text-xs font-medium uppercase tracking-wider">Weight (kg)</th>
                            <th class="px-6 py-3 text-left text-xs font-medium uppercase tracking-wider">Notes</th>
                            <th class="px-6 py-3 text-left text-xs font-medium uppercase tracking-wider">Actions</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-slate-200 dark:divide-slate-800">
                        <% for (MedicalRecord record : records) { %>
                        <tr class="hover:bg-slate-50 dark:hover:bg-slate-800/30">
                            <td class="px-6 py-4 whitespace-nowrap text-sm font-mono">
                                #<%= record.getRecordId() %>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                                <%= record.getPetName() != null ? record.getPetName() : "—" %>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm">
                                <span class="inline-flex items-center px-2 py-0.5 rounded-lg text-xs bg-slate-50 dark:bg-slate-800/50 text-slate-600 dark:text-slate-300">
                                    <%= record.getSpecies() != null ? record.getSpecies() : "—" %>
                                </span>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm">
                                <%= record.getStaffName() != null ? record.getStaffName() : "—" %>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm">
                                <%= record.getVisitTime() != null ? record.getVisitTime().toString().replace("T", " ").substring(0, 16) : "—" %>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm">
                                <%= record.getWeightKg() != null ? record.getWeightKg() : "—" %>
                            </td>
                            <td class="px-6 py-4 text-sm max-w-xs truncate">
                                <%= record.getNotes() != null && !record.getNotes().isEmpty() ? record.getNotes() : "—" %>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm">
                                <div class="flex items-center gap-2">
                                    <a href="<%= cpath %>/medical/records?action=edit&id=<%= record.getRecordId() %>"
                                       class="inline-flex items-center px-3 py-1.5 rounded-xl border border-slate-200 dark:border-slate-800 hover:shadow-soft text-xs">
                                        Edit
                                    </a>
                                    <form method="post" action="<%= request.getContextPath() %>/medical/records" style="display:inline;" onsubmit="return confirm('Delete this medical record? This action cannot be undone.');">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="recordId" value="<%= record.getRecordId() %>">
                                        <button type="submit"
                                                class="inline-flex items-center px-3 py-1.5 rounded-xl bg-rose-600 text-white hover:bg-rose-700 text-xs">
                                            Delete
                                        </button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
        <% } else { %>

        <!-- Empty state -->
        <div class="reveal">
            <div class="rounded-2xl border-2 border-dashed border-slate-200 dark:border-slate-800 p-10 text-center bg-white dark:bg-slate-900">
                <div class="mx-auto h-12 w-12 rounded-2xl bg-brand-50 dark:bg-slate-800 flex items-center justify-center mb-3">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-brand-600" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                        <path d="M12 6v12m6-6H6" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                    </svg>
                </div>
                <h3 class="font-semibold">No medical records yet</h3>
                <p class="mt-1 text-sm text-slate-500 dark:text-slate-400">Add the first medical record to get started.</p>
                <div class="mt-4">
                    <button onclick="toggleAddRecordForm()"
                       class="inline-flex items-center px-4 py-2 rounded-xl bg-brand-600 hover:bg-brand-700 text-white shadow-soft">
                        Add New Record
                    </button>
                </div>
            </div>
        </div>
        <% } %>
    </div>
</section>

<%@ include file="../common/footer.jsp" %>

<script>
    // Reveal on scroll
    const observer = new IntersectionObserver(entries => {
        entries.forEach(e => { if (e.isIntersecting) e.target.classList.add('visible'); });
    }, { threshold: 0.08 });
    document.querySelectorAll('.reveal').forEach(el => observer.observe(el));

    // Toggle Add Record Form
    function toggleAddRecordForm() {
        const form = document.getElementById('addRecordForm');
        const btn = document.getElementById('addRecordBtn');
        
        if (form.style.display === 'none' || form.style.display === '') {
            form.style.display = 'block';
            setTimeout(() => form.classList.add('show'), 10);
            btn.textContent = 'Cancel';
            btn.classList.remove('bg-brand-600', 'hover:bg-brand-700');
            btn.classList.add('bg-slate-600', 'hover:bg-slate-700');
            
            // Scroll to form
            form.scrollIntoView({ behavior: 'smooth', block: 'start' });
        } else {
            form.classList.remove('show');
            setTimeout(() => form.style.display = 'none', 300);
            btn.textContent = 'Add New Record';
            btn.classList.remove('bg-slate-600', 'hover:bg-slate-700');
            btn.classList.add('bg-brand-600', 'hover:bg-brand-700');
            
            // Reload to clear edit mode
            window.location.href = '<%= cpath %>/medical/records';
        }
    }

    async function deleteRecord(recordId) {
        if(!confirm("Delete this medical record? This action cannot be undone.")) return;
        
        const formData = new FormData();
        formData.append('action', 'delete');
        formData.append('recordId', recordId);
        
        try {
            const res = await fetch("<%= cpath %>/medical/records", {
                method: "POST",
                body: formData
            });
            
            if(res.ok) {
                location.reload();
            } else {
                alert("Failed to delete medical record");
            }
        } catch (e) {
            alert("Error deleting record: " + e.message);
        }
    }
    
    // Auto-show form if in edit mode
    <% if (editRecord != null) { %>
    window.addEventListener('DOMContentLoaded', function() {
        const form = document.getElementById('addRecordForm');
        const btn = document.getElementById('addRecordBtn');
        form.classList.add('show');
        btn.textContent = 'Cancel';
        btn.classList.remove('bg-brand-600', 'hover:bg-brand-700');
        btn.classList.add('bg-slate-600', 'hover:bg-slate-700');
    });
    <% } %>
    
    <% if (error != null) { %>
    window.addEventListener('DOMContentLoaded', function() {
        toggleAddRecordForm();
    });
    <% } %>
</script>

</body>
</html>

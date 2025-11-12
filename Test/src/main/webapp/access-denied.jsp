<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Access Denied - Happy Paws PetCare</title>
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
                    }
                }
            },
            darkMode: 'class'
        }
    </script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body class="antialiased text-slate-800 dark:text-slate-100 bg-slate-50 dark:bg-slate-950 min-h-screen">

<%@ include file="views/common/header.jsp" %>

<main class="flex-1 flex items-center justify-center py-16">
    <div class="max-w-md mx-auto text-center px-4">
        <div class="h-20 w-20 rounded-full bg-red-100 dark:bg-red-900/30 text-red-600 dark:text-red-400 grid place-items-center mx-auto mb-6">
            <i class="fas fa-lock text-2xl"></i>
        </div>
        
        <h1 class="text-3xl font-bold text-slate-900 dark:text-slate-100 mb-4">Access Denied</h1>
        
        <p class="text-slate-600 dark:text-slate-300 mb-8">
            You don't have permission to access this resource. Please contact your administrator if you believe this is an error.
        </p>
        
        <div class="flex flex-col sm:flex-row gap-4 justify-center">
            <a href="<%= request.getContextPath() %>/" 
               class="inline-flex items-center px-6 py-3 rounded-xl bg-brand-600 hover:bg-brand-700 text-white font-medium shadow-soft transition-all">
                <i class="fas fa-home mr-2"></i>
                Go Home
            </a>
            
            <a href="javascript:history.back()" 
               class="inline-flex items-center px-6 py-3 rounded-xl border border-slate-300 dark:border-slate-700 hover:shadow-soft transition-all">
                <i class="fas fa-arrow-left mr-2"></i>
                Go Back
            </a>
        </div>
    </div>
</main>

<%@ include file="views/common/footer.jsp" %>

</body>
</html>

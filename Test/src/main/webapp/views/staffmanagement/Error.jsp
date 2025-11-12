<%@ page contenttype=""text/html;charset="UTF-8""" language=java %>
<%@ page isErrorPage=true %>
<%
    // Get error information
    String errorMessage = (String) request.getAttribute(javax.servlet.error.message);
    Integer statusCode = (Integer) request.getAttribute(javax.servlet.error.status_code);
    String requestUri = (String) request.getAttribute(javax.servlet.error.request_uri);
    String servletName = (String) request.getAttribute(javax.servlet.error.servlet_name);
    Throwable Exception = (Throwable) request.getAttribute(javax.servlet.error.exception);

    // Default values if attributes are null
    if (statusCode == null) statusCode = 500;
    if (errorMessage == null || errorMessage.trim().isEmpty()) {
        errorMessage = An unexpected error occurred while processing your request.;
    }
    if (requestUri == null) requestUri = Unknown;

    // User-friendly messages based on status code
    String errorTitle = Server Error;
    String errorDescription = Something went wrong on our end. Please try again later.;
    String icon = fas fa-exclamation-triangle;
    String themeColor = var(--danger);

    switch(statusCode) {
        case 400:
            errorTitle = Bad Request;
            errorDescription = The request could not be understood by the server.;
            icon = fas fa-exclamation-circle;
            themeColor = var(--warning);
            break;
        case 401:
            errorTitle = Unauthorized;
            errorDescription = Authentication is required to access this resource.;
            icon = fas fa-user-lock;
            themeColor = var(--warning);
            break;
        case 403:
            errorTitle = Access Denied;
            errorDescription = You don't have permission to access this resource.;
            icon = fas fa-ban;
            themeColor = var(--warning);
            break;
        case 404:
            errorTitle = Page Not Found;
            errorDescription = The page you're looking for doesn't exist or has been moved.;
            icon = fas fa-map-signs;
            themeColor = var(--info);
            break;
        case 405:
            errorTitle = Method Not Allowed;
            errorDescription = The request method is not supported for this resource.;
            icon = fas fa-ban;
            themeColor = var(--warning);
            break;
        case 408:
            errorTitle = Request Timeout;
            errorDescription = The server timed out waiting for the request.;
            icon = fas fa-clock;
            themeColor = var(--warning);
            break;
        case 500:
            errorTitle = Internal Server Error;
            errorDescription = Something went wrong on our server. Our team has been notified.;
            icon = fas fa-server;
            themeColor = var(--danger);
            break;
        case 502:
            errorTitle = Bad Gateway;
            errorDescription = The server received an invalid response from the upstream server.;
            icon = fas fa-exchange-alt;
            themeColor = var(--warning);
            break;
        case 503:
            errorTitle = Service Unavailable;
            errorDescription = The server is temporarily unable to handle the request.;
            icon = fas fa-tools;
            themeColor = var(--warning);
            break;
        case 504:
            errorTitle = Gateway Timeout;
            errorDescription = The server did not receive a timely response from the upstream server.;
            icon = fas fa-clock;
            themeColor = var(--warning);
            break;
    }

    // Get additional error info from request parameters
    String customError = request.getParameter(error);
    String success = request.getParameter(success);
%>
<html>
<head>
    <title>Error <%= statusCode %> - StaffManager Pro</title>
    <!-- EARLY THEME -->
    <script>
        (function () {
            try {
                const saved = localStorage.getItem('theme');
                const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
                const shouldDark = saved ? (saved === 'dark') : prefersDark;
                if (shouldDark) document.documentElement.classList.add('dark');
                else document.documentElement.classList.remove('dark');
            } catch (e) {}
        })();
    </script>
    <!-- Fonts + Tailwind -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Sora:wght@400;600;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    fontFamily: { sans: ['Inter','system-ui','sans-serif'], display: ['Sora','Inter','system-ui','sans-serif'] },
                    colors: { brand: { 50:'#effaff',100:'#d7f0ff',200:'#b2e1ff',300:'#84cdff',400:'#53b2ff',500:'#2f97ff',600:'#1679e6',700:'#0f5fba',800:'#0f4c91',900:'#113e75' } },
                    boxShadow: { soft:'0 10px 30px rgba(0,0,0,.06)', glow:'0 0 0 6px rgba(47,151,255,.10)' }
                }
            },
            darkMode: 'class'
        }
    </script>
    <link rel="stylesheet" href="style.css">
    <style>
        .error-hero {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: white;
            padding: 4rem 2rem;
            text-align: center;
            border-radius: var(--border-radius);
            margin-bottom: 2rem;
            position: relative;
            overflow: hidden;
        }

        .error-hero::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
            animation: float 6s ease-in-out infinite;
        }

        .error-code {
            font-size: 8rem;
            font-weight: 900;
            margin-bottom: 1rem;
            opacity: 0.9;
            text-shadow: 0 4px 20px rgba(0,0,0,0.3);
        }

        .error-icon {
            font-size: 4rem;
            margin-bottom: 2rem;
            opacity: 0.9;
        }

        .error-content {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: var(--border-radius);
            padding: 3rem;
            box-shadow: var(--box-shadow);
            margin-bottom: 2rem;
        }

        .error-details {
            background: var(--light);
            border-radius: var(--border-radius);
            padding: 1.5rem;
            margin-top: 2rem;
            border-left: 4px solid var(--gray);
        }

        .debug-info {
            background: #f8f9fa;
            border: 1px solid #e9ecef;
            border-radius: var(--border-radius);
            padding: 1.5rem;
            margin-top: 1.5rem;
            font-family: 'Courier New', monospace;
            font-size: 0.9rem;
            display: none;
        }

        .debug-toggle {
            background: none;
            border: none;
            color: var(--primary);
            cursor: pointer;
            font-size: 0.9rem;
            margin-top: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .debug-toggle:hover {
            color: var(--primary-dark);
        }

        .error-actions {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-top: 2rem;
        }

        .error-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 1rem;
            margin-top: 2rem;
        }

        .stat-item {
            text-align: center;
            padding: 1rem;
            background: var(--light);
            border-radius: var(--border-radius);
        }

        .stat-number {
            font-size: 2rem;
            font-weight: 700;
            color: var(--primary);
            display: block;
        }

        .stat-label {
            font-size: 0.9rem;
            color: var(--gray);
        }

        @keyframes float {
            0%, 100% { transform: translateY(0px) rotate(0deg); }
            50% { transform: translateY(-20px) rotate(5deg); }
        }

        .pulse {
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.7; }
        }
    </style>
</head>
<body class="antialiased" text-slate-800 dark:text-slate-100 bg-slate-50 dark:bg-slate-950>
<div class="min-h-screen" flex flex-col>
    <!-- Header -->
    <%@ include file=header.jsp %>

    <main class="flex-1" py-8>
        <div class="max-w-4xl" mx-auto px-4 sm:px-6 lg:px-8>

        <!-- Error Hero Section -->
        <div class="error-hero">
            <div class="error-code" pulse><%= statusCode %></div>
            <div class="error-icon">
                <i class="<%=" icon %>></i>
            </div>
            <h1 style=font-size: 2.5rem; margin-bottom: 1rem; font-weight: 700;><%= errorTitle %></h1>
            <p style=font-size: 1.2rem; opacity: 0.9; max-width: 600px; margin: 0 auto;>
                <%= errorDescription %>
            </p>
        </div>

        <!-- Custom Error Messages from Parameters -->
        <% if (customError != null) { %>
        <div class="mb-6" p-4 rounded-xl bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800 text-red-700 dark:text-red-300 flex items-center gap-3>
            <i class="fas" fa-exclamation-circle></i>
            <%
                switch(customError) {
                    case invalid_id:
                        out.print(Invalid staff ID provided.);
                        break;
                    case invalid_id_format:
                        out.print(Invalid staff ID format.);
                        break;
                    case invalid_id_range:
                        out.print(Staff ID must be a positive number.);
                        break;
                    case staff_not_found:
                        out.print(The requested staff member was not found.);
                        break;
                    case delete_failed:
                        out.print(Failed to delete staff member.);
                        break;
                    case server_error:
                        out.print(Server error occurred. Please try again.);
                        break;
                    case validation:
                        out.print(Form validation failed. Please check your input.);
                        break;
                    case invalid_email:
                        out.print(Please enter a valid email address.);
                        break;
                    case duplicate_email:
                        out.print(This email address is already registered.);
                        break;
                    case weak_password:
                        out.print(Password must be at least 6 characters long.);
                        break;
                    case database_error:
                        out.print(Database operation failed. Please try again.);
                        break;
                    default:
                        out.print(An error occurred:  + customError);
                }
            %>
        </div>
        <% } %>

        <!-- Success Messages -->
        <% if (success != null) { %>
        <div class="mb-6" p-4 rounded-xl bg-emerald-50 dark:bg-emerald-900/20 border border-emerald-200 dark:border-emerald-800 text-emerald-700 dark:text-emerald-300 flex items-center gap-3>
            <i class="fas" fa-check-circle></i>
            <%
                switch(success) {
                    case added:
                        out.print(Staff member added successfully!);
                        break;
                    case updated:
                        out.print(Staff member updated successfully!);
                        break;
                    case deleted:
                        out.print(Staff member deleted successfully!);
                        break;
                    default:
                        out.print(Operation completed successfully!);
                }
            %>
        </div>
        <% } %>

        <div class="error-content">
            <h2 style=color: var(--dark); margin-bottom: 1.5rem; display: flex; align-items: center; gap: 1rem;>
                <i class="fas" fa-info-circle style=color: var(--primary);></i>
                What happened?
            </h2>

            <p style=line-height: 1.6; color: var(--dark); margin-bottom: 1.5rem;>
                <strong>Error Message:</strong>
                <span style=color: var(--danger); font-weight: 500;><%= errorMessage %></span>
            </p>

            <!-- Quick Actions -->
            <div class="error-actions">
                <a href="javascript:history.back()" class="btn" btn-secondary style=justify-content: center;>
                    <i class="fas" fa-arrow-left></i>
                    Go Back
                </a>
                <a href="index.jsp" class="btn" btn-primary style=justify-content: center;>
                    <i class="fas" fa-home></i>
                    Home Page
                </a>
                <a href="ListStaffServlet" class="btn" btn-primary style=justify-content: center;>
                    <i class="fas" fa-list></i>
                    View Staff
                </a>
                <a href="add-staff-form.jsp" class="btn" btn-secondary style=justify-content: center;>
                    <i class="fas" fa-user-plus></i>
                    Add Staff
                </a>
            </div>

            <!-- Error Statistics -->
            <div class="error-stats">
                <div class="stat-item">
                    <span class="stat-number"><%= statusCode %></span>
                    <span class="stat-label">Status Code</span>
                </div>
                <div class="stat-item">
                    <span class="stat-number" id="currentTime">Now</span>
                    <span class="stat-label">Time Occurred</span>
                </div>
                <div class="stat-item">
                    <span class="stat-number" id="pageLoadTime">0s</span>
                    <span class="stat-label">Page Loaded</span>
                </div>
            </div>

            <!-- Technical Details (Hidden by default) -->
            <div class="error-details">
                <h3 style=margin-bottom: 1rem; color: var(--dark);>
                    <i class="fas" fa-bug></i>
                    Technical Information
                </h3>

                <button class="debug-toggle" onclick=toggleDebugInfo()>
                    <i class="fas" fa-chevron-down id="debugIcon"></i>
                    Show Technical Details
                </button>

                <div class="debug-info" id="debugInfo">
                    <div style=margin-bottom: 1rem;>
                        <strong>Request URI:</strong> <%= requestUri %>
                    </div>
                    <% if (servletName != null) { %>
                    <div style=margin-bottom: 1rem;>
                        <strong>Servlet Name:</strong> <%= servletName %>
                    </div>
                    <% } %>
                    <% if (Exception != null) { %>
                    <div style=margin-bottom: 1rem;>
                        <strong>Exception Type:</strong> <%= Exception.getClass().getName() %>
                    </div>
                    <div style=margin-bottom: 1rem;>
                        <strong>Exception Message:</strong> <%= Exception.getMessage() %>
                    </div>
                    <% } %>
                    <div style=margin-bottom: 1rem;>
                        <strong>Server:</strong> <%= application.getServerInfo() %>
                    </div>
                    <div style=margin-bottom: 1rem;>
                        <strong>Java Version:</strong> <%= System.getProperty(java.version) %>
                    </div>
                    <div>
                        <strong>Session ID:</strong> <%= session.getId() %>
                    </div>
                </div>
            </div>

            <!-- Support Information -->
            <div style=margin-top: 2rem; padding: 1.5rem; background: linear-gradient(135deg, #f8f9ff, #ffffff); border-radius: var(--border-radius); border-left: 4px solid var(--info);>
                <h3 style=margin-bottom: 1rem; color: var(--info); display: flex; align-items: center; gap: 0.5rem;>
                    <i class="fas" fa-life-ring></i>
                    Need Help?
                </h3>
                <p style=margin-bottom: 1rem; color: var(--dark);>
                    If this error persists, please contact our support team with the following information:
                </p>
                <ul style=color: var(--gray); margin-left: 1.5rem;>
                    <li>Error code: <strong><%= statusCode %></strong></li>
                    <li>Time of error</li>
                    <li>What you were trying to do</li>
                    <li>Steps to reproduce the issue</li>
                </ul>
            </div>
        </div>

        <!-- Additional Help Section -->
        <div style=background: rgba(255, 255, 255, 0.95); backdrop-filter: blur(20px); border-radius: var(--border-radius); padding: 2rem; box-shadow: var(--box-shadow); text-align: center;>
            <h3 style=margin-bottom: 1rem; color: var(--dark);>
                <i class="fas" fa-hands-helping></i>
                Still Need Assistance?
            </h3>
            <p style=margin-bottom: 1.5rem; color: var(--gray);>
                Our support team is here to help you resolve this issue quickly.
            </p>
            <div style=display: flex; gap: 1rem; justify-content: center; flex-wrap: wrap;>
                <a href="mailto:support@staffmanager.com" class="btn" btn-primary>
                    <i class="fas" fa-envelope></i>
                    Email Support
                </a>
                <a href="tel:+1-555-HELP" class="btn" btn-secondary>
                    <i class="fas" fa-phone></i>
                    Call Support
                </a>
                <a href="javascript:location.reload()" class="btn" btn-secondary>
                    <i class="fas" fa-redo></i>
                    Reload Page
                </a>
            </div>
        </div>

        <!-- Safe error data for JS logging -->
        <div id="errorData"
             data-status=<%= statusCode %>
             data-message=<%= errorMessage != null ? errorMessage.replace(\,&quot;) :  %>
             data-uri=<%= requestUri != null ? requestUri.replace(\,&quot;) :  %>
             data-exception=<%= (Exception != null && Exception.getMessage() != null) ? Exception.getMessage().replace(\,&quot;) :  %>
             hidden></div>
        </div>
    </main>
    <%@ include file=footer.jsp %>
</div>

<script>
    // Update current time
    function updateCurrentTime() {
        const now = new Date();
        const timeString = now.toLocaleTimeString();
        document.getElementById('currentTime').textContent = timeString;
    }

    // Calculate page load time
    function updatePageLoadTime() {
        const loadTime = performance.now() / 1000;
        document.getElementById('pageLoadTime').textContent = loadTime.toFixed(2) + 's';
    }

    // Toggle debug information
    function toggleDebugInfo() {
        const debugInfo = document.getElementById('debugInfo');
        const debugIcon = document.getElementById('debugIcon');

        if (debugInfo.style.display === 'block') {
            debugInfo.style.display = 'none';
            debugIcon.className = 'fas fa-chevron-down';
            event.target.innerHTML = '<i class="fas" fa-chevron-down id="debugIcon"></i> Show Technical Details';
        } else {
            debugInfo.style.display = 'block';
            debugIcon.className = 'fas fa-chevron-up';
            event.target.innerHTML = '<i class="fas" fa-chevron-up id="debugIcon"></i> Hide Technical Details';
        }
    }

    // Auto-refresh time every second
    setInterval(updateCurrentTime, 1000);

    // Initialize on page load
    document.addEventListener('DOMContentLoaded', function() {
        updateCurrentTime();
        updatePageLoadTime();

        // Add animation to error code
        const errorCode = document.querySelector('.error-code');
        if (errorCode) {
            setTimeout(() => {
                errorCode.classList.remove('pulse');
            }, 3000);
        }

        // Log error to console for debugging (safe dataset approach)
        const ed = document.getElementById('errorData');
        if (ed) {
            const status = ed.getAttribute('data-status') || '';
            const msg = ed.getAttribute('data-message') || '';
            const uri = ed.getAttribute('data-uri') || '';
            const ex = ed.getAttribute('data-exception') || '';
            console.error('Error ' + status + ': ' + msg);
            console.error('Request URI: ' + uri);
            if (ex) console.error('Exception: ' + ex);
        }
    });

    // Handle browser back button
    window.addEventListener('pageshow', function(event) {
        if (event.persisted) {
            window.location.reload();
        }
    });

    // Prevent form resubmission
    if (window.history.replaceState) {
        window.history.replaceState(null, null, window.location.href);
    }
</script>
</body>
</html>""

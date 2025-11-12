# 🐾 Pet Care Management System

The **Pet Care Management System** is a full-stack web application developed for a pet care shop to streamline appointment scheduling, staff management, and record keeping.  
It provides a centralized and efficient platform for managing daily operations, with integrated analytics, email notifications, and online payment support.

---

## 🚀 Features

### 🗓️ Appointment Management
- Create, update, and cancel client appointments.  
- Real-time scheduling with automatic availability checks.  

### 👩‍⚕️ Staff Management
- Add, edit, and remove staff members.  
- Manage staff roles, working hours, and responsibilities.  

### 📋 Centralized Record System
- Store detailed information about pets and their owners.  
- Maintain health records, service history, and billing data securely.  

### 💳 Online Payments (Stripe Sandbox)
- Secure payment integration using **Stripe Sandbox** for testing transactions.  
- Supports booking fee payments and service invoices.

### 📊 Analytics Dashboard
- Dynamic data visualization using **Chart.js (Graph.js)**.  
- Displays key metrics such as appointments, revenue, and staff activity.  

### 📧 Email Notifications
- **SMTP integration** for appointment confirmations, reminders, and updates.  

### 🔐 User Authentication
- Role-based access for admin, staff, and customers.  
- Secure login and session handling via JSP and Servlets.  

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|-------------|
| **Frontend** | HTML, Tailwind CSS, JavaScript |
| **Backend** | JSP, Servlets (Java EE) |
| **Database** | Microsoft SQL Server (MS SQL) |
| **Data Visualization** | Chart.js (Graph.js) |
| **Email Notifications** | SMTP |
| **Payment Gateway** | Stripe Sandbox |
| **Server** | Apache Tomcat |

---

## ⚙️ Installation & Setup

### 1️⃣ Prerequisites
Make sure you have the following installed:
- [Java JDK 8+](https://www.oracle.com/java/technologies/javase-downloads.html)  
- [Apache Tomcat 9+](https://tomcat.apache.org/)  
- [Microsoft SQL Server](https://www.microsoft.com/en-us/sql-server/)  
- [Maven](https://maven.apache.org/) (optional, if used for dependency management)

### 2️⃣ Database Setup
1. Create a new database in **MS SQL Server** named `petcare_db`.  
2. Import the provided SQL schema (`petcare_db.sql`).  
3. Update your database credentials in:

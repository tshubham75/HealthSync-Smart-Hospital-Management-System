# 🏥 MedicaCare - Hospital Management System

![MedicaCare](https://img.shields.io/badge/Ruby-3.x.x-red?style=flat-square)
![Rails](https://img.shields.io/badge/Rails-8.x.x-red?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)

## 📌 Overview

**MedicaCare** is a **comprehensive Hospital Management System (HMS)** that streamlines hospital operations, including **patient management, doctor scheduling, room allocations, and appointment booking**. It features **role-based access control** to ensure secure medical data management.

---

🎯 **Key Features**
👥 **User Roles & Responsibilities**

🔹 **1️⃣ Admin**
✅ Manage **departments, rooms, beds, and doctor profiles**.  
✅ Send **login credentials** to doctors via email upon account creation.  
✅ Define **doctor appointment slots** with flexible durations.  
✅ Generate **room utilization reports** as CSV files.  

🔹 **2️⃣ Doctors**
🩺 Maintain **detailed profiles** (name, qualifications, experience, contact details).  
📝 Record **patient visits**, including medical history, prescriptions, and reports.  
📄 Provide **PDF downloads** of medical records using **Wicked PDF** & **Prawn**.  
🏥 Recommend **patient admission**, triggering **room allocation** based on availability.  

🔹 **3️⃣ Patients**
🆓 **Self-register** with personal details (name, contact, gender, DOB, address, blood group, etc.).  
📅 **Book doctor appointments** based on available slots.  
📂 Access and **download personal medical records** securely.  
🚫 **Restricted access**—cannot view other patient records or hospital administrative details.  

---

 🛠️ **Technology Stack**
Here's a properly formatted and visually appealing version table:  

| 🚀 **Component**          | 🏗 **Technology Used**         |  
|-------------------------- |--------------------------------|  
| **Backend**               | Ruby on Rails (v8.x.x)         |  
| **Frontend**              | Rails Views (ERB) / JavaScript |  
| **Authentication**        | Devise Gem                     |  
| **Database**              | PostgreSQL                     |  
| **Authorization**         | Pundit                         |  
| **CSV Export**            | Any CSV Gem                    |  
| **PDF Generation**        | Wicked PDF / Prawn             |  
| **File Upload Validation**| Active Storage Validations     |  
| **Security & Linting**    | Brakeman, RuboCop              |  

---

🔹 **Gems Used**
🔥 **Core Dependencies**
- **Rails (v8.x.x)** – Web framework.
- **PostgreSQL (pg)** – Database management.
- **Puma** – High-performance web server.

🎨 **Frontend & UI Enhancements**
- **Importmap-rails** – JavaScript asset management.
- **Turbo-Rails** – Enhances responsiveness.
- **Stimulus-Rails** – Lightweight JavaScript framework.

🔐 **Security & Authentication**
- **Devise** – User authentication.
- **Pundit** – Authorization & access control.
- **BCrypt** – Secure password encryption.

📊 **Data Management**
- **Active Storage Validations** – File upload validation.
- **Solid Cache / Solid Queue / Solid Cable** – Performance optimization.

📄 **Reports & Documents**
- **Wicked PDF & Wkhtmltopdf-binary** – Generate medical reports in PDF.
- **Prawn & Prawn-Table** – Advanced PDF table formatting.

🛠️ **Development & Testing**
- **Web Console** – Debugging in development.
- **Capybara & Selenium WebDriver** – System testing.
- **Brakeman** – Security vulnerability scanner.
- **RuboCop & RuboCop-Rails-Omakase** – Code quality and linting.

---

🚀 **Installation & Setup**
```sh
# Clone the repository
git clone https://github.com/your-username/medicare-hms.git
cd medicare-hms

# Install dependencies
bundle install

# Set up the database
rails db:create db:migrate db:seed

# Start the server
rails server

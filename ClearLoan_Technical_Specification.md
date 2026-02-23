# Technical Specification (TS)
## Project: ClearLoan – Financial Navigator for Kyrgyzstan

---

## 1. Project Overview

ClearLoan is a fintech mobile application designed to help people in Kyrgyzstan find the most suitable loan offers from banks and microfinance institutions. The main goal of the application is not only to compare loans, but also to guide users toward financial products that are realistic and safe for their personal situation.

ClearLoan works as a financial navigator that reduces unnecessary applications, lowers rejection rates, and improves access to banking services, especially in regions with limited infrastructure.

---

## 2. Purpose of the Application

The purpose of ClearLoan is:

- to provide users with personalized loan recommendations  
- to simplify the loan application process  
- to connect banks and MFIs in one platform  
- to increase financial inclusion in Kyrgyzstan  
- to offer offline-friendly features for rural areas  

---

## 3. Target Users

The main users of the system are:

- people without strong credit history  
- young adults and students  
- residents of rural regions  
- self-employed individuals  
- users who need quick access to financial products  

---

## 4. Main Functional Requirements

### 4.1 User Authentication

The application must provide user login and registration.

**Login must include:**

- phone number input  
- password input  

**Registration must include:**

- phone number  
- password  
- passport information (only during registration)  
- full name  
- workplace or occupation  

After successful registration, the user can log in using phone number and password.

---

### 4.2 Aggregator Screen (Main Page)

The Aggregator screen must display a list of loan offers from banks and MFIs.

Each offer should contain:

- bank name  
- loan amount  
- interest rate  
- loan term  
- status (Approved / Alternative / Rejected)

The user must be able to browse offers in a clear card-based UI.

---

### 4.3 Active Loans Screen (“Loans Basket”)

The application must include a section where users can see their current active loans.

This screen should display:

- loan provider  
- remaining amount  
- monthly payment  
- status (active / completed)

This module acts as a simple credit tracker.

---

### 4.4 Loan Request Screen

The Loan Request screen must allow the user to enter loan conditions, such as:

- desired amount  
- repayment period  
- purpose of the loan  

Based on this input, the system should generate recommended offers (prototype logic is acceptable).

---

### 4.5 Profile Screen

The Profile screen must display user personal information:

- full name  
- phone number  
- passport details (hidden or partially masked)  
- workplace or occupation  

The profile must include a logout option.

---

### 4.6 Navigation Footer

The application must include a bottom navigation bar with four main tabs:

1. Aggregator  
2. Loans  
3. Request  
4. Profile  

Navigation must be smooth and intuitive.

---

### 4.7 Language Switcher

The application must include a language switcher with two options:

- Russian  
- Kyrgyz  

Full translation is not required for the prototype, but the UI element must exist.

---

## 5. Non-Functional Requirements

### Design Requirements

- Modern UI with red-green fintech color theme  
- Clear typography and readable layout  
- Responsive design for mobile screens  

### Performance Requirements

- Fast loading of screens  
- Smooth navigation between pages  
- Offline-friendly architecture for future development  

### Security Requirements

- User password must not be displayed  
- Passport data must only be collected during registration  
- Personal data should be stored securely (future implementation)

---

## 6. Future Improvements (Optional)

In later versions, ClearLoan can include:

- real AI-based scoring system  
- integration with bank APIs  
- approval probability prediction  
- SMS/USSD offline mode  
- Kyrgyz language full localization  
- financial education module  

---

## 7. Expected Result

At the end of development, ClearLoan must function as a working prototype that demonstrates:

- user registration and login  
- loan marketplace interface  
- personalized loan request flow  
- active loans tracking  
- user profile management  
- navigation and UI design  
- language switcher element  

The project should clearly show the concept of a financial navigator adapted to the needs of Kyrgyzstan.

# Personal Financial Planner – Iteration 3

## Overview
**UniWallet** is a SwiftUI iOS application designed for **York University students** to track income, expenses, manage budgets, and plan semester-based finances. This release transforms the app into a **predictive semester financial dashboard** that forecasts safe weekly spending, tracks tuition and OSAP timing, and provides actionable financial insights.

---

## Target Users
University and college students who want an intelligent, semester-based personal finance tool, including tuition, rent, OSAP, and monthly costs.

---

## Features

### Core Features
- Add income entries with source and amount  
- Add expense entries with category and date  
- View transaction history  
- Group expenses by category  
- Create and manage budgets  
- View financial summary: total income, total expenses, remaining balance  
- Local data persistence  
- Budget over-limit alerts  

### Major Updates in ITR3
- **Login system** for multiple student users  
- Updated **ContentView, LoginView, ProfileView**  
- Removed hardcoded student IDs in `ContentView`  
- Added **SemesterPlan model** for predictive semester planning  
- Redesigned **dashboard** into a predictive financial dashboard  
- Seeded repository with **semester-based York University student data**  
- Implemented **predictive calculations and alerts**  
- UI improvements and added **app icon**  
- Updated `FinancialService.swift` logic for:  
  - Net current balance  
  - Expense grouping  
  - Income and expense totals  
  - Predictive semester budgeting  

---

## Team & Responsibilities

| Team Member | Responsibilities |
|-------------|-----------------|
| **Harneet Arri** | Login system, `ContentView`, `LoginView`, `ProfileView`, net balance & category calculations, UI improvements |
| **Mehrshad Zarastounia** | Predictive dashboard, semester financial calculations, `SemesterPlan` model, repository seeding |
| **Gurshaan Gill** | `FinancialService` logic, income/expense calculations, grouped expenses, predictive alerts integration |
| **Chilotam Mba** | Data persistence improvements, transaction deletion, budget over-limit alerts |

---

## User Stories Implemented
- **Transaction Management**: Add/view income & expenses – *Gurshaan Gill*  
- **Financial Calculations**: Net balance, category grouping, totals – *Harneet Arri*  
- **Semester Planning**: Configure semester, tuition/OSAP, fixed costs – *Mehrshad Zarastounia*  
- **Data Persistence & Alerts**: Local storage, deletion, budget notifications – *Chilotam Mba*  

---

## Known Issues
- Minor UI bugs remain in `ProfileView`  
- Some alert messages may overlap on smaller screens  

---

## Technologies Used
- Swift, SwiftUI  
- Xcode  
- Git/GitHub  

---

## How to Run
1. Clone the repository
2. Open PersonalFinancialPlanner.xcodeproj in Xcode
3. Build and run on iOS Simulator in Xcode
4. Use the login system to access and configure a semester plan

## Project Structure

### Models
- Student  
- Account  
- Budget  
- Transaction  
- SemesterPlan  

### Repository
- StudentRepository  
- StudentRepositoryReal  
- StudentRepositoryStub  

### Services
- FinancialService  

### Views
- ContentView  
- LoginView  
- ProfileView  
- DashboardView  

---

## Documentation Links
- Planning Document: 
- Refactoring Document:
- Architecture Diagram: 

---

## Release Status
Iteration 3 transforms the app into a **predictive, semester-based financial dashboard**, supporting:  

- Multi-user login  
- Predictive budgeting calculations  
- Semester planning (tuition, OSAP, rent, fixed costs)  
- York University realistic student data  
- Local persistence and financial alerts  
- UI improvements and app icon updates  

This release enables **students to forecast their semester financial runway**, improving financial decision-making and budgeting awareness.

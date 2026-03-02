# Iteration 1 Log
Project: Personal Financial Planner for Students  
Course: EECS2311  
Group: Group 4

---

## Overview

Iteration 1 was focused on starting the actual implementation of our project after completing the planning work in Iteration 0. The main goal was to set up the project structure, implement the core domain logic, create a stub database, add unit tests, and build an initial working interface.

Most coordination happened through daily group messages, with one formal Zoom meeting used to finalize plans and task assignments.

---

## Team Meeting

### Zoom Meeting — February 11

Attendees: Chilotam, Mehrshad, Harneet, Gurshaan

During this meeting, the team reviewed the results from Iteration 0 and discussed how to begin development for Iteration 1. We agreed to focus on building the foundation of the application before adding more advanced features.

Main points discussed:
- confirmed project scope and main features
- reviewed user stories created in Iteration 0
- divided development tasks between members
- discussed GitHub workflow and Jira tracking
- agreed to start with domain models and stub database first

Decisions made:
- keep the UI simple for now
- prioritize functionality over appearance
- postpone advanced features like alerts until later iterations

---

## Ongoing Communication

Outside of the Zoom meeting, the group communicated almost daily through messaging. We used this to give progress updates, ask questions, coordinate commits, and help each other debug issues.

Most implementation decisions were finalized through these discussions as work progressed.

---

## Work Completed 

### Planning and Setup

Gurshaan:
- Set up team communication
- Helped decide app scope and basic architecture
- Created vision description, summary, and target user work

Harneet:
- Created initial SwiftUI project
- Set up repository and default test targets
- Wrote detailed user stories and big user stories

Chilotam:
- Created customer meeting summary video

---

### Core Development

Harneet:
- Implemented domain models
- Implemented stub repository/database
- Added unit tests
- Refactored project structure
- Built initial and final content views
- Worked on UI layout and architecture wiki

Gurshaan:
- Implemented FinancialService logic
- Implemented recurring transactions feature
- Planned UI/UX layouts
- Assisted with cleanup and fixes

Mehrshad:
- Created architecture sketch
- Assisted with development integration

---

### Documentation and Architecture

Harneet:
- Wrote architecture description
- Documented source code groups and major files
- Added component dependency explanations
- Created GitHub architecture wiki

---

### Code Review and Collaboration

Team members reviewed each other’s work through Jira tasks and GitHub commits. Feedback was provided through messages and small fixes were made continuously during development.

---

## Estimated vs Actual Effort (Approximate)

Chilotam  
Estimated: 4 hours  
Actual: ~4 hours  

Mehrshad  
Estimated: 5 hours  
Actual: ~6 hours  

Gurshaan  
Estimated: 7 hours  
Actual: ~8 hours  

Harneet  
Estimated: 10 hours  
Actual: ~12 hours  

(Time increased mainly due to debugging and UI integration.)

---

## Developer Tasks — Iteration 1

| Task | Assigned To | Notes / Status | Hours Spent |
|------|------------|----------------|-------------|
| Set up team communication | Gurshaan | Planning / coordination | 1 |
| Decide app scope & architecture | Gurshaan | Planning / coordination | 2 |
| Create vision description & target user work | Gurshaan | Documentation | 2 |
| Create initial SwiftUI project | Harneet | Project setup | 2 |
| Set up repository & default test targets | Harneet | Project setup | 2 |
| Write detailed user stories | Harneet | Documentation | 2 |
| Implement domain models | Harneet | Core development | 3 |
| Implement stub repository / database | Harneet | Core development | 3 |
| Add unit tests | Harneet | Core development | 3 |
| Refactor project structure | Harneet | Core development | 2 |
| Build initial & final content views | Harneet | UI development | 2 |
| Work on UI layout & architecture wiki | Harneet | Documentation / UI | 1 |
| Implement FinancialService logic | Gurshaan | Core development | 3 |
| Implement recurring transactions | Gurshaan | Core development | 3 |
| Plan UI/UX layouts | Gurshaan | Design / planning | 2 |
| Assist with cleanup and fixes | Gurshaan | Integration / maintenance | 2 |
| Create architecture sketch | Mehrshad | Design / planning | 2 |
| Assist with development integration | Mehrshad | Integration / support | 4 |
| Create customer meeting summary video | Chilotam | Documentation / planning | 4 |

## Design Decisions

- Used a stub database instead of a real database as required for Iteration 1.
- Kept business logic separate from UI code to make future updates easier.
- Used SwiftUI for fast interface development.
- Focused on getting a working system first rather than polishing design.

These choices helped us move faster while still keeping the code organized.

---

## Changes From Iteration 0 Plan

Originally planned:
- budgeting system
- savings goals
- spending alerts
- financial tracking

What was done in Iteration 1:
- project setup
- domain models
- stub database
- financial service logic
- basic UI
- unit tests

Advanced features were moved to later iterations so we could first build a stable foundation.

---

## Issues Encountered

- Some merge conflicts happened when multiple members pushed changes.
- UI integration took longer than expected.
- Unit testing setup required extra configuration in Xcode.

How we handled them:
- communicated before pushing large updates
- fixed conflicts together
- simplified parts of the UI when necessary

---

## Iteration Summary

By the end of Iteration 1, the project had a working structure with domain models, service logic, stub data storage, unit tests, and an initial user interface.

The application builds and runs successfully, and the team now has a solid base to continue development in the next iteration.

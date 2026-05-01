# Agri-Census 2024: Advanced Agricultural Data Collection System

Agri-Census is a professional-grade mobile application built with **Flutter**, designed specifically for field agents to conduct the national agricultural census. It provides a robust, offline-first solution for managing field data, investor profiles, and detailed site inspections with a focus on high-efficiency data entry and a premium user experience.

## 🌟 Key Features

### 1. Unified Management Hub
*   **Exploitant (Investor) Tracking**: Comprehensive profiles including personal identity, education, agricultural training, and professional affiliations (UNPA, Chamber of Commerce, etc.).
*   **Exploitation (Site) Management**: Detailed tracking of agricultural sites including legal status (EAC/EAI), vocation (Vegetal/Animal/Mixed), and infrastructure.

### 2. Intelligent Data Collection
*   **Dynamic Questionnaire System**: A structured 10-section survey addressing everything from land status to livestock census and equipment inventory.
*   **Smart Forms**: Real-time validation, automatic value bridging (connecting owners to sites), and responsive UI components (Inline adding, toggles, and dynamic tables).
*   **Geolocation Integration**: Capture precise coordinates (Latitude/Longitude) for every exploitation.

### 3. Professional UI/UX Design
*   **Premium Forest Green Theme**: A custom design system reflecting the agricultural nature of the project.
*   **Full Bilingual Support**: Instant switching between **Arabic (RTL)** and **French (LTR)** across all screens and datasets.
*   **Micro-interactions**: Card-based layouts, smooth transitions, and intuitive feedback loops for field agents.

### 4. Technical Architecture
*   **State Management**: Powered by `Provider` for clean data flow across complex multi-step forms.
*   **Local Storage**: Robust `SQLite` implementation via `sqflite` for reliable offline data persistence in remote areas.
*   **Reference Data**: Pre-seeded database with official Wilaya and Commune data for accurate location tagging.

## 🛠️ Technology Stack

*   **Framework**: Flutter (Dart)
*   **State Management**: Provider
*   **Database**: SQLite (sqflite)
*   **Theme**: Custom Design System (Premium Forest Green)
*   **Localization**: Custom JSON-based Translation Engine

## 📁 Project Structure

```text
lib/
├── core/             # Base configurations (Theme, Database Helpers)
├── models/           # Data entities (Exploitant, Exploitation, etc.)
├── providers/        # Business logic & State management
├── screens/          # Main UI screens (Management, Details, Surveys)
│   └── sections/     # Modular questionnaire sections (Section 1 to 10)
└── widgets/          # Reusable UI components
```

## 🚀 Future Roadmap

- [ ] PDF Report Generation for completed surveys.
- [ ] Cloud Synchronization via REST API.
- [ ] Advanced Analytics Dashboard for regional comparison.
- [ ] Satellite Map integration for land verification.

---
> [!NOTE]
> This project was developed as part of a modernization initiative for the Agricultural Census workflow, moving from paper-based surveys to a high-efficiency digital platform.

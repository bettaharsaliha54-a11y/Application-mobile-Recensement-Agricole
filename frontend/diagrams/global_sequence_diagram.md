# Global Sequence Diagram - Agricultural Census (RGA)

This document contains the global sequence diagram for the RGA application, illustrating the complete workflow from authentication to data synchronization.

## Mermaid Code

```mermaid
sequenceDiagram
    autonumber
    actor User
    participant App as Mobile App (UI)
    participant DB as SQLite (Local)
    participant API as Backend Server

    Note over User, API: Authentication Phase
    User->>App: Enter Credentials
    App->>API: POST /login
    API-->>App: Token & User Profile
    App->>DB: Store Session Data

    Note over User, API: Data Collection Phase (Section 1-7)
    loop For Each Section
        User->>App: Input Data (Livestock, Land, etc.)
        App->>DB: Save Progress (Local Draft)
    end

    Note over User, API: Validation & Finalization
    User->>App: Request Final Validation
    App->>DB: Fetch All Sections
    DB-->>App: Full Data
    App->>App: Run Validation Logic
    App-->>User: Show Summary & Errors (if any)
    User->>App: Confirm Submission
    App->>DB: Update Status to "Completed"

    Note over User, API: Synchronization Phase
    User->>App: Trigger Synchronization
    App->>DB: Fetch "Completed" Surveys
    DB-->>App: List of Surveys
    loop For Each Survey
        App->>API: POST /sync/survey
        API-->>App: Success/Failure
        alt On Success
            App->>DB: Update Status to "Synced"
        else On Failure
            App-->>User: Show Sync Error
        end
    end
    App-->>User: Sync Task Finished Successfully
```

## Description of Workflow

1.  **Authentication**: The user logs in to the application. Credentials are verified against the backend server, and a session is created locally in SQLite.
2.  **Data Collection**: The user fills out the 7 sections of the agricultural census. Each step is saved locally in the SQLite database to prevent data loss.
3.  **Validation**: Before submission, the app performs a comprehensive check of all required fields and business rules. A summary is presented to the user for final review.
4.  **Finalization**: Once confirmed, the survey status is changed to "Completed" in the local database.
5.  **Synchronization**: The user can sync completed surveys with the central server when an internet connection is available. The app sends the data to the API and updates the local status to "Synced" upon success.

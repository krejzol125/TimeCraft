# TimeCraft ⏱️📆

**TimeCraft** is a cross-platform task and calendar application built with **Flutter**, focused on advanced scheduling, recurring tasks, offline-first architecture and smooth, interactive calendar views.

The app allows users to manage tasks as **patterns**, **instances**, and **overrides**, providing fine-grained control over recurring schedules while remaining fully usable offline.


## Core Features

### Calendar Views
- **Month view** with clickable days and task indicators
- **Week view** with draggable and resizable task blocks
- **Day view** (responsive – used on narrow screens)
- Smooth transitions between month ↔ week/day views

### Task Model
- Tasks are modeled as:
  - **TaskPatterns** – recurring definitions (RRULE-based)
  - **TaskInstances** – materialized, cached occurrences
  - **TaskOverrides** – per-instance modifications
- Support for:
  - Start & end time
  - Duration
  - Priority
  - Tags
  - Subtasks
  - Completion modes (binary / quantitative)

### Authentication
- Firebase Authentication (email/password)
- User session management
- Data isolated per user

## Instructions
### Adding task
- Press floating action button with a plus icon on bottom right (you can also fiddle with it)
- follow 3 steps of creating a task
- to add tags you can write them in a title after a `#` character

### Rescheduling a task
- Drag a task tile to desired location on a schedule
- Drag bottom white strip on a tile to change duration
- If the task is reccurring you will have to choose the scope of change

### Undated tasks
- in the top right corner there is a button to see all unscheduled tasks
- they can be given a date by simply dragging them to a schedule

### Editing a task
- press on a task tile
- on bottom left there is a `edit` button
- follow the steps similiar to adding task
- If the task is reccurring you will have to choose the scope of change

### Calendar navigation
- you can go to previous month/week with arrows on top of the calendar
- to see whole month you can either scroll to the top or press the blue `month` button on the top
- when on the phone you can change selected day by pressing on the calendar

### auth/locale
- on top left there is a button to account settings


## Architecture Overview

### State Management
- **Bloc / Cubit**
  - `CalendarCubit` – calendar navigation & interactions
  - `SessionCubit` – authentication & session lifecycle

### Data Layer
- **Drift (SQLite)** for local persistence
- Offline-first approach
#### schema: 
    - MaterializationState
| Kolumna      | Typ (Drift)      | SQL typ (typowo) | NULL     | Default | Uwagi                                        |
| ------------ | ---------------- | ---------------- | -------- | ------- | -------------------------------------------- |
| `taskId`     | `TextColumn`     | `TEXT`           | NOT NULL | —       | PK                                           |
| `lastRev`    | `IntColumn`      | `INTEGER`        | NOT NULL | —       |                                              |
| `windowFrom` | `DateTimeColumn` | `INTEGER/TEXT`   | NOT NULL | —       | timestamp/ISO zależnie od konfiguracji drift |
| `windowTo`   | `DateTimeColumn` | `INTEGER/TEXT`   | NOT NULL | —       |                                              |

    - Outbox
| Kolumna       | Typ (Drift)      | SQL typ (typowo) | NULL     | Default              | Uwagi                            |
| ------------- | ---------------- | ---------------- | -------- | -------------------- | -------------------------------- |
| `uid`         | `TextColumn`     | `TEXT`           | NOT NULL | —                    |                          user id |
| `entityType`  | `TextColumn`     | `TEXT`           | NOT NULL | —                    |                                  |
| `entityKey`   | `TextColumn`     | `TEXT`           | NOT NULL | —                    | **PK**                           |
| `rev`         | `IntColumn`      | `INTEGER`        | NOT NULL | —                    | rewizja/wersja                   |
| `payloadJson` | `TextColumn`     | `TEXT`           | NOT NULL | —                    | JSON jako string                 |
| `createdAt`   | `DateTimeColumn` | `INTEGER/TEXT`   | NOT NULL | `currentDateAndTime` |                                  |
| `sent`        | `BoolColumn`     | `INTEGER`        | NOT NULL | `false`              |                                  |
    - TaskInstance
| Kolumna       | Typ (Drift)      | SQL typ (typowo) | NULL     | Default              | Uwagi                                   |
| ------------- | ---------------- | ---------------- | -------- | -------------------- | --------------------------------------- |
| `taskId`      | `TextColumn`     | `TEXT`           | NOT NULL | —                    | **PK (część)**, FK do `TaskPatterns.id` |
| `rid`         | `DateTimeColumn` | `INTEGER/TEXT`   | NULL     | —                    | **PK (część)** (uwaga: PK + nullable)   |
| `title`       | `TextColumn`     | `TEXT`           | NOT NULL | —                    |                                         |
| `completion`  | `TextColumn`     | `TEXT`           | NOT NULL | `'0 false'`          |                                         |
| `description` | `TextColumn`     | `TEXT`           | NULL     | —                    |                                         |
| `startTime`   | `DateTimeColumn` | `INTEGER/TEXT`   | NULL     | —                    | objęte indeksem `rid_index`             |
| `duration`    | `IntColumn`      | `INTEGER`        | NULL     | —                    |                                         |
| `isRepeating` | `BoolColumn`     | `INTEGER`        | NOT NULL | `false`              |                                         |
| `tags`        | `TextColumn`     | `TEXT`           | NULL     | —                    |                                         |
| `priority`    | `IntColumn`      | `INTEGER`        | NOT NULL | `3`                  |                                         |
| `reminders`   | `TextColumn`     | `TEXT`           | NULL     | —                    |                                         |
| `subTasks`    | `TextColumn`     | `TEXT`           | NULL     | —                    |                                         |
| `deleted`     | `BoolColumn`     | `INTEGER`        | NOT NULL | `false`              | soft delete                             |
| `createdAt`   | `DateTimeColumn` | `INTEGER/TEXT`   | NOT NULL | `currentDateAndTime` |                                         |
| `updatedAt`   | `DateTimeColumn` | `INTEGER/TEXT`   | NOT NULL | `currentDateAndTime` |                                         |
    - TaskOverride
| Kolumna       | Typ (Drift)      | SQL typ (typowo) | NULL     | Default              | Uwagi                                   |
| ------------- | ---------------- | ---------------- | -------- | -------------------- | --------------------------------------- |
| `taskId`      | `TextColumn`     | `TEXT`           | NOT NULL | —                    | **PK (część)**, FK do `TaskPatterns.id` |
| `rid`         | `DateTimeColumn` | `INTEGER/TEXT`   | NOT NULL | —                    | **PK (część)**                          |
| `title`       | `TextColumn`     | `TEXT`           | NULL     | —                    |                                         |
| `completion`  | `TextColumn`     | `TEXT`           | NULL     | —                    |                                         |
| `description` | `TextColumn`     | `TEXT`           | NULL     | —                    |                                         |
| `startTime`   | `DateTimeColumn` | `INTEGER/TEXT`   | NULL     | —                    |                                         |
| `duration`    | `IntColumn`      | `INTEGER`        | NULL     | —                    |                                         |
| `rrule`       | `TextColumn`     | `TEXT`           | NULL     | —                    |                                         |
| `tags`        | `TextColumn`     | `TEXT`           | NULL     | —                    |                                         |
| `priority`    | `IntColumn`      | `INTEGER`        | NULL     | —                    |                                         |
| `reminders`   | `TextColumn`     | `TEXT`           | NULL     | —                    |                                         |
| `subTasks`    | `TextColumn`     | `TEXT`           | NULL     | —                    |                                         |
| `rev`         | `IntColumn`      | `INTEGER`        | NOT NULL | `0`                  | rewizja override                        |
| `deleted`     | `BoolColumn`     | `INTEGER`        | NULL     | —                    | nullable soft delete                    |
| `createdAt`   | `DateTimeColumn` | `INTEGER/TEXT`   | NOT NULL | `currentDateAndTime` |                                         |
| `updatedAt`   | `DateTimeColumn` | `INTEGER/TEXT`   | NOT NULL | `currentDateAndTime` |                                         |
    - TaskPattern
| Kolumna       | Typ (Drift)      | SQL typ (typowo) | NULL     | Default              | Uwagi   |
| ------------- | ---------------- | ---------------- | -------- | -------------------- | ------- |
| `id`          | `TextColumn`     | `TEXT`           | NOT NULL | —                    | **PK**  |
| `title`       | `TextColumn`     | `TEXT`           | NOT NULL | —                    |         |
| `completion`  | `TextColumn`     | `TEXT`           | NOT NULL | `'0 false'`          |         |
| `description` | `TextColumn`     | `TEXT`           | NULL     | —                    |         |
| `startTime`   | `DateTimeColumn` | `INTEGER/TEXT`   | NULL     | —                    |         |
| `duration`    | `IntColumn`      | `INTEGER`        | NULL     | —                    |         |
| `rrule`       | `TextColumn`     | `TEXT`           | NULL     | —                    |         |
| `rdates`      | `TextColumn`     | `TEXT`           | NULL     | —                    |         |
| `exdates`     | `TextColumn`     | `TEXT`           | NULL     | —                    |         |
| `tags`        | `TextColumn`     | `TEXT`           | NULL     | —                    |         |
| `priority`    | `IntColumn`      | `INTEGER`        | NOT NULL | `3`                  |         |
| `reminders`   | `TextColumn`     | `TEXT`           | NULL     | —                    |         |
| `subTasks`    | `TextColumn`     | `TEXT`           | NULL     | —                    |         |
| `deleted`     | `BoolColumn`     | `INTEGER`        | NOT NULL | `false`              |         |
| `rev`         | `IntColumn`      | `INTEGER`        | NOT NULL | `0`                  | rewizja |
| `createdAt`   | `DateTimeColumn` | `INTEGER/TEXT`   | NOT NULL | `currentDateAndTime` |         |
| `updatedAt`   | `DateTimeColumn` | `INTEGER/TEXT`   | NOT NULL | `currentDateAndTime` |         |

### Synchronization
- **Outbox pattern**
  - Local changes are queued
  - Synced to Firebase when online
- **MaterializationWorker**
  - Observes pattern changes
  - Regenerates cached task instances for visible date ranges

### Remote Backend
- **Firebase Firestore**
  - `users/{uid}/taskPatterns`
  - `users/{uid}/taskOverrides`
- Conflict-safe, revision-based syncing



## 🚀 CI/CD

- **GitHub Actions**
  - Code formatting check
  - Static analysis
  - Running Flutter tests on each push / PR

Workflow file:
.github/workflows/ci.yml


## 📋 Optional Requirements Checklist

### Platforms
- Mobile (Android / iOS)
- Web
- Desktop (Windows)

### UI / UX
- Animations (calendar transitions, ghost previews)
- Implicit / ready-to-use packages (TableCalendar, Drift, Flutter Bloc)
- Custom interactions (spring animation on floating action button, drag, resize, zoom, auto-scroll)

### Authentication
- Firebase Auth

### Forms
- Multi-step form with validation (Adding/editing tasks)

### CI/CD
- Code analysis & `flutter test` via GitHub Actions


### Other
- Internationalization
- Local data persistence (offline-first, Drift + SQLite)

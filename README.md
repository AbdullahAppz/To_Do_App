# 📝 To Do - Flutter Task Management App

A modern and responsive **To Do Task Management Application** built with **Flutter and Dart**.

The application allows users to securely log in, manage their personal tasks, track task completion, search and filter tasks, and store their data using **Firebase Authentication and Cloud Firestore**.

This project was developed as part of my **AlgoHub Internship Program** and was finalized with testing, UI improvements, responsive design, Firebase integration, and an Android release build.

---

## 📱 About the Project

**To Do** is a task management application designed to help users organize and manage their daily tasks in a simple and professional interface.

Users can create tasks, edit existing tasks, mark tasks as completed, delete tasks, search through their tasks, and filter them based on their completion status.

The application uses Firebase to provide authentication and cloud database functionality, allowing user and task data to be stored securely.

---

## ✨ Features

### 🔐 Authentication

- User Signup
- User Login
- Logout
- Authentication validation
- Password validation
- Password visibility toggle
- Persistent user authentication

### 👤 User Profile

- View user profile
- Edit profile information
- Update profile details
- Profile avatar support

### 📋 Task Management

- Create new tasks
- View all tasks
- View task details
- Edit tasks
- Delete tasks
- Mark tasks as completed
- Track pending tasks
- Track completed tasks

### 🔎 Search

Users can search tasks by:

- Task title
- Task description

Search results update dynamically.

### 🏷️ Task Filters

Tasks can be filtered using:

- All
- Pending
- Completed

### ↕️ Task Sorting

Tasks can be sorted using:

- Newest First
- Oldest First
- A → Z
- Z → A

### 📱 Responsive UI

The application was tested for different screen sizes and orientations.

Supported layouts include:

- Portrait
- Landscape

The UI was adjusted to provide a better experience across different device dimensions.

### 🎨 UI & UX

- Consistent application theme
- Professional color scheme
- Splash screen
- Loading indicators
- Empty-state screens
- Error-state handling
- Confirmation dialogs
- Success messages
- Responsive task cards
- Clean navigation

---

# 🛠️ Technology Stack

| Technology | Purpose |
|---|---|
| Flutter | Cross-platform application framework |
| Dart | Programming language |
| Firebase Authentication | User authentication |
| Cloud Firestore | Cloud database |
| Provider | State management |
| Android Studio | Development environment |
| Git & GitHub | Version control |
| UUID | Unique task IDs |

---

# 🏗️ Project Architecture

The project follows a modular structure to keep the application organized and maintainable.

```text
lib/
│
├── model/
│   ├── task_model.dart
│   └── user_model.dart
│
├── providers/
│   ├── task_provider.dart
│   └── user_provider.dart
│
├── services/
│   ├── auth_service.dart
│   ├── firestore_task_services.dart
│   └── firestore_user_service.dart
│
├── screens/
│   ├── login_screen.dart
│   ├── signup_screen.dart
│   ├── home_screen.dart
│   ├── profile_screen.dart
│   ├── task_list_screen.dart
│   ├── task_detail_screen.dart
│   └── add_edit_task_screen.dart
│
├── utility/
│   ├── task_card.dart
│   ├── empty_widget.dart
│   ├── error_widget.dart
│   ├── filter_chips.dart
│   ├── sort_dropdown.dart
│   └── search_bar.dart
│
└── main.dart
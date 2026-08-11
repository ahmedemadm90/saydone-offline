# SayDone Offline - Voice-to-Task AI Assistant

SayDone Offline is a privacy-focused, fully local mobile application that converts voice notes into organized tasks. Built with Flutter and SQLite, it ensures all your data stays on your device.

## 🚀 Features

- **Offline-First**: Works without an internet connection.
- **Local SQLite Database**: All tasks and data are stored locally using `sqflite`.
- **Voice-to-Task**: Converts spoken notes (English & Arabic) into structured tasks.
- **Material 3 UI**: Modern, clean, and intuitive user interface.
- **Privacy Focused**: No data is sent to external servers.
- **Daily Task Limits**: Built-in 5-task daily limit for free users (resets daily).
- **Onboarding Experience**: Smooth introduction to the app's features.

## 🛠 Tech Stack

- **Framework**: Flutter (Dart)
- **Local Storage**: SQLite (`sqflite`)
- **State Management**: Provider
- **Preferences**: Shared Preferences (for onboarding and limits)

## 📦 Getting Started

### Prerequisites
- Flutter SDK (>= 3.0.0)
- Android SDK / Xcode

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/ahmedemadm90/saydone-offline.git
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```

### Building APK
To generate the APK for Android:
```bash
flutter build apk --release
```

## 📝 License
Private Project - All Rights Reserved.

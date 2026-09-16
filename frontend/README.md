# LabourConnect — Flutter App

The mobile app for **LabourConnect**, a daily-wage job-matching platform connecting workers (masons, painters, farmers, plumbers, electricians, drivers) with contractors in rural Karnataka. Supports Kannada, Hindi, English, and Tulu.

This repository contains the Flutter frontend. The Agentic AI backend lives in a separate repository: [labourconnect-ai](https://github.com/Suraksha12345/labourconnect-ai).

## Features

- 13+ screens covering worker and contractor flows: registration/login, job posting, job browsing, applications, chat, notifications, and profile
- **Wage Advisor** — AI-powered fair-wage check before posting or accepting a job
- **Job Matching** — AI-assisted job recommendations for workers
- **Safety Check** — flags risky job posts or contractors based on history
- **Chatbot** — answers worker questions on government schemes, safety, and platform usage
- Firebase Anonymous Auth + self-generated OTP for phone-based login
- Multi-language support (Kannada, Hindi, English, Tulu)

## Tech Stack

- **Framework**: Flutter / Dart
- **Auth & Database**: Firebase (Anonymous Auth, Firestore)
- **Backend**: connects to the [labourconnect-ai](https://github.com/Suraksha12345/labourconnect-ai) Flask AI backend

## Setup

### 1. Install prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (developed on 3.47.4)
- Android Studio + Android SDK
- Run `flutter doctor` and resolve any issues before continuing

### 2. Clone the repository
```bash
git clone https://github.com/Suraksha12345/labourconnect-app.git
cd labourconnect-app
```

### 3. Install dependencies
```bash
flutter pub get
```

### 4. Connect to the AI backend
Open `lib/main.dart` and set `AI_BACKEND_URL` to wherever the backend is running:

| Scenario | URL to use |
|----------|------------|
| Backend and Android emulator on the same machine | `http://10.0.2.2:5000` |
| Testing on a physical phone, backend on a local machine | Use a tunnel, e.g. `ngrok http 5000`, then use the ngrok URL |
| Backend deployed to a cloud platform | The platform's public URL (e.g. `https://your-app.onrender.com`) |

Make sure the backend (see the [labourconnect-ai](https://github.com/Suraksha12345/labourconnect-ai) repo) is running before starting the app.

### 5. Firebase setup
Add your own `google-services.json` (Android) to `android/app/` — this is not committed to GitHub for security reasons. Request it separately if working on this project.

### 6. Run the app
```bash
flutter run
```

### 7. Build a release APK
```bash
flutter build apk
```
The output APK will be at `build/app/outputs/flutter-apk/app-release.apk`.

## Project Structure

- `lib/` — Dart source code (screens, widgets, services)
- `android/` — Android platform configuration (Gradle, manifest)
- `assets/` — images, translations, and other static assets

## Notes

- Phone verification currently uses a self-generated OTP (no real SMS gateway) — a documented limitation, not a bug.
- If `flutter run` / `flutter build apk` fails on first setup with a Gradle download error, ensure the Gradle wrapper version in `android/gradle/wrapper/gradle-wrapper.properties` can fully download — this is a large file and can fail on unstable connections; retry or use a tool like `aria2c` for a more reliable download.

## Author

Suraksha — MCA, Mangalore University (Internship Project)

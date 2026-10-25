# Local Development Instructions

This guide walks through starting and testing both the Flutter mobile application and Next.js admin dashboard locally.

---

## Prerequisites
- Flutter SDK (>= 3.2.0, tested on Flutter 3.47.0 / Dart 3.13)
- Node.js (>= 18.x, tested on v24.11.0)
- npm (>= 9.x, tested on 11.6.1)
- Git

---

## 1. Running the Mobile App (Flutter)

1. Open a terminal in the `/mobile` directory:
   ```bash
   cd mobile
   ```

2. Verify dependencies:
   ```bash
   flutter pub get
   ```

3. Run static analyzer and unit tests:
   ```bash
   flutter test
   flutter analyze
   ```

4. Launch on an Android Emulator, Connected Device, Chrome, or Windows:
   ```bash
   # On Android device/emulator:
   flutter run

   # On Web browser (instant live testing):
   flutter run -d chrome
   ```

> [!NOTE]
> The app is built with self-contained fallback seed data. Even without internet or live Firebase credentials, all 52 products, checkout simulation, OpenStreetMap pinning, and role switching work seamlessly.

---

## 2. Running the Admin Dashboard (Next.js)

1. Open a terminal in the `/admin` directory:
   ```bash
   cd admin
   ```

2. Install dependencies (if not already done):
   ```bash
   npm install
   ```

3. Run the development server:
   ```bash
   npm run dev
   ```

4. Open your browser and navigate to:
   ```text
   http://localhost:3000
   ```

5. Log in with the pre-filled demo administrator credentials:
   - Email: `admin@califnco.com`
   - Password: `AdminPass@2026`

---

## 3. Running the AI Automation Test Simulation

To verify the daily marketing workflow locally without needing live Docker or Meta credentials:
```bash
node automation/test_runner/simulate_workflow.js
```
This runs the full 7-step pipeline (Queue polling -> Duplicate prevention -> Gemini copywriting -> Visual verification -> CDN upload validation -> Meta Instagram Graph API container creation -> Sheets audit logging).

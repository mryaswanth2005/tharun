# Android Build Instructions

This guide explains how to generate a release or debug Android APK / App Bundle (.aab) for Califnco PureWater.

---

## 1. Prerequisites
- Android Studio with Android SDK (API Level 34 / 35 installed)
- Java Development Kit (JDK 17 or higher)
- Flutter SDK 3.47+

---

## 2. Generating Android Debug APK
For immediate testing or sharing with evaluators:

```bash
cd mobile
flutter build apk --debug
```
The output APK file will be located at:
```text
mobile/build/app/outputs/flutter-apk/app-debug.apk
```

---

## 3. Generating Production Release APK
To build an optimized production release:

```bash
cd mobile
flutter build apk --release
```
Output:
```text
mobile/build/app/outputs/flutter-apk/app-release.apk
```

---

## 4. Generating Google Play Store Bundle (.aab)
To generate an Android App Bundle for Google Play Store upload:

```bash
cd mobile
flutter build appbundle --release
```
Output:
```text
mobile/build/app/outputs/bundle/release/app-release.aab
```

---

## 5. Android Permissions Configured
The Android Manifest (`mobile/android/app/src/main/AndroidManifest.xml`) includes:
- `INTERNET`: For fetching catalog products, images, and payment processing.
- `ACCESS_FINE_LOCATION` / `ACCESS_COARSE_LOCATION`: For OpenStreetMap delivery address pin selection.
- `POST_NOTIFICATIONS`: For Firebase Cloud Messaging shipment and service updates.

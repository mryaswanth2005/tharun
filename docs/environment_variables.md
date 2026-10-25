# Environment Variable Reference Guide

This document lists all environment variables used across the Califnco ecosystem. A matching `.env.example` is provided in each relevant folder.

---

## 1. Admin Dashboard (`/admin/.env.local`)

```bash
# Firebase Client SDK
NEXT_PUBLIC_FIREBASE_API_KEY=AIzaSyDemoKeyExampleOnly123456
NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN=califnco-water.firebaseapp.com
NEXT_PUBLIC_FIREBASE_PROJECT_ID=califnco-water
NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET=califnco-water.appspot.com
NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID=109283746501
NEXT_PUBLIC_FIREBASE_APP_ID=1:109283746501:web:a9182b3c4d5e6f7g

# Firebase Admin SDK (Server-Side)
FIREBASE_CLIENT_EMAIL=firebase-adminsdk-xxxxx@califnco-water.iam.gserviceaccount.com
FIREBASE_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASC...\n-----END PRIVATE KEY-----\n"

# Public App URLs
NEXT_PUBLIC_APP_URL=https://califnco-admin.vercel.app
```

---

## 2. AI Marketing Automation (`/automation/.env`)

```bash
# Google Sheets Queue Integration
GOOGLE_SHEETS_SPREADSHEET_ID=1CalifncoProductQueueExampleSheetId
GOOGLE_APPLICATION_CREDENTIALS=/path/to/google_service_account.json

# Gemini AI (Free Tier LLM)
GEMINI_API_KEY=AIzaSyYourGeminiApiKeyHere

# Hugging Face Inference API (Zero-Cost Image Generation)
HUGGINGFACE_API_KEY=hf_yourHuggingFaceTokenHere

# Cloudinary Public Image Hosting (Free Tier)
CLOUDINARY_CLOUD_NAME=califnco
CLOUDINARY_API_KEY=123456789012345
CLOUDINARY_API_SECRET=your_cloudinary_api_secret_here

# Meta Instagram Graph API
# (Leave empty to run in simulated Dry-Run mode)
INSTAGRAM_ACCOUNT_ID=17841400000000000
META_ACCESS_TOKEN=EAAG...YourLongLivedMetaGraphAccessToken

# WAHA Docker (Optional WhatsApp Status Bonus)
WAHA_BASE_URL=http://localhost:3008
WAHA_SESSION=default
```

---

## 3. Mobile Android App (`/mobile`)

The mobile app reads its configuration through Flutter build configuration or `google-services.json`:

```text
mobile/android/app/google-services.json
```

For test checkout without external secrets:
- Razorpay public test key is integrated: `rzp_test_1DP5mmOlF5G5ag`
- All 52 products and demo accounts are bundled locally in `mobile/assets/data/products.json`.

# n8n Automated Daily Marketing Setup Guide

This guide walks through configuring and activating the automated daily AI Instagram marketing workflow in n8n.

---

## 1. Deploying n8n Locally with Docker

If you do not have an active n8n instance, run n8n using Docker:

```bash
docker run -d \
  --name n8n \
  -p 5678:5678 \
  -v n8n_data:/home/node/.n8n \
  docker.n8n.io/n8nio/n8n
```

Open your browser at `http://localhost:5678` and complete the initial account setup.

---

## 2. Importing the Workflow JSON

1. In n8n, click **"Workflows"** in the left sidebar.
2. Click the three dots icon (`...`) in the top right and select **"Import from File"**.
3. Select:
   ```text
   automation/workflows/califnco_daily_instagram_workflow.json
   ```
4. The complete 13-node visual canvas will appear.

---

## 3. Configuring Service Credentials

### A. Google Sheets Credential
1. Open the node **"Google Sheets - Read Next Pending Product"**.
2. Connect your Google account using OAuth2 or Service Account.
3. Import `automation/sheets_template/califnco_product_queue.csv` into a Google Sheet and paste its Spreadsheet ID.

### B. Google Gemini AI Credential
1. Create a free API key at [Google AI Studio](https://aistudio.google.com).
2. Open node **"Gemini AI - Generate Caption & Hashtags"**.
3. Create a **Google PaLM/Gemini API** credential in n8n and paste your API key.

### C. Hugging Face Token (Zero-Cost Image Generation)
1. Generate a free Access Token at [Hugging Face Settings](https://huggingface.co/settings/tokens).
2. Add the token to the header parameter in node **"Hugging Face - Generate Marketing Visual"**.

### D. Cloudinary Credential (Free Image CDN)
1. Sign up for a free account at [Cloudinary](https://cloudinary.com).
2. Create an **Upload Preset** named `califnco_daily_feed` with unsigned uploading enabled.
3. Configure your Cloud Name in the Cloudinary upload node URL.

---

## 4. Activating the Daily Schedule
- Click the toggle switch in the top right of the canvas from **Inactive** to **Active**.
- The cron trigger `0 9 * * *` will fire automatically every day at 09:00 AM IST.

---

## 5. Dry-Run / Evaluation Testing Mode
If live Meta Instagram credentials are not configured:
- The conditional node **"Is Live Meta API Configured?"** automatically routes execution to the **"Dry-Run Simulator"** branch.
- A simulated container and post ID are generated.
- Google Sheets is updated with `status = published_dry_run` and the complete timestamp.
- No real post is dispatched until valid credentials are added.

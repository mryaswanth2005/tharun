# Vercel Deployment Instructions

The Califnco Admin Dashboard is built with Next.js 16 (App Router) and is ready for one-click deployment to Vercel's zero-cost hosting tier.

---

## Method 1: Deploy via Vercel Git Integration (Recommended)

1. Push this repository to GitHub or GitLab.
2. Log in to [vercel.com](https://vercel.com) and click **"Add New Project"**.
3. Import your Califnco repository.
4. Set the **Root Directory** setting to:
   ```text
   admin
   ```
5. Framework Preset will automatically detect **Next.js**.
6. Under **Environment Variables**, add the variables documented in `docs/environment_variables.md`:
   - `NEXT_PUBLIC_FIREBASE_API_KEY`
   - `NEXT_PUBLIC_FIREBASE_PROJECT_ID`
   - `FIREBASE_CLIENT_EMAIL`
   - `FIREBASE_PRIVATE_KEY`
7. Click **Deploy**. Vercel will run `npm run build` and publish your live production dashboard URL (e.g., `https://califnco-admin.vercel.app`).

---

## Method 2: Deploy via Vercel CLI

1. Install Vercel CLI globally:
   ```bash
   npm install -g vercel
   ```

2. Navigate to the `admin/` folder:
   ```bash
   cd admin
   ```

3. Run the deployment command:
   ```bash
   vercel
   ```

4. Follow the interactive prompts:
   - Link to existing project? **No**
   - Project name: **califnco-admin**
   - Directory located: **./**
   - Override settings? **No**

5. Deploy directly to production:
   ```bash
   vercel --prod
   ```

---

## Verification
Once deployed:
1. Access your live Vercel URL.
2. Sign in with the evaluator credentials:
   - Email: `admin@califnco.com`
   - Password: `AdminPass@2026`
3. Verify that the Overview metrics, Order Management, Dealer Compliance, and Field Service Dispatcher load without errors.

# Seed Data Instructions

Califnco includes 52 realistic, categorized water purification products with authentic pricing, technical specifications, and matching high-definition photography across 10 categories.

---

## 1. Product Seed Dataset Structure
The master catalog dataset is stored in:
```text
backend/data/products.json
```
And copied to:
- Mobile asset bundle: `mobile/assets/data/products.json`
- Admin dashboard: `admin/src/data/products.json`
- Google Sheets queue: `automation/sheets_template/califnco_product_queue.csv`

---

## 2. Category Distribution
The 52 products are organized across all 10 required categories:
1. **RO water purifiers** (5 models: AquaPro 10L, Slimline 8L, AlkaGold 12L, Under-Sink HydroHide, EcoSave 9L)
2. **UV water purifiers** (5 models: PureStream SS 8L, DirectFlow Instant, GlowPlus 7L, SmartTouch 10L, OfficePure 15L)
3. **UF water purifiers** (5 models: GraviPure 16L, Jumbo Non-Electric 20L, TapMount Online, Wall-Mount 9L, CampHydrate Straw)
4. **Commercial water purification systems** (5 models: 50 LPH Skid, 100 LPH Dual Membrane, 250 LPH Industrial FRP, 500 LPH Softener, SS Cooler 60L)
5. **Water dispensers** (5 models: Bottom Loading 3-Temperature, Tabletop Compact, Plumbed-In POU, Freestanding Fridge, Automatic Wireless Bottle Pump)
6. **Water pumps** (5 models: SilentDrive 75 GPD 24V, HighFlow 100 GPD 24V, TurboPressure 150 GPD 36V, Commercial 300 GPD 48V, Copper SMPS Adapter 24V)
7. **RO membranes** (5 models: Filmtech High TDS 75 GPD, Dow Sheet 80 GPD, Low-Energy 100 GPD, Commercial 300 GPD, Industrial 4040 Brackish Water)
8. **Sediment filters** (5 models: 10-inch 5-Micron Spun 3-Pack, Heavy Dirt String Wound, Washable Pleated Polyester, 20-inch Big Blue Jumbo, Quick-Connect Inline)
9. **Carbon filters** (5 models: 10-inch CTO Coconut Block, 10-inch GAC Granular, Silver Nano Post-Carbon Polisher, 20-inch Jumbo Commercial, Active Copper & Zinc)
10. **Replacement cartridges & spare parts** (7 models: Pre-Filter Bowl with Wrench, SmartCut 24V Solenoid Valve, FR-450 Flow Restrictor 2-Pack, Double O-Ring Membrane Housing, 15m Food Grade PE Pipe, Complete Annual Overhaul Maintenance Kit, Titanium Digital TDS Meter)

---

## 3. How to Seed Firestore Live

1. Navigate to the `backend/` directory:
   ```bash
   cd backend
   npm install
   ```

2. Provide your Firebase Service Account JSON credentials:
   ```bash
   export GOOGLE_APPLICATION_CREDENTIALS="/path/to/serviceAccountKey.json"
   # On Windows PowerShell:
   # $env:GOOGLE_APPLICATION_CREDENTIALS="C:\path\to\serviceAccountKey.json"
   ```

3. Run the seeder:
   ```bash
   npm run seed
   ```

---

## 4. How to Generate Google Sheets CSV Queue

Run the exporter from the root or `backend/` folder:
```bash
node backend/scripts/export_csv.js
```
The output file `automation/sheets_template/califnco_product_queue.csv` can be imported directly into Google Drive as a Google Sheet for n8n queue polling.

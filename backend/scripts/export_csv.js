const fs = require('fs');
const path = require('path');

const products = JSON.parse(fs.readFileSync(path.join(__dirname, '../data/products.json'), 'utf8'));

const headers = [
  'product_id',
  'sku',
  'name',
  'category',
  'brand',
  'customer_price',
  'dealer_price',
  'description',
  'specifications_summary',
  'image_url',
  'status',
  'published_at',
  'instagram_post_id',
  'generated_caption',
  'error_details'
];

function escapeCsv(val) {
  if (val === null || val === undefined) return '""';
  const str = String(val).replace(/"/g, '""');
  return `"${str}"`;
}

const rows = products.map((p, idx) => {
  const specs = Object.entries(p.specifications || {})
    .map(([k, v]) => `${k}: ${v}`)
    .join(' | ');

  return [
    escapeCsv(p.id),
    escapeCsv(p.sku),
    escapeCsv(p.name),
    escapeCsv(p.category),
    escapeCsv(p.brand),
    escapeCsv(p.price),
    escapeCsv(p.dealerPrice),
    escapeCsv(p.description),
    escapeCsv(specs),
    escapeCsv(p.imageUrl),
    escapeCsv(idx === 0 ? 'published' : 'pending'), // First item marked published as demo
    escapeCsv(idx === 0 ? new Date().toISOString() : ''),
    escapeCsv(idx === 0 ? '17983421098456721' : ''),
    escapeCsv(idx === 0 ? 'Experience pure health with Califnco AquaPro RO! 💧 Engineered with 8-stage purification and active copper enrichment. #Califnco #PureWater #ROPurifier' : ''),
    escapeCsv('')
  ].join(',');
});

const csvContent = [headers.join(','), ...rows].join('\n');

const outputPath = path.join(__dirname, '../../automation/sheets_template/califnco_product_queue.csv');
fs.writeFileSync(outputPath, csvContent, 'utf8');
console.log(`[Califnco CSV Exporter] Successfully exported ${products.length} products to: ${outputPath}`);

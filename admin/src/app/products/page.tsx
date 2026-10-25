'use client';

import { useState, useEffect } from 'react';
import {
  Package,
  Search,
  Filter,
  Eye,
  AlertTriangle,
  CheckCircle,
  Tag,
  Boxes,
} from 'lucide-react';
import Sidebar from '@/components/Sidebar';
import Header from '@/components/Header';
import { dataStore } from '@/lib/dataStore';
import { Product } from '@/lib/types';

const categories = [
  'All Products',
  'RO water purifiers',
  'UV water purifiers',
  'UF water purifiers',
  'Commercial water purification systems',
  'Water dispensers',
  'Water pumps',
  'RO membranes',
  'Sediment filters',
  'Carbon filters',
  'Replacement cartridges and spare parts',
];

export default function ProductsPage() {
  const [products, setProducts] = useState<Product[]>([]);
  const [selectedCategory, setSelectedCategory] = useState('All Products');
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedProduct, setSelectedProduct] = useState<Product | null>(null);

  const loadProducts = () => {
    setProducts([...dataStore.getProducts()]);
  };

  useEffect(() => {
    loadProducts();
  }, []);

  const filtered = products.filter((p) => {
    const matchesCat =
      selectedCategory === 'All Products' ||
      p.category.toLowerCase() === selectedCategory.toLowerCase();
    const matchesSearch =
      p.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
      p.sku.toLowerCase().includes(searchQuery.toLowerCase()) ||
      p.category.toLowerCase().includes(searchQuery.toLowerCase()) ||
      p.brand.toLowerCase().includes(searchQuery.toLowerCase());
    return matchesCat && matchesSearch;
  });

  const formatCurrency = (val: number) => {
    return new Intl.NumberFormat('en-IN', {
      style: 'currency',
      currency: 'INR',
      maximumFractionDigits: 0,
    }).format(val);
  };

  return (
    <div className="flex min-h-screen bg-slate-50">
      <Sidebar />

      <main className="flex-1 flex flex-col min-w-0">
        <Header
          title="Product Catalog & Inventory Master"
          subtitle="Manage 52 realistic water purifiers, commercial plants, and replacement spares"
          onRefresh={loadProducts}
        />

        <div className="p-6 space-y-6">
          {/* Controls Bar */}
          <div className="bg-white p-4 rounded-2xl border border-slate-200 shadow-sm flex flex-col md:flex-row gap-4 justify-between items-center">
            {/* Search */}
            <div className="relative w-full md:w-80">
              <Search className="w-4 h-4 text-slate-400 absolute left-3.5 top-3" />
              <input
                type="text"
                placeholder="Search 52 products by name, SKU..."
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                className="w-full pl-10 pr-4 py-2 bg-slate-50 border border-slate-200 rounded-xl text-xs focus:outline-none focus:ring-2 focus:ring-[#00B4D8]"
              />
            </div>

            {/* Category Filter */}
            <div className="w-full md:w-auto">
              <select
                value={selectedCategory}
                onChange={(e) => setSelectedCategory(e.target.value)}
                className="w-full md:w-auto px-3.5 py-2 bg-slate-50 border border-slate-200 rounded-xl text-xs font-semibold text-slate-700 focus:outline-none focus:ring-2 focus:ring-[#00B4D8]"
              >
                {categories.map((c) => (
                  <option key={c} value={c}>
                    {c}
                  </option>
                ))}
              </select>
            </div>
          </div>

          {/* Products Table */}
          <div className="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
            <div className="p-4 border-b border-slate-100 flex items-center justify-between">
              <p className="text-xs font-bold text-slate-600">
                Displaying {filtered.length} of {products.length} Products
              </p>
            </div>

            <div className="overflow-x-auto">
              <table className="w-full text-left border-collapse">
                <thead>
                  <tr className="bg-slate-50 border-b border-slate-100 text-[11px] font-bold text-slate-500 uppercase tracking-wider">
                    <th className="py-3 px-4">Product Details</th>
                    <th className="py-3 px-4">Category</th>
                    <th className="py-3 px-4">Customer Retail</th>
                    <th className="py-3 px-4">Wholesale Dealer</th>
                    <th className="py-3 px-4">Inventory</th>
                    <th className="py-3 px-4">Rating</th>
                    <th className="py-3 px-4 text-right">View Specs</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-slate-100 text-xs">
                  {filtered.map((p) => {
                    const discount = Math.round(((p.price - p.dealerPrice) / p.price) * 100);
                    return (
                      <tr key={p.id} className="hover:bg-slate-50/70 transition">
                        <td className="py-3 px-4">
                          <div className="flex items-center space-x-3">
                            <img
                              src={p.imageUrl}
                              alt={p.name}
                              className="w-11 h-11 rounded-lg object-cover bg-slate-100 border border-slate-200"
                            />
                            <div className="min-w-0 max-w-xs">
                              <p className="font-bold text-slate-900 truncate">{p.name}</p>
                              <p className="text-[11px] font-mono text-slate-400">SKU: {p.sku}</p>
                            </div>
                          </div>
                        </td>
                        <td className="py-3 px-4">
                          <span className="px-2 py-0.5 rounded text-[10px] font-medium bg-slate-100 text-slate-700">
                            {p.category}
                          </span>
                        </td>
                        <td className="py-3 px-4 font-bold text-slate-900">
                          {formatCurrency(p.price)}
                        </td>
                        <td className="py-3 px-4">
                          <div className="flex items-center space-x-1.5">
                            <span className="font-bold text-[#0077B6]">{formatCurrency(p.dealerPrice)}</span>
                            <span className="px-1.5 py-0.2 rounded text-[10px] font-bold bg-cyan-100 text-cyan-800">
                              -{discount}%
                            </span>
                          </div>
                        </td>
                        <td className="py-3 px-4">
                          {p.stock < 15 ? (
                            <span className="px-2 py-0.5 rounded-full text-[10px] font-bold bg-amber-100 text-amber-800">
                              Low: {p.stock} units
                            </span>
                          ) : (
                            <span className="px-2 py-0.5 rounded-full text-[10px] font-medium bg-emerald-50 text-emerald-700">
                              {p.stock} in stock
                            </span>
                          )}
                        </td>
                        <td className="py-3 px-4 font-semibold text-slate-700">
                          ⭐ {p.rating} ({p.reviewCount})
                        </td>
                        <td className="py-3 px-4 text-right">
                          <button
                            onClick={() => setSelectedProduct(p)}
                            className="p-1.5 text-slate-500 hover:text-[#0077B6] hover:bg-slate-100 rounded-lg transition"
                            title="Inspect Specs"
                          >
                            <Eye className="w-4 h-4" />
                          </button>
                        </td>
                      </tr>
                    );
                  })}
                </tbody>
              </table>
            </div>
          </div>
        </div>

        {/* Specifications Modal */}
        {selectedProduct && (
          <div className="fixed inset-0 z-50 bg-slate-900/40 backdrop-blur-sm flex justify-end">
            <div className="w-full max-w-lg bg-white h-full shadow-2xl overflow-y-auto p-6 flex flex-col justify-between">
              <div>
                <div className="flex items-center justify-between pb-4 border-b border-slate-100">
                  <h3 className="font-bold text-base text-slate-900 truncate pr-4">{selectedProduct.name}</h3>
                  <button
                    onClick={() => setSelectedProduct(null)}
                    className="p-2 text-slate-400 hover:text-slate-600 rounded-lg"
                  >
                    ✕
                  </button>
                </div>

                <div className="py-4 space-y-4 text-xs">
                  <img
                    src={selectedProduct.imageUrl}
                    alt={selectedProduct.name}
                    className="w-full h-48 rounded-xl object-contain bg-slate-50 border border-slate-200"
                  />

                  <div className="p-3 bg-slate-50 rounded-xl space-y-1">
                    <p><strong>SKU:</strong> {selectedProduct.sku}</p>
                    <p><strong>Brand:</strong> {selectedProduct.brand}</p>
                    <p><strong>Category:</strong> {selectedProduct.category}</p>
                    <p><strong>Retail Price:</strong> {formatCurrency(selectedProduct.price)}</p>
                    <p><strong>Wholesale Price:</strong> {formatCurrency(selectedProduct.dealerPrice)}</p>
                  </div>

                  <div>
                    <h4 className="font-bold text-slate-900 mb-1">Description</h4>
                    <p className="text-slate-600 leading-relaxed">{selectedProduct.description}</p>
                  </div>

                  <div>
                    <h4 className="font-bold text-slate-900 mb-2">Technical Specifications</h4>
                    <div className="border border-slate-200 rounded-xl overflow-hidden divide-y divide-slate-100">
                      {Object.entries(selectedProduct.specifications).map(([key, value]) => (
                        <div key={key} className="p-2.5 flex justify-between bg-white text-xs">
                          <span className="text-slate-500 font-medium">{key}</span>
                          <span className="font-semibold text-slate-800 text-right">{value}</span>
                        </div>
                      ))}
                    </div>
                  </div>
                </div>
              </div>

              <button
                onClick={() => setSelectedProduct(null)}
                className="w-full py-2.5 bg-slate-900 text-white rounded-xl text-xs font-bold hover:bg-slate-800 transition"
              >
                Close Inspector
              </button>
            </div>
          </div>
        )}
      </main>
    </div>
  );
}

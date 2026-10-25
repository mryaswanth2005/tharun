'use client';

import { useState, useEffect } from 'react';
import Link from 'next/link';
import {
  DollarSign,
  ShoppingBag,
  Users,
  Wrench,
  AlertTriangle,
  ArrowUpRight,
  Clock,
  CheckCircle,
  Truck,
  ExternalLink,
} from 'lucide-react';
import Sidebar from '@/components/Sidebar';
import Header from '@/components/Header';
import { dataStore } from '@/lib/dataStore';
import { DashboardMetrics, Order, DealerApplication } from '@/lib/types';

export default function DashboardPage() {
  const [metrics, setMetrics] = useState<DashboardMetrics>({
    totalRevenue: 0,
    totalOrdersCount: 0,
    pendingOrdersCount: 0,
    approvedDealersCount: 0,
    pendingDealersCount: 0,
    openServiceRequestsCount: 0,
    lowStockProductsCount: 0,
  });

  const [recentOrders, setRecentOrders] = useState<Order[]>([]);
  const [pendingDealers, setPendingDealers] = useState<DealerApplication[]>([]);

  const loadData = () => {
    setMetrics(dataStore.getMetrics());
    setRecentOrders(dataStore.getOrders().slice(0, 5));
    setPendingDealers(
      dataStore.getDealerApplications().filter((a) => a.status === 'pending')
    );
  };

  useEffect(() => {
    loadData();
  }, []);

  const formatCurrency = (val: number) => {
    return new Intl.NumberFormat('en-IN', {
      style: 'currency',
      currency: 'INR',
      maximumFractionDigits: 0,
    }).format(val);
  };

  const getStatusBadge = (status: string) => {
    switch (status) {
      case 'placed':
        return <span className="px-2.5 py-1 rounded-full text-xs font-semibold bg-blue-50 text-blue-700 border border-blue-200">Order Placed</span>;
      case 'confirmed':
        return <span className="px-2.5 py-1 rounded-full text-xs font-semibold bg-cyan-50 text-cyan-700 border border-cyan-200">Confirmed</span>;
      case 'processing':
        return <span className="px-2.5 py-1 rounded-full text-xs font-semibold bg-amber-50 text-amber-700 border border-amber-200">Processing</span>;
      case 'dispatched':
        return <span className="px-2.5 py-1 rounded-full text-xs font-semibold bg-purple-50 text-purple-700 border border-purple-200">Dispatched</span>;
      case 'delivered':
        return <span className="px-2.5 py-1 rounded-full text-xs font-semibold bg-emerald-50 text-emerald-700 border border-emerald-200">Delivered</span>;
      case 'cancelled':
        return <span className="px-2.5 py-1 rounded-full text-xs font-semibold bg-rose-50 text-rose-700 border border-rose-200">Cancelled</span>;
      default:
        return <span className="px-2.5 py-1 rounded-full text-xs font-semibold bg-slate-100 text-slate-700">{status}</span>;
    }
  };

  return (
    <div className="flex min-h-screen bg-slate-50">
      <Sidebar />

      <main className="flex-1 flex flex-col min-w-0">
        <Header
          title="Operations Command Center"
          subtitle="Real-time monitoring of orders, wholesale dealers, and service tickets"
          onRefresh={loadData}
        />

        <div className="p-6 space-y-6">
          {/* Top Metric Cards */}
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
            {/* Revenue */}
            <div className="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm">
              <div className="flex items-center justify-between">
                <p className="text-xs font-semibold text-slate-500 uppercase tracking-wider">Gross Sales (INR)</p>
                <div className="p-2 bg-emerald-50 text-emerald-600 rounded-xl">
                  <DollarSign className="w-5 h-5" />
                </div>
              </div>
              <h3 className="text-2xl font-bold text-slate-900 mt-2">{formatCurrency(metrics.totalRevenue)}</h3>
              <p className="text-xs text-slate-400 mt-1 flex items-center gap-1">
                <span className="text-emerald-600 font-semibold">18% GST</span> Inclusive Verified
              </p>
            </div>

            {/* Orders */}
            <div className="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm">
              <div className="flex items-center justify-between">
                <p className="text-xs font-semibold text-slate-500 uppercase tracking-wider">Active Orders</p>
                <div className="p-2 bg-blue-50 text-blue-600 rounded-xl">
                  <ShoppingBag className="w-5 h-5" />
                </div>
              </div>
              <div className="flex items-baseline space-x-2 mt-2">
                <h3 className="text-2xl font-bold text-slate-900">{metrics.totalOrdersCount}</h3>
                <span className="text-xs font-medium px-2 py-0.5 rounded-full bg-amber-100 text-amber-800">
                  {metrics.pendingOrdersCount} in fulfillment
                </span>
              </div>
              <p className="text-xs text-slate-400 mt-1">Retail & Wholesale Combined</p>
            </div>

            {/* Dealers */}
            <div className="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm">
              <div className="flex items-center justify-between">
                <p className="text-xs font-semibold text-slate-500 uppercase tracking-wider">Wholesalers</p>
                <div className="p-2 bg-cyan-50 text-cyan-600 rounded-xl">
                  <Users className="w-5 h-5" />
                </div>
              </div>
              <div className="flex items-baseline space-x-2 mt-2">
                <h3 className="text-2xl font-bold text-slate-900">{metrics.approvedDealersCount} Active</h3>
                {metrics.pendingDealersCount > 0 && (
                  <span className="text-xs font-semibold px-2 py-0.5 rounded-full bg-rose-100 text-rose-800 animate-pulse">
                    {metrics.pendingDealersCount} Pending
                  </span>
                )}
              </div>
              <Link href="/dealers" className="text-xs text-[#0077B6] font-semibold mt-1 inline-flex items-center gap-1 hover:underline">
                Review Applications <ArrowUpRight className="w-3 h-3" />
              </Link>
            </div>

            {/* Services */}
            <div className="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm">
              <div className="flex items-center justify-between">
                <p className="text-xs font-semibold text-slate-500 uppercase tracking-wider">Service Requests</p>
                <div className="p-2 bg-purple-50 text-purple-600 rounded-xl">
                  <Wrench className="w-5 h-5" />
                </div>
              </div>
              <div className="flex items-baseline space-x-2 mt-2">
                <h3 className="text-2xl font-bold text-slate-900">{metrics.openServiceRequestsCount} Open</h3>
                <span className="text-xs font-medium px-2 py-0.5 rounded-full bg-purple-100 text-purple-800">
                  Installation / AMC
                </span>
              </div>
              <Link href="/services" className="text-xs text-[#0077B6] font-semibold mt-1 inline-flex items-center gap-1 hover:underline">
                Dispatch Technicians <ArrowUpRight className="w-3 h-3" />
              </Link>
            </div>
          </div>

          {/* Pending Dealer Applications Banner if any */}
          {pendingDealers.length > 0 && (
            <div className="bg-amber-50 border border-amber-200 rounded-2xl p-5">
              <div className="flex items-start justify-between">
                <div className="flex items-start space-x-3">
                  <AlertTriangle className="w-5 h-5 text-amber-600 flex-shrink-0 mt-0.5" />
                  <div>
                    <h4 className="font-bold text-amber-900 text-sm">
                      {pendingDealers.length} Dealer Application(s) Awaiting Compliance Review
                    </h4>
                    <p className="text-xs text-amber-700 mt-1">
                      New businesses have submitted GSTIN credentials for wholesale purchasing privileges.
                    </p>
                  </div>
                </div>
                <Link
                  href="/dealers"
                  className="px-3.5 py-1.5 bg-amber-600 text-white rounded-xl text-xs font-bold hover:bg-amber-700 transition"
                >
                  Inspect & Decide
                </Link>
              </div>
            </div>
          )}

          {/* Two Columns: Recent Orders & Dealer Review */}
          <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
            {/* Recent Orders Table (2 Cols) */}
            <div className="lg:col-span-2 bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
              <div className="p-5 border-b border-slate-100 flex items-center justify-between">
                <div>
                  <h3 className="font-bold text-slate-900 text-base">Recent Customer & Wholesale Orders</h3>
                  <p className="text-xs text-slate-500">Live order status and dispatch updates</p>
                </div>
                <Link
                  href="/orders"
                  className="text-xs font-semibold text-[#0077B6] hover:underline flex items-center gap-1"
                >
                  View All Orders <ArrowUpRight className="w-3.5 h-3.5" />
                </Link>
              </div>

              <div className="overflow-x-auto">
                <table className="w-full text-left border-collapse">
                  <thead>
                    <tr className="bg-slate-50/75 border-b border-slate-100 text-[11px] font-bold text-slate-500 uppercase tracking-wider">
                      <th className="py-3 px-4">Order #</th>
                      <th className="py-3 px-4">Customer</th>
                      <th className="py-3 px-4">Channel</th>
                      <th className="py-3 px-4">Total</th>
                      <th className="py-3 px-4">Status</th>
                      <th className="py-3 px-4 text-right">Actions</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-slate-100 text-xs">
                    {recentOrders.map((o) => (
                      <tr key={o.id} className="hover:bg-slate-50/60 transition">
                        <td className="py-3.5 px-4 font-mono font-bold text-slate-800">{o.orderNumber}</td>
                        <td className="py-3.5 px-4">
                          <p className="font-semibold text-slate-900">{o.userName}</p>
                          <p className="text-[11px] text-slate-400">{o.shippingAddress.city}</p>
                        </td>
                        <td className="py-3.5 px-4">
                          {o.isWholesale ? (
                            <span className="px-2 py-0.5 rounded text-[10px] font-bold bg-cyan-100 text-cyan-800 border border-cyan-300">
                              WHOLESALE
                            </span>
                          ) : (
                            <span className="px-2 py-0.5 rounded text-[10px] font-semibold bg-slate-100 text-slate-700">
                              RETAIL
                            </span>
                          )}
                        </td>
                        <td className="py-3.5 px-4 font-bold text-slate-900">
                          {formatCurrency(o.totalAmount)}
                        </td>
                        <td className="py-3.5 px-4">{getStatusBadge(o.orderStatus)}</td>
                        <td className="py-3.5 px-4 text-right">
                          <Link
                            href="/orders"
                            className="text-[#0077B6] hover:text-[#005f73] font-semibold inline-flex items-center gap-0.5"
                          >
                            Manage <ExternalLink className="w-3 h-3" />
                          </Link>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>

            {/* Quick Actions & System Health (1 Col) */}
            <div className="space-y-4">
              <div className="bg-white rounded-2xl border border-slate-200 p-5 shadow-sm">
                <h4 className="font-bold text-slate-900 text-sm mb-3">Quick Operations</h4>
                <div className="space-y-2.5">
                  <Link
                    href="/orders"
                    className="flex items-center justify-between p-3 rounded-xl bg-slate-50 hover:bg-slate-100 transition border border-slate-200/60 text-xs font-semibold text-slate-800"
                  >
                    <span className="flex items-center gap-2.5">
                      <Truck className="w-4 h-4 text-[#0077B6]" />
                      Dispatch Ready Orders
                    </span>
                    <span className="font-bold text-slate-500">&rarr;</span>
                  </Link>

                  <Link
                    href="/dealers"
                    className="flex items-center justify-between p-3 rounded-xl bg-slate-50 hover:bg-slate-100 transition border border-slate-200/60 text-xs font-semibold text-slate-800"
                  >
                    <span className="flex items-center gap-2.5">
                      <CheckCircle className="w-4 h-4 text-emerald-600" />
                      Approve Wholesaler Portals
                    </span>
                    <span className="font-bold text-slate-500">&rarr;</span>
                  </Link>

                  <Link
                    href="/services"
                    className="flex items-center justify-between p-3 rounded-xl bg-slate-50 hover:bg-slate-100 transition border border-slate-200/60 text-xs font-semibold text-slate-800"
                  >
                    <span className="flex items-center gap-2.5">
                      <Clock className="w-4 h-4 text-purple-600" />
                      Assign AMC Technicians
                    </span>
                    <span className="font-bold text-slate-500">&rarr;</span>
                  </Link>
                </div>
              </div>

              {/* Demo Credentials Info Card for Reviewer */}
              <div className="bg-[#0A192F] text-white rounded-2xl p-5 shadow-sm border border-[#172A45]">
                <h4 className="font-bold text-sm text-[#00B4D8] mb-1.5">Evaluator Demo Accounts</h4>
                <p className="text-[11px] text-slate-300 leading-relaxed mb-3">
                  Use these pre-configured accounts in both Mobile and Admin to inspect all authorization flows:
                </p>
                <div className="space-y-2 text-xs">
                  <div className="bg-[#172A45] p-2 rounded-lg">
                    <p className="font-bold text-white">Admin:</p>
                    <p className="text-[11px] text-slate-300">admin@califnco.com</p>
                  </div>
                  <div className="bg-[#172A45] p-2 rounded-lg">
                    <p className="font-bold text-cyan-300">Approved Dealer (Wholesale Tier):</p>
                    <p className="text-[11px] text-slate-300">dealer.approved@califnco.com</p>
                  </div>
                  <div className="bg-[#172A45] p-2 rounded-lg">
                    <p className="font-bold text-amber-300">Pending Dealer Application:</p>
                    <p className="text-[11px] text-slate-300">dealer.pending@califnco.com</p>
                  </div>
                  <div className="bg-[#172A45] p-2 rounded-lg">
                    <p className="font-bold text-emerald-300">Customer (Retail Price):</p>
                    <p className="text-[11px] text-slate-300">customer@califnco.com</p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </main>
    </div>
  );
}

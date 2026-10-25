'use client';

import { useState, useEffect } from 'react';
import {
  Search,
  Filter,
  Eye,
  CheckCircle,
  Truck,
  XCircle,
  Clock,
  PackageCheck,
  AlertCircle,
  ChevronDown,
} from 'lucide-react';
import Sidebar from '@/components/Sidebar';
import Header from '@/components/Header';
import { dataStore } from '@/lib/dataStore';
import { Order, OrderStatus } from '@/lib/types';

export default function OrdersPage() {
  const [orders, setOrders] = useState<Order[]>([]);
  const [searchQuery, setSearchQuery] = useState('');
  const [statusFilter, setStatusFilter] = useState<string>('all');
  const [channelFilter, setChannelFilter] = useState<string>('all');
  const [selectedOrder, setSelectedOrder] = useState<Order | null>(null);
  const [statusToUpdate, setStatusToUpdate] = useState<{ id: string; status: OrderStatus } | null>(null);

  const loadOrders = () => {
    setOrders([...dataStore.getOrders()]);
  };

  useEffect(() => {
    loadOrders();
  }, []);

  const handleStatusChange = (orderId: string, newStatus: OrderStatus) => {
    dataStore.updateOrderStatus(orderId, newStatus);
    loadOrders();
    setStatusToUpdate(null);
    if (selectedOrder && selectedOrder.id === orderId) {
      setSelectedOrder({
        ...selectedOrder,
        orderStatus: newStatus,
        updatedAt: new Date().toISOString(),
      });
    }
  };

  const filteredOrders = orders.filter((o) => {
    const matchesSearch =
      o.orderNumber.toLowerCase().includes(searchQuery.toLowerCase()) ||
      o.userName.toLowerCase().includes(searchQuery.toLowerCase()) ||
      o.userEmail.toLowerCase().includes(searchQuery.toLowerCase()) ||
      o.userPhone.includes(searchQuery);

    const matchesStatus = statusFilter === 'all' || o.orderStatus === statusFilter;
    const matchesChannel =
      channelFilter === 'all' ||
      (channelFilter === 'wholesale' && o.isWholesale) ||
      (channelFilter === 'retail' && !o.isWholesale);

    return matchesSearch && matchesStatus && matchesChannel;
  });

  const formatCurrency = (val: number) => {
    return new Intl.NumberFormat('en-IN', {
      style: 'currency',
      currency: 'INR',
      maximumFractionDigits: 0,
    }).format(val);
  };

  const getStatusBadge = (status: OrderStatus) => {
    switch (status) {
      case 'placed':
        return <span className="px-2.5 py-1 rounded-full text-xs font-semibold bg-blue-50 text-blue-700 border border-blue-200">Placed</span>;
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
    }
  };

  return (
    <div className="flex min-h-screen bg-slate-50">
      <Sidebar />

      <main className="flex-1 flex flex-col min-w-0">
        <Header
          title="Order Fulfillment & Dispatch"
          subtitle="Track customer and wholesale shipments, inspect invoices, and update lifecycle states"
          onRefresh={loadOrders}
        />

        <div className="p-6 space-y-6">
          {/* Filter Bar */}
          <div className="bg-white p-4 rounded-2xl border border-slate-200 shadow-sm flex flex-col md:flex-row gap-4 justify-between items-center">
            {/* Search */}
            <div className="relative w-full md:w-80">
              <Search className="w-4 h-4 text-slate-400 absolute left-3.5 top-3" />
              <input
                type="text"
                placeholder="Search by order #, customer, phone..."
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                className="w-full pl-10 pr-4 py-2 bg-slate-50 border border-slate-200 rounded-xl text-xs focus:outline-none focus:ring-2 focus:ring-[#00B4D8]"
              />
            </div>

            {/* Filters */}
            <div className="flex flex-wrap items-center gap-3 w-full md:w-auto">
              <select
                value={statusFilter}
                onChange={(e) => setStatusFilter(e.target.value)}
                className="px-3 py-2 bg-slate-50 border border-slate-200 rounded-xl text-xs font-medium text-slate-700 focus:outline-none focus:ring-2 focus:ring-[#00B4D8]"
              >
                <option value="all">All Statuses</option>
                <option value="placed">Placed</option>
                <option value="confirmed">Confirmed</option>
                <option value="processing">Processing</option>
                <option value="dispatched">Dispatched</option>
                <option value="delivered">Delivered</option>
                <option value="cancelled">Cancelled</option>
              </select>

              <select
                value={channelFilter}
                onChange={(e) => setChannelFilter(e.target.value)}
                className="px-3 py-2 bg-slate-50 border border-slate-200 rounded-xl text-xs font-medium text-slate-700 focus:outline-none focus:ring-2 focus:ring-[#00B4D8]"
              >
                <option value="all">All Channels</option>
                <option value="retail">Customer Retail</option>
                <option value="wholesale">Dealer Wholesale</option>
              </select>
            </div>
          </div>

          {/* Orders Table */}
          <div className="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
            <div className="overflow-x-auto">
              <table className="w-full text-left border-collapse">
                <thead>
                  <tr className="bg-slate-50 border-b border-slate-100 text-[11px] font-bold text-slate-500 uppercase tracking-wider">
                    <th className="py-3.5 px-4">Order Details</th>
                    <th className="py-3.5 px-4">Customer</th>
                    <th className="py-3.5 px-4">Channel</th>
                    <th className="py-3.5 px-4">Amount</th>
                    <th className="py-3.5 px-4">Current Status</th>
                    <th className="py-3.5 px-4">Update Status</th>
                    <th className="py-3.5 px-4 text-right">View</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-slate-100 text-xs">
                  {filteredOrders.length === 0 ? (
                    <tr>
                      <td colSpan={7} className="py-12 text-center text-slate-400">
                        No orders match the selected filters.
                      </td>
                    </tr>
                  ) : (
                    filteredOrders.map((o) => (
                      <tr key={o.id} className="hover:bg-slate-50/70 transition">
                        <td className="py-3.5 px-4">
                          <p className="font-mono font-bold text-slate-900">{o.orderNumber}</p>
                          <p className="text-[11px] text-slate-400">
                            {new Date(o.createdAt).toLocaleDateString('en-IN', {
                              day: '2-digit',
                              month: 'short',
                              year: 'numeric',
                            })}
                          </p>
                        </td>
                        <td className="py-3.5 px-4">
                          <p className="font-semibold text-slate-900">{o.userName}</p>
                          <p className="text-[11px] text-slate-500">{o.userPhone}</p>
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
                        <td className="py-3.5 px-4">
                          <p className="font-bold text-slate-900">{formatCurrency(o.totalAmount)}</p>
                          <p className="text-[10px] text-emerald-600 font-medium">
                            {o.paymentStatus.toUpperCase()} ({o.paymentMethod.split(' ')[0]})
                          </p>
                        </td>
                        <td className="py-3.5 px-4">{getStatusBadge(o.orderStatus)}</td>
                        <td className="py-3.5 px-4">
                          <select
                            value={o.orderStatus}
                            onChange={(e) => {
                              const newSt = e.target.value as OrderStatus;
                              if (newSt === 'cancelled') {
                                setStatusToUpdate({ id: o.id, status: newSt });
                              } else {
                                handleStatusChange(o.id, newSt);
                              }
                            }}
                            className="text-xs bg-white border border-slate-300 rounded-lg px-2 py-1 focus:outline-none focus:ring-1 focus:ring-[#00B4D8]"
                          >
                            <option value="placed">Placed</option>
                            <option value="confirmed">Confirmed</option>
                            <option value="processing">Processing</option>
                            <option value="dispatched">Dispatched</option>
                            <option value="delivered">Delivered</option>
                            <option value="cancelled">Cancelled</option>
                          </select>
                        </td>
                        <td className="py-3.5 px-4 text-right">
                          <button
                            onClick={() => setSelectedOrder(o)}
                            className="p-1.5 text-slate-500 hover:text-[#0077B6] hover:bg-slate-100 rounded-lg transition"
                            title="Inspect Order"
                          >
                            <Eye className="w-4 h-4" />
                          </button>
                        </td>
                      </tr>
                    ))
                  )}
                </tbody>
              </table>
            </div>
          </div>
        </div>

        {/* Order Details Drawer / Modal */}
        {selectedOrder && (
          <div className="fixed inset-0 z-50 bg-slate-900/40 backdrop-blur-sm flex justify-end">
            <div className="w-full max-w-lg bg-white h-full shadow-2xl overflow-y-auto p-6 flex flex-col justify-between">
              <div>
                <div className="flex items-center justify-between pb-4 border-b border-slate-100">
                  <div>
                    <h3 className="font-bold text-lg text-slate-900">{selectedOrder.orderNumber}</h3>
                    <p className="text-xs text-slate-500">
                      Channel: {selectedOrder.isWholesale ? 'Wholesale Bulk Order' : 'Standard Retail Customer'}
                    </p>
                  </div>
                  <button
                    onClick={() => setSelectedOrder(null)}
                    className="p-2 text-slate-400 hover:text-slate-600 rounded-lg"
                  >
                    ✕
                  </button>
                </div>

                <div className="py-4 space-y-4 text-xs">
                  {/* Status Section */}
                  <div className="p-3.5 bg-slate-50 rounded-xl border border-slate-200">
                    <p className="text-slate-500 font-semibold mb-1">Status & Timeline</p>
                    <div className="flex items-center justify-between">
                      {getStatusBadge(selectedOrder.orderStatus)}
                      <span className="text-[11px] text-slate-400">
                        Updated {new Date(selectedOrder.updatedAt).toLocaleTimeString()}
                      </span>
                    </div>
                  </div>

                  {/* Customer & Shipping */}
                  <div>
                    <h4 className="font-bold text-slate-900 mb-2">Delivery Destination</h4>
                    <div className="p-3 bg-white border border-slate-200 rounded-xl space-y-1">
                      <p className="font-bold text-slate-800">{selectedOrder.userName}</p>
                      <p className="text-slate-600">{selectedOrder.shippingAddress.street}</p>
                      <p className="text-slate-600">
                        {selectedOrder.shippingAddress.city}, {selectedOrder.shippingAddress.state} -{' '}
                        {selectedOrder.shippingAddress.pincode}
                      </p>
                      <p className="text-slate-500 font-mono mt-1">Phone: {selectedOrder.userPhone}</p>
                    </div>
                  </div>

                  {/* Items List */}
                  <div>
                    <h4 className="font-bold text-slate-900 mb-2">Items Purchased ({selectedOrder.items.length})</h4>
                    <div className="space-y-2">
                      {selectedOrder.items.map((item, idx) => (
                        <div key={idx} className="flex items-center space-x-3 p-2 bg-slate-50 rounded-xl border border-slate-100">
                          <img
                            src={item.imageUrl}
                            alt={item.name}
                            className="w-12 h-12 rounded-lg object-cover bg-white"
                          />
                          <div className="flex-1 min-w-0">
                            <p className="font-semibold text-slate-900 truncate">{item.name}</p>
                            <p className="text-[11px] text-slate-500">
                              Qty: {item.quantity} × {formatCurrency(item.unitPrice)}
                            </p>
                          </div>
                          <p className="font-bold text-slate-900">{formatCurrency(item.totalPrice)}</p>
                        </div>
                      ))}
                    </div>
                  </div>

                  {/* Financial Breakdown */}
                  <div className="p-3.5 bg-slate-50 rounded-xl space-y-1.5 border border-slate-200">
                    <div className="flex justify-between text-slate-600">
                      <span>Subtotal</span>
                      <span>{formatCurrency(selectedOrder.subtotal)}</span>
                    </div>
                    <div className="flex justify-between text-slate-600">
                      <span>GST (18% Included)</span>
                      <span>{formatCurrency(selectedOrder.taxAmount)}</span>
                    </div>
                    <div className="flex justify-between text-slate-600">
                      <span>Shipping</span>
                      <span className="text-emerald-600 font-bold">FREE</span>
                    </div>
                    <div className="flex justify-between text-slate-900 font-bold text-sm pt-2 border-t border-slate-200">
                      <span>Total Amount</span>
                      <span>{formatCurrency(selectedOrder.totalAmount)}</span>
                    </div>
                    <div className="pt-2 text-[11px] text-slate-400">
                      <span>Payment: {selectedOrder.paymentMethod}</span>
                      {selectedOrder.paymentId && <span className="block font-mono">ID: {selectedOrder.paymentId}</span>}
                    </div>
                  </div>
                </div>
              </div>

              {/* Close Button */}
              <button
                onClick={() => setSelectedOrder(null)}
                className="w-full py-2.5 bg-slate-900 text-white rounded-xl text-xs font-bold hover:bg-slate-800 transition"
              >
                Close Drawer
              </button>
            </div>
          </div>
        )}

        {/* Cancellation Confirmation Dialog */}
        {statusToUpdate && (
          <div className="fixed inset-0 z-50 bg-slate-900/50 backdrop-blur-sm flex items-center justify-center p-4">
            <div className="bg-white rounded-2xl p-6 max-w-sm w-full shadow-2xl border border-slate-200">
              <div className="flex items-center space-x-3 text-rose-600 mb-3">
                <AlertCircle className="w-6 h-6" />
                <h4 className="font-bold text-base text-slate-900">Confirm Order Cancellation?</h4>
              </div>
              <p className="text-xs text-slate-600 leading-relaxed mb-6">
                Cancelling this order will release reserved inventory and send an automated cancellation notification to the buyer.
              </p>
              <div className="flex space-x-3">
                <button
                  onClick={() => setStatusToUpdate(null)}
                  className="flex-1 py-2 text-xs font-semibold text-slate-700 bg-slate-100 hover:bg-slate-200 rounded-xl transition"
                >
                  Go Back
                </button>
                <button
                  onClick={() => handleStatusChange(statusToUpdate.id, statusToUpdate.status)}
                  className="flex-1 py-2 text-xs font-bold text-white bg-rose-600 hover:bg-rose-700 rounded-xl transition"
                >
                  Yes, Cancel
                </button>
              </div>
            </div>
          </div>
        )}
      </main>
    </div>
  );
}

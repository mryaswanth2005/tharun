'use client';

import { useState, useEffect } from 'react';
import {
  Users,
  CheckCircle,
  XCircle,
  Clock,
  ShieldCheck,
  Search,
  Building,
  FileText,
  AlertTriangle,
} from 'lucide-react';
import Sidebar from '@/components/Sidebar';
import Header from '@/components/Header';
import { dataStore } from '@/lib/dataStore';
import { DealerApplication, DealerStatus } from '@/lib/types';

export default function DealersPage() {
  const [dealers, setDealers] = useState<DealerApplication[]>([]);
  const [activeTab, setActiveTab] = useState<DealerStatus | 'all'>('pending');
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedApplication, setSelectedApplication] = useState<DealerApplication | null>(null);
  const [decisionType, setDecisionType] = useState<DealerStatus | null>(null);
  const [decisionNotes, setDecisionNotes] = useState('');

  const loadDealers = () => {
    setDealers([...dataStore.getDealerApplications()]);
  };

  useEffect(() => {
    loadDealers();
  }, []);

  const handleDecision = () => {
    if (!selectedApplication || !decisionType) return;
    dataStore.decideDealerApplication(
      selectedApplication.id,
      decisionType,
      decisionNotes.trim() || (decisionType === 'approved' ? 'Compliance verified. Wholesale discount authorized.' : 'Application rejected.'),
      'Califnco Admin Ops'
    );
    loadDealers();
    setSelectedApplication(null);
    setDecisionType(null);
    setDecisionNotes('');
  };

  const filteredDealers = dealers.filter((d) => {
    const matchesTab = activeTab === 'all' || d.status === activeTab;
    const matchesSearch =
      d.companyName.toLowerCase().includes(searchQuery.toLowerCase()) ||
      d.contactName.toLowerCase().includes(searchQuery.toLowerCase()) ||
      d.gstNumber.toLowerCase().includes(searchQuery.toLowerCase()) ||
      d.email.toLowerCase().includes(searchQuery.toLowerCase());
    return matchesTab && matchesSearch;
  });

  const pendingCount = dealers.filter((d) => d.status === 'pending').length;
  const approvedCount = dealers.filter((d) => d.status === 'approved').length;
  const rejectedCount = dealers.filter((d) => d.status === 'rejected').length;

  return (
    <div className="flex min-h-screen bg-slate-50">
      <Sidebar />

      <main className="flex-1 flex flex-col min-w-0">
        <Header
          title="Dealer Compliance & Wholesaler Verification"
          subtitle="Review GST credentials, approve bulk-order purchasing tiers, and manage dealer contracts"
          onRefresh={loadDealers}
        />

        <div className="p-6 space-y-6">
          {/* Tabs & Search */}
          <div className="flex flex-col sm:flex-row justify-between items-center gap-4 bg-white p-4 rounded-2xl border border-slate-200 shadow-sm">
            {/* Tabs */}
            <div className="flex items-center space-x-2 bg-slate-100 p-1 rounded-xl">
              <button
                onClick={() => setActiveTab('pending')}
                className={`px-3.5 py-1.5 rounded-lg text-xs font-bold transition flex items-center gap-1.5 ${
                  activeTab === 'pending'
                    ? 'bg-white text-slate-900 shadow-sm'
                    : 'text-slate-600 hover:text-slate-900'
                }`}
              >
                <Clock className="w-3.5 h-3.5 text-amber-500" />
                <span>Pending Review ({pendingCount})</span>
              </button>

              <button
                onClick={() => setActiveTab('approved')}
                className={`px-3.5 py-1.5 rounded-lg text-xs font-bold transition flex items-center gap-1.5 ${
                  activeTab === 'approved'
                    ? 'bg-white text-slate-900 shadow-sm'
                    : 'text-slate-600 hover:text-slate-900'
                }`}
              >
                <CheckCircle className="w-3.5 h-3.5 text-emerald-600" />
                <span>Authorized Wholesalers ({approvedCount})</span>
              </button>

              <button
                onClick={() => setActiveTab('rejected')}
                className={`px-3.5 py-1.5 rounded-lg text-xs font-bold transition flex items-center gap-1.5 ${
                  activeTab === 'rejected'
                    ? 'bg-white text-slate-900 shadow-sm'
                    : 'text-slate-600 hover:text-slate-900'
                }`}
              >
                <XCircle className="w-3.5 h-3.5 text-rose-500" />
                <span>Rejected ({rejectedCount})</span>
              </button>
            </div>

            {/* Search */}
            <div className="relative w-full sm:w-64">
              <Search className="w-4 h-4 text-slate-400 absolute left-3 top-2.5" />
              <input
                type="text"
                placeholder="Search firm, GSTIN, name..."
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                className="w-full pl-9 pr-3 py-1.5 bg-slate-50 border border-slate-200 rounded-xl text-xs focus:outline-none focus:ring-2 focus:ring-[#00B4D8]"
              />
            </div>
          </div>

          {/* Applications Grid / Cards */}
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
            {filteredDealers.length === 0 ? (
              <div className="col-span-full py-16 text-center bg-white rounded-2xl border border-slate-200">
                <Users className="w-12 h-12 text-slate-300 mx-auto mb-3" />
                <h4 className="text-sm font-bold text-slate-700">No Applications In This Category</h4>
                <p className="text-xs text-slate-400 mt-1">
                  All dealer records have been handled or no records match your query.
                </p>
              </div>
            ) : (
              filteredDealers.map((app) => (
                <div
                  key={app.id}
                  className="bg-white rounded-2xl border border-slate-200 p-5 shadow-sm hover:shadow-md transition flex flex-col justify-between"
                >
                  <div className="space-y-3">
                    {/* Header */}
                    <div className="flex items-start justify-between">
                      <div className="p-2.5 rounded-xl bg-slate-100 text-[#0077B6]">
                        <Building className="w-5 h-5" />
                      </div>
                      {app.status === 'approved' && (
                        <span className="px-2.5 py-1 rounded-full text-[11px] font-bold bg-emerald-50 text-emerald-700 border border-emerald-200 flex items-center gap-1">
                          <CheckCircle className="w-3 h-3" /> Authorized Partner
                        </span>
                      )}
                      {app.status === 'pending' && (
                        <span className="px-2.5 py-1 rounded-full text-[11px] font-bold bg-amber-50 text-amber-700 border border-amber-200 flex items-center gap-1">
                          <Clock className="w-3 h-3" /> Awaiting Decision
                        </span>
                      )}
                      {app.status === 'rejected' && (
                        <span className="px-2.5 py-1 rounded-full text-[11px] font-bold bg-rose-50 text-rose-700 border border-rose-200 flex items-center gap-1">
                          <XCircle className="w-3 h-3" /> Rejected
                        </span>
                      )}
                    </div>

                    {/* Company Details */}
                    <div>
                      <h3 className="font-bold text-slate-900 text-sm leading-snug">{app.companyName}</h3>
                      <p className="text-xs text-slate-500 mt-0.5">Contact: {app.contactName}</p>
                    </div>

                    {/* GSTIN Badge */}
                    <div className="p-2.5 bg-slate-50 rounded-xl border border-slate-200/80 font-mono text-xs flex items-center justify-between">
                      <span className="text-slate-400 text-[10px]">GSTIN:</span>
                      <span className="font-bold text-slate-800">{app.gstNumber}</span>
                    </div>

                    {/* Contact info */}
                    <div className="text-xs text-slate-600 space-y-1">
                      <p className="truncate">Email: {app.email}</p>
                      <p>Phone: {app.phone}</p>
                      <p className="text-slate-500 text-[11px] line-clamp-2 mt-1">Address: {app.address}</p>
                    </div>

                    {/* Decision Notes if present */}
                    {app.adminDecisionNotes && (
                      <div className="p-2.5 rounded-xl bg-slate-50 border border-slate-200 text-[11px] text-slate-600">
                        <span className="font-semibold text-slate-700 block mb-0.5">Recorded Decision Notes:</span>
                        {app.adminDecisionNotes}
                      </div>
                    )}
                  </div>

                  {/* Actions */}
                  <div className="pt-4 mt-4 border-t border-slate-100">
                    {app.status === 'pending' ? (
                      <div className="flex space-x-2">
                        <button
                          onClick={() => {
                            setSelectedApplication(app);
                            setDecisionType('approved');
                          }}
                          className="flex-1 py-2 rounded-xl text-xs font-bold text-white bg-emerald-600 hover:bg-emerald-700 transition"
                        >
                          Approve
                        </button>
                        <button
                          onClick={() => {
                            setSelectedApplication(app);
                            setDecisionType('rejected');
                          }}
                          className="flex-1 py-2 rounded-xl text-xs font-semibold text-rose-700 bg-rose-50 hover:bg-rose-100 transition border border-rose-200"
                        >
                          Reject
                        </button>
                      </div>
                    ) : (
                      <p className="text-[11px] text-slate-400 text-center">
                        Decision recorded on{' '}
                        {app.reviewedAt ? new Date(app.reviewedAt).toLocaleDateString() : 'Active file'}
                      </p>
                    )}
                  </div>
                </div>
              ))
            )}
          </div>
        </div>

        {/* Decision Confirmation Modal */}
        {selectedApplication && decisionType && (
          <div className="fixed inset-0 z-50 bg-slate-900/50 backdrop-blur-sm flex items-center justify-center p-4">
            <div className="bg-white rounded-2xl p-6 max-w-md w-full shadow-2xl border border-slate-200 space-y-4">
              <div className="flex items-center space-x-3">
                {decisionType === 'approved' ? (
                  <div className="p-2.5 rounded-xl bg-emerald-100 text-emerald-600">
                    <CheckCircle className="w-6 h-6" />
                  </div>
                ) : (
                  <div className="p-2.5 rounded-xl bg-rose-100 text-rose-600">
                    <XCircle className="w-6 h-6" />
                  </div>
                )}
                <div>
                  <h3 className="font-bold text-slate-900 text-base">
                    {decisionType === 'approved' ? 'Authorize Wholesale Account' : 'Reject Dealer Application'}
                  </h3>
                  <p className="text-xs text-slate-500">{selectedApplication.companyName}</p>
                </div>
              </div>

              <div className="text-xs text-slate-600 space-y-2">
                <p>
                  <strong>GSTIN:</strong> {selectedApplication.gstNumber}
                </p>
                <p>
                  {decisionType === 'approved'
                    ? 'Approving will grant this dealer access to the wholesale pricing catalog (up to 35% margin) and bulk ordering capabilities.'
                    : 'Rejecting will maintain the applicant on standard retail customer pricing.'}
                </p>
              </div>

              <div>
                <label className="block text-xs font-bold text-slate-700 mb-1.5">
                  Audit Decision Notes (Recorded in Compliance Log):
                </label>
                <textarea
                  value={decisionNotes}
                  onChange={(e) => setDecisionNotes(e.target.value)}
                  placeholder={
                    decisionType === 'approved'
                      ? 'e.g. Verified with state GST portal. Authorized for 35% wholesale tier.'
                      : 'e.g. Invalid GSTIN or unverifiable business address.'
                  }
                  rows={3}
                  className="w-full p-2.5 bg-slate-50 border border-slate-200 rounded-xl text-xs focus:outline-none focus:ring-2 focus:ring-[#00B4D8]"
                />
              </div>

              <div className="flex space-x-3 pt-2">
                <button
                  onClick={() => {
                    setSelectedApplication(null);
                    setDecisionType(null);
                  }}
                  className="flex-1 py-2 text-xs font-semibold text-slate-700 bg-slate-100 hover:bg-slate-200 rounded-xl transition"
                >
                  Cancel
                </button>
                <button
                  onClick={handleDecision}
                  className={`flex-1 py-2 text-xs font-bold text-white rounded-xl transition ${
                    decisionType === 'approved'
                      ? 'bg-emerald-600 hover:bg-emerald-700'
                      : 'bg-rose-600 hover:bg-rose-700'
                  }`}
                >
                  Confirm Decision
                </button>
              </div>
            </div>
          </div>
        )}
      </main>
    </div>
  );
}

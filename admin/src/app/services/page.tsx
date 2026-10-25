'use client';

import { useState, useEffect } from 'react';
import {
  Wrench,
  Search,
  CheckCircle,
  Clock,
  UserCheck,
  AlertCircle,
  Calendar,
  MapPin,
  Phone,
} from 'lucide-react';
import Sidebar from '@/components/Sidebar';
import Header from '@/components/Header';
import { dataStore } from '@/lib/dataStore';
import { ServiceBooking, ServiceStatus } from '@/lib/types';

const technicianList = [
  'Suresh Kumar (+91 94480 11223) - South Zone',
  'Ramesh Babu (+91 98440 44556) - East Zone',
  'Mohammed Arif (+91 97410 77889) - North Zone',
  'Kiran Gowda (+91 99000 33441) - Central Zone',
];

export default function ServicesPage() {
  const [bookings, setBookings] = useState<ServiceBooking[]>([]);
  const [statusFilter, setStatusFilter] = useState<string>('all');
  const [searchQuery, setSearchQuery] = useState('');
  const [assignModalBooking, setAssignModalBooking] = useState<ServiceBooking | null>(null);
  const [selectedTech, setSelectedTech] = useState<string>(technicianList[0]);

  const loadServices = () => {
    setBookings([...dataStore.getServiceBookings()]);
  };

  useEffect(() => {
    loadServices();
  }, []);

  const handleStatusChange = (bookingId: string, status: ServiceStatus, tech?: string) => {
    dataStore.updateServiceStatus(bookingId, status, tech);
    loadServices();
  };

  const handleAssignTechnician = () => {
    if (!assignModalBooking) return;
    handleStatusChange(assignModalBooking.id, 'assigned', selectedTech);
    setAssignModalBooking(null);
  };

  const filtered = bookings.filter((b) => {
    const matchesStatus = statusFilter === 'all' || b.status === statusFilter;
    const matchesSearch =
      b.ticketNumber.toLowerCase().includes(searchQuery.toLowerCase()) ||
      b.customerName.toLowerCase().includes(searchQuery.toLowerCase()) ||
      b.purifierModel.toLowerCase().includes(searchQuery.toLowerCase()) ||
      b.serviceType.toLowerCase().includes(searchQuery.toLowerCase());
    return matchesStatus && matchesSearch;
  });

  const getStatusBadge = (status: ServiceStatus) => {
    switch (status) {
      case 'pending':
        return <span className="px-2.5 py-1 rounded-full text-xs font-semibold bg-amber-50 text-amber-700 border border-amber-200">Pending Assignment</span>;
      case 'assigned':
        return <span className="px-2.5 py-1 rounded-full text-xs font-semibold bg-blue-50 text-blue-700 border border-blue-200">Tech Assigned</span>;
      case 'inProgress':
        return <span className="px-2.5 py-1 rounded-full text-xs font-semibold bg-cyan-50 text-cyan-700 border border-cyan-200">In Progress</span>;
      case 'completed':
        return <span className="px-2.5 py-1 rounded-full text-xs font-semibold bg-emerald-50 text-emerald-700 border border-emerald-200">Completed</span>;
      case 'cancelled':
        return <span className="px-2.5 py-1 rounded-full text-xs font-semibold bg-rose-50 text-rose-700 border border-rose-200">Cancelled</span>;
    }
  };

  return (
    <div className="flex min-h-screen bg-slate-50">
      <Sidebar />

      <main className="flex-1 flex flex-col min-w-0">
        <Header
          title="Field Service & AMC Management"
          subtitle="Dispatch certified water purifier technicians for installation, filter overhauls, and repairs"
          onRefresh={loadServices}
        />

        <div className="p-6 space-y-6">
          {/* Controls */}
          <div className="flex flex-col sm:flex-row justify-between items-center gap-4 bg-white p-4 rounded-2xl border border-slate-200 shadow-sm">
            <div className="flex items-center space-x-2">
              <select
                value={statusFilter}
                onChange={(e) => setStatusFilter(e.target.value)}
                className="px-3.5 py-2 bg-slate-50 border border-slate-200 rounded-xl text-xs font-medium text-slate-700 focus:outline-none focus:ring-2 focus:ring-[#00B4D8]"
              >
                <option value="all">All Service Tickets</option>
                <option value="pending">Pending Technician</option>
                <option value="assigned">Technician Assigned</option>
                <option value="inProgress">In Progress</option>
                <option value="completed">Completed</option>
                <option value="cancelled">Cancelled</option>
              </select>
            </div>

            <div className="relative w-full sm:w-72">
              <Search className="w-4 h-4 text-slate-400 absolute left-3 top-3" />
              <input
                type="text"
                placeholder="Search ticket, model, customer..."
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                className="w-full pl-9 pr-3 py-2 bg-slate-50 border border-slate-200 rounded-xl text-xs focus:outline-none focus:ring-2 focus:ring-[#00B4D8]"
              />
            </div>
          </div>

          {/* Tickets List */}
          <div className="space-y-4">
            {filtered.length === 0 ? (
              <div className="py-16 text-center bg-white rounded-2xl border border-slate-200">
                <Wrench className="w-12 h-12 text-slate-300 mx-auto mb-3" />
                <h4 className="text-sm font-bold text-slate-700">No Service Tickets Found</h4>
                <p className="text-xs text-slate-400 mt-1">There are no service requests matching this query.</p>
              </div>
            ) : (
              filtered.map((ticket) => (
                <div
                  key={ticket.id}
                  className="bg-white rounded-2xl border border-slate-200 p-5 shadow-sm hover:shadow-md transition"
                >
                  <div className="flex flex-col lg:flex-row lg:items-center justify-between gap-4">
                    {/* Ticket Header & Customer */}
                    <div className="space-y-2 flex-1">
                      <div className="flex items-center space-x-3">
                        <span className="font-mono font-bold text-slate-900 text-sm bg-slate-100 px-2 py-0.5 rounded">
                          {ticket.ticketNumber}
                        </span>
                        {getStatusBadge(ticket.status)}
                        <span className="text-xs font-semibold text-[#0077B6]">{ticket.serviceType}</span>
                      </div>

                      <div className="grid grid-cols-1 sm:grid-cols-2 gap-2 text-xs text-slate-600 pt-1">
                        <div className="flex items-center gap-1.5">
                          <UserCheck className="w-3.5 h-3.5 text-slate-400" />
                          <span className="font-semibold text-slate-800">{ticket.customerName}</span>
                          <span className="text-slate-400">({ticket.customerPhone})</span>
                        </div>
                        <div className="flex items-center gap-1.5">
                          <Calendar className="w-3.5 h-3.5 text-slate-400" />
                          <span>Slot: {ticket.preferredDate} ({ticket.preferredTimeSlot})</span>
                        </div>
                        <div className="flex items-center gap-1.5 sm:col-span-2">
                          <MapPin className="w-3.5 h-3.5 text-slate-400 flex-shrink-0" />
                          <span className="truncate">{ticket.address.street}, {ticket.address.city}</span>
                        </div>
                      </div>

                      <p className="text-[11px] text-slate-500 bg-slate-50 p-2 rounded-lg border border-slate-100">
                        <strong className="text-slate-700">Appliance Model:</strong> {ticket.purifierModel}{' '}
                        {ticket.notes && `• Notes: "${ticket.notes}"`}
                      </p>
                    </div>

                    {/* Technician & Actions */}
                    <div className="lg:w-80 flex flex-col justify-between items-end space-y-3 pt-3 lg:pt-0 border-t lg:border-t-0 border-slate-100">
                      {ticket.assignedTechnician ? (
                        <div className="w-full text-right">
                          <span className="text-[10px] text-slate-400 uppercase tracking-wider block">Assigned Engineer</span>
                          <span className="text-xs font-bold text-slate-800 block truncate">
                            {ticket.assignedTechnician}
                          </span>
                        </div>
                      ) : (
                        <button
                          onClick={() => {
                            setAssignModalBooking(ticket);
                          }}
                          className="px-3 py-1.5 bg-[#0077B6] text-white rounded-xl text-xs font-bold hover:bg-[#005f73] transition"
                        >
                          + Assign Field Technician
                        </button>
                      )}

                      {/* State update dropdown */}
                      <div className="flex items-center space-x-2 w-full justify-end">
                        <span className="text-xs text-slate-400">Change Status:</span>
                        <select
                          value={ticket.status}
                          onChange={(e) => handleStatusChange(ticket.id, e.target.value as ServiceStatus)}
                          className="text-xs bg-slate-50 border border-slate-200 rounded-lg px-2 py-1 focus:outline-none focus:ring-1 focus:ring-[#00B4D8]"
                        >
                          <option value="pending">Pending</option>
                          <option value="assigned">Assigned</option>
                          <option value="inProgress">In Progress</option>
                          <option value="completed">Completed</option>
                          <option value="cancelled">Cancelled</option>
                        </select>
                      </div>
                    </div>
                  </div>
                </div>
              ))
            )}
          </div>
        </div>

        {/* Technician Assignment Modal */}
        {assignModalBooking && (
          <div className="fixed inset-0 z-50 bg-slate-900/50 backdrop-blur-sm flex items-center justify-center p-4">
            <div className="bg-white rounded-2xl p-6 max-w-md w-full shadow-2xl border border-slate-200 space-y-4">
              <div className="flex items-center space-x-3">
                <div className="p-2.5 rounded-xl bg-blue-100 text-[#0077B6]">
                  <Wrench className="w-6 h-6" />
                </div>
                <div>
                  <h3 className="font-bold text-slate-900 text-base">Assign Certified Technician</h3>
                  <p className="text-xs text-slate-500">Ticket: {assignModalBooking.ticketNumber}</p>
                </div>
              </div>

              <div className="text-xs text-slate-600 bg-slate-50 p-3 rounded-xl border border-slate-100 space-y-1">
                <p><strong>Customer:</strong> {assignModalBooking.customerName}</p>
                <p><strong>Service:</strong> {assignModalBooking.serviceType}</p>
                <p><strong>Location:</strong> {assignModalBooking.address.city} - {assignModalBooking.address.pincode}</p>
              </div>

              <div>
                <label className="block text-xs font-bold text-slate-700 mb-2">
                  Select Field Engineer:
                </label>
                <div className="space-y-2">
                  {technicianList.map((tech) => (
                    <label
                      key={tech}
                      className={`flex items-center p-2.5 rounded-xl border text-xs cursor-pointer transition ${
                        selectedTech === tech
                          ? 'border-[#0077B6] bg-blue-50/50 font-semibold text-slate-900'
                          : 'border-slate-200 hover:bg-slate-50 text-slate-700'
                      }`}
                    >
                      <input
                        type="radio"
                        name="technician"
                        checked={selectedTech === tech}
                        onChange={() => setSelectedTech(tech)}
                        className="mr-2 text-[#0077B6]"
                      />
                      <span>{tech}</span>
                    </label>
                  ))}
                </div>
              </div>

              <div className="flex space-x-3 pt-3">
                <button
                  onClick={() => setAssignModalBooking(null)}
                  className="flex-1 py-2 text-xs font-semibold text-slate-700 bg-slate-100 hover:bg-slate-200 rounded-xl transition"
                >
                  Cancel
                </button>
                <button
                  onClick={handleAssignTechnician}
                  className="flex-1 py-2 text-xs font-bold text-white bg-[#0077B6] hover:bg-[#005f73] rounded-xl transition"
                >
                  Confirm Assignment
                </button>
              </div>
            </div>
          </div>
        )}
      </main>
    </div>
  );
}

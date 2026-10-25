'use client';

import Link from 'next/link';
import { usePathname } from 'next/navigation';
import {
  LayoutDashboard,
  ShoppingBag,
  Users,
  Wrench,
  Package,
  ShieldCheck,
  Droplets,
  LogOut,
} from 'lucide-react';

const navItems = [
  { name: 'Overview', href: '/', icon: LayoutDashboard },
  { name: 'Order Management', href: '/orders', icon: ShoppingBag },
  { name: 'Dealer Applications', href: '/dealers', icon: Users },
  { name: 'Service Tickets & AMC', href: '/services', icon: Wrench },
  { name: 'Products & Inventory', href: '/products', icon: Package },
];

export default function Sidebar() {
  const pathname = usePathname();

  return (
    <aside className="w-64 bg-[#0A192F] text-slate-100 flex flex-col min-h-screen border-r border-[#172A45] flex-shrink-0">
      {/* Brand Header */}
      <div className="p-5 border-b border-[#172A45] flex items-center space-x-3">
        <div className="p-2 bg-[#00B4D8] rounded-xl text-[#0A192F] font-bold shadow-lg shadow-cyan-500/20">
          <Droplets className="w-5 h-5 text-[#0A192F]" />
        </div>
        <div>
          <h1 className="font-bold text-base tracking-tight text-white flex items-center gap-1.5">
            Califnco <span className="text-[#00B4D8] text-xs font-semibold px-1.5 py-0.5 rounded bg-cyan-950/60 border border-cyan-500/30">OPS</span>
          </h1>
          <p className="text-[11px] text-slate-400">Operations & Logistics Panel</p>
        </div>
      </div>

      {/* Navigation */}
      <nav className="flex-1 p-4 space-y-1.5">
        <div className="text-[10px] font-bold text-slate-400 uppercase tracking-wider px-3 mb-2">
          Core Workflows
        </div>
        {navItems.map((item) => {
          const isActive = pathname === item.href;
          const Icon = item.icon;
          return (
            <Link
              key={item.name}
              href={item.href}
              className={`flex items-center space-x-3 px-3.5 py-2.5 rounded-xl text-sm font-medium transition-all ${
                isActive
                  ? 'bg-[#0077B6] text-white shadow-md shadow-blue-900/30 font-semibold'
                  : 'text-slate-300 hover:bg-[#172A45] hover:text-white'
              }`}
            >
              <Icon className={`w-4 h-4 ${isActive ? 'text-white' : 'text-slate-400'}`} />
              <span>{item.name}</span>
            </Link>
          );
        })}
      </nav>

      {/* Admin User Card */}
      <div className="p-4 border-t border-[#172A45] bg-[#0F2744]/60">
        <div className="flex items-center space-x-3 mb-3">
          <div className="w-9 h-9 rounded-full bg-gradient-to-tr from-[#00B4D8] to-[#0077B6] flex items-center justify-center text-white font-bold text-xs shadow-md">
            AD
          </div>
          <div className="flex-1 min-w-0">
            <p className="text-xs font-semibold text-white truncate">Califnco Admin</p>
            <p className="text-[11px] text-emerald-400 flex items-center gap-1 font-medium">
              <ShieldCheck className="w-3 h-3" /> Super Admin Role
            </p>
          </div>
        </div>
        <Link
          href="/login"
          className="w-full flex items-center justify-center space-x-1.5 py-1.5 px-3 rounded-lg text-xs text-slate-400 hover:text-rose-400 hover:bg-rose-950/30 transition border border-slate-700/60"
        >
          <LogOut className="w-3.5 h-3.5" />
          <span>Switch Account / Sign Out</span>
        </Link>
      </div>
    </aside>
  );
}

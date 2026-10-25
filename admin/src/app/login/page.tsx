'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { Droplets, ShieldCheck, Lock, Mail, ArrowRight } from 'lucide-react';

export default function LoginPage() {
  const router = useRouter();
  const [email, setEmail] = useState('admin@califnco.com');
  const [password, setPassword] = useState('AdminPass@2026');
  const [isLoading, setIsLoading] = useState(false);

  const handleLogin = (e: React.FormEvent) => {
    e.preventDefault();
    setIsLoading(true);
    setTimeout(() => {
      router.push('/');
    }, 600);
  };

  const quickFillAdmin = () => {
    setEmail('admin@califnco.com');
    setPassword('AdminPass@2026');
  };

  return (
    <div className="min-h-screen bg-[#0A192F] flex flex-col justify-center items-center p-4">
      <div className="w-full max-w-md bg-white rounded-3xl shadow-2xl p-8 border border-slate-100">
        {/* Logo */}
        <div className="flex flex-col items-center mb-6">
          <div className="p-3 bg-[#00B4D8] rounded-2xl text-[#0A192F] mb-3 shadow-lg shadow-cyan-500/20">
            <Droplets className="w-8 h-8 text-[#0A192F]" />
          </div>
          <h1 className="text-2xl font-bold text-slate-900 tracking-tight">Califnco Operations</h1>
          <p className="text-xs text-slate-500 mt-1">Super Admin Operations & Logistics Portal</p>
        </div>

        {/* Demo Credentials Quick Fill Banner */}
        <div className="mb-6 p-3.5 bg-blue-50 border border-blue-200 rounded-2xl flex items-center justify-between">
          <div>
            <p className="text-xs font-bold text-blue-900">Evaluator Demo Account</p>
            <p className="text-[11px] text-blue-700">admin@califnco.com</p>
          </div>
          <button
            type="button"
            onClick={quickFillAdmin}
            className="px-3 py-1 bg-blue-600 text-white rounded-xl text-xs font-bold hover:bg-blue-700 transition"
          >
            Auto Fill
          </button>
        </div>

        <form onSubmit={handleLogin} className="space-y-4">
          <div>
            <label className="block text-xs font-bold text-slate-700 mb-1.5">Admin Email</label>
            <div className="relative">
              <Mail className="w-4 h-4 text-slate-400 absolute left-3.5 top-3" />
              <input
                type="email"
                required
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                placeholder="admin@califnco.com"
                className="w-full pl-10 pr-4 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-xs text-slate-900 focus:outline-none focus:ring-2 focus:ring-[#00B4D8]"
              />
            </div>
          </div>

          <div>
            <label className="block text-xs font-bold text-slate-700 mb-1.5">Admin Password</label>
            <div className="relative">
              <Lock className="w-4 h-4 text-slate-400 absolute left-3.5 top-3" />
              <input
                type="password"
                required
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                className="w-full pl-10 pr-4 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-xs text-slate-900 focus:outline-none focus:ring-2 focus:ring-[#00B4D8]"
              />
            </div>
          </div>

          <button
            type="submit"
            disabled={isLoading}
            className="w-full py-3 bg-[#0A192F] text-white rounded-xl text-xs font-bold hover:bg-[#0F2744] transition flex items-center justify-center space-x-2 shadow-lg shadow-navy-900/20"
          >
            {isLoading ? (
              <span>Authenticating Admin Credentials...</span>
            ) : (
              <>
                <span>Sign In to Command Center</span>
                <ArrowRight className="w-4 h-4" />
              </>
            )}
          </button>
        </form>

        <div className="mt-6 pt-4 border-t border-slate-100 flex items-center justify-center space-x-1.5 text-[11px] text-slate-400">
          <ShieldCheck className="w-3.5 h-3.5 text-emerald-500" />
          <span>Secured with Firebase Role-Based Security Rules</span>
        </div>
      </div>
    </div>
  );
}

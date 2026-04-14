'use client';

import React from 'react';
import { ShieldAlert, ArrowLeft, Home, Lock } from 'lucide-react';
import Link from 'next/link';

interface AccessDeniedProps {
  pathname?: string;
}

export default function AccessDenied({ pathname }: AccessDeniedProps) {
  return (
    <div className="min-h-[80vh] flex flex-col items-center justify-center p-6 text-center animate-in fade-in duration-500">
      {/* Decorative background elements */}
      <div className="absolute inset-0 z-0 overflow-hidden pointer-events-none opacity-30">
        <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[500px] h-[500px] bg-red-500/10 rounded-full blur-[120px]"></div>
        <div className="absolute top-1/4 left-1/3 w-[300px] h-[300px] bg-amber-500/10 rounded-full blur-[100px]"></div>
      </div>

      <div className="relative z-10 max-w-md w-full">
        <div className="mb-8 relative inline-block">
          <div className="w-24 h-24 rounded-3xl bg-red-500/10 flex items-center justify-center text-red-500 shadow-xl shadow-red-500/10 border border-red-500/20 rotate-3 transform group hover:rotate-0 transition-transform duration-300">
            <ShieldAlert size={48} />
          </div>
          <div className="absolute -bottom-2 -right-2 w-10 h-10 rounded-xl bg-bg-surface border border-border shadow-lg flex items-center justify-center text-amber-500 animate-bounce">
            <Lock size={20} />
          </div>
        </div>

        <h1 className="text-4xl font-black tracking-tight mb-4 tracking-tight" style={{ color: 'var(--text-primary)' }}>
          Access Denied
        </h1>
        
        <p className="text-lg font-medium mb-2" style={{ color: 'var(--text-secondary)' }}>
          403 — Forbidden
        </p>
        
        <div className="p-4 rounded-2xl border bg-bg-muted/50 mb-8 border-dashed" style={{ borderColor: 'var(--border)' }}>
          <p className="text-sm font-medium leading-relaxed" style={{ color: 'var(--text-muted)' }}>
            You don&apos;t have the required permissions to view <code className="px-1.5 py-0.5 rounded bg-red-500/10 text-red-500 font-bold whitespace-nowrap">{pathname || 'this page'}</code>. 
            Please contact your administrator if you believe this is an error.
          </p>
        </div>

        <div className="flex flex-col sm:flex-row gap-4 items-center justify-center">
          <button 
            onClick={() => window.history.back()}
            className="w-full sm:w-auto px-6 py-3 rounded-xl border font-bold flex items-center justify-center gap-2 transition-all hover:bg-bg-muted active:scale-95"
            style={{ borderColor: 'var(--border)', color: 'var(--text-primary)' }}
          >
            <ArrowLeft size={18} />
            Go Back
          </button>
          
          <Link 
            href="/"
            className="w-full sm:w-auto px-6 py-3 rounded-xl font-bold flex items-center justify-center gap-2 text-white gradient-accent shadow-lg shadow-blue-500/20 active:scale-95 transition-all"
          >
            <Home size={18} />
            Dashboard
          </Link>
        </div>
      </div>
      
      <p className="mt-12 text-[10px] font-black uppercase tracking-[0.2em] opacity-30" style={{ color: 'var(--text-faint)' }}>
        Authorized Personnel Only
      </p>
    </div>
  );
}

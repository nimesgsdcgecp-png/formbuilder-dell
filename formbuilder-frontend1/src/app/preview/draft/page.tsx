'use client';

import React, { useEffect, useState } from 'react';
import FormRenderer from '@/components/FormRenderer';
import { FormSchema } from '@/types/schema';
import { Loader2, AlertTriangle } from 'lucide-react';

export default function DraftPreviewPage() {
    const [schema, setSchema] = useState<FormSchema | null>(null);
    const [error, setError] = useState<string | null>(null);

    useEffect(() => {
        try {
            const stored = sessionStorage.getItem('form_draft_preview');
            if (stored) {
                const parsed = JSON.parse(stored);
                setSchema(parsed);
            } else {
                setError("No preview data found. Please generate a form using Form Architect first.");
            }
        } catch (err) {
            setError("Failed to load preview data.");
        }
    }, []);

    if (error) {
        return (
            <div className="min-h-screen bg-gray-50 flex items-center justify-center p-4">
                <div className="max-w-md w-full bg-white rounded-2xl shadow-sm border border-gray-200 p-8 text-center space-y-4">
                    <div className="w-16 h-16 bg-red-50 text-red-500 rounded-full flex items-center justify-center mx-auto">
                        <AlertTriangle size={32} />
                    </div>
                    <h1 className="text-xl font-bold text-gray-900">Preview Error</h1>
                    <p className="text-gray-500 text-sm leading-relaxed">{error}</p>
                    <button 
                        onClick={() => window.close()}
                        className="px-6 py-2.5 bg-gray-900 text-white rounded-xl text-sm font-bold hover:bg-gray-800 transition-all"
                    >
                        Close Tab
                    </button>
                </div>
            </div>
        );
    }

    if (!schema) {
        return (
            <div className="min-h-screen bg-gray-50 flex items-center justify-center">
                <Loader2 className="w-8 h-8 text-blue-600 animate-spin" />
            </div>
        );
    }

    return (
        <div className="min-h-screen bg-gray-50 py-12 px-4 flex flex-col items-center">
            <div className="max-w-4xl w-full">
                <div className="mb-8 flex items-center justify-between">
                    <div>
                        <div className="flex items-center gap-2 mb-1">
                            <span className="px-2 py-0.5 bg-blue-600 text-[10px] font-bold text-white rounded uppercase tracking-wider">AI Draft Preview</span>
                            <span className="text-[10px] text-gray-500 font-medium">This is a temporary view of your AI-generated form</span>
                        </div>
                        <h2 className="text-sm font-bold text-gray-400">Viewing: {schema.title || 'Untitled Form'}</h2>
                    </div>
                    <button 
                         onClick={() => window.close()}
                         className="px-4 py-2 border border-gray-200 bg-white text-gray-600 rounded-xl text-xs font-bold hover:bg-gray-50 transition-all shadow-sm"
                    >
                        Close Preview
                    </button>
                </div>
                
                <FormRenderer 
                    schema={schema} 
                    isPreview={true}
                    submitButtonText="Preview Complete" 
                    onSubmit={() => alert("Form submission is disabled in preview mode.")}
                />
            </div>
        </div>
    );
}

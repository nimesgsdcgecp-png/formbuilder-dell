'use client';

import { useEffect, useState } from 'react';
import { usePathname, useRouter } from 'next/navigation';
import { usePermissions } from '@/hooks/usePermissions';
import { MENU } from '@/utils/apiConstants';
import { extractArray } from '@/utils/apiData';
import AccessDenied from './AccessDenied';

interface MenuNode {
  id: number;
  name: string;
  url: string;
  children: MenuNode[];
}

export default function RouteGuard({ children }: { children: React.ReactNode }) {
  const pathname = usePathname();
  const router = useRouter();
  const { assignments, isLoading: permsLoading, isAuthenticated } = usePermissions();
  const [isAuthorized, setIsAuthorized] = useState<boolean | null>(null);

  useEffect(() => {
    const checkAccess = async () => {
      // 1. Define Public vs Protected Paths
      const publicPaths = ['/login', '/register', '/f/'];
      const isPublic = publicPaths.some(p => pathname === p || (p !== '/' && pathname.startsWith(p)));

      // Always allow public paths
      if (isPublic) {
        setIsAuthorized(true);
        return;
      }

      // 2. Authentication Check
      // If we know for sure they aren't logged in, redirect to login
      if (isAuthenticated === false) {
        router.push(`/login?redirect=${pathname}`);
        return;
      }

      // If still checking identity, wait
      if (isAuthenticated === null) return;

      // 3. Authorization Check (Authenticated Users)
      
      const isAdmin = assignments.some(a => 
        ['ADMIN', 'ROLE_ADMIN', 'ROLE_ADMINISTRATOR'].includes(a.role.name)
      );
      const isBuilder = assignments.some(a => 
        ['BUILDER', 'ROLE_BUILDER', 'ADMIN', 'ROLE_ADMIN', 'ROLE_ADMINISTRATOR', 'USER', 'ROLE_USER'].includes(a.role.name)
      );

      // Admin-only paths
      const adminPaths = ['/admin/users', '/admin/roles', '/admin/audit', '/admin/modules', '/admin/role-modules'];
      const isAdminPath = adminPaths.some(p => pathname === p || pathname.startsWith(p));
      if (isAdminPath) {
        if (!isAdmin) {
          setIsAuthorized(false);
          return;
        }
        setIsAuthorized(true);
        return;
      }

      // Builder-only paths
      const isBuilderPath = pathname.startsWith('/builder');
      if (isBuilderPath) {
        if (!isBuilder) {
          setIsAuthorized(false);
          return;
        }
        setIsAuthorized(true);
        return;
      }

      // Core pages allowed for any logged-in user
      const corePaths = ['/', '/profile', '/forms', '/approvals', '/preview/draft'];
      const isCorePath = corePaths.some(p => pathname === p || (p !== '/' && pathname.startsWith(p)));
      
      if (isCorePath) {
        setIsAuthorized(true);
        return;
      }

      // 4. Dynamic Menu Permission Check (for dynamic modules)
      try {
        const res = await fetch(MENU.LIST, { credentials: 'include' });
        if (res.ok) {
          const raw = await res.json();
          const menuTree = extractArray<MenuNode>(raw, ['menu', 'menuTree', 'items', 'content']);
          
          const allowedUrls = new Set<string>();
          const flatten = (nodes: MenuNode[]) => {
            nodes.forEach(node => {
              if (node.url) allowedUrls.add(node.url);
              if (node.children) flatten(node.children);
            });
          };
          flatten(menuTree);

          const hasAccess = Array.from(allowedUrls).some(url => 
            pathname === url || (url !== '/' && pathname.startsWith(url))
          );

          if (!hasAccess && assignments.length > 0) {
             setIsAuthorized(false);
          } else {
             setIsAuthorized(true);
          }
        } else {
           setIsAuthorized(true);
        }
      } catch {
        setIsAuthorized(true);
      }
    };

    if (!permsLoading) {
      checkAccess();
    }
  }, [pathname, assignments, permsLoading, isAuthenticated, router]);


  if (isAuthorized === null || permsLoading || isAuthenticated === null) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-bg-main">
        <div className="w-8 h-8 border-2 border-accent border-t-transparent rounded-full animate-spin"></div>
      </div>
    );
  }

  if (isAuthorized === false) {
    return <AccessDenied pathname={pathname} />;
  }

  return <>{children}</>;
}

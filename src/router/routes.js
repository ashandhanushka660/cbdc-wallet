const routes = [
  {
    path: '/',
    component: () => import('layouts/MainLayout.vue'),
    children: [
      { path: '', component: () => import('pages/IndexPage.vue') },
      { path: 'get-started', component: () => import('pages/GetStartedPage.vue') },
      { path: 'documentation', component: () => import('pages/DocumentationPage.vue') },
      { path: 'team', component: () => import('pages/TeamPage.vue') },
    ],
  },

  {
    path: '/auth',
    component: () => import('layouts/MainLayout.vue'), // Using MainLayout for auth for now, can switch if needed
    children: [
      { path: 'login', component: () => import('pages/auth/LoginPage.vue') },
      { path: 'register', component: () => import('pages/auth/RegisterPage.vue') },
    ],
  },

  {
    path: '/dashboard',
    component: () => import('layouts/DashboardLayout.vue'),
    children: [
      { path: '', component: () => import('pages/dashboard/DashboardPage.vue') },
      { path: 'transactions', component: () => import('pages/dashboard/TransactionsPage.vue') },
      { path: 'cards', component: () => import('pages/dashboard/CardsPage.vue') },
      { path: 'loans', component: () => import('pages/dashboard/LoansPage.vue') },
    ],
  },

  {
    path: '/admin',
    component: () => import('layouts/AdminLayout.vue'),
    beforeEnter: async (to, from, next) => {
      const { adminGuard } = await import('src/router/guards/adminGuard.js')
      return adminGuard(to, from, next)
    },
    children: [
      { path: '', component: () => import('pages/admin/AdminDashboardPage.vue') },
      { path: 'users', component: () => import('pages/admin/UsersPage.vue') },
      { path: 'transactions', component: () => import('pages/admin/TransactionsPage.vue') },
      { path: 'monetary', component: () => import('pages/admin/MonetaryPage.vue') },
    ],
  },

  // Always leave this as last one,
  // but you can also remove it
  {
    path: '/:catchAll(.*)*',
    component: () => import('pages/ErrorNotFound.vue'),
  },
]

export default routes

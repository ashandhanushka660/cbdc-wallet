<template>
  <q-layout view="lHh Lpr lFf" class="bg-dark text-white">
    <!-- Added reveal-offset="0" so it hides immediately when scrolling starts -->
    <q-header
      reveal
      :reveal-offset="0"
      class="bg-transparent text-white q-py-md transition-bg"
      height-hint="98"
    >
      <q-toolbar class="container no-wrap">
        <q-btn
          flat
          dense
          round
          icon="menu"
          class="lt-md q-mr-sm"
          @click="leftDrawerOpen = !leftDrawerOpen"
        />

        <q-btn flat no-caps no-wrap dense class="q-mr-sm" to="/">
          <!-- Logo Icon -->
          <div class="bg-white text-primary q-pa-xs rounded-borders q-mr-sm">
            <q-icon name="account_balance_wallet" size="24px" />
          </div>
          <q-toolbar-title shrink class="text-weight-bold text-h6 font-heading gt-xs">
            CBDC Wallet
          </q-toolbar-title>
        </q-btn>

        <q-space />

        <!-- Desktop Navigation -->
        <div class="q-gutter-md row items-center gt-sm">
          <q-btn flat label="Features" no-caps class="text-weight-medium" to="/#features" />
          <q-btn flat label="Security" no-caps class="text-weight-medium" to="/#security" />
          <q-btn flat label="Architecture" no-caps class="text-weight-medium" to="/documentation" />
          <q-btn
            flat
            label="Research Team"
            no-caps
            class="text-weight-medium"
            to="/team"
            icon-right="groups"
          />
        </div>

        <!-- Action Buttons -->
        <div class="row items-center no-wrap q-gutter-x-xs">
          <!-- Show when NOT logged in -->
          <template v-if="!isAuthenticated">
            <q-btn
              flat
              dense
              label="Login"
              no-caps
              class="text-weight-bold"
              to="/auth/login"
              size="sm"
            />
            <q-btn
              unelevated
              rounded
              dense
              color="white"
              text-color="primary"
              label="Join"
              no-caps
              class="q-px-sm text-weight-bold shadow-2 transition-transform"
              size="sm"
              to="/get-started"
            />
          </template>

          <!-- Show when logged in -->
          <template v-else>
            <q-btn
              flat
              dense
              no-caps
              class="text-weight-bold"
              to="/dashboard"
              icon="dashboard"
              size="sm"
            >
              <span class="gt-xs q-ml-xs">Dashboard</span>
            </q-btn>
            <q-btn
              unelevated
              rounded
              dense
              color="red-5"
              text-color="white"
              label="Logout"
              no-caps
              class="q-px-sm text-weight-bold shadow-2"
              @click="handleLogout"
              icon="logout"
              size="sm"
            />
          </template>
        </div>
      </q-toolbar>
    </q-header>

    <q-drawer
      v-model="leftDrawerOpen"
      side="left"
      overlay
      behavior="mobile"
      class="bg-dark text-white"
      :width="250"
    >
      <q-scroll-area class="fit">
        <div class="q-pa-md">
          <div class="text-h6 q-mb-md">Navigation</div>
          <q-list padding>
            <q-item clickable v-ripple to="/#features" @click="leftDrawerOpen = false">
              <q-item-section avatar><q-icon name="star" /></q-item-section>
              <q-item-section>Features</q-item-section>
            </q-item>
            <q-item clickable v-ripple to="/#security" @click="leftDrawerOpen = false">
              <q-item-section avatar><q-icon name="security" /></q-item-section>
              <q-item-section>Security</q-item-section>
            </q-item>
            <q-item clickable v-ripple to="/documentation" @click="leftDrawerOpen = false">
              <q-item-section avatar><q-icon name="article" /></q-item-section>
              <q-item-section>Architecture</q-item-section>
            </q-item>
            <q-item clickable v-ripple to="/team" @click="leftDrawerOpen = false">
              <q-item-section avatar><q-icon name="groups" /></q-item-section>
              <q-item-section>Research Team</q-item-section>
            </q-item>

            <q-separator dark class="q-my-md" />

            <template v-if="!isAuthenticated">
              <q-item clickable v-ripple to="/auth/login" @click="leftDrawerOpen = false">
                <q-item-section avatar><q-icon name="login" /></q-item-section>
                <q-item-section>Login</q-item-section>
              </q-item>
              <q-item clickable v-ripple to="/get-started" @click="leftDrawerOpen = false">
                <q-item-section avatar><q-icon name="person_add" /></q-item-section>
                <q-item-section>Get Started</q-item-section>
              </q-item>
            </template>
            <template v-else>
              <q-item clickable v-ripple to="/dashboard" @click="leftDrawerOpen = false">
                <q-item-section avatar><q-icon name="dashboard" /></q-item-section>
                <q-item-section>Dashboard</q-item-section>
              </q-item>
              <q-item clickable v-ripple @click="onLogoutClick">
                <q-item-section avatar><q-icon name="logout" /></q-item-section>
                <q-item-section>Logout</q-item-section>
              </q-item>
            </template>
          </q-list>
        </div>
      </q-scroll-area>
    </q-drawer>

    <q-page-container class="no-padding">
      <router-view />
    </q-page-container>
  </q-layout>
</template>

<script>
import { defineComponent, ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useQuasar } from 'quasar'
import { supabase } from 'boot/supabase'

export default defineComponent({
  name: 'MainLayout',
  setup() {
    const router = useRouter()
    const $q = useQuasar()
    const isAuthenticated = ref(false)
    const leftDrawerOpen = ref(false)

    const checkAuth = async () => {
      const {
        data: { user },
      } = await supabase.auth.getUser()
      isAuthenticated.value = !!user
    }

    const handleLogout = async () => {
      try {
        const { error } = await supabase.auth.signOut()
        if (error) throw error

        $q.notify({
          color: 'green-4',
          textColor: 'white',
          icon: 'check_circle',
          message: 'Logged out successfully',
        })

        isAuthenticated.value = false
        router.push('/')
      } catch (err) {
        console.error('Logout error:', err)
        $q.notify({
          color: 'red-5',
          textColor: 'white',
          icon: 'error',
          message: 'Logout failed',
        })
      }
    }

    onMounted(() => {
      checkAuth()

      // Listen for auth state changes
      supabase.auth.onAuthStateChange((event, session) => {
        isAuthenticated.value = !!session
      })
    })

    const onLogoutClick = async () => {
      await handleLogout()
      leftDrawerOpen.value = false
    }

    return {
      isAuthenticated,
      handleLogout,
      onLogoutClick,
      leftDrawerOpen,
    }
  },
})
</script>

<style scoped>
/* Ensure content doesn't jump */
.container {
  max-width: 1280px;
  margin: 0 auto;
  width: 100%;
  padding: 0 16px; /* Default side padding for nav */
}

/* Optional: Add a subtle backdrop filter if user scrolls (requires JS usually, but for fixed header minimal style) */
.q-header {
  background: linear-gradient(to bottom, rgba(0, 0, 0, 0.8) 0%, rgba(0, 0, 0, 0) 100%);
}

.font-heading {
  letter-spacing: 0.5px;
}

.transition-transform:hover {
  transform: translateY(-1px);
}
</style>

<template>
  <q-layout view="lHh Lpr lFf" class="bg-dark text-white">
    <!-- Added reveal-offset="0" so it hides immediately when scrolling starts -->
    <q-header
      reveal
      :reveal-offset="0"
      class="bg-transparent text-white q-py-md md:q-py-xl transition-bg"
      height-hint="98"
    >
      <q-toolbar class="container">
        <q-btn flat no-caps no-wrap dense class="q-mr-sm">
          <!-- Logo Icon -->
          <div class="bg-white text-primary q-pa-xs rounded-borders q-mr-sm">
            <q-icon name="account_balance_wallet" size="24px" />
          </div>
          <q-toolbar-title
            shrink
            class="text-weight-bold text-h6 font-heading cursor-pointer"
            @click="$router.push('/')"
          >
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

        <q-space class="gt-sm" />

        <!-- Action Buttons -->
        <div class="q-gutter-sm row items-center">
          <!-- Show when NOT logged in -->
          <template v-if="!isAuthenticated">
            <q-btn flat label="Login" no-caps class="text-weight-bold" to="/auth/login" size="sm" />
            <q-btn
              unelevated
              rounded
              color="white"
              text-color="primary"
              label="Get Started"
              no-caps
              class="q-px-md text-weight-bold shadow-2 transition-transform"
              size="sm"
              to="/get-started"
            />
          </template>

          <!-- Show when logged in -->
          <template v-else>
            <q-btn
              flat
              label="Dashboard"
              no-caps
              class="text-weight-bold"
              to="/dashboard"
              icon="dashboard"
              size="sm"
            />
            <q-btn
              unelevated
              rounded
              color="red-5"
              text-color="white"
              label="Logout"
              no-caps
              class="q-px-md text-weight-bold shadow-2"
              @click="handleLogout"
              icon="logout"
              size="sm"
            />
          </template>
        </div>
      </q-toolbar>
    </q-header>

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

    return {
      isAuthenticated,
      handleLogout,
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

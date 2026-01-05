<template>
  <q-layout view="lHh LpR lFf" class="bg-dark text-white">
    <q-header
      bordered
      class="bg-dark text-white"
      style="border-bottom: 1px solid rgba(255, 255, 255, 0.1)"
    >
      <q-toolbar>
        <q-btn dense flat round icon="menu" @click="toggleLeftDrawer" />

        <q-btn flat no-caps no-wrap dense to="/" class="q-mr-sm">
          <q-toolbar-title shrink class="text-weight-bold">
            <q-icon name="account_balance_wallet" class="q-mr-sm text-primary" />
            My Wallet
          </q-toolbar-title>
        </q-btn>

        <!-- Notifications -->
        <q-btn flat round dense icon="notifications" class="q-mr-sm">
          <q-badge floating color="red" rounded label="2" />
          <q-menu dark style="min-width: 300px">
            <q-list>
              <q-item-label header>Notifications</q-item-label>
              <q-item v-close-popup clickable>
                <q-item-section>Welcome to CBDC Wallet</q-item-section>
              </q-item>
              <q-item v-close-popup clickable>
                <q-item-section>Identity Verified</q-item-section>
              </q-item>
            </q-list>
          </q-menu>
        </q-btn>

        <!-- Profile Dropdown -->
        <q-btn flat round dense icon="account_circle">
          <q-menu dark auto-close>
            <q-list style="min-width: 150px">
              <q-item clickable>
                <q-item-section>Profile</q-item-section>
              </q-item>
              <q-separator dark />
              <q-item clickable class="text-red-4" @click="handleSignOut">
                <q-item-section>Sign Out</q-item-section>
              </q-item>
            </q-list>
          </q-menu>
        </q-btn>
      </q-toolbar>
    </q-header>

    <q-drawer
      show-if-above
      v-model="leftDrawerOpen"
      side="left"
      bordered
      content-class="bg-darker text-white"
      :width="240"
    >
      <div class="q-pa-md text-center">
        <div class="text-subtitle2 text-grey-5 q-mb-xs">Account ID</div>
        <div
          class="text-caption font-mono bg-surface q-pa-sm rounded-borders text-blue-2"
          style="border: 1px solid rgba(255, 255, 255, 0.1)"
        >
          {{ user?.id ? user.id.slice(0, 8) + '...' : 'Loading...' }}
        </div>
      </div>

      <q-list padding class="text-grey-1">
        <q-item
          clickable
          v-ripple
          active-class="text-primary bg-primary-soft"
          to="/dashboard"
          exact
        >
          <q-item-section avatar>
            <q-icon name="dashboard" />
          </q-item-section>
          <q-item-section> Overview </q-item-section>
        </q-item>

        <q-item
          clickable
          v-ripple
          active-class="text-primary bg-primary-soft"
          to="/dashboard/transactions"
        >
          <q-item-section avatar>
            <q-icon name="sync_alt" />
          </q-item-section>
          <q-item-section> Transactions </q-item-section>
        </q-item>

        <q-item
          clickable
          v-ripple
          active-class="text-primary bg-primary-soft"
          to="/dashboard/cards"
        >
          <q-item-section avatar>
            <q-icon name="credit_card" />
          </q-item-section>
          <q-item-section> Cards & Accounts </q-item-section>
        </q-item>

        <q-item
          clickable
          v-ripple
          active-class="text-primary bg-primary-soft"
          to="/dashboard/loans"
        >
          <q-item-section avatar>
            <q-icon name="payments" />
          </q-item-section>
          <q-item-section> Loans & Credit </q-item-section>
        </q-item>

        <q-item
          clickable
          v-ripple
          active-class="text-primary bg-primary-soft"
          to="/dashboard/services"
        >
          <q-item-section avatar>
            <q-icon name="hub" />
          </q-item-section>
          <q-item-section> Services </q-item-section>
        </q-item>

        <q-item
          clickable
          v-ripple
          active-class="text-primary bg-primary-soft"
          to="/dashboard/settings"
        >
          <q-item-section avatar>
            <q-icon name="settings" />
          </q-item-section>
          <q-item-section> Settings </q-item-section>
        </q-item>

        <q-separator dark spaced />

        <q-item clickable v-ripple class="text-red-4" @click="handleSignOut">
          <q-item-section avatar>
            <q-icon name="logout" />
          </q-item-section>
          <q-item-section> Sign Out </q-item-section>
        </q-item>
      </q-list>
    </q-drawer>

    <!-- Mobile Bottom Navigation -->
    <q-footer
      bordered
      class="bg-dark text-white lt-md"
      style="border-top: 1px solid rgba(255, 255, 255, 0.1)"
    >
      <q-tabs
        no-caps
        active-color="primary"
        indicator-color="transparent"
        class="text-grey-5"
        v-model="tab"
      >
        <q-route-tab to="/dashboard" name="dashboard" icon="dashboard" label="Home" exact />
        <q-route-tab
          to="/dashboard/transactions"
          name="transactions"
          icon="sync_alt"
          label="Activity"
        />
        <q-route-tab to="/dashboard/cards" name="cards" icon="credit_card" label="Cards" />
        <q-route-tab to="/dashboard/loans" name="loans" icon="payments" label="Loans" />
        <q-route-tab to="/dashboard/services" name="services" icon="hub" label="Services" />
      </q-tabs>
    </q-footer>

    <q-page-container>
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
  name: 'DashboardLayout',
  setup() {
    const leftDrawerOpen = ref(false)
    const tab = ref('dashboard')
    const router = useRouter()
    const $q = useQuasar()
    const user = ref(null)

    onMounted(async () => {
      const { data } = await supabase.auth.getUser()
      user.value = data.user
    })

    const handleSignOut = async () => {
      try {
        const { error } = await supabase.auth.signOut()
        if (error) throw error

        $q.notify({
          color: 'green-4',
          textColor: 'white',
          icon: 'check_circle',
          message: 'Signed out successfully',
        })

        router.push('/auth/login')
      } catch (err) {
        console.error('Sign out error:', err)
        $q.notify({
          color: 'red-5',
          textColor: 'white',
          icon: 'error',
          message: 'Sign out failed',
        })
      }
    }

    return {
      leftDrawerOpen,
      tab,
      user,
      handleSignOut,
      toggleLeftDrawer() {
        leftDrawerOpen.value = !leftDrawerOpen.value
      },
    }
  },
})
</script>

<style scoped>
.bg-darker {
  background: #0a0a0b;
  border-right: 1px solid rgba(255, 255, 255, 0.1);
}
.bg-primary-soft {
  background: rgba(0, 210, 255, 0.15);
}
.bg-surface {
  background: rgba(255, 255, 255, 0.08);
}
:deep(.q-drawer .q-list .q-item) {
  color: #777777 !important; /* Darker grey for inactive text */
}
:deep(.q-drawer .q-list .q-item.q-router-link--exact-active) {
  color: #008ebf !important; /* Darker blue for active text */
}
:deep(.q-drawer .q-list .q-item--active) {
  color: #008ebf !important;
}
</style>

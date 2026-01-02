<template>
  <q-layout view="lHh LpR lFf" class="bg-dark text-white">
    <q-header bordered class="bg-dark text-white" style="border-bottom: 1px solid rgba(255,255,255,0.1)">
      <q-toolbar>
        <q-btn dense flat round icon="menu" @click="toggleLeftDrawer" />

        <q-toolbar-title class="text-weight-bold">
          <q-icon name="admin_panel_settings" class="q-mr-sm text-red-5" />
          Admin Panel
        </q-toolbar-title>

        <!-- System Status Indicators -->
        <div class="row q-gutter-sm items-center q-mr-md">
          <q-chip dense color="green-9" text-color="white" icon="people">
            {{ stats.total_users || 0 }} Users
          </q-chip>
          <q-chip dense color="blue-9" text-color="white" icon="account_balance">
            ${{ (stats.total_supply || 0).toFixed(2) }}
          </q-chip>
        </div>

        <q-btn flat round dense icon="logout" @click="handleLogout">
          <q-tooltip>Logout</q-tooltip>
        </q-btn>
      </q-toolbar>
    </q-header>

    <q-drawer show-if-above v-model="leftDrawerOpen" side="left" bordered content-class="bg-darker text-white" :width="240">
      <div class="q-pa-md text-center">
         <q-avatar size="64px" color="red-9" text-color="white" icon="admin_panel_settings" />
         <div class="text-subtitle1 q-mt-sm text-weight-bold">{{ adminName || 'Admin' }}</div>
         <div class="text-caption text-grey-5">System Administrator</div>
      </div>
      
      <q-list padding class="text-grey-4">
        <q-item clickable v-ripple active-class="text-red-5 bg-red-soft" to="/admin" exact>
          <q-item-section avatar>
            <q-icon name="dashboard" />
          </q-item-section>
          <q-item-section>
            Dashboard
          </q-item-section>
        </q-item>

        <q-item clickable v-ripple active-class="text-red-5 bg-red-soft" to="/admin/users">
          <q-item-section avatar>
            <q-icon name="people" />
          </q-item-section>
          <q-item-section>
            User Management
          </q-item-section>
        </q-item>

        <q-item clickable v-ripple active-class="text-red-5 bg-red-soft" to="/admin/transactions">
          <q-item-section avatar>
            <q-icon name="receipt_long" />
          </q-item-section>
          <q-item-section>
            Transactions
          </q-item-section>
        </q-item>

        <q-item clickable v-ripple active-class="text-red-5 bg-red-soft" to="/admin/monetary">
          <q-item-section avatar>
            <q:icon name="account_balance_wallet" />
          </q-item-section>
          <q-item-section>
            Monetary Control
          </q-item-section>
        </q-item>

        <q-separator dark spaced />

        <q-item clickable v-ripple class="text-red-4" @click="handleLogout">
          <q-item-section avatar>
            <q-icon name="logout" />
          </q-item-section>
          <q-item-section>
            Logout
          </q-item-section>
        </q-item>
      </q-list>
    </q-drawer>

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
  name: 'AdminLayout',
  setup () {
    const router = useRouter()
    const $q = useQuasar()
    const leftDrawerOpen = ref(false)
    const adminName = ref(null)
    const stats = ref({
      total_users: 0,
      total_supply: 0
    })

    const fetchAdminData = async () => {
      try {
        const { data: { user } } = await supabase.auth.getUser()
        if (!user) return

        // Get admin profile
        const { data: profile } = await supabase
          .from('profiles')
          .select('first_name, last_name')
          .eq('id', user.id)
          .single()

        if (profile) {
          adminName.value = `${profile.first_name || ''} ${profile.last_name || ''}`.trim() || user.email
        }

        // Fetch system stats
        const { data: systemStats } = await supabase
          .from('system_stats')
          .select('*')
          .single()

        if (systemStats) {
          stats.value = systemStats
        }
      } catch (err) {
        console.error('Error fetching admin data:', err)
      }
    }

    const handleLogout = async () => {
      try {
        const { error } = await supabase.auth.signOut()
        if (error) throw error
        
        $q.notify({
          color: 'green-4',
          textColor: 'white',
          icon: 'check_circle',
          message: 'Logged out successfully'
        })
        
        router.push('/')
      } catch (err) {
        console.error('Logout error:', err)
        $q.notify({
          color: 'red-5',
          textColor: 'white',
          icon: 'error',
          message: 'Logout failed'
        })
      }
    }

    onMounted(() => {
      fetchAdminData()
      
      // Refresh stats every 30 seconds
      setInterval(fetchAdminData, 30000)
    })

    return {
      leftDrawerOpen,
      adminName,
      stats,
      handleLogout,
      toggleLeftDrawer () {
        leftDrawerOpen.value = !leftDrawerOpen.value
      }
    }
  }
})
</script>

<style scoped>
.bg-darker {
    background: #050505;
    border-right: 1px solid rgba(255,255,255,0.1);
}
.bg-red-soft {
    background: rgba(244, 67, 54, 0.1);
}
</style>

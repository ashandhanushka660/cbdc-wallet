<template>
  <q-page class="q-pa-md">
    <!-- Stats Cards -->
    <div class="row q-col-gutter-md q-mb-lg">
      <div class="col-12 col-md-3">
        <q-card dark class="bg-gradient-blue">
          <q-card-section>
            <div class="row items-center">
              <q-icon name="people" size="48px" class="col-auto" />
              <div class="col q-pl-md">
                <div class="text-h4 text-weight-bold">{{ stats.total_users || 0 }}</div>
                <div class="text-subtitle2">Total Users</div>
              </div>
            </div>
          </q-card-section>
        </q-card>
      </div>

      <div class="col-12 col-md-3">
        <q-card dark class="bg-gradient-green">
          <q-card-section>
            <div class="row items-center">
              <q-icon name="account_balance_wallet" size="48px" class="col-auto" />
              <div class="col q-pl-md">
                <div class="text-h4 text-weight-bold">${{ (stats.total_supply || 0).toFixed(2) }}</div>
                <div class="text-subtitle2">Total Supply</div>
              </div>
            </div>
          </q-card-section>
        </q-card>
      </div>

      <div class="col-12 col-md-3">
        <q-card dark class="bg-gradient-purple">
          <q-card-section>
            <div class="row items-center">
              <q-icon name="swap_horiz" size="48px" class="col-auto" />
              <div class="col q-pl-md">
                <div class="text-h4 text-weight-bold">{{ stats.transactions_24h || 0 }}</div>
                <div class="text-subtitle2">Transactions (24h)</div>
              </div>
            </div>
          </q-card-section>
        </q-card>
      </div>

      <div class="col-12 col-md-3">
        <q-card dark class="bg-gradient-orange">
          <q-card-section>
            <div class="row items-center">
              <q-icon name="account_balance" size="48px" class="col-auto" />
              <div class="col q-pl-md">
                <div class="text-h4 text-weight-bold">{{ stats.total_accounts || 0 }}</div>
                <div class="text-subtitle2">Active Accounts</div>
              </div>
            </div>
          </q-card-section>
        </q-card>
      </div>
    </div>

    <!-- Charts Row -->
    <div class="row q-col-gutter-md">
      <div class="col-12 col-md-8">
        <q-card dark class="bg-surface">
          <q-card-section>
            <div class="text-h6">Transaction Volume</div>
            <div class="text-caption text-grey-5">Last 7 days</div>
          </q-card-section>
          <q-card-section class="q-pt-none">
            <div class="text-center q-pa-xl">
              <q-icon name="show_chart" size="64px" color="grey-7" />
              <div class="text-grey-5 q-mt-md">Chart visualization would go here</div>
              <div class="text-caption text-grey-6">Integrate with Chart.js or similar</div>
            </div>
          </q-card-section>
        </q-card>
      </div>

      <div class="col-12 col-md-4">
        <q-card dark class="bg-surface">
          <q-card-section>
            <div class="text-h6">Quick Actions</div>
          </q-card-section>
          <q-card-section class="q-pt-none">
            <q-list dark>
              <q-item clickable v-ripple to="/admin/users">
                <q-item-section avatar>
                  <q-icon name="people" color="blue-5" />
                </q-item-section>
                <q-item-section>
                  <q-item-label>Manage Users</q-item-label>
                  <q-item-label caption>View and control user accounts</q-item-label>
                </q-item-section>
              </q-item>

              <q-item clickable v-ripple to="/admin/monetary">
                <q-item-section avatar>
                  <q-icon name="account_balance_wallet" color="green-5" />
                </q-item-section>
                <q-item-section>
                  <q-item-label>Monetary Control</q-item-label>
                  <q-item-label caption>Mint or burn CBDC</q-item-label>
                </q-item-section>
              </q-item>

              <q-item clickable v-ripple to="/admin/transactions">
                <q-item-section avatar>
                  <q-icon name="receipt_long" color="purple-5" />
                </q-item-section>
                <q-item-section>
                  <q-item-label>View Transactions</q-item-label>
                  <q-item-label caption>Monitor all system transactions</q-item-label>
                </q-item-section>
              </q-item>
            </q-list>
          </q-card-section>
        </q-card>
      </div>
    </div>

    <!-- Recent Activity -->
    <div class="row q-col-gutter-md q-mt-md">
      <div class="col-12">
        <q-card dark class="bg-surface">
          <q-card-section>
            <div class="text-h6">Recent Transactions</div>
          </q-card-section>
          <q-card-section class="q-pt-none">
            <q-list dark separator v-if="recentTransactions.length > 0">
              <q-item v-for="tx in recentTransactions" :key="tx.id">
                <q-item-section avatar>
                  <q-avatar :color="tx.sender_id ? 'blue-9' : 'green-9'" text-color="white" :icon="tx.sender_id ? 'arrow_upward' : 'add'" />
                </q-item-section>
                <q-item-section>
                  <q-item-label>{{ tx.sender_id ? 'Transfer' : 'Mint' }}</q-item-label>
                  <q-item-label caption>{{ formatDate(tx.created_at) }}</q-item-label>
                </q-item-section>
                <q-item-section side>
                  <div class="text-weight-bold">${{ tx.amount.toFixed(2) }}</div>
                </q-item-section>
              </q-item>
            </q-list>
            <div v-else class="text-center text-grey-5 q-pa-md">
              No recent transactions
            </div>
          </q-card-section>
        </q-card>
      </div>
    </div>
  </q-page>
</template>

<script>
import { defineComponent, ref, onMounted } from 'vue'
import { supabase } from 'boot/supabase'

export default defineComponent({
  name: 'AdminDashboardPage',
  setup () {
    const stats = ref({
      total_users: 0,
      total_accounts: 0,
      total_supply: 0,
      transactions_24h: 0,
      transactions_7d: 0,
      transactions_30d: 0
    })
    const recentTransactions = ref([])

    const formatDate = (dateString) => {
      const date = new Date(dateString)
      const now = new Date()
      const diffMs = now - date
      const diffMins = Math.floor(diffMs / 60000)
      const diffHours = Math.floor(diffMs / 3600000)

      if (diffMins < 60) return `${diffMins}m ago`
      if (diffHours < 24) return `${diffHours}h ago`
      return date.toLocaleDateString()
    }

    const fetchStats = async () => {
      try {
        const { data, error } = await supabase
          .from('system_stats')
          .select('*')
          .single()

        if (error) throw error
        if (data) stats.value = data
      } catch (err) {
        console.error('Error fetching stats:', err)
      }
    }

    const fetchRecentTransactions = async () => {
      try {
        const { data, error } = await supabase
          .from('transactions')
          .select('*')
          .order('created_at', { ascending: false })
          .limit(5)

        if (error) throw error
        if (data) recentTransactions.value = data
      } catch (err) {
        console.error('Error fetching transactions:', err)
      }
    }

    onMounted(() => {
      fetchStats()
      fetchRecentTransactions()

      // Refresh every 30 seconds
      setInterval(() => {
        fetchStats()
        fetchRecentTransactions()
      }, 30000)
    })

    return {
      stats,
      recentTransactions,
      formatDate
    }
  }
})
</script>

<style scoped>
.bg-surface {
  background: #111;
}
.bg-gradient-blue {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}
.bg-gradient-green {
  background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
}
.bg-gradient-purple {
  background: linear-gradient(135deg, #8e2de2 0%, #4a00e0 100%);
}
.bg-gradient-orange {
  background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
}
</style>

<template>
  <q-page class="q-pa-md">
    <div class="text-h5 text-white q-mb-md">Transaction History</div>

    <q-card dark bordered class="bg-surface">
      <q-list separator v-if="transactions.length > 0">
        <q-item v-for="tx in transactions" :key="tx.id" class="q-py-md">
          <q-item-section avatar>
            <q-avatar
              :color="tx.type === 'sent' ? 'red-9' : 'green-9'"
              text-color="white"
              :icon="tx.type === 'sent' ? 'arrow_upward' : 'arrow_downward'"
            />
          </q-item-section>
          <q-item-section>
            <q-item-label>{{
              tx.type === 'sent' ? 'Payment Sent' : 'Payment Received'
            }}</q-item-label>
            <q-item-label caption class="text-grey-5">
              {{ tx.type === 'sent' ? 'To: ' : 'From: ' }}{{ tx.otherParty }}
            </q-item-label>
          </q-item-section>
          <q-item-section side>
            <div
              :class="tx.type === 'sent' ? 'text-red-4' : 'text-green-4'"
              class="text-weight-bold"
            >
              {{ tx.type === 'sent' ? '-' : '+' }}${{ tx.amount.toFixed(2) }}
            </div>
            <div class="text-grey-6 text-caption">{{ formatDate(tx.created_at) }}</div>
          </q-item-section>
        </q-item>
      </q-list>

      <q-card-section v-else class="text-center text-grey-5">
        <q-icon name="receipt_long" size="64px" class="q-mb-md" />
        <div>No transactions yet</div>
      </q-card-section>
    </q-card>
  </q-page>
</template>

<script>
import { defineComponent, ref, onMounted } from 'vue'
import { supabase } from 'boot/supabase'

export default defineComponent({
  name: 'TransactionsPage',
  setup() {
    const transactions = ref([])

    const formatDate = (dateString) => {
      const date = new Date(dateString)
      const now = new Date()
      const diffMs = now - date
      const diffMins = Math.floor(diffMs / 60000)
      const diffHours = Math.floor(diffMs / 3600000)
      const diffDays = Math.floor(diffMs / 86400000)

      if (diffMins < 60) return `${diffMins}m ago`
      if (diffHours < 24) return `${diffHours}h ago`
      if (diffDays < 7) return `${diffDays}d ago`
      return date.toLocaleDateString()
    }

    const fetchTransactions = async () => {
      try {
        // Get current user's account
        const {
          data: { user },
        } = await supabase.auth.getUser()
        if (!user) return

        const { data: account } = await supabase
          .from('accounts')
          .select('id')
          .eq('user_id', user.id)
          .single()

        if (!account) return

        // Fetch transactions
        const { data, error } = await supabase
          .from('transactions')
          .select('*')
          .or(`sender_id.eq.${account.id},receiver_id.eq.${account.id}`)
          .order('created_at', { ascending: false })
          .limit(50)

        if (error) throw error

        // Format transactions
        transactions.value = data.map((tx) => ({
          ...tx,
          type: tx.sender_id === account.id ? 'sent' : 'received',
          otherParty:
            tx.sender_id === account.id
              ? tx.receiver_id.slice(0, 8) + '...'
              : tx.sender_id.slice(0, 8) + '...',
        }))
      } catch (err) {
        console.error('Error fetching transactions:', err)
      }
    }

    onMounted(() => {
      fetchTransactions()
    })

    return {
      transactions,
      formatDate,
    }
  },
})
</script>

<style scoped>
.bg-surface {
  background: #111;
}
</style>

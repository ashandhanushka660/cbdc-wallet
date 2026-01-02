<template>
  <q-page class="q-pa-md">
    <!-- Balance Card -->
    <div class="row q-col-gutter-md q-mb-lg">
      <div class="col-12 col-md-8">
        <q-card
          class="bg-primary-gradient text-white q-pa-lg full-height shadow-10"
          style="border-radius: 20px"
        >
          <div class="text-subtitle1 text-blue-1">
            Welcome back, {{ user?.user_metadata?.first_name || 'User' }}
          </div>
          <div class="text-h2 text-weight-bold q-my-sm">${{ balance }}</div>
          <div class="text-subtitle2 text-blue-1">+ $0.00 (Last 30 days)</div>

          <div class="row q-col-gutter-md q-mt-md">
            <div class="col-12 col-sm-auto">
              <q-btn
                color="white"
                text-color="primary"
                label="Send"
                icon="arrow_upward"
                rounded
                unelevated
                class="full-width q-px-xl q-py-sm"
                @click="showSendDialog = true"
              />
            </div>
            <div class="col-12 col-sm-auto">
              <q-btn
                color="white"
                text-color="primary"
                label="Receive"
                icon="arrow_downward"
                rounded
                outline
                class="full-width q-px-xl q-py-sm bg-white-soft"
                @click="showReceiveDialog = true"
              />
            </div>
            <div class="col-12 col-sm-auto">
              <q-btn
                color="yellow-9"
                text-color="black"
                label="Faucet"
                icon="water_drop"
                rounded
                unelevated
                class="full-width q-px-xl q-py-sm shadow-glow-sm"
                @click="handleFaucet"
              />
            </div>
          </div>
        </q-card>
      </div>

      <!-- Quick Stats -->
      <div class="col-12 col-md-4">
        <q-card dark bordered class="bg-transparent full-height q-pa-md flex flex-center column">
          <q-circular-progress
            show-value
            font-size="20px"
            class="q-ma-md"
            :value="75"
            size="120px"
            :thickness="0.2"
            color="teal"
            track-color="grey-9"
          >
            75% Safe
          </q-circular-progress>
          <div class="text-grey-4">Monthly Spending Limit</div>
        </q-card>
      </div>
    </div>

    <!-- Recent Transactions -->
    <div class="text-h6 text-white q-mb-md">Recent Activity</div>
    <q-list dark separator class="bg-surface rounded-borders" v-if="transactions.length > 0">
      <q-item v-for="tx in transactions" :key="tx.id" class="q-py-md">
        <q-item-section avatar>
          <q-avatar
            :color="tx.sender_id === accountId ? 'red-9' : 'green-9'"
            text-color="white"
            :icon="tx.sender_id === accountId ? 'arrow_upward' : 'arrow_downward'"
          />
        </q-item-section>
        <q-item-section>
          <q-item-label>{{
            tx.sender_id === accountId ? 'Payment Sent' : 'Payment Received'
          }}</q-item-label>
          <q-item-label caption class="text-grey-5">{{
            new Date(tx.created_at).toLocaleString()
          }}</q-item-label>
        </q-item-section>
        <q-item-section side>
          <div
            :class="tx.sender_id === accountId ? 'text-white' : 'text-green-4'"
            class="text-weight-bold"
          >
            {{ tx.sender_id === accountId ? '-' : '+' }}${{ tx.amount }}
          </div>
        </q-item-section>
      </q-item>
    </q-list>
    <div v-else class="bg-surface rounded-borders q-pa-xl text-center text-grey-6">
      <q-icon name="history" size="48px" class="q-mb-md" />
      <div>No recent activity found</div>
    </div>

    <!-- Send Money Dialog -->
    <q-dialog v-model="showSendDialog">
      <q-card dark class="bg-surface" style="min-width: 400px">
        <q-card-section>
          <div class="text-h6">Send Money</div>
        </q-card-section>

        <q-card-section class="q-pt-none">
          <q-form @submit="handleSendMoney" class="q-gutter-md">
            <q-input
              dark
              filled
              v-model="sendForm.receiverAccountId"
              label="Receiver Account ID"
              hint="Enter the recipient's account ID"
              lazy-rules
              :rules="[(val) => (val && val.length > 0) || 'Please enter account ID']"
            >
              <template v-slot:prepend>
                <q-icon name="account_circle" />
              </template>
            </q-input>

            <q-input
              dark
              filled
              v-model.number="sendForm.amount"
              type="number"
              label="Amount"
              prefix="$"
              step="0.01"
              lazy-rules
              :rules="[
                (val) => val > 0 || 'Amount must be greater than 0',
                (val) => val <= balance || 'Insufficient balance',
              ]"
            >
              <template v-slot:prepend>
                <q-icon name="payments" />
              </template>
            </q-input>

            <q-input
              dark
              filled
              v-model="sendForm.note"
              label="Note (Optional)"
              type="textarea"
              rows="2"
            />

            <div class="row justify-end q-gutter-sm">
              <q-btn flat label="Cancel" color="grey" v-close-popup />
              <q-btn
                unelevated
                label="Send"
                type="submit"
                color="primary"
                icon-right="send"
                :loading="sendLoading"
              />
            </div>
          </q-form>
        </q-card-section>
      </q-card>
    </q-dialog>

    <!-- Receive Money Dialog -->
    <q-dialog v-model="showReceiveDialog">
      <q-card dark class="bg-surface" style="min-width: 400px">
        <q-card-section>
          <div class="text-h6">Receive Money</div>
        </q-card-section>

        <q-card-section class="q-pt-none">
          <div class="text-center q-mb-md">
            <div class="text-subtitle2 text-grey-5 q-mb-sm">Your Account ID</div>
            <div
              class="text-caption font-mono bg-grey-9 q-pa-md rounded-borders text-blue-2"
              style="border: 1px solid rgba(255, 255, 255, 0.2); word-break: break-all"
            >
              {{ accountId || 'Loading...' }}
            </div>
          </div>

          <q-separator dark class="q-my-md" />

          <div class="text-caption text-grey-5 text-center">
            Share this Account ID with others to receive payments
          </div>

          <div class="row justify-center q-mt-md">
            <q-btn
              outline
              color="primary"
              label="Copy ID"
              icon="content_copy"
              @click="copyAccountId"
            />
          </div>
        </q-card-section>

        <q-card-actions align="right">
          <q-btn flat label="Close" color="grey" v-close-popup />
        </q-card-actions>
      </q-card>
    </q-dialog>
  </q-page>
</template>

<script>
import { defineComponent, ref, onMounted } from 'vue'
import { useQuasar } from 'quasar'
import { supabase } from 'boot/supabase'

export default defineComponent({
  name: 'DashboardPage',
  setup() {
    const $q = useQuasar()
    const balance = ref(0.0)
    const transactions = ref([])
    const user = ref(null)
    const accountId = ref(null)
    const showSendDialog = ref(false)
    const showReceiveDialog = ref(false)
    const sendLoading = ref(false)
    const sendForm = ref({
      receiverAccountId: '',
      amount: 0,
      note: '',
    })

    const fetchBalance = async () => {
      const {
        data: { user: currentUser },
      } = await supabase.auth.getUser()
      user.value = currentUser

      if (!currentUser) return

      // Fetch Profile for Name
      const { data: profile } = await supabase
        .from('profiles')
        .select('first_name')
        .eq('id', currentUser.id)
        .single()

      if (profile) user.value.user_metadata.first_name = profile.first_name

      const { data, error } = await supabase
        .from('accounts')
        .select('id, balance')
        .eq('user_id', currentUser.id)
        .single()

      if (error) console.error(error)
      if (data) {
        balance.value = data.balance
        accountId.value = data.id
      }
    }

    const fetchTransactions = async () => {
      // Conceptual: Join with accounts/profiles to get names, but for now simple select
      // In a real app we'd need a view or join
      const { data, error } = await supabase
        .from('transactions')
        .select('*')
        .order('created_at', { ascending: false })
        .limit(5)

      if (error) console.error(error)
      if (data) transactions.value = data
    }

    const handleSendMoney = async () => {
      sendLoading.value = true
      try {
        const { data, error } = await supabase.rpc('transfer_funds', {
          receiver_account_id: sendForm.value.receiverAccountId,
          transfer_amount: sendForm.value.amount,
        })

        if (error) throw error

        if (data.success) {
          $q.notify({
            color: 'green-4',
            textColor: 'white',
            icon: 'check_circle',
            message: data.message || 'Transfer completed successfully!',
          })

          // Reset form and close dialog
          sendForm.value = { receiverAccountId: '', amount: 0, note: '' }
          showSendDialog.value = false

          // Refresh balance and transactions
          fetchBalance()
          fetchTransactions()
        } else {
          throw new Error(data.error || 'Transfer failed')
        }
      } catch (err) {
        console.error('Transfer error:', err)
        $q.notify({
          color: 'red-5',
          textColor: 'white',
          icon: 'error',
          message: err.message || 'Transfer failed',
        })
      } finally {
        sendLoading.value = false
      }
    }

    const copyAccountId = () => {
      if (accountId.value) {
        navigator.clipboard.writeText(accountId.value)
        $q.notify({
          color: 'green-4',
          textColor: 'white',
          icon: 'check_circle',
          message: 'Account ID copied to clipboard!',
        })
      }
    }

    const handleFaucet = async () => {
      try {
        const { error } = await supabase.rpc('mint_funds', {
          target_account_id: accountId.value,
          mint_amount: 1000,
          reason: 'Prototype Faucet',
        })
        if (error) throw error
        $q.notify({
          color: 'yellow-9',
          textColor: 'black',
          message: '$1,000 Minted Successfully (Prototype Mode)',
        })
        fetchBalance()
      } catch (err) {
        console.error('Faucet error:', err)
        $q.notify({ color: 'red-5', message: 'Faucet failed' })
      }
    }

    onMounted(() => {
      fetchBalance()
      fetchTransactions()

      // Realtime Subscription for Balance
      supabase
        .channel('public:accounts')
        .on('postgres_changes', { event: 'UPDATE', schema: 'public', table: 'accounts' }, () => {
          // Verify it's our account
          // Ideally we check payload.new.user_id === user.id
          fetchBalance()
        })
        .subscribe()
    })

    return {
      balance,
      transactions,
      user,
      accountId,
      showSendDialog,
      showReceiveDialog,
      sendForm,
      sendLoading,
      handleSendMoney,
      copyAccountId,
      handleFaucet,
    }
  },
})
</script>

<style scoped>
.bg-primary-gradient {
  background: linear-gradient(135deg, #0061ff 0%, #60efff 100%);
}
.bg-white-soft {
  background: rgba(255, 255, 255, 0.2);
}
.bg-surface {
  background: #111;
}
</style>

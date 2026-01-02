<template>
  <q-page class="q-pa-md">
    <div class="text-h5 text-white q-mb-md">Monetary Control</div>

    <!-- Current Supply Card -->
    <q-card dark class="bg-gradient-green q-mb-md">
      <q-card-section>
        <div class="row items-center">
          <q-icon name="account_balance" size="64px" class="col-auto" />
          <div class="col q-pl-md">
            <div class="text-subtitle2">Total Money Supply</div>
            <div class="text-h3 text-weight-bold">${{ totalSupply.toFixed(2) }}</div>
          </div>
        </div>
      </q-card-section>
    </q-card>

    <div class="row q-col-gutter-md">
      <!-- Mint Funds Card -->
      <div class="col-12 col-md-6">
        <q-card dark class="bg-surface">
          <q-card-section>
            <div class="text-h6 text-green-4">
              <q-icon name="add_circle" class="q-mr-sm" />
              Mint New Funds
            </div>
            <div class="text-caption text-grey-5">Add new CBDC to the system</div>
          </q-card-section>

          <q-card-section class="q-pt-none">
            <q-form @submit="handleMint" class="q-gutter-md">
              <q-input
                dark
                filled
                v-model="mintForm.accountId"
                label="Target Account ID"
                hint="Account to receive minted funds"
                lazy-rules
                :rules="[val => val && val.length > 0 || 'Please enter account ID']"
              >
                <template v-slot:prepend>
                  <q-icon name="account_circle" />
                </template>
              </q-input>

              <q-input
                dark
                filled
                v-model.number="mintForm.amount"
                type="number"
                label="Amount"
                prefix="$"
                step="0.01"
                lazy-rules
                :rules="[val => val > 0 || 'Amount must be greater than 0']"
              >
                <template v-slot:prepend>
                  <q-icon name="payments" />
                </template>
              </q-input>

              <q-input
                dark
                filled
                v-model="mintForm.reason"
                label="Reason"
                type="textarea"
                rows="2"
                hint="Explain why funds are being minted"
              />

              <q-btn
                unelevated
                type="submit"
                color="green"
                label="Mint Funds"
                icon-right="add_circle"
                class="full-width"
                :loading="mintLoading"
              />
            </q-form>
          </q-card-section>
        </q-card>
      </div>

      <!-- Burn Funds Card -->
      <div class="col-12 col-md-6">
        <q-card dark class="bg-surface">
          <q-card-section>
            <div class="text-h6 text-red-4">
              <q-icon name="remove_circle" class="q-mr-sm" />
              Burn Funds
            </div>
            <div class="text-caption text-grey-5">Remove CBDC from the system</div>
          </q-card-section>

          <q-card-section class="q-pt-none">
            <q-form @submit="handleBurn" class="q-gutter-md">
              <q-input
                dark
                filled
                v-model="burnForm.accountId"
                label="Target Account ID"
                hint="Account to burn funds from"
                lazy-rules
                :rules="[val => val && val.length > 0 || 'Please enter account ID']"
              >
                <template v-slot:prepend>
                  <q-icon name="account_circle" />
                </template>
              </q-input>

              <q-input
                dark
                filled
                v-model.number="burnForm.amount"
                type="number"
                label="Amount"
                prefix="$"
                step="0.01"
                lazy-rules
                :rules="[val => val > 0 || 'Amount must be greater than 0']"
              >
                <template v-slot:prepend>
                  <q-icon name="payments" />
                </template>
              </q-input>

              <q-input
                dark
                filled
                v-model="burnForm.reason"
                label="Reason"
                type="textarea"
                rows="2"
                hint="Explain why funds are being burned"
              />

              <q-btn
                unelevated
                type="submit"
                color="red"
                label="Burn Funds"
                icon-right="remove_circle"
                class="full-width"
                :loading="burnLoading"
              />
            </q-form>
          </q-card-section>
        </q-card>
      </div>
    </div>

    <!-- Recent Operations -->
    <q-card dark class="bg-surface q-mt-md">
      <q-card-section>
        <div class="text-h6">Recent Monetary Operations</div>
      </q-card-section>
      <q-card-section class="q-pt-none">
        <q-list dark separator v-if="recentOps.length > 0">
          <q-item v-for="op in recentOps" :key="op.id">
            <q-item-section avatar>
              <q-avatar :color="op.sender_id ? 'red-9' : 'green-9'" text-color="white" :icon="op.sender_id ? 'remove' : 'add'" />
            </q-item-section>
            <q-item-section>
              <q-item-label>{{ op.sender_id ? 'Burn' : 'Mint' }}</q-item-label>
              <q-item-label caption>{{ op.metadata?.reason || 'No reason provided' }}</q-item-label>
            </q-item-section>
            <q-item-section side>
              <div class="text-weight-bold">${{ op.amount.toFixed(2) }}</div>
              <div class="text-caption text-grey-5">{{ formatDate(op.created_at) }}</div>
            </q-item-section>
          </q-item>
        </q-list>
        <div v-else class="text-center text-grey-5 q-pa-md">
          No recent operations
        </div>
      </q-card-section>
    </q-card>
  </q-page>
</template>

<script>
import { defineComponent, ref, onMounted } from 'vue'
import { useQuasar } from 'quasar'
import { supabase } from 'boot/supabase'

export default defineComponent({
  name: 'MonetaryPage',
  setup () {
    const $q = useQuasar()
    const totalSupply = ref(0)
    const mintLoading = ref(false)
    const burnLoading = ref(false)
    const recentOps = ref([])

    const mintForm = ref({
      accountId: '',
      amount: 0,
      reason: ''
    })

    const burnForm = ref({
      accountId: '',
      amount: 0,
      reason: ''
    })

    const formatDate = (dateString) => {
      const date = new Date(dateString)
      return date.toLocaleString()
    }

    const fetchSupply = async () => {
      try {
        const { data, error } = await supabase
          .from('system_stats')
          .select('total_supply')
          .single()

        if (error) throw error
        if (data) totalSupply.value = data.total_supply || 0
      } catch (err) {
        console.error('Error fetching supply:', err)
      }
    }

    const fetchRecentOps = async () => {
      try {
        const { data, error } = await supabase
          .from('transactions')
          .select('*')
          .or('sender_id.is.null,receiver_id.is.null')
          .order('created_at', { ascending: false })
          .limit(5)

        if (error) throw error
        recentOps.value = data || []
      } catch (err) {
        console.error('Error fetching operations:', err)
      }
    }

    const handleMint = async () => {
      $q.dialog({
        title: 'Confirm Mint Operation',
        message: `You are about to mint $${mintForm.value.amount.toFixed(2)}. This will increase the total money supply. Continue?`,
        cancel: true,
        persistent: true,
        dark: true
      }).onOk(async () => {
        mintLoading.value = true
        try {
          const { data, error } = await supabase.rpc('mint_funds', {
            target_account_id: mintForm.value.accountId,
            mint_amount: mintForm.value.amount,
            reason: mintForm.value.reason || 'Admin minting'
          })

          if (error) throw error

          if (data.success) {
            $q.notify({
              color: 'green-4',
              textColor: 'white',
              icon: 'check_circle',
              message: data.message
            })

            mintForm.value = { accountId: '', amount: 0, reason: '' }
            fetchSupply()
            fetchRecentOps()
          } else {
            throw new Error(data.error)
          }
        } catch (err) {
          console.error('Mint error:', err)
          $q.notify({
            color: 'red-5',
            textColor: 'white',
            icon: 'error',
            message: err.message || 'Mint operation failed'
          })
        } finally {
          mintLoading.value = false
        }
      })
    }

    const handleBurn = async () => {
      $q.dialog({
        title: 'Confirm Burn Operation',
        message: `You are about to burn $${burnForm.value.amount.toFixed(2)}. This will decrease the total money supply. This action cannot be undone. Continue?`,
        cancel: true,
        persistent: true,
        dark: true
      }).onOk(async () => {
        burnLoading.value = true
        try {
          const { data, error } = await supabase.rpc('burn_funds', {
            target_account_id: burnForm.value.accountId,
            burn_amount: burnForm.value.amount,
            reason: burnForm.value.reason || 'Admin burning'
          })

          if (error) throw error

          if (data.success) {
            $q.notify({
              color: 'green-4',
              textColor: 'white',
              icon: 'check_circle',
              message: data.message
            })

            burnForm.value = { accountId: '', amount: 0, reason: '' }
            fetchSupply()
            fetchRecentOps()
          } else {
            throw new Error(data.error)
          }
        } catch (err) {
          console.error('Burn error:', err)
          $q.notify({
            color: 'red-5',
            textColor: 'white',
            icon: 'error',
            message: err.message || 'Burn operation failed'
          })
        } finally {
          burnLoading.value = false
        }
      })
    }

    onMounted(() => {
      fetchSupply()
      fetchRecentOps()
    })

    return {
      totalSupply,
      mintForm,
      burnForm,
      mintLoading,
      burnLoading,
      recentOps,
      handleMint,
      handleBurn,
      formatDate
    }
  }
})
</script>

<style scoped>
.bg-surface {
  background: #111;
}
.bg-gradient-green {
  background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
}
</style>

<template>
  <q-page class="q-pa-md">
    <div class="row q-col-gutter-lg">
      <!-- Credit Score AI Assessment -->
      <div class="col-12 col-md-4">
        <q-card dark class="bg-gradient-blue text-center q-pa-lg full-height">
          <div class="text-h6 q-mb-md">AI Credit Score</div>
          <q-circular-progress
            show-value
            font-size="24px"
            :value="creditScore"
            size="180px"
            :thickness="0.15"
            :color="scoreColor"
            track-color="grey-9"
            class="q-ma-md"
          >
            {{ creditScore }}
          </q-circular-progress>
          <div :class="`text-h5 text-weight-bold text-${scoreColor}`">{{ riskTier }} Risk</div>
          <div class="text-caption text-grey-4 q-mt-md">
            Last AI Assessment: {{ lastAssessment }}
          </div>

          <div class="q-mt-md q-pa-sm bg-black rounded-borders text-left">
            <div class="text-caption text-weight-bold q-mb-xs text-grey-4">
              AI Data Sources Verified:
            </div>
            <div class="row items-center q-gutter-x-sm">
              <q-icon name="check_circle" color="green-4" size="xs" />
              <span class="text-caption">Wallet Balance</span>
            </div>
            <div class="row items-center q-gutter-x-sm">
              <q-icon name="check_circle" color="green-4" size="xs" />
              <span class="text-caption">Mobile Bill Payments</span>
            </div>
            <div class="row items-center q-gutter-x-sm">
              <q-icon name="check_circle" color="green-4" size="xs" />
              <span class="text-caption">Social Reputation</span>
            </div>
          </div>

          <q-btn
            outline
            color="white"
            label="Refresh AI Score"
            class="q-mt-lg"
            @click="refreshScore"
            :loading="loading"
          />
        </q-card>
      </div>

      <!-- Active Loans -->
      <div class="col-12 col-md-8">
        <q-card dark class="bg-surface full-height">
          <q-card-section class="row items-center justify-between">
            <div class="text-h6">Microfinance Loans</div>
            <q-btn
              color="primary"
              label="Apply for Loan"
              icon="add"
              @click="showApplyDialog = true"
            />
          </q-card-section>

          <q-separator dark />

          <q-card-section>
            <q-list separator v-if="loans.length > 0">
              <q-item v-for="loan in loans" :key="loan.id" class="q-py-md">
                <q-item-section avatar>
                  <q-avatar color="primary" text-color="white" icon="account_balance" />
                </q-item-section>
                <q-item-section>
                  <q-item-label class="text-weight-bold"
                    >${{ loan.remaining_balance }} Remaining</q-item-label
                  >
                  <q-item-label caption class="text-grey-5">
                    Original: ${{ loan.principal_amount }} • {{ loan.interest_rate }}% APR
                  </q-item-label>
                </q-item-section>
                <q-item-section side>
                  <q-chip :color="getStatusColor(loan.status)" text-color="white" size="sm">
                    {{ loan.status.toUpperCase() }}
                  </q-chip>
                  <div class="text-caption text-grey-6">
                    Next: {{ formatDate(loan.next_payment_date) }}
                  </div>
                </q-item-section>
              </q-item>
            </q-list>
            <div v-else class="text-center text-grey-6 q-pa-xl">
              <q-icon name="info" size="48px" />
              <div class="q-mt-md">No active loans found. Check your eligibility score.</div>
            </div>
          </q-card-section>
        </q-card>
      </div>
    </div>

    <!-- Loan Application Dialog -->
    <q-dialog v-model="showApplyDialog">
      <q-card dark class="bg-surface" style="min-width: 400px">
        <q-card-section>
          <div class="text-h6">Apply for CBDC Micro-Loan</div>
          <div class="text-caption text-grey-5">Instant approval based on AI credit score</div>
        </q-card-section>

        <q-card-section class="q-pt-none">
          <q-form @submit="handleApply" class="q-gutter-md">
            <q-input
              dark
              filled
              v-model.number="loanRequest.amount"
              type="number"
              label="Requested Amount"
              prefix="$"
            />
            <q-select
              dark
              filled
              v-model="loanRequest.term"
              :options="[3, 6, 12, 24]"
              label="Term (Months)"
            />

            <div class="bg-grey-9 q-pa-md rounded-borders">
              <div class="row justify-between">
                <span>Monthly Repayment:</span>
                <span class="text-weight-bold text-primary">${{ calculatedRepayment }}</span>
              </div>
              <div class="row justify-between q-mt-xs">
                <span>Interest Rate (AI Adjusted):</span>
                <span class="text-weight-bold">{{ calculatedRate }}%</span>
              </div>
            </div>

            <div class="row justify-end q-gutter-sm">
              <q-btn flat label="Cancel" color="grey" v-close-popup />
              <q-btn
                unelevated
                color="primary"
                label="Submit Application"
                type="submit"
                :disable="creditScore < 600"
              />
            </div>
            <div v-if="creditScore < 600" class="text-caption text-negative text-center">
              Credit score too low for automatic approval.
            </div>
          </q-form>
        </q-card-section>
      </q-card>
    </q-dialog>
  </q-page>
</template>

<script>
import { defineComponent, ref, onMounted, computed } from 'vue'
import { supabase } from 'boot/supabase'
import { useQuasar } from 'quasar'

export default defineComponent({
  name: 'LoansPage',
  setup() {
    const $q = useQuasar()
    const loading = ref(false)
    const creditScore = ref(0)
    const riskTier = ref('Pending')
    const lastAssessment = ref('Never')
    const loans = ref([])
    const showApplyDialog = ref(false)
    const loanRequest = ref({ amount: 1000, term: 12 })

    const scoreColor = computed(() => {
      if (creditScore.value > 700) return 'positive'
      if (creditScore.value > 600) return 'warning'
      return 'negative'
    })

    const calculatedRate = computed(() => {
      // Risk-based pricing simulation
      if (creditScore.value > 750) return 4.5
      if (creditScore.value > 650) return 8.0
      return 12.5
    })

    const calculatedRepayment = computed(() => {
      const p = loanRequest.value.amount
      const r = calculatedRate.value / 100 / 12
      const n = loanRequest.value.term
      if (!p || !n) return 0
      const payment = (p * r * Math.pow(1 + r, n)) / (Math.pow(1 + r, n) - 1)
      return payment.toFixed(2)
    })

    const fetchData = async () => {
      const {
        data: { user },
      } = await supabase.auth.getUser()
      if (!user) return

      // Fetch Score
      const { data: scoreData } = await supabase
        .from('credit_scores')
        .select('*')
        .eq('user_id', user.id)
        .single()

      if (scoreData) {
        creditScore.value = scoreData.score
        riskTier.value = scoreData.risk_tier
        lastAssessment.value = new Date(scoreData.last_ai_assessment).toLocaleDateString()
      }

      // Fetch Loans
      const { data: loanData } = await supabase.from('loans').select('*').eq('user_id', user.id)

      if (loanData) loans.value = loanData
    }

    const refreshScore = async () => {
      loading.value = true
      const {
        data: { user },
      } = await supabase.auth.getUser()
      await supabase.rpc('calculate_user_credit_score', { target_user_id: user.id })
      await fetchData()
      loading.value = false
      $q.notify({ color: 'primary', message: 'AI Credit Profile Updated' })
    }

    onMounted(fetchData)

    return {
      creditScore,
      riskTier,
      lastAssessment,
      loans,
      loading,
      showApplyDialog,
      loanRequest,
      scoreColor,
      calculatedRate,
      calculatedRepayment,
      refreshScore,
      getStatusColor: (s) => (s === 'active' ? 'positive' : 'grey'),
      formatDate: (d) => (d ? new Date(d).toLocaleDateString() : 'N/A'),
      handleApply: async () => {
        try {
          const {
            data: { user },
          } = await supabase.auth.getUser()
          const { error } = await supabase.from('loans').insert({
            user_id: user.id,
            principal_amount: loanRequest.value.amount,
            interest_rate: calculatedRate.value,
            term_months: loanRequest.value.term,
            remaining_balance: loanRequest.value.amount,
            status: 'active', // Auto-approve for prototype
            monthly_repayment: parseFloat(calculatedRepayment.value),
            next_payment_date: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toISOString(),
          })

          if (error) throw error

          $q.notify({
            color: 'green-4',
            icon: 'check_circle',
            message: `Loan Approved! $${loanRequest.value.amount} added to your CBDC balance.`,
          })
          fetchData()
          showApplyDialog.value = false
        } catch (err) {
          console.error(err)
          $q.notify({ color: 'red-5', message: 'Loan application failed' })
        }
      },
    }
  },
})
</script>

<style scoped>
.bg-gradient-blue {
  background: linear-gradient(135deg, #1a2a6c 0%, #3a7bd5 100%);
}
.bg-surface {
  background: #111;
}
</style>

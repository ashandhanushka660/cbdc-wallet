<template>
  <q-page class="q-pa-md">
    <div class="text-h4 text-white q-mb-lg">Settings</div>

    <div class="row q-col-gutter-md">
      <!-- Connectivity Settings -->
      <div class="col-12 col-md-6">
        <q-card dark class="bg-surface">
          <q-card-section>
            <div class="text-h6 text-primary">Connectivity & Sync</div>
          </q-card-section>
          <q-list class="q-px-sm">
            <q-item tag="label" v-ripple>
              <q-item-section>
                <q-item-label>Offline Mode</q-item-label>
                <q-item-label caption class="text-grey-5">
                  Enable for areas with intermittent internet
                </q-item-label>
              </q-item-section>
              <q-item-section side>
                <q-toggle v-model="offlineMode" color="primary" />
              </q-item-section>
            </q-item>
          </q-list>

          <q-card-section v-if="offlineMode" class="text-center q-pa-md animate-fade">
            <div class="bg-white q-pa-sm inline-block rounded-borders">
              <q-icon name="qr_code_2" size="150px" color="black" />
            </div>
            <div class="text-subtitle1 q-mt-md text-weight-bold">Offline Transaction Token</div>
            <div class="text-caption text-grey-4">
              Transactions cached for local sync. Scan this to transfer offline.
            </div>
          </q-card-section>
        </q-card>
      </div>

      <!-- Privacy Settings -->
      <div class="col-12 col-md-6">
        <q-card dark class="bg-surface">
          <q-card-section>
            <div class="text-h6 text-green-4">Privacy & Data</div>
          </q-card-section>
          <q-list class="q-px-sm">
            <q-item tag="label" v-ripple>
              <q-item-section>
                <q-item-label>Share Data for Credit Scoring</q-item-label>
                <q-item-label caption class="text-grey-5"
                  >Allow AI analysis of spending patterns</q-item-label
                >
              </q-item-section>
              <q-item-section side>
                <q-toggle v-model="shareData" color="green-4" />
              </q-item-section>
            </q-item>

            <q-item tag="label" v-ripple>
              <q-item-section>
                <q-item-label>Private Transactions</q-item-label>
                <q-item-label caption class="text-grey-5"
                  >Hide transaction details from public ledger</q-item-label
                >
              </q-item-section>
              <q-item-section side>
                <q-toggle v-model="privateTransactions" color="green-4" />
              </q-item-section>
            </q-item>
          </q-list>
        </q-card>
      </div>
    </div>
  </q-page>
</template>

<script>
import { defineComponent, ref } from 'vue'

export default defineComponent({
  name: 'SettingsPage',
  setup() {
    const offlineMode = ref(false)
    const shareData = ref(true)
    const privateTransactions = ref(false)

    return {
      offlineMode,
      shareData,
      privateTransactions,
    }
  },
})
</script>

<style scoped>
.bg-surface {
  background: #1e1e1e;
}
.animate-fade {
  animation: fadeIn 0.5s ease-in-out;
}
@keyframes fadeIn {
  from {
    opacity: 0;
  }
  to {
    opacity: 1;
  }
}
</style>

<template>
  <q-page class="q-pa-xl flex flex-center column bg-dark text-white">
    <div style="max-width: 800px; width: 100%">
      <div class="text-h3 q-mb-lg text-weight-bold">
        <span class="text-primary">Open Banking</span> API
      </div>

      <p class="text-h6 text-grey-4 q-mb-xl">
        Build the future of finance with our secure, open-standard APIs. Integrate CBDC payments,
        identity verification, and AI credit scoring into your third-party applications.
      </p>

      <q-card dark class="bg-grey-9 q-mb-lg">
        <q-card-section>
          <div class="text-subtitle1 text-primary q-mb-sm">Your Sandbox API Key</div>
          <div class="bg-black q-pa-md rounded-borders row items-center justify-between">
            <code class="text-green-4 text-subtitle2">sk_test_51Mz...9Xp2</code>
            <q-btn flat icon="content_copy" size="sm" color="grey-5" @click="copyKey" />
          </div>
        </q-card-section>
      </q-card>

      <div class="text-h5 q-mb-md">Quick Start</div>
      <q-card dark class="bg-grey-9">
        <q-card-section>
          <pre
            class="bg-black text-grey-3 q-pa-md overflow-hidden rounded-borders"
            style="font-family: monospace"
          >
// Initiate a CBDC Transfer
const response = await fetch('https://api.rupeecbdc.lk/v1/transfers', {
  method: 'POST',
  headers: {
    'Authorization': 'Bearer sk_test_51Mz...',
    'Content-Type': 'application/json'
  },
  body: JSON.stringify({
    amount: 5000,
    currency: 'LKR',
    recipient: 'wallet_abc123'
  })
});

const data = await response.json();
console.log(data.transaction_hash);</pre
          >
        </q-card-section>
      </q-card>

      <div class="q-mt-xl row justify-between">
        <q-btn outline label="Read Full Documentation" icon="menu_book" color="primary" />
        <q-btn flat label="Back to Home" to="/" color="white" />
      </div>
    </div>
  </q-page>
</template>

<script>
import { defineComponent } from 'vue'
import { useQuasar } from 'quasar'

export default defineComponent({
  name: 'DeveloperPage',
  setup() {
    const $q = useQuasar()

    return {
      copyKey() {
        // In a real app we'd actually copy to clipboard
        $q.notify({
          message: 'API Key copied to clipboard',
          color: 'green-4',
          icon: 'check',
        })
      },
    }
  },
})
</script>

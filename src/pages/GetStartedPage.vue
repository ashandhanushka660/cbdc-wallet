<template>
  <q-page class="flex flex-center bg-dark text-white">
    <div style="max-width: 600px; width: 100%" class="q-pa-md">
      <q-carousel
        v-model="slide"
        transition-prev="scale"
        transition-next="scale"
        swipeable
        animated
        control-color="primary"
        navigation
        padding
        arrows
        height="400px"
        class="bg-transparent rounded-borders"
      >
        <q-carousel-slide name="welcome" class="column no-wrap flex-center text-center">
          <q-icon name="account_balance_wallet" size="80px" color="primary" />
          <div class="q-mt-md text-h5 text-weight-bold">Welcome to CBDC Wallet</div>
          <div class="q-mt-sm text-grey-4">
            The future of secure, digital currency is here. Let's get you set up.
          </div>
        </q-carousel-slide>

        <q-carousel-slide name="security" class="column no-wrap flex-center text-center">
          <q-icon name="security" size="80px" color="secondary" />
          <div class="q-mt-md text-h5 text-weight-bold">Bank-Grade Security</div>
          <div class="q-mt-sm text-grey-4">
            Your assets are protected by biometric verification and state-of-the-art encryption.
          </div>
        </q-carousel-slide>

        <q-carousel-slide name="start" class="column no-wrap flex-center text-center">
          <q-icon name="rocket_launch" size="80px" color="accent" />
          <div class="q-mt-md text-h5 text-weight-bold">Ready to Launch?</div>
          <div class="q-mt-lg">
             <q-btn color="primary" label="Create New Wallet" to="/auth/register" rounded size="lg" unelevated />
             <div class="q-mt-md">
                <q-btn flat color="white" label="I have an account" to="/auth/login" />
             </div>
          </div>
        </q-carousel-slide>
      </q-carousel>
    </div>
  </q-page>
</template>

<script>
import { defineComponent, ref } from 'vue'

export default defineComponent({
  name: 'GetStartedPage',
  setup () {
    return {
      slide: ref('welcome')
    }
  }
})
</script>

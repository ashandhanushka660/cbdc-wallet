<template>
  <q-page class="flex flex-center bg-dark text-white q-py-lg q-pb-xl">
    <q-card
      class="glass-card q-pa-lg q-mt-xl"
      style="width: 100%; max-width: 500px; margin-top: 150px"
    >
      <q-card-section class="text-center">
        <div class="text-h4 text-weight-bold q-mb-sm">Identity Verification</div>
        <div class="text-grey-4">Create your secure CBDC account</div>
      </q-card-section>

      <q-card-section>
        <q-form @submit="onSubmit" class="q-gutter-md">
          <!-- Step 1: Personal Info -->
          <div class="text-subtitle2 text-primary text-uppercase letter-spacing-1">
            1. Personal Information
          </div>

          <div class="row q-col-gutter-sm">
            <div class="col-6">
              <q-input
                dark
                filled
                v-model="firstName"
                class="input-box"
                input-class="q-pl-md"
                label="First Name"
              />
            </div>
            <div class="col-6">
              <q-input
                dark
                filled
                v-model="lastName"
                class="input-box"
                input-class="q-pl-md"
                label="Last Name"
              />
            </div>
          </div>

          <q-input
            dark
            filled
            v-model="nationalId"
            class="input-box"
            input-class="q-pl-md"
            label="National Identity Number (NID)"
          >
            <template v-slot:prepend>
              <q-icon name="fingerprint" class="text-accent" />
            </template>
          </q-input>

          <!-- Step 2: Credentials -->
          <div class="text-subtitle2 text-primary text-uppercase letter-spacing-1 q-mt-lg">
            2. Security Credentials
          </div>

          <q-input
            dark
            filled
            v-model="email"
            class="input-box"
            input-class="q-pl-md"
            type="email"
            label="Email Address"
          >
            <template v-slot:prepend>
              <q-icon name="email" />
            </template>
          </q-input>

          <q-input
            dark
            filled
            v-model="password"
            class="input-box"
            input-class="q-pl-md"
            type="password"
            label="Create Password"
          >
            <template v-slot:prepend>
              <q-icon name="lock" />
            </template>
          </q-input>

          <q-checkbox
            dark
            v-model="terms"
            label="I agree to the Terms of Sovereign Service"
            size="sm"
          />

          <div class="q-mt-lg q-mb-md">
            <q-btn
              label="Verify & Create Wallet"
              type="submit"
              color="secondary"
              class="full-width text-weight-bold q-py-sm"
              rounded
              unelevated
              icon-right="verified_user"
            />
          </div>
        </q-form>
      </q-card-section>

      <q-card-section class="text-center q-pt-none">
        <div class="text-grey-4 text-caption">
          Already verified?
          <router-link
            to="/auth/login"
            class="text-primary text-weight-bold"
            style="text-decoration: none"
            >Log In</router-link
          >
        </div>
      </q-card-section>
    </q-card>
  </q-page>
</template>

<script>
import { defineComponent, ref } from 'vue'
import { useRouter } from 'vue-router'
import { useQuasar } from 'quasar'
import { supabase } from 'boot/supabase'

export default defineComponent({
  name: 'RegisterPage',
  setup() {
    const router = useRouter()
    const $q = useQuasar()

    // Define refs in scope so they can be accessed by onSubmit
    const firstName = ref('')
    const lastName = ref('')
    const nationalId = ref('')
    const email = ref('')
    const password = ref('')
    const terms = ref(false)

    const onSubmit = async () => {
      try {
        // 1. Sign Up with Metadata
        // This saves the names/NID in the auth.users table immediately
        const { error } = await supabase.auth.signUp({
          email: email.value,
          password: password.value,
          options: {
            data: {
              first_name: firstName.value,
              last_name: lastName.value,
              national_id: nationalId.value,
            },
          },
        })

        if (error) throw error

        // 2. Instant Success Notification
        $q.notify({
          color: 'green-4',
          textColor: 'white',
          icon: 'check_circle',
          message: 'Wallet Identity Verified! You can now log in.',
          timeout: 5000,
        })

        router.push('/auth/login')
      } catch (err) {
        console.error('Registration failed', err)
        $q.notify({
          color: 'red-5',
          textColor: 'white',
          icon: 'error',
          message: 'Registration Error: ' + err.message,
        })
      }
    }

    return {
      firstName,
      lastName,
      nationalId,
      email,
      password,
      terms,
      onSubmit,
    }
  },
})
</script>

<style scoped>
.glass-card {
  background: rgba(255, 255, 255, 0.05);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 16px;
}
.letter-spacing-1 {
  letter-spacing: 1px;
}
</style>

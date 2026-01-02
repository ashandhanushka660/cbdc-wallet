<template>
  <q-page class="flex flex-center bg-dark text-white q-pb-xl">
    <q-card
      class="glass-card q-pa-lg q-mt-xl"
      style="width: 100%; max-width: 400px; margin-top: 150px"
    >
      <q-card-section class="text-center">
        <div class="text-h4 text-weight-bold q-mb-sm">Welcome Back</div>
        <div class="text-grey-4">Sign in to your sovereign wallet</div>
      </q-card-section>

      <q-card-section>
        <q-form @submit="onSubmit" class="q-gutter-md">
          <q-input
            dark
            filled
            v-model="email"
            class="input-box"
            input-class="q-pl-md"
            label="National ID / Email"
            lazy-rules
            :rules="[(val) => (val && val.length > 0) || 'Please enter your ID']"
          >
            <template v-slot:prepend>
              <q-icon name="badge" class="text-primary" />
            </template>
          </q-input>

          <q-input
            dark
            filled
            type="password"
            v-model="password"
            class="input-box"
            input-class="q-pl-md"
            label="Password"
            lazy-rules
            :rules="[(val) => (val && val.length > 0) || 'Please enter your password']"
          >
            <template v-slot:prepend>
              <q-icon name="lock" class="text-primary" />
            </template>
          </q-input>

          <div class="row justify-between items-center">
            <q-checkbox dark v-model="rememberMe" label="Remember me" size="sm" />
            <a
              href="#"
              class="text-primary text-caption text-weight-bold"
              style="text-decoration: none"
              >Forgot Password?</a
            >
          </div>

          <div class="q-mb-md">
            <q-btn
              label="Secure Login"
              type="submit"
              color="primary"
              class="full-width text-weight-bold q-py-sm"
              rounded
              unelevated
              icon-right="login"
            />
          </div>
        </q-form>
      </q-card-section>

      <q-card-section class="text-center q-pt-none">
        <div class="text-grey-4 text-caption">
          Don't have a wallet?
          <router-link
            to="/auth/register"
            class="text-secondary text-weight-bold"
            style="text-decoration: none"
            >Verify Identity</router-link
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
  name: 'LoginPage',
  setup() {
    const router = useRouter()
    const $q = useQuasar()
    const email = ref(null)
    const password = ref(null)
    const rememberMe = ref(false)

    return {
      email,
      password,
      rememberMe,

      async onSubmit() {
        try {
          const { error } = await supabase.auth.signInWithPassword({
            email: email.value,
            password: password.value,
          })

          if (error) throw error

          $q.notify({
            color: 'green-4',
            textColor: 'white',
            icon: 'check_circle',
            message: 'Login Successful! Welcome back.',
          })

          router.push('/dashboard')
        } catch (err) {
          console.error('Login failed', err)
          $q.notify({
            color: 'red-5',
            textColor: 'white',
            icon: 'error',
            message:
              'Login Failed: ' +
              (err.message.includes('Email not confirmed')
                ? 'Access Denied. Please verify identity.'
                : err.message),
          })
        }
      },
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
</style>

<template>
  <q-page class="q-pa-md">
    <div class="text-h5 text-white q-mb-md">Cards & Accounts</div>
    
    <div class="row q-col-gutter-md">
      <!-- Digital Card (Primary CBDC Account) -->
      <div class="col-12 col-md-6">
         <q-card class="bg-primary-gradient text-white q-pa-lg shadow-5" style="border-radius: 16px; height: 220px">
           <div class="row items-center justify-between">
              <div class="text-h6">CBDC Debit</div>
              <q-icon name="contactless" size="32px" />
           </div>
           
           <div class="q-mt-xl text-h5 font-mono">
             **** **** **** {{ accountId ? accountId.slice(-4) : '****' }}
           </div>
           
           <div class="row items-center justify-between q-mt-lg">
             <div class="text-subtitle2">Card Holder<br><span class="text-weight-bold">{{ userName || 'User' }}</span></div>
             <div class="text-subtitle2 text-right">Expires<br><span class="text-weight-bold">12/28</span></div>
           </div>
         </q-card>
      </div>

      <!-- Display Added Payment Methods -->
      <div v-for="(method, index) in paymentMethods" :key="index" class="col-12 col-md-6">
        <q-card class="bg-gradient-secondary text-white q-pa-lg shadow-5" style="border-radius: 16px; height: 220px; position: relative">
          <q-btn
            flat
            round
            dense
            icon="close"
            color="white"
            size="sm"
            class="absolute-top-right q-ma-sm"
            @click="removeMethod(index)"
          />
          
          <div class="row items-center justify-between">
            <div class="text-h6">{{ method.type }}</div>
            <q-icon :name="getMethodIcon(method.type)" size="32px" />
          </div>
          
          <div class="q-mt-xl text-h5 font-mono">
            {{ method.number }}
          </div>
          
          <div class="row items-center justify-between q-mt-lg">
            <div class="text-subtitle2">Holder<br><span class="text-weight-bold">{{ method.name }}</span></div>
            <div class="text-subtitle2 text-right">Added<br><span class="text-weight-bold">{{ formatDate(method.addedAt) }}</span></div>
          </div>
        </q-card>
      </div>
      
      <!-- Add New Method -->
      <div class="col-12 col-md-6">
        <q-card dark bordered class="bg-transparent flex flex-center cursor-pointer" style="border-radius: 16px; height: 220px; border-style: dashed" @click="showAddMethodDialog = true">
           <q-btn flat color="grey-5" icon="add" label="Add New Method" stacked />
        </q-card>
      </div>
    </div>

    <!-- Add Payment Method Dialog -->
    <q-dialog v-model="showAddMethodDialog">
      <q-card dark class="bg-surface" style="min-width: 400px">
        <q-card-section>
          <div class="text-h6">Add Payment Method</div>
        </q-card-section>

        <q-card-section class="q-pt-none">
          <q-form @submit="handleAddMethod" class="q-gutter-md">
            <q-select
              dark
              filled
              v-model="methodType"
              :options="['Bank Account', 'Credit Card', 'Debit Card']"
              label="Method Type"
            >
              <template v-slot:prepend>
                <q-icon name="payment" />
              </template>
            </q-select>

            <q-input
              dark
              filled
              v-model="methodDetails.name"
              label="Account/Card Holder Name"
              lazy-rules
              :rules="[val => val && val.length > 0 || 'Please enter name']"
            >
              <template v-slot:prepend>
                <q-icon name="person" />
              </template>
            </q-input>

            <q-input
              dark
              filled
              v-model="methodDetails.number"
              label="Account/Card Number"
              mask="#### #### #### ####"
              lazy-rules
              :rules="[val => val && val.length > 0 || 'Please enter number']"
            >
              <template v-slot:prepend>
                <q-icon name="credit_card" />
              </template>
            </q-input>

            <div class="row justify-end q-gutter-sm">
              <q-btn flat label="Cancel" color="grey" v-close-popup />
              <q-btn
                unelevated
                label="Add Method"
                type="submit"
                color="primary"
                icon-right="add"
              />
            </div>
          </q-form>
        </q-card-section>
      </q-card>
    </q-dialog>
  </q-page>
</template>

<script>
import { defineComponent, ref, onMounted } from 'vue'
import { useQuasar } from 'quasar'
import { supabase } from 'boot/supabase'

export default defineComponent({
  name: 'CardsPage',
  setup () {
    const $q = useQuasar()
    const showAddMethodDialog = ref(false)
    const methodType = ref('Bank Account')
    const methodDetails = ref({
      name: '',
      number: ''
    })
    const accountId = ref(null)
    const userName = ref(null)
    const paymentMethods = ref([])

    const getMethodIcon = (type) => {
      const icons = {
        'Bank Account': 'account_balance',
        'Credit Card': 'credit_card',
        'Debit Card': 'payment'
      }
      return icons[type] || 'payment'
    }

    const formatDate = (dateString) => {
      const date = new Date(dateString)
      return date.toLocaleDateString('en-US', { month: 'short', day: 'numeric' })
    }

    const loadPaymentMethods = () => {
      const stored = localStorage.getItem('paymentMethods')
      if (stored) {
        paymentMethods.value = JSON.parse(stored)
      }
    }

    const savePaymentMethods = () => {
      localStorage.setItem('paymentMethods', JSON.stringify(paymentMethods.value))
    }

    const handleAddMethod = () => {
      const newMethod = {
        type: methodType.value,
        name: methodDetails.value.name,
        number: methodDetails.value.number,
        addedAt: new Date().toISOString()
      }

      paymentMethods.value.push(newMethod)
      savePaymentMethods()

      $q.notify({
        color: 'green-4',
        textColor: 'white',
        icon: 'check_circle',
        message: 'Payment method added successfully!'
      })
      
      // Reset form
      methodDetails.value = { name: '', number: '' }
      methodType.value = 'Bank Account'
      showAddMethodDialog.value = false
    }

    const removeMethod = (index) => {
      $q.dialog({
        title: 'Remove Payment Method',
        message: 'Are you sure you want to remove this payment method?',
        cancel: true,
        persistent: true,
        dark: true
      }).onOk(() => {
        paymentMethods.value.splice(index, 1)
        savePaymentMethods()
        
        $q.notify({
          color: 'orange-5',
          textColor: 'white',
          icon: 'delete',
          message: 'Payment method removed'
        })
      })
    }

    const fetchUserData = async () => {
      try {
        const { data: { user } } = await supabase.auth.getUser()
        if (!user) return

        // Get profile
        const { data: profile } = await supabase
          .from('profiles')
          .select('first_name, last_name')
          .eq('id', user.id)
          .single()

        if (profile) {
          userName.value = `${profile.first_name || ''} ${profile.last_name || ''}`.trim()
        }

        // Get account ID
        const { data: account } = await supabase
          .from('accounts')
          .select('id')
          .eq('user_id', user.id)
          .single()

        if (account) {
          accountId.value = account.id
        }
      } catch (err) {
        console.error('Error fetching user data:', err)
      }
    }

    onMounted(() => {
      fetchUserData()
      loadPaymentMethods()
    })

    return {
      showAddMethodDialog,
      methodType,
      methodDetails,
      accountId,
      userName,
      paymentMethods,
      handleAddMethod,
      removeMethod,
      getMethodIcon,
      formatDate
    }
  }
})
</script>

<style scoped>
.bg-primary-gradient {
  background: linear-gradient(135deg, #0061ff 0%, #60efff 100%);
}
.bg-gradient-secondary {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}
.cursor-pointer {
  cursor: pointer;
}
</style>

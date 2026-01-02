<template>
  <q-page class="q-pa-md">
    <div class="text-h5 text-white q-mb-md">System Transactions</div>

    <!-- Filters -->
    <q-card dark class="bg-surface q-mb-md">
      <q-card-section>
        <div class="row q-col-gutter-md">
          <div class="col-12 col-md-6">
            <q-input
              dark
              filled
              v-model="searchQuery"
              label="Search"
              placeholder="Search by account ID..."
              @update:model-value="filterTransactions"
            >
              <template v-slot:prepend>
                <q-icon name="search" />
              </template>
            </q-input>
          </div>
          <div class="col-12 col-md-3">
            <q-select
              dark
              filled
              v-model="filterType"
              :options="['All', 'Transfer', 'Mint', 'Burn']"
              label="Type"
              @update:model-value="filterTransactions"
            />
          </div>
          <div class="col-12 col-md-3">
            <q-select
              dark
              filled
              v-model="filterStatus"
              :options="['All', 'completed', 'pending', 'failed']"
              label="Status"
              @update:model-value="filterTransactions"
            />
          </div>
        </div>
      </q-card-section>
    </q-card>

    <!-- Transactions Table -->
    <q-card dark class="bg-surface">
      <q-table
        dark
        flat
        :rows="filteredTransactions"
        :columns="columns"
        row-key="id"
        :loading="loading"
        :pagination="pagination"
      >
        <template v-slot:body-cell-type="props">
          <q-td :props="props">
            <q-badge :color="getTypeColor(props.row)">
              {{ getTransactionType(props.row) }}
            </q-badge>
          </q-td>
        </template>

        <template v-slot:body-cell-amount="props">
          <q-td :props="props">
            <div class="text-weight-bold">${{ props.row.amount?.toFixed(2) }}</div>
          </q-td>
        </template>

        <template v-slot:body-cell-status="props">
          <q-td :props="props">
            <q-badge :color="props.row.status === 'completed' ? 'green-9' : 'orange-9'">
              {{ props.row.status }}
            </q-badge>
          </q-td>
        </template>

        <template v-slot:body-cell-created_at="props">
          <q-td :props="props">
            {{ formatDate(props.row.created_at) }}
          </q-td>
        </template>
      </q-table>
    </q-card>
  </q-page>
</template>

<script>
import { defineComponent, ref, onMounted } from 'vue'
import { useQuasar } from 'quasar'
import { supabase } from 'boot/supabase'

export default defineComponent({
  name: 'TransactionsPage',
  setup () {
    const $q = useQuasar()
    const transactions = ref([])
    const filteredTransactions = ref([])
    const searchQuery = ref('')
    const filterType = ref('All')
    const filterStatus = ref('All')
    const loading = ref(false)
    const pagination = ref({
      rowsPerPage: 15
    })

    const columns = [
      { name: 'id', label: 'TX ID', field: 'id', align: 'left', format: val => val.slice(0, 8) + '...' },
      { name: 'type', label: 'Type', field: 'sender_id', align: 'center' },
      { name: 'sender_id', label: 'From', field: 'sender_id', align: 'left', format: val => val ? val.slice(0, 8) + '...' : 'System' },
      { name: 'receiver_id', label: 'To', field: 'receiver_id', align: 'left', format: val => val ? val.slice(0, 8) + '...' : 'System' },
      { name: 'amount', label: 'Amount', field: 'amount', align: 'right', sortable: true },
      { name: 'status', label: 'Status', field: 'status', align: 'center' },
      { name: 'created_at', label: 'Date', field: 'created_at', align: 'left', sortable: true }
    ]

    const getTransactionType = (tx) => {
      if (!tx.sender_id && tx.receiver_id) return 'Mint'
      if (tx.sender_id && !tx.receiver_id) return 'Burn'
      return 'Transfer'
    }

    const getTypeColor = (tx) => {
      const type = getTransactionType(tx)
      if (type === 'Mint') return 'green-9'
      if (type === 'Burn') return 'red-9'
      return 'blue-9'
    }

    const formatDate = (dateString) => {
      const date = new Date(dateString)
      return date.toLocaleString()
    }

    const fetchTransactions = async () => {
      loading.value = true
      try {
        const { data, error } = await supabase
          .from('transactions')
          .select('*')
          .order('created_at', { ascending: false })
          .limit(100)

        if (error) throw error
        transactions.value = data || []
        filteredTransactions.value = data || []
      } catch (err) {
        console.error('Error fetching transactions:', err)
        $q.notify({
          color: 'red-5',
          textColor: 'white',
          icon: 'error',
          message: 'Failed to load transactions'
        })
      } finally {
        loading.value = false
      }
    }

    const filterTransactions = () => {
      let filtered = transactions.value

      // Filter by search query
      if (searchQuery.value) {
        const query = searchQuery.value.toLowerCase()
        filtered = filtered.filter(tx =>
          tx.sender_id?.toLowerCase().includes(query) ||
          tx.receiver_id?.toLowerCase().includes(query) ||
          tx.id?.toLowerCase().includes(query)
        )
      }

      // Filter by type
      if (filterType.value !== 'All') {
        filtered = filtered.filter(tx => {
          const type = getTransactionType(tx)
          return type === filterType.value
        })
      }

      // Filter by status
      if (filterStatus.value !== 'All') {
        filtered = filtered.filter(tx => tx.status === filterStatus.value)
      }

      filteredTransactions.value = filtered
    }

    onMounted(() => {
      fetchTransactions()
    })

    return {
      transactions,
      filteredTransactions,
      searchQuery,
      filterType,
      filterStatus,
      loading,
      pagination,
      columns,
      getTransactionType,
      getTypeColor,
      formatDate,
      filterTransactions
    }
  }
})
</script>

<style scoped>
.bg-surface {
  background: #111;
}
</style>

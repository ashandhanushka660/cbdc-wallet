<template>
  <q-page class="q-pa-md">
    <div class="text-h5 text-white q-mb-md">User Management</div>

    <!-- Search and Filters -->
    <q-card dark class="bg-surface q-mb-md">
      <q-card-section>
        <q-input
          dark
          filled
          v-model="searchQuery"
          label="Search users"
          placeholder="Search by name or email..."
          @update:model-value="filterUsers"
        >
          <template v-slot:prepend>
            <q-icon name="search" />
          </template>
        </q-input>
      </q-card-section>
    </q-card>

    <!-- Users Table -->
    <q-card dark class="bg-surface">
      <q-table
        dark
        flat
        :rows="filteredUsers"
        :columns="columns"
        row-key="id"
        :loading="loading"
        :pagination="pagination"
      >
        <template v-slot:body-cell-name="props">
          <q-td :props="props">
            <div class="text-weight-bold">{{ props.row.first_name }} {{ props.row.last_name }}</div>
            <div class="text-caption text-grey-5">{{ props.row.email }}</div>
          </q-td>
        </template>

        <template v-slot:body-cell-balance="props">
          <q-td :props="props">
            <div class="text-weight-bold">${{ props.row.balance?.toFixed(2) || '0.00' }}</div>
          </q-td>
        </template>

        <template v-slot:body-cell-status="props">
          <q-td :props="props">
            <q-badge :color="props.row.is_frozen ? 'red-9' : 'green-9'">
              {{ props.row.is_frozen ? 'Frozen' : 'Active' }}
            </q-badge>
          </q-td>
        </template>

        <template v-slot:body-cell-actions="props">
          <q-td :props="props">
            <q-btn
              flat
              dense
              round
              :icon="props.row.is_frozen ? 'lock_open' : 'lock'"
              :color="props.row.is_frozen ? 'green' : 'red'"
              @click="toggleFreeze(props.row)"
            >
              <q-tooltip>{{ props.row.is_frozen ? 'Unfreeze' : 'Freeze' }} Account</q-tooltip>
            </q-btn>
            <q-btn
              flat
              dense
              round
              icon="visibility"
              color="blue"
              @click="viewUserDetails(props.row)"
            >
              <q-tooltip>View Details</q-tooltip>
            </q-btn>
          </q-td>
        </template>
      </q-table>
    </q-card>

    <!-- User Details Dialog -->
    <q-dialog v-model="showUserDialog">
      <q-card dark class="bg-surface" style="min-width: 500px">
        <q-card-section>
          <div class="text-h6">User Details</div>
        </q-card-section>

        <q-card-section v-if="selectedUser" class="q-pt-none">
          <q-list dark>
            <q-item>
              <q-item-section>
                <q-item-label overline>Name</q-item-label>
                <q-item-label>{{ selectedUser.first_name }} {{ selectedUser.last_name }}</q-item-label>
              </q-item-section>
            </q-item>

            <q-item>
              <q-item-section>
                <q-item-label overline>Email</q-item-label>
                <q-item-label>{{ selectedUser.email }}</q-item-label>
              </q-item-section>
            </q-item>

            <q-item>
              <q-item-section>
                <q-item-label overline>Account ID</q-item-label>
                <q-item-label class="font-mono text-caption">{{ selectedUser.account_id }}</q-item-label>
              </q-item-section>
            </q-item>

            <q-item>
              <q-item-section>
                <q-item-label overline>Balance</q-item-label>
                <q-item-label class="text-h6 text-green-4">${{ selectedUser.balance?.toFixed(2) || '0.00' }}</q-item-label>
              </q-item-section>
            </q-item>

            <q-item>
              <q-item-section>
                <q-item-label overline>Status</q-item-label>
                <q-badge :color="selectedUser.is_frozen ? 'red-9' : 'green-9'">
                  {{ selectedUser.is_frozen ? 'Frozen' : 'Active' }}
                </q-badge>
              </q-item-section>
            </q-item>
          </q-list>
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
  name: 'UsersPage',
  setup () {
    const $q = useQuasar()
    const users = ref([])
    const filteredUsers = ref([])
    const searchQuery = ref('')
    const loading = ref(false)
    const showUserDialog = ref(false)
    const selectedUser = ref(null)
    const pagination = ref({
      rowsPerPage: 10
    })

    const columns = [
      { name: 'name', label: 'User', field: 'first_name', align: 'left', sortable: true },
      { name: 'account_id', label: 'Account ID', field: 'account_id', align: 'left', format: val => val?.slice(0, 8) + '...' },
      { name: 'balance', label: 'Balance', field: 'balance', align: 'right', sortable: true },
      { name: 'status', label: 'Status', field: 'is_frozen', align: 'center' },
      { name: 'actions', label: 'Actions', align: 'center' }
    ]

    const fetchUsers = async () => {
      loading.value = true
      try {
        const { data, error } = await supabase
          .from('profiles')
          .select(`
            id,
            first_name,
            last_name,
            email,
            created_at
          `)

        if (error) throw error

        // Fetch account details for each user
        const usersWithAccounts = await Promise.all(
          data.map(async (user) => {
            const { data: account } = await supabase
              .from('accounts')
              .select('id, balance, is_frozen')
              .eq('user_id', user.id)
              .single()

            return {
              ...user,
              account_id: account?.id,
              balance: account?.balance,
              is_frozen: account?.is_frozen || false
            }
          })
        )

        users.value = usersWithAccounts
        filteredUsers.value = usersWithAccounts
      } catch (err) {
        console.error('Error fetching users:', err)
        $q.notify({
          color: 'red-5',
          textColor: 'white',
          icon: 'error',
          message: 'Failed to load users'
        })
      } finally {
        loading.value = false
      }
    }

    const filterUsers = () => {
      const query = searchQuery.value.toLowerCase()
      filteredUsers.value = users.value.filter(user =>
        user.first_name?.toLowerCase().includes(query) ||
        user.last_name?.toLowerCase().includes(query) ||
        user.email?.toLowerCase().includes(query)
      )
    }

    const toggleFreeze = async (user) => {
      const action = user.is_frozen ? 'unfreeze' : 'freeze'
      
      $q.dialog({
        title: `${action.charAt(0).toUpperCase() + action.slice(1)} Account`,
        message: `Are you sure you want to ${action} this account?`,
        cancel: true,
        persistent: true,
        dark: true
      }).onOk(async () => {
        try {
          const { data, error } = await supabase.rpc('toggle_account_freeze', {
            target_account_id: user.account_id,
            freeze_status: !user.is_frozen
          })

          if (error) throw error

          if (data.success) {
            $q.notify({
              color: 'green-4',
              textColor: 'white',
              icon: 'check_circle',
              message: data.message
            })
            fetchUsers()
          } else {
            throw new Error(data.error)
          }
        } catch (err) {
          console.error('Error toggling freeze:', err)
          $q.notify({
            color: 'red-5',
            textColor: 'white',
            icon: 'error',
            message: err.message || 'Operation failed'
          })
        }
      })
    }

    const viewUserDetails = (user) => {
      selectedUser.value = user
      showUserDialog.value = true
    }

    onMounted(() => {
      fetchUsers()
    })

    return {
      users,
      filteredUsers,
      searchQuery,
      loading,
      showUserDialog,
      selectedUser,
      pagination,
      columns,
      filterUsers,
      toggleFreeze,
      viewUserDetails
    }
  }
})
</script>

<style scoped>
.bg-surface {
  background: #111;
}
</style>

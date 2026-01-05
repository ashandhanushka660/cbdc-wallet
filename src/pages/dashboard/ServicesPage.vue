<template>
  <q-page class="q-pa-md">
    <div class="row q-col-gutter-md">
      <div class="col-12">
        <h1 class="text-h4 text-white q-mb-md">Blockchain Services</h1>
        <p class="text-grey-4">Explore blockchain applications beyond financial transactions.</p>
      </div>

      <!-- Supply Chain Tracking -->
      <div class="col-12 col-md-4">
        <q-card dark class="bg-surface full-height cursor-pointer hover-effect">
          <q-card-section class="text-center">
            <q-icon name="inventory_2" size="4rem" color="primary" class="q-mb-sm" />
            <div class="text-h6">Supply Chain Tracking</div>
          </q-card-section>
          <q-card-section class="q-pt-none text-center text-grey-4">
            Track goods from "farm to factory" with immutable records.
          </q-card-section>
          <q-card-actions align="center">
            <q-btn outline color="primary" label="Track Item" />
          </q-card-actions>
        </q-card>
      </div>

      <!-- Health Records -->
      <div class="col-12 col-md-4">
        <q-card dark class="bg-surface full-height cursor-pointer hover-effect">
          <q-card-section class="text-center">
            <q-icon name="medical_services" size="4rem" color="green-4" class="q-mb-sm" />
            <div class="text-h6">Health Records</div>
          </q-card-section>
          <q-card-section class="q-pt-none text-center text-grey-4">
            Access patient-centered records securely (e.g., Estonia e-Health).
          </q-card-section>
          <q-card-actions align="center">
            <q-btn outline color="green-4" label="Access Medical ID" />
          </q-card-actions>
        </q-card>
      </div>

      <!-- Land Registries -->
      <div class="col-12 col-md-4">
        <q-card dark class="bg-surface full-height cursor-pointer hover-effect">
          <q-card-section class="text-center">
            <q-icon name="home_work" size="4rem" color="orange-4" class="q-mb-sm" />
            <div class="text-h6">Land Registries</div>
          </q-card-section>
          <q-card-section class="q-pt-none text-center text-grey-4">
            View tamper-proof land titles and property history.
          </q-card-section>
          <q-card-actions align="center">
            <q-btn outline color="orange-4" label="View Land Title" />
          </q-card-actions>
        </q-card>
      </div>
    </div>
  </q-page>
</template>

<script>
import { defineComponent } from 'vue'

export default defineComponent({
  name: 'ServicesPage',
})
</script>

<style scoped>
.bg-surface {
  background: #1e1e1e;
  transition: transform 0.2s;
}
.hover-effect:hover {
  transform: translateY(-5px);
}
</style>

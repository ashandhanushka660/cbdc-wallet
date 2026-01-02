<template>
  <q-page class="q-pa-xl bg-dark text-white">
    <div class="container">
      <q-btn flat icon="arrow_back" label="Back to Home" to="/" color="grey-5" class="q-mb-lg" />
      
      <h1 class="text-h3 text-weight-bold q-mb-lg">System Architecture</h1>
      
      <div class="text-body1 text-grey-4 q-mb-xl" style="max-width: 800px">
        This document outlines the technical specifications of the CBDC Wallet, demonstrating its compliance with Two-Tier distribution models and ISO 20022 standards.
      </div>

      <div class="row q-col-gutter-xl">
        <div class="col-12 col-md-8">
           <q-card dark bordered class="bg-transparent q-mb-lg">
             <q-card-section>
               <div class="text-h5 text-primary q-mb-md">1. Two-Tier Distribution</div>
               <p>
                 The Central Bank issues digital currency to commercial banks (Tier 1), which then distribute it to retail users (Tier 2). 
                 This wallet serves as the Tier 2 interface.
               </p>
               <div class="bg-grey-9 q-pa-md rounded-borders font-mono text-grey-4">
                 Tier 1 (Central Bank) &lt;--&gt; Tier 2 (Commercial Bank) &lt;--&gt; User Wallet
               </div>
             </q-card-section>
           </q-card>

           <q-card dark bordered class="bg-transparent q-mb-lg">
             <q-card-section>
               <div class="text-h5 text-secondary q-mb-md">2. Offline Capability</div>
               <p>
                 Using Quasar's PWA mode and IndexedDB, transactions can be signed offline and queued. 
                 Upon reconnection, the <code class="text-red-3">syncManager</code> broadcasts signed packets to Supabase.
               </p>
             </q-card-section>
           </q-card>
        </div>
        
        <div class="col-12 col-md-4">
           <div class="text-subtitle1 text-weight-bold q-mb-md">Tech Stack</div>
           <q-list class="text-grey-4">
             <q-item>
               <q-item-section>Frontend</q-item-section>
               <q-item-section side class="text-white">Quasar (Vue 3)</q-item-section>
             </q-item>
             <q-item>
               <q-item-section>Database</q-item-section>
               <q-item-section side class="text-white">PostgreSQL (Supabase)</q-item-section>
             </q-item>
             <q-item>
               <q-item-section>Auth</q-item-section>
               <q-item-section side class="text-white">Supabase Auth (RLS)</q-item-section>
             </q-item>
           </q-list>
        </div>
      </div>
    </div>
  </q-page>
</template>

<script>
import { defineComponent } from 'vue'

export default defineComponent({
  name: 'DocumentationPage'
})
</script>

<style scoped>
.container { max-width: 1000px; margin: 0 auto; }
</style>

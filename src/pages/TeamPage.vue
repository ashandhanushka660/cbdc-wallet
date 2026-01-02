<template>
  <q-page class="bg-dark text-white q-pa-xl">
    <div class="container container-center">
      <!-- Section Header -->
      <div class="text-center q-mb-xl">
        <h2 class="text-h3 text-weight-bolder text-primary-gradient q-mb-sm">Research Team</h2>
        <div class="text-h6 text-grey-4 text-weight-light">
          The architects behind the sovereign digital economy and distributed ledgers
        </div>
        <div class="h-1 bg-primary-gradient w-24 mx-auto q-mt-md rounded"></div>
      </div>

      <!-- Team Grid -->
      <div class="row items-stretch justify-center q-col-gutter-xl">
        <div v-for="member in teamMembers" :key="member.id" class="col-12 col-sm-6 col-md-4">
          <q-card flat class="team-card glass-card full-height text-center q-pa-lg">
            <q-avatar size="160px" class="shadow-20 q-mb-lg border-primary">
              <img :src="member.image" :alt="member.name" style="object-fit: cover" />
            </q-avatar>

            <q-card-section class="q-pt-none">
              <div class="text-h5 text-weight-bold text-white q-mb-xs">{{ member.name }}</div>
              <div class="text-overline text-primary q-mb-md text-weight-bold letter-spacing-1">
                {{ member.role }}
              </div>
              <p class="text-body2 text-grey-4 leading-relaxed">
                {{ member.description }}
              </p>
            </q-card-section>

            <q-card-actions align="center" class="q-pb-md">
              <q-btn flat round color="primary" icon="link" />
              <q-btn flat round color="primary" icon="share" />
            </q-card-actions>
          </q-card>
        </div>
      </div>

      <!-- Footer Call to Action -->
      <div class="text-center q-mt-xxl">
        <q-btn
          outline
          color="white"
          label="Explore Publications"
          class="q-px-xl"
          rounded
          size="lg"
          icon-right="menu_book"
        />
      </div>
    </div>
  </q-page>
</template>

<script setup>
import { ref } from 'vue'

const teamMembers = ref([
  {
    id: 1,
    name: 'P.A Dhanushka',
    role: 'Researcher (CBDC)',
    image: 'images/team/ashan.png',
    description:
      'Leading critical research on Central Bank Digital Currencies (CBDCs) and digital currency pilots, focusing on national economic integration.',
  },
  {
    id: 2,
    name: 'D.M.N.D.Dissanayaka',
    role: 'Researcher (Blockchain Layers)',
    image: 'images/team/nimeshi.png',
    description:
      'Exploring Blockchain utilities beyond cryptocurrency, including supply chain integrity, secure health records, and land registries.',
  },
  {
    id: 3,
    name: 'A.S.C.K.Nissanka',
    role: 'Researcher (FinTech)',
    image: 'https://cdn.quasar.dev/img/avatar3.jpg',
    description:
      'Specializes in the evolution of FinTech and the Digital Economy, researching institutional transformation and sovereign financial tech.',
  },
  {
    id: 4,
    name: 'H.M Anurdha Kokila Hansa',
    role: 'Researcher (AI Microfinance)',
    image: 'https://cdn.quasar.dev/img/avatar4.jpg',
    description:
      'Developing AI-driven microfinance solutions and rural credit scoring models to bridge the gap in financial inclusion for rural communities.',
  },
  {
    id: 5,
    name: 'D.M.N.K.Disanayaka',
    role: 'Researcher (Open Banking)',
    image: 'https://cdn.quasar.dev/img/avatar5.jpg',
    description:
      'Researching and standardizing Open Banking APIs to enable seamless, secure, and new financial ecosystems for 3rd party integration.',
  },
])
</script>

<style scoped>
.container-center {
  max-width: 1200px;
  margin: 0 auto;
}

.team-card {
  transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1);
  border: 1px solid rgba(255, 255, 255, 0.08);
  background: rgba(255, 255, 255, 0.03) !important;
  border-radius: 20px;
}

.team-card:hover {
  transform: translateY(-8px);
  background: rgba(255, 255, 255, 0.06) !important;
  border-color: rgba(0, 210, 255, 0.4);
  box-shadow: 0 15px 30px -10px rgba(0, 210, 255, 0.25) !important;
}

.border-primary {
  border: 3px solid #3a7bd5;
  padding: 4px;
  background: #000;
}

.text-primary-gradient {
  background: linear-gradient(135deg, #00d2ff 0%, #3a7bd5 100%);
  -webkit-background-clip: text;
  background-clip: text;
  -webkit-text-fill-color: transparent;
}

.letter-spacing-1 {
  letter-spacing: 1px;
  text-transform: uppercase;
}

.leading-relaxed {
  line-height: 1.6;
}

.w-24 {
  width: 96px;
}
.h-1 {
  height: 4px;
}
.bg-primary-gradient {
  background: linear-gradient(135deg, #00d2ff 0%, #3a7bd5 100%);
}
</style>

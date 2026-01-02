<template>
  <q-page class="bg-dark text-white overflow-hidden">
    <!-- 1. Hero Section -->
    <!-- Added q-px-md specifically for mobile side padding redundancy -->
    <section class="min-h-screen flex flex-center relative-position q-px-md">
      <!-- Dynamic Background -->
      <div class="absolute-full gradient-bg"></div>
      <div class="absolute-full bg-noise opacity-05"></div>

      <div class="container text-center relative-position z-10 q-pb-xl">
        <!-- Spacing for Fixed Header -->
        <div style="height: 15vh" class="gt-xs"></div>
        <div style="height: 10vh" class="lt-sm"></div>

        <h1 class="text-h3 md:text-h1 text-weight-bolder leading-tight q-mb-lg hero-title">
          Bridging Central Banks <br class="gt-xs" />
          <span class="text-primary-gradient">to the Modern Economy</span>
        </h1>

        <div
          class="text-overline text-primary q-mb-sm text-weight-bolder letter-spacing-3 opacity-80"
        >
          THE INTERMEDIARY STANDARD
        </div>
        <p
          class="text-h5 text-grey-4 q-py-xl q-mx-auto max-w-700 leading-relaxed text-weight-light"
        >
          The sovereign digital wallet intermediary. Secure, offline-capable, and integrated
          directly with the two-tier CBDC architecture.
        </p>
        <div
          class="text-caption text-grey-6 q-mb-xl text-uppercase tracking-widest font-mono text-weight-medium"
        >
          <span class="q-mx-sm">Resilient</span> • <span class="q-mx-sm">Atomic</span> •
          <span class="q-mx-sm">Interoperable</span>
        </div>

        <div class="row q-gutter-md justify-center q-mb-xl">
          <q-btn
            size="lg"
            unelevated
            rounded
            class="bg-primary-gradient text-white q-px-xl text-weight-bold shadow-glow"
            label="Launch Wallet"
            no-caps
            icon="rocket_launch"
            to="/auth/register"
          />
          <q-btn
            size="lg"
            outline
            rounded
            color="white"
            label="Documentation"
            no-caps
            class="q-px-xl"
            icon-right="menu_book"
            to="/documentation"
          />
        </div>

        <!-- PWA/Device Preview -->
        <div class="row justify-center q-mt-xl">
          <div class="mockup-glass q-pa-lg">
            <div class="row items-center justify-center text-grey-5">
              <q-icon name="devices" size="48px" class="q-mr-md" />
              <div class="text-left">
                <div class="text-weight-bold text-white">Full PWA Support</div>
                <div class="text-caption">iOS • Android • Desktop</div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- 2. Core Functional Features -->
    <section class="q-py-xl bg-darker q-px-md">
      <div class="container">
        <div class="text-center q-mb-xl">
          <h2 class="text-h4 md:text-h3 text-weight-bold">Fintech-Grade Capabilities</h2>
          <div class="h-1 bg-primary-gradient w-24 mx-auto q-mt-md rounded"></div>
        </div>

        <div class="row q-col-gutter-lg">
          <div class="col-12 col-md-4">
            <q-card flat class="glass-card full-height q-pa-lg">
              <q-card-section>
                <div class="icon-box bg-accent-soft q-mb-md">
                  <q-icon name="wifi_off" size="32px" class="text-accent" />
                </div>
                <div class="text-h5 text-weight-bold q-mb-sm">Offline-First</div>
                <div class="text-grey-4 text-body1">
                  Transact without limits. Balance and history are cached locally, syncing
                  automatically when connectivity returns.
                </div>
              </q-card-section>
            </q-card>
          </div>
          <div class="col-12 col-md-4">
            <q-card flat class="glass-card full-height q-pa-lg">
              <q-card-section>
                <div class="icon-box bg-warning-soft q-mb-md">
                  <q-icon name="bolt" size="32px" class="text-warning" />
                </div>
                <div class="text-h5 text-weight-bold q-mb-sm">Real-Time Ledger</div>
                <div class="text-grey-4 text-body1">
                  Experience instant finality. Built on Supabase Realtime for sub-second transaction
                  updates to all devices.
                </div>
              </q-card-section>
            </q-card>
          </div>
          <div class="col-12 col-md-4">
            <q-card flat class="glass-card full-height q-pa-lg">
              <q-card-section>
                <div class="icon-box bg-success-soft q-mb-md">
                  <q-icon name="fingerprint" size="32px" class="text-green-4" />
                </div>
                <div class="text-h5 text-weight-bold q-mb-sm">Biometric Security</div>
                <div class="text-grey-4 text-body1">
                  Bank-grade protection. Integrates device biometrics and Supabase Auth for
                  multi-factor verification.
                </div>
              </q-card-section>
            </q-card>
          </div>
          <div class="col-12 col-md-12">
            <q-card flat class="glass-card q-pa-lg bg-primary-soft">
              <q-card-section class="row items-center">
                <div class="col-12 col-md-8">
                  <div class="text-h4 text-weight-bold q-mb-sm text-primary">AI Microfinance</div>
                  <div class="text-body1 text-grey-4">
                    Empowering rural economies with AI-driven credit scoring and instant CBDC
                    micro-loans. Bridging the gap in financial inclusion through decentralized
                    credibility assessment.
                  </div>
                </div>
                <div class="col-12 col-md-4 flex flex-center">
                  <q-icon name="psychology" size="100px" color="primary" class="opacity-20" />
                </div>
              </q-card-section>
            </q-card>
          </div>
        </div>
      </div>
    </section>

    <!-- 3. Technical Deep-Dive -->
    <section class="q-py-xl relative-position q-px-md">
      <div class="absolute-full bg-grid-pattern opacity-10"></div>
      <div class="container relative-position z-10">
        <div class="row items-center q-col-gutter-xxl">
          <div class="col-12 col-md-6 q-mb-xl md:q-mb-0">
            <div class="text-overline text-primary q-mb-sm">UNDER THE HOOD</div>
            <h2 class="text-h3 text-weight-bold q-mb-md">Engineered for Trust</h2>
            <p class="text-body1 text-grey-4 q-mb-lg leading-relaxed">
              We move beyond simple transfers. Our architecture ensures atomic consistency and
              sovereign data isolation.
            </p>

            <q-list class="text-lg q-gutter-y-md">
              <q-item class="glass-item rounded-borders">
                <q-item-section avatar>
                  <q-icon name="account_balance" color="primary" />
                </q-item-section>
                <q-item-section>
                  <q-item-label class="text-weight-bold">Account-Based Model</q-item-label>
                  <q-item-label caption class="text-grey-5"
                    >Simplifies KYC & AML compliance chains.</q-item-label
                  >
                </q-item-section>
              </q-item>

              <q-item class="glass-item rounded-borders">
                <q-item-section avatar>
                  <q-icon name="storage" color="secondary" />
                </q-item-section>
                <q-item-section>
                  <q-item-label class="text-weight-bold">Atomic ACID Transactions</q-item-label>
                  <q-item-label caption class="text-grey-5"
                    >Zero "phantom" money via Postgres procedures.</q-item-label
                  >
                </q-item-section>
              </q-item>

              <q-item class="glass-item rounded-borders">
                <q-item-section avatar>
                  <q-icon name="lock" color="accent" />
                </q-item-section>
                <q-item-section>
                  <q-item-label class="text-weight-bold">Row-Level Security (RLS)</q-item-label>
                  <q-item-label caption class="text-grey-5"
                    >Database-level data isolation.</q-item-label
                  >
                </q-item-section>
              </q-item>
            </q-list>
          </div>

          <div class="col-12 col-md-6">
            <div class="code-window bg-black rounded-borders shadow-20 overflow-hidden">
              <div class="row bg-grey-9 q-px-md q-py-sm items-center">
                <div class="row q-gutter-xs">
                  <div class="w-3 h-3 rounded-full bg-red-5"></div>
                  <div class="w-3 h-3 rounded-full bg-yellow-5"></div>
                  <div class="w-3 h-3 rounded-full bg-green-5"></div>
                </div>
                <div class="col text-center text-xs text-grey-5 font-mono">transaction.sql</div>
              </div>
              <div class="q-pa-md font-mono text-xs md:text-sm">
                <div class="text-grey-6">// Atomic Transfer Procedure</div>
                <div class="text-purple-4">BEGIN;</div>
                <div class="q-pl-md group q-py-xs">
                  <span class="text-blue-3">UPDATE</span> accounts
                  <span class="text-orange-3">SET</span> balance = balance - amount <br /><span
                    class="text-grey-5"
                    >WHERE</span
                  >
                  id = sender_id;
                </div>
                <div class="q-pl-md group q-py-xs">
                  <span class="text-blue-3">UPDATE</span> accounts
                  <span class="text-orange-3">SET</span> balance = balance + amount <br /><span
                    class="text-grey-5"
                    >WHERE</span
                  >
                  id = receiver_id;
                </div>
                <div class="q-pl-md group q-py-xs">
                  <span class="text-green-4">INSERT INTO</span> audit_log ...;
                </div>
                <div class="text-purple-4">COMMIT;</div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- 4. Infrastructure -->
    <section class="q-py-xl bg-darker q-px-md">
      <div class="container text-center">
        <h2 class="text-h3 text-weight-bold q-mb-xl">Global Infrastructure</h2>

        <div class="row q-col-gutter-lg justify-center">
          <div class="col-12 col-md-5">
            <div
              class="feature-box border-gradient q-pa-xl full-height relative-position overflow-hidden"
            >
              <div class="absolute-top-right q-pa-md opacity-20">
                <q-icon name="cloud_queue" size="75px" />
              </div>
              <div class="text-h5 text-weight-bold q-mb-md text-white relative-position z-10">
                Vercel Fluid Compute
              </div>
              <p class="text-grey-4 relative-position z-10">
                Intelligent workload distribution. Maintains hot database connections to eliminate
                cold starts, ensuring bank-like responsiveness.
              </p>
            </div>
          </div>
          <div class="col-12 col-md-5">
            <div
              class="feature-box border-gradient q-pa-xl full-height relative-position overflow-hidden"
            >
              <div class="absolute-top-right q-pa-md opacity-20">
                <q-icon name="hub" size="75px" />
              </div>
              <div class="text-h5 text-weight-bold q-mb-md text-white relative-position z-10">
                Smart Pooling
              </div>
              <p class="text-grey-4 relative-position z-10">
                Resilient connectivity. Utilizing <code>attachDatabasePool</code> to gracefully
                handle traffic spikes without dropping transactions.
              </p>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- 5. Dashboard Preview -->
    <section class="q-py-xl q-px-md">
      <div class="container">
        <h2 class="text-h3 text-center text-weight-bold q-mb-xl">Institutional Analytics</h2>

        <div class="row q-col-gutter-lg">
          <div class="col-12 col-md-6">
            <!-- Dashboard Card 1 -->
            <q-card dark bordered class="bg-glass-surface full-height">
              <q-card-section>
                <div class="row items-center justify-between">
                  <div>
                    <div class="text-h6">Liquidity Forecast</div>
                    <div class="text-caption text-grey-5">AI-driven cash flow prediction</div>
                  </div>
                  <q-btn flat round icon="more_horiz" color="grey" />
                </div>
              </q-card-section>
              <q-separator dark />
              <q-card-section class="q-pa-lg flex flex-center" style="height: 250px">
                <div class="text-center w-full">
                  <!-- Simple CSS Chart Representation -->
                  <div class="row items-end justify-between q-gutter-x-sm h-32 w-full q-px-md">
                    <div class="bg-primary-dark w-1-6 rounded-t h-40"></div>
                    <div class="bg-primary-dark w-1-6 rounded-t h-60"></div>
                    <div class="bg-primary w-1-6 rounded-t h-50"></div>
                    <div class="bg-primary-gradient w-1-6 rounded-t h-80 shadow-glow-sm"></div>
                    <div class="bg-primary-dark w-1-6 rounded-t h-70"></div>
                  </div>
                  <div class="text-caption text-grey-6 q-mt-md">30-Day Projection</div>
                </div>
              </q-card-section>
            </q-card>
          </div>

          <div class="col-12 col-md-6">
            <!-- Dashboard Card 2 -->
            <q-card dark bordered class="bg-glass-surface full-height">
              <q-card-section class="row items-center justify-between">
                <div>
                  <div class="text-h6">Compliance Monitor</div>
                  <div class="text-caption text-grey-5">Real-time risk scoring</div>
                </div>
                <q-chip color="red-9" text-color="white" icon="warning" size="sm">1 Alert</q-chip>
              </q-card-section>
              <q-separator dark />
              <q-list separator dark>
                <q-item class="q-py-md">
                  <q-item-section avatar>
                    <q-avatar color="red-10" text-color="red-2" icon="priority_high" size="md" />
                  </q-item-section>
                  <q-item-section>
                    <q-item-label class="text-weight-bold">Large Unverified Transfer</q-item-label>
                    <q-item-label caption class="text-red-3"
                      >Risk Score: High (85/100)</q-item-label
                    >
                  </q-item-section>
                  <q-item-section side>
                    <q-btn outline dense color="red" label="Audit" size="sm" />
                  </q-item-section>
                </q-item>
                <q-item class="q-py-md">
                  <q-item-section avatar>
                    <q-avatar color="blue-grey-9" text-color="blue-grey-2" icon="check" size="md" />
                  </q-item-section>
                  <q-item-section>
                    <q-item-label>Utility Payment Pattern</q-item-label>
                    <q-item-label caption class="text-grey-5"
                      >Recurring verified merchant.</q-item-label
                    >
                  </q-item-section>
                </q-item>
              </q-list>
            </q-card>
          </div>
        </div>
      </div>
    </section>

    <!-- Footer -->
    <footer class="q-py-xl text-center text-grey-6 border-top-light bg-darker q-px-md">
      <div class="text-white text-h6 q-mb-sm text-weight-bold">CBDC Wallet</div>
      <div class="q-mb-lg">Sovereign Financial Technology</div>
      <div class="text-caption">
        &copy; 2025 Central Bank Digital Currency Project. <br class="lt-sm" />
        All rights reserved.
      </div>
    </footer>
  </q-page>
</template>

<script>
import { defineComponent } from 'vue'

export default defineComponent({
  name: 'IndexPage',
})
</script>

<style scoped>
/* Core Layout */
.container {
  max-width: 1200px;
  margin: 0 auto;
  width: 100%;
}

.max-w-700 {
  max-width: 700px;
}

.bg-darker {
  background-color: #050505;
}

/* Gradients & Backgrounds */
.gradient-bg {
  background: radial-gradient(circle at 50% 0%, #1a2a6c 0%, #0c0a20 60%, #000000 100%);
  opacity: 0.8;
}

.bg-noise {
  background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 200 200' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noiseFilter'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.65' numOctaves='3' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noiseFilter)'/%3E%3C/svg%3E");
  opacity: 0.03;
}

.bg-primary-gradient {
  background: linear-gradient(135deg, #00d2ff 0%, #3a7bd5 100%);
}

.text-primary-gradient {
  background: linear-gradient(135deg, #00d2ff 0%, #3a7bd5 100%);
  -webkit-background-clip: text;
  background-clip: text;
  -webkit-text-fill-color: transparent;
}

/* Glassmorphism */
.glass-card {
  background: rgba(255, 255, 255, 0.03);
  border: 1px solid rgba(255, 255, 255, 0.08);
  border-radius: 16px;
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
}

.glass-card:hover {
  transform: translateY(-8px);
  background: rgba(255, 255, 255, 0.06);
  border-color: rgba(255, 255, 255, 0.2);
  box-shadow: 0 10px 30px -10px rgba(0, 210, 255, 0.15);
}

.glass-item {
  background: rgba(255, 255, 255, 0.02);
  border: 1px solid rgba(255, 255, 255, 0.05);
}

.bg-glass-surface {
  background: rgba(255, 255, 255, 0.02) !important;
  backdrop-filter: blur(5px);
}

.mockup-glass {
  background: rgba(255, 255, 255, 0.05);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 20px;
  width: 300px;
}

/* Feature Boxes */
.feature-box {
  background: #0a0a0a;
  border-radius: 16px;
  transition: transform 0.3s ease;
}

.feature-box:hover {
  transform: scale(1.02);
}

.border-gradient {
  position: relative;
  z-index: 1;
}

.border-gradient::before {
  content: '';
  position: absolute;
  inset: -1px;
  border-radius: 17px;
  background: linear-gradient(45deg, #00d2ff, #3a7bd5, #9b59b6);
  z-index: -1;
  opacity: 0.3;
}

/* Icons & Utilities */
.icon-box {
  width: 60px;
  height: 60px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.bg-accent-soft {
  background: rgba(0, 210, 255, 0.1);
}
.bg-warning-soft {
  background: rgba(242, 192, 55, 0.1);
}
.bg-success-soft {
  background: rgba(76, 175, 80, 0.1);
}

.bg-grid-pattern {
  background-image:
    linear-gradient(rgba(255, 255, 255, 0.05) 1px, transparent 1px),
    linear-gradient(90deg, rgba(255, 255, 255, 0.05) 1px, transparent 1px);
  background-size: 40px 40px;
}

.shadow-glow {
  box-shadow: 0 4px 20px rgba(0, 210, 255, 0.4);
}

.shadow-glow-sm {
  box-shadow: 0 0 10px rgba(0, 210, 255, 0.3);
}

.w-1-6 {
  width: 15%;
}
.h-32 {
  height: 8rem;
}
.h-40 {
  height: 40%;
}
.h-50 {
  height: 50%;
}
.h-60 {
  height: 60%;
}
.h-70 {
  height: 70%;
}
.h-80 {
  height: 80%;
}

/* Typography */
.leading-tight {
  line-height: 1.1;
}
.leading-relaxed {
  line-height: 1.6;
}
.font-mono {
  font-family: 'Courier New', Courier, monospace;
}

/* Responsive Overrides */
@media (max-width: 599px) {
  .text-h1 {
    font-size: 2.5rem;
  }
  .hero-title {
    font-size: 2.5rem;
    line-height: 1.2;
  }
}

.opacity-20 {
  opacity: 0.2;
}
</style>

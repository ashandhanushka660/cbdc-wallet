# CBDC Wallet

A modern, secure Central Bank Digital Currency (CBDC) wallet application with real-time transactions and comprehensive admin controls.

![CBDC Wallet](https://img.shields.io/badge/Status-Production%20Ready-success)
![Vue.js](https://img.shields.io/badge/Vue.js-3.x-brightgreen)
![Quasar](https://img.shields.io/badge/Quasar-2.x-blue)
![Supabase](https://img.shields.io/badge/Supabase-Backend-orange)

## 🌟 Features

### User Features
- 🔐 **Secure Authentication** - Email verification, password reset
- 💸 **Send Money** - Instant transfers between accounts
- 📥 **Receive Money** - Share account ID with copy functionality
- 📊 **Transaction History** - Real-time transaction tracking
- 💳 **Payment Methods** - Manage multiple payment methods
- 🎨 **Premium UI** - Glassmorphism design with smooth animations

### Admin Panel
- 📈 **System Dashboard** - Real-time metrics and statistics
- 👥 **User Management** - View, search, freeze/unfreeze accounts
- 🔍 **Transaction Oversight** - Monitor all system transactions
- 💰 **Monetary Control** - Mint and burn CBDC to control money supply
- 🛡️ **Security Controls** - Role-based access control

## 🚀 Tech Stack

- **Frontend**: Vue.js 3 + Quasar Framework
- **Backend**: Supabase (PostgreSQL + Auth + Realtime)
- **Deployment**: Vercel
- **Styling**: CSS3 with Glassmorphism

## 📦 Installation

### Prerequisites
- Node.js 16+ 
- npm or yarn
- Supabase account

### Setup

1. **Clone the repository**
```bash
git clone https://github.com/yourusername/cbdc-wallet.git
cd cbdc-wallet
```

2. **Install dependencies**
```bash
npm install
```

3. **Configure environment variables**
Create a `.env` file:
```env
VITE_SUPABASE_URL=your_supabase_url
VITE_SUPABASE_ANON_KEY=your_supabase_anon_key
```

4. **Set up database**
Run the SQL files in Supabase SQL Editor:
- `supabase_schema.sql`
- `supabase_schema_additions.sql`
- `admin_schema.sql`

5. **Run development server**
```bash
npm run dev
```

Visit `http://localhost:9000`

## 🔧 Build for Production

```bash
npm run build
```

Output will be in `dist/spa/`

## 🌐 Deployment

See [DEPLOYMENT.md](./DEPLOYMENT.md) for detailed Vercel deployment instructions.

Quick deploy:
```bash
vercel
```

## 📱 Usage

### As a User
1. Register at `/auth/register`
2. Verify your email
3. Login and access dashboard
4. Send/receive money, view transactions

### As an Admin
1. Set admin role in Supabase:
```sql
UPDATE profiles SET is_admin = true WHERE email = 'admin@example.com';
```
2. Login and navigate to `/admin`
3. Access admin dashboard, user management, and monetary controls

## 🔒 Security

- Row-Level Security (RLS) enabled on all tables
- Admin-only RPC functions with authorization checks
- Email verification required
- Secure password hashing via Supabase Auth
- HTTPS enforced in production

## 📄 License

MIT License - feel free to use this project for learning or commercial purposes.

## 👨‍💻 Author

Built with ❤️ by [Your Name]

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📞 Support

For issues or questions, please open an issue on GitHub.

---

**⭐ Star this repo if you find it helpful!**

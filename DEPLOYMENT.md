# Vercel Deployment Guide for CBDC Wallet

## Prerequisites
- GitHub account
- Vercel account (free tier is fine)
- Supabase project already set up

## Step 1: Prepare Your Repository

### 1.1 Create .gitignore (if not exists)
Make sure these are in your `.gitignore`:
```
node_modules/
dist/
.quasar/
.env
.env.local
```

### 1.2 Commit Your Code
```bash
git add .
git commit -m "Prepare for Vercel deployment"
git push origin main
```

## Step 2: Configure Environment Variables

You'll need to add these to Vercel (NOT in your code):
- `VITE_SUPABASE_URL` - Your Supabase project URL
- `VITE_SUPABASE_ANON_KEY` - Your Supabase anon/public key

## Step 3: Deploy to Vercel

### Option A: Deploy via Vercel Dashboard (Recommended)

1. Go to [vercel.com](https://vercel.com) and sign in
2. Click **"Add New Project"**
3. Import your GitHub repository
4. Vercel will auto-detect Quasar settings
5. Add environment variables:
   - Click **"Environment Variables"**
   - Add `VITE_SUPABASE_URL` = `your-supabase-url`
   - Add `VITE_SUPABASE_ANON_KEY` = `your-supabase-anon-key`
6. Click **"Deploy"**
7. Wait 2-3 minutes for build to complete
8. Your app will be live at `https://your-project.vercel.app`

### Option B: Deploy via Vercel CLI

```bash
# Install Vercel CLI
npm i -g vercel

# Login to Vercel
vercel login

# Deploy
vercel

# Follow prompts and add environment variables when asked
```

## Step 4: Configure Supabase for Production

### 4.1 Add Production URL to Supabase
1. Go to Supabase Dashboard → **Authentication** → **URL Configuration**
2. Add your Vercel URL to **Site URL**: `https://your-project.vercel.app`
3. Add to **Redirect URLs**: `https://your-project.vercel.app/**`

### 4.2 Update Email Templates (Optional)
1. Go to **Authentication** → **Email Templates**
2. Update confirmation links to use your production URL

## Step 5: Test Your Deployment

1. Visit your Vercel URL
2. Test registration (check email verification)
3. Test login
4. Test sending money
5. Test admin panel access

## Step 6: Custom Domain (Optional)

1. In Vercel Dashboard → **Settings** → **Domains**
2. Add your custom domain
3. Follow DNS configuration instructions
4. Update Supabase redirect URLs to use custom domain

## Troubleshooting

### Build Fails
- Check Vercel build logs
- Ensure all dependencies are in `package.json`
- Verify Node.js version compatibility

### Environment Variables Not Working
- Make sure they start with `VITE_` prefix
- Redeploy after adding variables
- Check they're set in Vercel dashboard

### Email Verification Not Working
- Verify Supabase redirect URLs include your Vercel domain
- Check email template links

### Admin Panel Not Accessible
- Ensure `is_admin` column exists in database
- Verify admin user is set correctly
- Check browser console for errors

## Performance Optimization (Optional)

### Enable Vercel Analytics
```bash
npm install @vercel/analytics
```

Add to `src/App.vue`:
```javascript
import { inject } from '@vercel/analytics'
inject()
```

### Enable Caching
Vercel automatically caches static assets. No configuration needed!

## Monitoring

- **Vercel Dashboard**: View deployment logs, analytics
- **Supabase Dashboard**: Monitor database queries, auth events
- **Browser DevTools**: Check for console errors

## Continuous Deployment

Every push to `main` branch will automatically deploy to Vercel!

```bash
git add .
git commit -m "Update feature"
git push origin main
# Vercel automatically deploys!
```

## Security Checklist

- ✅ Environment variables not in code
- ✅ `.env` in `.gitignore`
- ✅ Supabase RLS policies enabled
- ✅ Admin routes protected with guards
- ✅ HTTPS enabled (automatic on Vercel)

## Your Deployment URLs

- **Production**: `https://your-project.vercel.app`
- **Admin Panel**: `https://your-project.vercel.app/admin`
- **Supabase Dashboard**: Your Supabase project URL

---

**Congratulations! Your CBDC Wallet is now live! 🚀**

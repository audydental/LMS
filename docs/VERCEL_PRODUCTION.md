# Vercel Production Deployment

## Prerequisites

- GitHub account with this project pushed
- Vercel account
- Supabase project created and configured

## 1. Push to GitHub

```bash
git init
git add .
git commit -m "feat: initial production implementation"
git remote add origin https://github.com/YOUR_ORG/audy-learning-centre.git
git push -u origin main
```

## 2. Import to Vercel

1. Go to [vercel.com](https://vercel.com) → **New Project**
2. Import your GitHub repository
3. Vercel auto-detects SvelteKit

## 3. Configure Build Settings

Vercel should auto-detect, but verify:
- **Framework Preset**: SvelteKit
- **Build Command**: `bun run build`
- **Install Command**: `bun install`
- **Output Directory**: `.svelte-kit` (auto)

## 4. Set Environment Variables

In Vercel Dashboard → Project → Settings → **Environment Variables**:

| Name | Value | Environment |
|---|---|---|
| `PUBLIC_SUPABASE_URL` | `https://xxx.supabase.co` | Production, Preview |
| `PUBLIC_SUPABASE_PUBLISHABLE_KEY` | `eyJhbGci...` | Production, Preview |

## 5. Deploy

```bash
# Using Vercel CLI
vercel --prod

# Or push to main branch (auto-deploys via GitHub integration)
git push origin main
```

## 6. Configure Custom Domain

In Vercel Dashboard → Project → **Domains**:
1. Add your domain (e.g. `learning.audydental.com`)
2. Add DNS records as instructed
3. SSL is automatic via Let's Encrypt

## 7. Update Supabase Auth URLs

After domain is live, update in Supabase Dashboard → Authentication → URL Configuration:
- **Site URL**: `https://learning.audydental.com`
- **Redirect URLs**: `https://learning.audydental.com/auth/callback`

## 8. Verify Deployment

- [ ] Homepage loads
- [ ] `/auth` page works
- [ ] Login works (with real Supabase credentials)
- [ ] `/learning` loads
- [ ] `/admin` redirects to login (not logged in) or shows dashboard (logged in as admin)
- [ ] HTTPS is active

## Troubleshooting

**Build fails**: Check `bun run build` locally first. Ensure all types pass with `bun run check`.

**Auth not working**: Verify Supabase redirect URLs include your Vercel domain.

**Environment variables not loading**: Redeploy after setting env vars in Vercel.

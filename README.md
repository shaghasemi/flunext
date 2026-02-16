# Flunext — Next.js + Flutter hybrid

A hybrid app that gives you **fast initial load** (Next.js) and **cross-platform app features** (Flutter) loaded on demand.

---

## Run locally (anywhere)

**Prerequisites:** [Node.js](https://nodejs.org/) (v18+), [npm](https://www.npmjs.com/), and [Flutter](https://flutter.dev/docs/get-started/install) SDK.

From a **fresh clone** (or any machine):

```bash
# 1. Install Next.js dependencies
npm install
# If you see peer dependency errors:
# npm install --legacy-peer-deps

# 2. Build the Flutter web app and copy it into Next.js public folder
cd flutter_app
flutter pub get
flutter build web --base-href "/flutter-app/"
cd ..
node scripts/copy-flutter-build.js

# 3. Start the dev server
npm run dev
```

Open **http://localhost:3000**. Use the **OTC** and **Marketplace** links to load the Flutter app in the iframe.

---

## Deploy to a server

### Option A: Node server (VPS, VM, or any host with Node)

Build the app and run it with Node:

```bash
# Build Flutter web and copy into public (same as “Run locally” step 2)
cd flutter_app && flutter pub get && flutter build web --base-href "/flutter-app/" && cd ..
node scripts/copy-flutter-build.js

# Build Next.js for production
npm run build

# Start the production server (serves on port 3000 by default)
npm run start
```

To serve on a different port:

```bash
PORT=8080 npm run start
```

Use a process manager (e.g. **pm2**) or a reverse proxy (e.g. **nginx**) in front of this server for a real deployment.

### Option B: Vercel (or similar)

1. Push this repo to GitHub (see [Push to GitHub](#push-to-github) below).
2. In [Vercel](https://vercel.com), **Import** the `flunext` repo.
3. **Recommended:** Build Flutter locally, run `node scripts/copy-flutter-build.js`, then **commit** the `public/flutter-app/` folder. In Vercel set **Build command** to `npm run build`. Deploy (Vercel does not include the Flutter SDK).
4. **Alternative:** Use a [custom Docker/build image](https://vercel.com/docs/build-step#custom-build-image) that has Flutter installed, and set **Build command** to `cd flutter_app && flutter build web --base-href "/flutter-app/" && cd .. && node scripts/copy-flutter-build.js && npm run build`.

### Option C: Static export (no server)

If you don’t need server-side APIs, you can export static files. In `next.config.ts` set `output: 'export'`, then:

```bash
node scripts/copy-flutter-build.js
npm run build
```

Upload the contents of the `out/` folder to any static host (GitHub Pages, Netlify, S3, etc.).

---

## Push to GitHub

The project is already committed locally. To put it on GitHub:

1. **Create a new repo on GitHub:** go to [github.com/new](https://github.com/new), set the name to **flunext**, leave “Add a README” **unchecked**, then click **Create repository**.

2. **Add the remote and push** (replace `YOUR_USERNAME` with your GitHub username):

```bash
git remote add origin https://github.com/YOUR_USERNAME/flunext.git
git branch -M main
git push -u origin main
```

**If you use GitHub CLI** and want to create the repo from the terminal:

```bash
gh repo create flunext --public --source=. --remote=origin --push
```

---

## How it works

1. **Landing and shell** are served by Next.js → fast first paint and SEO.
2. **Flutter** is loaded only when the user navigates to app routes (e.g. **OTC**, **Marketplace**).
3. Optional **background preload**: after the page is interactive, a hidden iframe starts loading the Flutter app so that when the user clicks “OTC” or “Marketplace”, the engine is often already cached.
4. The **same Flutter code** can power web (embedded here), iOS, Android, and desktop builds.

## Project structure

```
flunext/
├── app/                    # Next.js App Router
│   ├── page.tsx            # Fast landing page
│   ├── (flutter)/          # Routes that show the Flutter app
│   │   ├── otc/
│   │   └── marketplace/
│   └── layout.tsx
├── components/
│   ├── FlutterFrame.tsx       # iframe that loads /flutter-app/index.html#/<route>
│   ├── FlutterFrameLoader.tsx # Client component that lazy-loads FlutterFrame (ssr: false)
│   └── FlutterPreload.tsx     # Background preload (hidden iframe)
├── public/
│   └── flutter-app/       # Flutter web build output (you generate this)
└── flutter_app/            # Flutter project (same code for all platforms)
    ├── lib/main.dart
    └── web/
```

## Setup reference

The [Run locally](#run-locally-anywhere) section above is the main checklist. Copy alternatives:

- **Windows (PowerShell):**  
  `Remove-Item -Recurse -Force public\flutter-app\* 2>$null; Copy-Item -Recurse flutter_app\build\web\* public\flutter-app\`
- **macOS / Linux:**  
  `rm -rf public/flutter-app/* && cp -r flutter_app/build/web/* public/flutter-app/`

**Troubleshooting**

- **Build fails with `ssr: false is not allowed with next/dynamic in Server Components`**  
  The Flutter iframe is loaded via a client-only component (`FlutterFrameLoader`). The app routes import that component; they do not use `dynamic(..., { ssr: false })` directly in a server page.

- **Next.js build fails with `MODULE_NOT_FOUND` (e.g. `module.compiled`)**  
  After upgrading Next.js, do a clean install: remove `node_modules` and `.next`, then run `npm install --legacy-peer-deps` again. Close any running dev server or other process that might be locking files under `node_modules` before deleting.

- **OTC or Marketplace shows 404 (with “Back to home” header)**  
  Next.js does not serve `index.html` for folder paths in `public/`. The iframe must request the entry file explicitly: `/flutter-app/index.html#/otc` (not `/flutter-app/#/otc`). The app is already configured this way; ensure you have run the Flutter build and copy step so `public/flutter-app/index.html` exists.

## Flutter routing

The Flutter app uses **hash routing** (default for Flutter web). Next.js links point to:

- `/otc` → iframe loads `/flutter-app/index.html#/otc`
- `/marketplace` → iframe loads `/flutter-app/index.html#/marketplace`

Routes are defined in `flutter_app/lib/main.dart` with `go_router`. Add more routes there and corresponding Next.js pages under `app/(flutter)/`.

## Checking that data and state persist (fake login)

The Flutter app includes a **fake login** so you can verify that state persists when opening different Flutter pages from the Next.js shell (e.g. OTC vs Marketplace), even though each link loads a **new iframe** (new Flutter instance).

- **Persistence:** The “logged in” username is stored with `shared_preferences` (on web this is **localStorage**). All iframes share the same origin, so they share the same localStorage.
- **How to check:**
  1. Open the app (e.g. click **OTC** or **Marketplace** from the Next.js home).
  2. In the Flutter iframe, tap the **Home** icon (or open the Flutter home route) and use **Fake login**: enter a username and tap **Log in**.
  3. Go to another Flutter page (e.g. use **Go to Marketplace** inside Flutter, or use the Next.js **Marketplace** link in the browser).
  4. You should see **“Logged in as: &lt;your name&gt;”** on the new page — state persisted across iframe loads.

This confirms that data/state can persist in the web build across “navigations” that open different Flutter routes (or different Next.js links that load new iframes).

## Using the same Flutter app on mobile and desktop

- **Web:** Embedded here via iframe; build with `flutter build web --base-href "/flutter-app/"`.
- **iOS / Android:** `flutter build ios` / `flutter build apk` or `appbundle` from the same `flutter_app/` project.
- **Desktop:** `flutter build windows` / `flutter build macos` / `flutter build linux` from the same project.

One Dart codebase, one set of screens (OTC, Marketplace, etc.), multiple platforms.

## Optional: disable background preload

If you prefer not to preload Flutter (e.g. to save bandwidth until the user chooses an app link), remove or comment out `<FlutterPreload />` in `app/layout.tsx`. The app routes will still work; Flutter will load when the user first opens OTC or Marketplace.

## Tech summary

| Concern              | Solution                          |
|----------------------|-----------------------------------|
| Fast initial load    | Next.js landing + shell           |
| Slow Flutter web     | Load only on app routes (lazy)    |
| Even faster app open | Optional Flutter preload iframe   |
| Cross-platform       | Same Flutter app for all platforms|

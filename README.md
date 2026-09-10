# The Mental Tilt Wellness Hub — Android app wrapper

This is a **separate, standalone project**. It does not contain, modify, or depend on
the source code of your web app (`web-app-chi-ten.vercel.app`). It is a thin native
Android shell (built with [Capacitor](https://capacitorjs.com)) that simply opens
your live web app inside a full-screen native WebView, with a launcher icon, splash
screen, and the ability to be installed as a normal Android app.

**Nothing about your web app changes.** Ship updates to it exactly as you do today —
anyone using this Android app sees the update immediately, the next time they open
it, because it is always loading the real, live site.

## Why you don't already have an .apk file in this folder

Building the actual installable file requires Google's Android SDK and the Maven
package repositories that the Android build tools pull from. The sandbox this project
was built in is not allowed to reach those servers, so the very last step — turning
this project into `app-debug.apk` — has to happen somewhere with normal internet
access. Three ways to do that, easiest first:

### Option A — GitHub Actions (recommended, no software to install)

1. Create a new **private** GitHub repository and push this folder to it:
   ```
   cd wellness-hub-apk
   git init
   git add .
   git commit -m "Android wrapper for Wellness Hub"
   git branch -M main
   git remote add origin https://github.com/<you>/wellness-hub-apk.git
   git push -u origin main
   ```
2. A workflow is already included at `.github/workflows/build-apk.yml`. As soon as
   you push, GitHub will build the app automatically. Watch it under the repo's
   **Actions** tab.
3. When it finishes (green check, a couple of minutes), open that run and download
   the **wellness-hub-debug-apk** artifact from the bottom of the page — that zip
   contains `app-debug.apk`.
4. Transfer that .apk to an Android phone (email it to yourself, Google Drive,
   WhatsApp, USB) and tap it to install. You'll need to allow "Install unknown apps"
   for whichever app you use to open it — Android will prompt you the first time.

This produces a **debug** APK, which installs and runs exactly like a real app but
isn't signed for the Play Store yet (see "Publishing to Google Play" below).

### Option B — Android Studio on your own computer

1. Install [Android Studio](https://developer.android.com/studio) (free).
2. Open the `android/` folder inside this project as a project.
3. Let it finish syncing (first time takes a few minutes while it downloads the SDK).
4. **Build → Build Bundle(s) / APK(s) → Build APK(s)**.
5. It'll show a notification with a "locate" link to the finished `.apk`.

### Option C — Ask me to build it, from a place with full internet access

If you'd rather not deal with GitHub or Android Studio yourself, tell me and I can
either run this same project through Claude Code on your own computer (if you link
one to this session), or walk you through Option A step by step.

## What's in this project

- `capacitor.config.ts` — the whole app's configuration. The important line is
  `server.url`, which points at `https://web-app-chi-ten.vercel.app`. Change this
  later if/when you move the web app to your own domain (e.g.
  `app.thementaltiltja.com`) — nothing else needs to change.
- `android/` — the generated native Android project (this is what actually compiles
  into the .apk).
- `assets/` + the generated icons in `android/app/src/main/res/mipmap-*` and
  `drawable*` — a **placeholder** app icon and splash screen in your brand colors
  (turquoise → purple gradient with a simple leaf mark), since I could only reach
  your real logo file at low resolution from here. See "Swap in your real logo"
  below — it's a two-minute fix.
- `.github/workflows/build-apk.yml` — the GitHub Actions build recipe.
- `www/` — a one-page loading screen shown for a split second before the live site
  takes over; not the app itself.

## Swap in your real logo

1. Save your existing `logo-transparent.png` (or a fresh 1024×1024 square PNG) into
   `assets/icon.png`, and a good splash image into `assets/splash.png` (any size,
   ideally square and at least 1200px).
2. Run:
   ```
   npm install
   npx capacitor-assets generate --android
   ```
   This regenerates every icon size and splash screen Android needs from those two
   files. Then rebuild via Option A or B above.

## Sharing the app with everybody, and publishing to Google Play

**Full step-by-step instructions are in [`HOW_TO_SHARE_AND_PUBLISH.md`](./HOW_TO_SHARE_AND_PUBLISH.md)** —
written in plain language, covering:

1. A public download link anyone can use today (no GitHub account, no Play
   Store wait) — via `.github/workflows/release.yml`, already set up.
2. The full Google Play Console process: developer account, signing key
   (via `create-signing-key.sh`), store listing, content rating, data
   safety form, and submitting for review.

Quick-reference notes:

- **App ID.** This project uses `com.thementaltiltja.hub` as a placeholder package
  ID (set in `capacitor.config.ts` and `android/app/build.gradle`). This can be
  changed freely right now, but **cannot be changed after your first Play Store
  upload** — pick the final one before you publish. If you already reserved
  `com.thementaltiltwellnesshub` for the other (Expo-built) Wellness Hub app, use a
  different, clearly distinct ID for this one so they're never confused as the same
  listing.
- **Signing key.** The debug APK from Option A/B works for installing and testing,
  but real distribution (Part 1 and Part 2 of the guide above) uses a proper signed
  release build instead, made with `create-signing-key.sh`. Keep that keystore file
  and its password backed up somewhere safe — losing it means you can never update
  that same app listing again.
- **Google Sign-In.** Your web app offers "Continue with Google." Inside a native
  WebView this works, but Google increasingly nudges these toward its native
  Android sign-in flow for a smoother experience. It's not broken as-is; it's worth
  testing on a real device before publishing.
- **Privacy Policy URL.** The Play Store requires a working, public privacy policy
  link for any app handling accounts or personal data — this was flagged as missing
  in the web app review; fixing that (see the separate Wellness Hub Sweep report)
  covers this requirement too.

## A lower-effort alternative worth knowing about

If at any point you'd rather skip maintaining an Android project altogether,
[PWABuilder](https://www.pwabuilder.com) (a free Microsoft tool) can generate a
similar Android package directly from a URL in your browser, no project files or
GitHub required. It works best once the web app has a proper PWA manifest — which
is also on the enhancement list in the Wellness Hub Sweep report. This Capacitor
project is the more flexible, more "real app" path; PWABuilder is the faster,
more disposable one.

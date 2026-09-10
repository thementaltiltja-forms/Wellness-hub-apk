# Getting the app to everybody — the full, simple guide

Right now, the app only exists as a file that GitHub can build for you. That's
great for testing on your own phone, but it's not something a stranger could
easily get — they'd need a GitHub account and to know where to click.

This guide has two parts:

- **Part 1** — a way for *anyone* to download the app today, with a normal
  link, no account needed. Good for friends, family, early testers.
- **Part 2** — the real, permanent home for the app: the **Google Play
  Store**, where anyone with an Android phone can search "The Mental Tilt
  Wellness Hub" and install it like any other app.

You don't have to do Part 2 right away. Part 1 gets you a working download
link today. Part 2 takes a few days to a few weeks (Google reviews every
app), so it's worth starting whenever you're ready, even before every last
feature is finished.

---

## Part 1 — A link anyone can use, today

Think of this like uploading a photo to get a shareable link, instead of
emailing the photo file to one person at a time.

### Step 1 — Make the project's GitHub repository public

1. Open your `wellness-hub-apk` repository on github.com.
2. Click **Settings** (top right of the repo page).
3. Scroll to the very bottom, to a section called **Danger Zone**.
4. Click **Change visibility → Make public**, and confirm.

Why this is safe: this project doesn't contain your web app's code, your
database, or any passwords — it's just a wrapper that points at your
already-public website, plus a placeholder icon. Nothing private is in it.
(Your signing key from Part 2 is automatically kept out of GitHub entirely —
more on that below.)

### Step 2 — Ask GitHub to build a "release" version

A "release" is a clean, finished build — like exporting a document as a
final PDF instead of sharing the messy draft.

1. On your computer, inside the `wellness-hub-apk` folder, run:
   ```
   git tag v1.0.0
   git push origin v1.0.0
   ```
   (No idea what that means? In GitHub Desktop, you can do the same thing
   from the menu: **Repository → Create Tag**, type `v1.0.0`, then push.)
2. This automatically starts a new robot helper (already set up for you —
   see `.github/workflows/release.yml`) that builds the app properly.
3. Click your repo's **Actions** tab and watch it run. Takes a few minutes.

### Step 3 — Share the link

1. Once it finishes (green checkmark), click your repo's **Releases**
   section (right-hand sidebar on the repo's main page, or
   `github.com/<you>/wellness-hub-apk/releases`).
2. You'll see a page titled **Wellness Hub v1.0.0** with a file listed:
   `WellnessHub-1.0.0.apk`.
3. That page's link is what you share. Anyone who opens it on their Android
   phone and taps the `.apk` file can install the app — no GitHub account,
   no sign-in, nothing to set up.

That's it — Part 1 done. Whenever you make changes and want a new version
out, repeat Step 2 with a new tag (`v1.0.1`, `v1.0.2`, and so on).

**One heads-up:** Android will show a warning the first time someone installs
an app this way ("this isn't from the Play Store, are you sure?") — it's
harmless, just Android being cautious about files from outside its store.
That warning goes away for good once you finish Part 2 and the app is on
the Play Store.

---

## Part 2 — Putting it on the Google Play Store

This is the "real" path — the app shows up in search results, updates
happen automatically for everyone, and there's no scary warning at install
time. It takes some paperwork the first time, but you only do most of it
once.

### Step 1 — Create your developer account

1. Go to **play.google.com/console/signup**.
2. Sign in with the Google account you want tied to the app forever (you can
   add helpers later, but this first account is the "owner").
3. Choose **Individual** or **Organization** — Individual is simpler and is
   fine for one person running the business.
4. Pay the **one-time $25 registration fee**. (Not a subscription — you pay
   this once, ever.)
5. Google will ask you to verify your identity — usually a photo of an ID
   and sometimes a short video. This step can take anywhere from a few hours
   to a few days, so it's worth starting early.

### Step 2 — Create the app's keystore (its permanent signature)

Every real Android app is digitally "signed," the same idea as signing a
legal document — it proves updates really came from you and not someone
pretending to be you.

1. In the `wellness-hub-apk` folder, run the helper script already included
   for you:
   ```
   bash create-signing-key.sh
   ```
2. It'll ask you to make up a password — write that password down somewhere
   safe (a password manager, or a note kept somewhere private). **If you
   lose it, you can never update this app again** — you'd have to publish it
   as a brand new listing from scratch. So back up the password and the file
   it creates (`wellness-hub-release.keystore`) somewhere safe, like a
   password manager's file storage.
3. Don't have a place to run this script? Tell me and I can run it for you
   if you link this session to your own computer — it just needs Java,
   nothing fancier.

### Step 3 — Give GitHub the key, without ever putting it in your code

You want the automated builder (from Part 1) to be able to use this key, but
you never want it sitting in your public repository where anyone could see
it. GitHub has a special locked box for exactly this, called **Secrets**.

1. Turn the keystore file into text:
   ```
   base64 -w0 wellness-hub-release.keystore > keystore.base64.txt
   ```
2. Open `keystore.base64.txt` and copy everything inside it (it'll look like
   a long jumble of letters and numbers).
3. On GitHub: your repo → **Settings → Secrets and variables → Actions →
   New repository secret**.
4. Create these four secrets (click "New repository secret" four times):

   | Secret name | What to paste in |
   |---|---|
   | `RELEASE_KEYSTORE_BASE64` | the long text you copied in step 2 |
   | `RELEASE_KEYSTORE_PASSWORD` | the password you chose in Step 2 |
   | `RELEASE_KEY_ALIAS` | `wellness-hub-key` (exactly that, it's set by the script) |
   | `RELEASE_KEY_PASSWORD` | same password you chose in Step 2 |

5. Delete `keystore.base64.txt` from your computer once it's pasted in
   (you don't need the text file anymore, just the original `.keystore`
   file, backed up somewhere safe).

From now on, every time you push a new version tag (like in Part 1, Step 2),
GitHub will build a properly **signed** app automatically, using this key,
without it ever appearing anywhere public.

### Step 4 — Get the file the Play Store actually wants

The Play Store doesn't accept the `.apk` file from Part 1 — it wants a
slightly different format called an **`.aab`** (Android App Bundle). Good
news: the same automated builder already makes this for you every time.

1. Repeat Part 1, Step 2 (push a new version tag) now that your signing
   secrets are set up.
2. On the **Releases** page from Part 1, Step 3, you'll now also see a
   `WellnessHub-1.0.0.aab` file. That's the one you'll upload to Google.

### Step 5 — Create the app listing in the Play Console

1. In the Play Console (play.google.com/console), click **Create app**.
2. Fill in:
   - App name: `The Mental Tilt Wellness Hub`
   - Default language
   - App or game: **App**
   - Free or paid: **Free** (you mentioned payment isn't set up yet — you
     can always add in-app purchases or subscriptions later without
     changing this)
3. Agree to the developer program policies, click **Create app**.

You'll land on a dashboard with a checklist — Google walks you through each
piece. Here's what each one means in plain terms:

- **App content** section:
  - *Privacy policy* — a webpage explaining what data you collect. This was
    already flagged as missing on your web app in the earlier sweep review —
    add a simple privacy policy page there first, then paste that page's
    link here.
  - *Ads* — say "No" unless you've added ad software (you haven't).
  - *App access* — say whether reviewers need a test login, or can use the
    app without signing in.
  - *Content rating* — a short questionnaire ("does the app show violence,
    gambling, etc.") — for a wellness app, this is quick and results in an
    "Everyone" or similar low rating.
  - *Target audience* — who the app is for (adults, general audience, etc).
  - *Data safety* — a form listing what data you collect (e.g. email for
    login, usage data) and how it's used. Answer honestly based on what your
    app actually does (Firebase Auth + Firestore, in your case).
  - *Government apps*, *Financial features*, *Health* — short yes/no
    declarations; answer based on what the app actually does today.

- **Store listing** section — this is the page people see before installing:
  - Short description (80 characters) and full description (up to 4,000
    characters) — what the app does and why someone should download it.
  - App icon (512×512 PNG) — **note:** the icon currently in this project is
    a placeholder gradient, not your real logo. Swap it first (see the
    "Swap in your real logo" section in `README.md`) before you get this
    far, so your real logo shows up in the store.
  - Feature graphic (a 1024×500 banner image shown at the top of your store
    page).
  - At least 2 screenshots of the app in use — just take these on your own
    phone once the app is installed via Part 1.

- **Release** section:
  1. Click **Testing → Internal testing** first (recommended) — this lets
     you and a few people you invite by email try the real, signed Play
     Store version before the whole world can see it.
  2. Click **Create new release**, upload the `.aab` file from Step 4.
  3. Add short release notes (e.g. "First release").
  4. Save, then **Review release**, then roll it out to your internal
     testers.
  5. Once you're happy, do the same thing under **Production** (instead of
     Internal testing) to go live for everyone.

### Step 6 — Submit and wait

1. Once every checklist item has a green checkmark, click **Send for
   review** on the Production release.
2. Google reviews new apps — this usually takes anywhere from a few hours to
   a few days, occasionally longer for the first submission from a new
   developer account.
3. You'll get an email when it's approved (or if they need something fixed
   — they'll tell you exactly what).
4. Once approved: the app is live. Anyone can find it by searching "The
   Mental Tilt Wellness Hub" in the Play Store, or you can share its direct
   Play Store link.

### After that — updates are easy

Every future update is just: make your changes, push a new version tag
(Part 1, Step 2), download the new `.aab` from the Releases page, and upload
it under **Production → Create new release** in the Play Console. No need to
redo the account setup, the listing, or the signing key ever again.

---

## Quick summary of what "everybody" actually needs

| Who | What they do |
|---|---|
| A friend testing it today | Open your GitHub Release link, tap the `.apk`, install |
| Anyone once it's on Google Play | Search the app name in the Play Store, tap Install — no warnings, fully normal |

## Things worth double-checking before you go fully public

1. **Real logo** — swap the placeholder icon/splash for your actual brand
   logo (instructions already in `README.md`).
2. **Privacy policy page** — required by the Play Store, and currently
   missing from the web app per the earlier sweep review.
3. **App ID is permanent** — `com.thementaltiltja.hub` cannot change once
   you upload your first release to Google Play. If you'd prefer a
   different one, change it now in `capacitor.config.ts` and
   `android/app/build.gradle` before doing Part 2.
4. **Keep the keystore backed up** — losing it means losing the ability to
   ever update the app again.

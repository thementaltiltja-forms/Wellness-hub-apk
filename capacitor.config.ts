import type { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.thementaltiltja.hub',
  appName: 'The Mental Tilt Wellness Hub',
  webDir: 'www',
  // This app does NOT bundle a copy of the web app's code.
  // It is a thin native shell that loads the live, already-deployed
  // web app directly. Any update you ship to web-app-chi-ten.vercel.app
  // (or your future production domain) is what users see immediately —
  // no separate mobile release is needed for ordinary content/UI changes.
  server: {
    url: 'https://web-app-chi-ten.vercel.app',
    androidScheme: 'https',
    cleartext: false,
    // Domains the in-app browser is allowed to navigate to without
    // being treated as "leaving the app" (Firebase Auth / Google Sign-In
    // redirect flows, and the marketing site linked from Settings).
    allowNavigation: [
      '*.vercel.app',
      '*.firebaseapp.com',
      '*.googleapis.com',
      'accounts.google.com',
      '*.google.com',
      'thementaltiltja.com',
      '*.thementaltiltja.com'
    ]
  },
  android: {
    backgroundColor: '#0F1418'
  }
};

export default config;

#!/usr/bin/env bash
# Creates the one-time "signing key" your app needs before it can be
# published as a real, trusted Android app (see HOW_TO_SHARE_AND_PUBLISH.md,
# Part 2, Step 5). Run this ONCE, keep the file it creates somewhere safe
# forever, and never share it or commit it to GitHub (it's already excluded
# via .gitignore).
#
# Usage:
#   bash create-signing-key.sh
#
# It will ask you three questions (a password, and some name/organization
# info that never gets shown publicly — Android just requires you fill it
# in). Just answer them, or press Enter to accept the defaults in brackets.

set -e

KEYSTORE_FILE="wellness-hub-release.keystore"
ALIAS="wellness-hub-key"

if [ -f "$KEYSTORE_FILE" ]; then
  echo "A keystore already exists at ./$KEYSTORE_FILE — delete it first if you really want a new one."
  echo "(Using a NEW keystore for an app that's already published to Google Play will break future updates.)"
  exit 1
fi

echo "Creating your app's signing key..."
echo "When it asks for a password, pick one and WRITE IT DOWN somewhere safe."
echo "(A password manager, or a note in a safe place — not a GitHub file.)"
echo ""

keytool -genkeypair \
  -v \
  -keystore "$KEYSTORE_FILE" \
  -alias "$ALIAS" \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000

echo ""
echo "Done! Created: $KEYSTORE_FILE"
echo ""
echo "Next: turn it into text so it can be stored as a GitHub Secret:"
echo ""
echo "   base64 -w0 $KEYSTORE_FILE > $KEYSTORE_FILE.base64.txt"
echo ""
echo "Then open $KEYSTORE_FILE.base64.txt, copy everything inside it, and follow"
echo "HOW_TO_SHARE_AND_PUBLISH.md Part 2, Step 5 to paste it into GitHub."
echo ""
echo "IMPORTANT: back up $KEYSTORE_FILE itself somewhere safe too (e.g. a"
echo "password manager's file storage, or a private cloud drive folder)."
echo "If you ever lose it, you can NEVER update this app again — you'd have"
echo "to publish it as a brand new, separate app instead."

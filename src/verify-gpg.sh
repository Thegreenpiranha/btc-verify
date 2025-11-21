#!/bin/bash
# GPG Signature Verification Script
# Usage: ./verify-gpg.sh <repo-url> <tag> [key-id]

set -e

REPO_URL=$1
TAG=$2
KEY_ID=$3

if [ -z "$REPO_URL" ] || [ -z "$TAG" ]; then
    echo "Usage: $0 <repo-url> <tag> [key-id]"
    echo "Example: $0 https://github.com/bitcoin/bitcoin.git v27.0 CFB16E21C950F67FA95E558F2EEB9F5CC09526C1"
    exit 1
fi

echo "=== BTC-Verify: GPG Signature Verification ==="
echo "Repository: $REPO_URL"
echo "Tag: $TAG"
echo ""

# Create temp directory
TEMP_DIR="temp_verify_$$"
mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR"

# Clone repository
echo "Cloning repository..."
git clone "$REPO_URL" repo 2>&1 | grep -v "^Cloning"
cd repo

# Fetch GPG key if provided
if [ -n "$KEY_ID" ]; then
    echo "Fetching GPG key: $KEY_ID"
    gpg --keyserver keyserver.ubuntu.com --recv-keys "$KEY_ID" 2>&1 | grep -v "^gpg:"
fi

# Verify tag signature
echo ""
echo "Verifying tag signature for: $TAG"
if git tag -v "$TAG" > ../../verification_result.txt 2>&1; then
    if grep -q "Good signature" ../../verification_result.txt; then
        echo "✓ SUCCESS: Valid GPG signature found"
        grep "Good signature" ../../verification_result.txt
        RESULT="PASS"
    else
        echo "✗ FAILED: Signature check inconclusive"
        cat ../../verification_result.txt
        RESULT="FAIL"
    fi
else
    echo "✗ FAILED: Signature verification failed"
    cat ../../verification_result.txt
    RESULT="FAIL"
fi

# Cleanup
cd ../..
rm -rf "$TEMP_DIR"

# Generate report
echo ""
echo "=== Verification Report ==="
echo "Status: $RESULT"
echo "Repository: $REPO_URL"
echo "Tag: $TAG"
echo "Date: $(date)"

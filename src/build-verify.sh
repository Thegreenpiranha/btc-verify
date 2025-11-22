#!/bin/bash
# Build Verification Script
# Usage: ./build-verify.sh <config-file> <version>

set -e

CONFIG_FILE=$1
VERSION=$2

if [ -z "$CONFIG_FILE" ] || [ -z "$VERSION" ]; then
    echo "Usage: $0 <config-file> <version>"
    echo "Example: $0 configs/sparrow.conf 1.9.1"
    exit 1
fi

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: Config file not found: $CONFIG_FILE"
    exit 1
fi

# Source the config
source "$CONFIG_FILE"

echo "=== BTC-Verify: Build Verification ==="
echo "Project: $NAME"
echo "Version: $VERSION"
echo ""

# Create working directory
WORK_DIR="builds/${NAME// /_}_${VERSION}"
mkdir -p "$WORK_DIR"

# Clone and checkout
echo "Step 1: Cloning repository..."
cd "$WORK_DIR"
if [ ! -d "source" ]; then
    git clone --recurse-submodules "$REPO_URL" source
fi
cd source

# Update submodules if they exist
if [ -f .gitmodules ]; then
    echo "Initializing submodules..."
    git submodule update --init --recursive
fi

# Try different tag formats
git checkout "$VERSION" 2>/dev/null || \
git checkout "v$VERSION" 2>/dev/null || \
git checkout "$VERSION.0" 2>/dev/null || {
    echo "Error: Could not find version $VERSION"
    cd ../../..
    exit 1
}

echo " Checked out version $VERSION"
echo ""

# Build from source
echo "Step 2: Building from source..."
echo "Running build commands..."
echo ""

build || {
    echo "Error: Build failed"
    cd ../../..
    exit 1
}

echo ""
echo " Build completed"
echo ""

# Download official release
RELEASE_URL="${RELEASE_URL_TEMPLATE//VERSION/$VERSION}"
echo "Step 3: Downloading official release..."
echo "URL: $RELEASE_URL"
cd ../..

if wget -q --show-progress "$RELEASE_URL" -O "$WORK_DIR/official-release" 2>/dev/null; then
    echo " Official release downloaded"
    echo ""
    
    # Step 4: Compare builds
    echo "Step 4: Comparing builds..."
    echo ""
    
    # Source the comparison script
    source src/compare-builds.sh
    
    # Find the built file (this is simplified - real version would search)
    LOCAL_BUILD="$WORK_DIR/source/$BUILD_OUTPUT_DIR"
    OFFICIAL_RELEASE="$WORK_DIR/official-release"
    
    if [ -d "$LOCAL_BUILD" ]; then
        # If it's a directory, find the main binary/archive
        LOCAL_FILE=$(find "$LOCAL_BUILD" -type f | head -1)
        if [ -n "$LOCAL_FILE" ]; then
            compare_files "$LOCAL_FILE" "$OFFICIAL_RELEASE"
            COMPARE_RESULT=$?
        else
            echo "Warning: Could not find build output in $LOCAL_BUILD"
            COMPARE_RESULT=2
        fi
    else
        echo "Warning: Build output directory not found: $LOCAL_BUILD"
        COMPARE_RESULT=2
    fi
else
    echo "Warning: Could not download official release"
    echo "Manual comparison required"
    COMPARE_RESULT=2
fi

echo ""
echo "=== Build Verification Report ==="
echo "Project: $NAME"
echo "Version: $VERSION"
echo "Build directory: $WORK_DIR"
echo "Date: $(date)"
echo ""

if [ $COMPARE_RESULT -eq 0 ]; then
    echo "Status: BUILD VERIFIED - Reproducible!"
elif [ $COMPARE_RESULT -eq 1 ]; then
    echo "Status: VERIFICATION FAILED - Not reproducible"
else
    echo "Status:  MANUAL VERIFICATION REQUIRED"
    echo "Local build: $WORK_DIR/source/$BUILD_OUTPUT_DIR"
    echo "Official release: $WORK_DIR/official-release"
fi
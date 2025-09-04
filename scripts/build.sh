#!/bin/bash

PROJECT_NAME="composition" 
SRC_DIR="src"
ASSETS_DIR="assets"
BUILD_DIR="build"

# Create build directories
mkdir -p $BUILD_DIR/dev $BUILD_DIR/prod

# Set the Lua path for require() to work
LUA_PATH="?;?.lua;src/?;src/?.lua;src/?/init.lua"

echo "Building development version..."
# Development build - using actual assets without minification
p8tool build $BUILD_DIR/dev/${PROJECT_NAME}-dev-built.p8 \
    --lua $SRC_DIR/main.lua \
    --lua-path="$LUA_PATH" \
    --gfx $ASSETS_DIR/sprites.p8 \
    --sfx $ASSETS_DIR/audio.p8 \
    --music $ASSETS_DIR/audio.p8

p8tool luamin --keep-all-names $BUILD_DIR/dev/${PROJECT_NAME}-dev-built.p8
mv $BUILD_DIR/dev/${PROJECT_NAME}-dev-built_fmt.p8 $BUILD_DIR/dev/${PROJECT_NAME}-dev.p8
rm $BUILD_DIR/dev/${PROJECT_NAME}-dev-built.p8

echo "Building production version..."
# Production build - using actual assets with minification
p8tool build $BUILD_DIR/prod/${PROJECT_NAME}-prod-built.p8 \
    --lua $SRC_DIR/main.lua \
    --lua-path="$LUA_PATH" \
    --gfx $ASSETS_DIR/sprites.p8 \
    --sfx $ASSETS_DIR/audio.p8 \
    --music $ASSETS_DIR/audio.p8 

# Now, minify the temporary build, preserving names from the file
p8tool luamin --keep-names-from-file=scripts/config/preserve_names.txt $BUILD_DIR/prod/${PROJECT_NAME}-prod-built.p8
mv $BUILD_DIR/prod/${PROJECT_NAME}-prod-built_fmt.p8 $BUILD_DIR/prod/${PROJECT_NAME}-prod.p8
rm $BUILD_DIR/prod/${PROJECT_NAME}-prod-built.p8

# Copy final distribution
cp $BUILD_DIR/prod/${PROJECT_NAME}-prod.p8 ${PROJECT_NAME}.p8

echo "Build complete!"
echo "Development build: $BUILD_DIR/dev/${PROJECT_NAME}-dev.p8"
echo "Production build: $BUILD_DIR/prod/${PROJECT_NAME}-prod.p8"
echo "Final cart: ${PROJECT_NAME}.p8"

# Show stats for the final cartridge
if [ -f "${PROJECT_NAME}.p8" ]; then
    p8tool stats ${PROJECT_NAME}.p8
else
    echo "Warning: Final cart file not created"
fi


# Troubleshooting:
# - Make sure you have the p8tool installed and available in your PATH.
# - If you encounter permission issues, you may need to make this script executable:
#   chmod +x scripts/build.sh

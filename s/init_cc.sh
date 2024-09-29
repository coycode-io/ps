#!/bin/bash

# Define the root directory as the parent of the script's location
ROOT_DIR=$(dirname $(dirname $(realpath $0)))

# 1. Add the latest flutter_riverpod package to pubspec.yaml
echo "Adding flutter_riverpod to pubspec.yaml..."
flutter pub add flutter_riverpod

# 2. Clone the repo coycode-io/template_riverpod_notifier
TEMP_DIR=$(mktemp -d)
echo "Cloning template repository..."
git clone https://github.com/coycode-io/template_riverpod_notifier.git $TEMP_DIR

# 3. Copy the folder lib/providers from the cloned repo to the root project's lib/providers
echo "Copying 'lib/providers' from the template to the root project..."
mkdir -p $ROOT_DIR/lib/providers
cp -r $TEMP_DIR/lib/providers/* $ROOT_DIR/lib/providers/

# 4. Copy the folder test_project from the cloned repo to the root project's lib/providers
echo "Copying 'test_project' to the root project's 'lib/providers'..."
cp -r $TEMP_DIR/test_project $ROOT_DIR/lib/providers/

# Clean up: Remove the temporary directory
echo "Cleaning up temporary files..."
rm -rf $TEMP_DIR

echo "Setup completed successfully."

#!/bin/bash

# Get the root directory of the current Flutter project
ROOT_DIR=$(pwd)

# Get the name of the root project (name of the current directory)
PROJECT_NAME=$(basename "$ROOT_DIR")

# 1. Add flutter_riverpod package to the current Flutter project
echo "Adding flutter_riverpod to the current Flutter project..."
flutter pub add flutter_riverpod

# 2. Create a new Flutter project with a random 5-digit number
RANDOM_NUMBER=$(shuf -i 10000-99999 -n 1)
NEW_PROJECT_NAME="test_project$RANDOM_NUMBER"
echo "Creating new Flutter project: $NEW_PROJECT_NAME..."
flutter create "$ROOT_DIR/$NEW_PROJECT_NAME"

# Add flutter_riverpod to the new Flutter project
echo "Adding flutter_riverpod to $NEW_PROJECT_NAME..."
cd "$ROOT_DIR/$NEW_PROJECT_NAME"
flutter pub add flutter_riverpod

# 3. Add project A as a dependency in the new project's pubspec.yaml
echo "Adding $PROJECT_NAME as a dependency in $NEW_PROJECT_NAME's pubspec.yaml..."
sed -i "/^  flutter:/a \ \ $PROJECT_NAME:\n\ \ \ \ path: ../" pubspec.yaml

# 4. Create the lib/providers directory in the current project
echo "Creating lib/providers directory in the current project..."
mkdir -p "$ROOT_DIR/lib/providers"

# 5. Clone the GitHub repo into a temporary directory
TEMP_DIR="$ROOT_DIR/temp"
echo "Cloning the template repository into $TEMP_DIR..."
git clone https://github.com/coycode-io/template_riverpod_notifier.git "$TEMP_DIR"

# 6. Copy the lib/providers content from the cloned repo into the current project's lib/providers
echo "Copying content from the template's lib/providers to the current project's lib/providers..."
cp -r "$TEMP_DIR/lib/providers/"* "$ROOT_DIR/lib/providers/"

# 7. Delete the temporary directory
echo "Deleting the temporary directory..."
rm -rf "$TEMP_DIR"

echo "Setup completed successfully."


#!/bin/bash

echo "🧹 Cleaning cache and rebuilding..."

# Clean .dart_tool directory
rm -rf .dart_tool
rm -rf build

# Clean pub cache (optional, uncomment if needed)
# dart pub cache clean

# Get dependencies
dart pub get

# Deactivate old version
dart pub global deactivate clean_arc 2>/dev/null || true

# Activate new version
dart pub global activate --source path .

echo "✅ Clean Arc tool updated successfully!"
echo "Run 'clean_arc --help' to test"

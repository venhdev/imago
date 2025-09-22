# Flutter Dart CLI Scripts

## Windows (.bat)

### Analyze
flutter pub outdated
flutter pub upgrade

### Build
flutter build apk --flavor dev --dart-define-from-file .env.dev
flutter build appbundle --flavor prod --dart-define-from-file .env
flutter build appbundle --flavor prod --dart-define-from-file .env.dev
dart run build_runner build --delete-conflicting-outputs

### Integration
vendoring_package.bat [package_name]

### Package
dart format --output=none --set-exit-if-changed . && flutter analyze && flutter test && dart pub publish --dry-run
dart format --output=none --set-exit-if-changed . && dart pub publish --force

### Dependencies
flutter pub get --no-example

## macOS/Linux (.sh)

### Analyze
flutter pub outdated
flutter pub upgrade

### Build
flutter build apk --flavor dev --dart-define-from-file .env.dev
flutter build appbundle --flavor prod --dart-define-from-file .env
flutter build appbundle --flavor prod --dart-define-from-file .env.dev
dart run build_runner build --delete-conflicting-outputs

### Integration
./vendoring_package.sh [package_name]

### Package
dart format --output=none --set-exit-if-changed . && flutter analyze && flutter test && dart pub publish --dry-run
dart format --output=none --set-exit-if-changed . && dart pub publish --force

### Dependencies
flutter pub get --no-example
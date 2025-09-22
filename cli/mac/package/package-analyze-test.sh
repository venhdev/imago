#!/bin/bash
dart format --output=none --set-exit-if-changed . && flutter analyze && flutter test && dart pub publish --dry-run

# Contributing to Deep Widget

Thank you for helping improve Deep Widget.

## Before starting

1. Read `README.md` and search existing issues.
2. Use an issue to discuss large behavior or architecture changes first.
3. Fork the repository and create a focused branch from `main`.
4. Never commit personal photos, generated APKs, signing keys or credentials.

## Local validation

Install Flutter `3.44.4` or a compatible stable version, then run:

```powershell
flutter pub get
flutter analyze
flutter test
flutter build apk --debug
```

A private release key is not required for development or pull requests.

## Project conventions

- Keep raw Flutter colors in `lib/core/theme/deep_widget_colors.dart` only.
- Preserve the SamsungOne 400 body and 700 title/button typography contract.
- Keep controls text-only unless a project decision explicitly changes it.
- Preserve PNG alpha and image aspect ratio in both Flutter and Android code.
- Add or update tests for behavior changes.
- Keep pull requests small and avoid unrelated formatting or generated files.

## Pull requests

Describe the problem, the solution, validation performed and any user-visible
change. Link the related issue when one exists. The GitHub CI workflow must pass
before review.

By submitting a contribution, you agree that it is licensed under the project's
MIT License and that you have the right to submit it.

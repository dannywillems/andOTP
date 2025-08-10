# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

andOTP is an open-source two-factor authentication (2FA) Android app written in Java. It supports TOTP (Time-based One-time Passwords) and HOTP (HMAC-based One-time Passwords) with encrypted local storage and multiple backup options.

**Important**: This repository is now being unofficially maintained by [@dannywillems](https://github.com/dannywillems), with active development focusing on modernizing the build system, improving code quality, and maintaining compatibility.

## Build System

This is an Android Gradle project using Android Gradle Plugin 4.1.3.

### Common Commands

```bash
# Build debug APK
./gradlew assembleDebug

# Build release APK
./gradlew assembleRelease

# Run tests
./gradlew test

# Run Android instrumentation tests
./gradlew connectedAndroidTest

# Clean build
./gradlew clean

# Build specific flavor variants
./gradlew assembleFdroidDebug    # F-Droid flavor
./gradlew assemblePlayDebug      # Google Play flavor
```

### Build Configuration

- **Target SDK**: 30 (Android 11)
- **Min SDK**: 22 (Android 5.1)
- **Build flavors**: `fdroid` and `play` (different distribution channels)
- **Debug suffix**: `.dev` is added to application ID for debug builds
- **Java version**: 8 with desugaring enabled for newer language features

## Architecture

### Core Components

1. **Activities** (`app/src/main/java/org/shadowice/flocke/andotp/Activities/`):
   - `MainActivity`: Main entry list with OTP entries
   - `AuthenticateActivity`: Authentication handling
   - `BackupActivity`: Import/export functionality
   - `SettingsActivity`: App configuration

2. **Database** (`app/src/main/java/org/shadowice/flocke/andotp/Database/`):
   - `Entry`: Core OTP entry model (TOTP/HOTP)
   - `EntryList`: Collection management
   - `DatabaseHelper`: Encrypted storage operations

3. **Utilities** (`app/src/main/java/org/shadowice/flocke/andotp/Utilities/`):
   - `EncryptionHelper`: Cryptographic operations
   - `KeyStoreHelper`: Android KeyStore integration
   - `TokenCalculator`: OTP generation algorithms
   - `BackupHelper`: Import/export functionality

4. **Views** (`app/src/main/java/org/shadowice/flocke/andotp/View/`):
   - `EntriesCardAdapter`: RecyclerView adapter for OTP entries
   - `EntryViewHolder`: Individual entry display logic

### Security Architecture

- **Encryption**: Uses Android KeyStore or password-based encryption
- **Database**: Stored in encrypted JSON format
- **Backups**: Support for plain-text, password-protected, and OpenPGP-encrypted exports
- **Broadcast receivers**: For automated backup operations via Tasker

### Key Features

- Multiple OTP types: TOTP, HOTP, MOTP, Steam
- Theming: Light, Dark, and Black (OLED) themes
- Thumbnails: Service-specific icons for easy identification
- Tags: Organization and filtering system
- QR code scanning: Camera and file-based import

## Testing

The project includes both unit tests and instrumentation tests:
- Unit tests: `app/src/test/`
- Instrumentation tests: `app/src/androidTest/`

## Localization

Extensive localization support with string resources in `app/src/main/res/values-*/` directories for multiple languages including German, French, Spanish, Japanese, Chinese, and many others.

## Important Security Considerations

- Never modify encryption/security code without thorough review
- All OTP secrets are stored encrypted using Android KeyStore when available
- Backup operations require careful handling to prevent data loss
- The app uses broadcast receivers for automation - ensure proper security context
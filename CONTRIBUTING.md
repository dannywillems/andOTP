# Contributing to andOTP

Thank you for your interest in contributing to andOTP! This guide will help you get started with development.

**⚠️ Important Notice**: This repository is currently unmaintained. While contributions are welcome, please be aware that maintenance and review may be limited.

## Table of Contents

- [Development Environment Setup](#development-environment-setup)
- [Building the Project](#building-the-project)
- [Contributing Guidelines](#contributing-guidelines)
- [Code Style](#code-style)
- [Testing](#testing)
- [Submitting Changes](#submitting-changes)
- [Translation](#translation)

## Development Environment Setup

### Prerequisites

#### Java Development Kit (JDK)

andOTP requires **Java 17** for the updated build system (Android Gradle Plugin 8.7.3+). Java 17 is mandatory for building the project.

**Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install openjdk-17-jdk
```

**Verify Installation:**
```bash
java -version
javac -version
```

#### Android SDK

**Option 1: Android Studio (Recommended)**

1. Download [Android Studio](https://developer.android.com/studio)
2. Install Android Studio following the setup wizard
3. Open Android Studio and install:
   - Android SDK Platform 35 (Android 15)
   - Android SDK Build-Tools 35.0.0 or latest
   - Android SDK Platform-Tools
   - Android SDK Tools

**Option 2: Command Line Tools Only (Ubuntu/Debian)**

```bash
# Create Android SDK directory
mkdir -p ~/Android/Sdk
cd ~/Android/Sdk

# Download command line tools (replace URL with latest version)
wget https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip
unzip commandlinetools-linux-*_latest.zip
rm commandlinetools-linux-*_latest.zip

# Create proper directory structure
mkdir -p cmdline-tools/latest
mv cmdline-tools/* cmdline-tools/latest/ 2>/dev/null || true

# Add to your shell profile (~/.bashrc, ~/.zshrc, etc.)
export ANDROID_HOME=~/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

# Reload shell configuration
source ~/.bashrc  # or ~/.zshrc

# Install required SDK components
sdkmanager "platform-tools" "platforms;android-35" "build-tools;35.0.0"
```

**Verify Installation:**
```bash
adb --version
android --version  # or sdkmanager --version
```

## Building the Project

### Clone the Repository

```bash
git clone https://github.com/andOTP/andOTP.git
cd andOTP
```

### Recent Build System Updates

The project has been recently modernized (as of latest commits):

- **Updated to Android Gradle Plugin 8.7.3** and **Gradle 8.11.1**
- **Target SDK updated to 35** (Android 15)
- **Fixed Android 12+ compatibility** issues in AndroidManifest.xml
- **Resolved Kotlin dependency conflicts** with consistent version enforcement
- **Fixed Java compilation errors** for newer Android Gradle Plugin versions

If you encounter build issues, ensure you're using the latest version of Android Studio and Gradle.

### Common Build Issues

**Java Version Issues:**
- Make sure you're using Java 17. Check with `java -version`
- If using multiple Java versions, set `JAVA_HOME` to Java 17 installation

**Android 12+ Manifest Issues:**
- These have been fixed in recent commits (b83baf99)
- Ensure you have the latest code from the repository

**Kotlin Dependency Conflicts:**
- These have been resolved with dependency resolution strategy (44ea3501)
- Clean and rebuild if you encounter duplicate class errors:
  ```bash
  make clean
  make build-debug
  ```

### Build Commands

We provide a Makefile for common tasks:

```bash
# Show all available commands
make help

# Build debug APK
make build-debug

# Run tests
make test

# Install debug APK to connected device
make install-debug

# Clean build artifacts
make clean
```

**Alternative Gradle Commands:**
```bash
# Make gradlew executable
chmod +x gradlew

# Build debug APK
./gradlew assembleDebug

# Build release APK
./gradlew assembleRelease

# Run tests
./gradlew test

# Run instrumentation tests (requires connected device/emulator)
./gradlew connectedAndroidTest
```

### Build Variants

andOTP has two build flavors:
- **fdroid**: For F-Droid distribution
- **play**: For Google Play Store distribution

```bash
# Build specific variants
make build-fdroid-debug
make build-play-release
```

## Contributing Guidelines

### Types of Contributions

- **Bug fixes**: Fix existing issues
- **Security improvements**: Enhance app security
- **UI/UX improvements**: Improve user experience
- **Performance optimizations**: Make the app faster
- **Documentation**: Improve docs and help materials
- **Translations**: Add or improve translations
- **Thumbnails**: Add service icons

### Before You Start

1. **Check existing issues** to avoid duplicate work
2. **Create an issue** for new features or significant changes
3. **Security vulnerabilities** should be reported privately
4. **Follow the code style** described below

## Code Style

### Java Code Style

- **Indentation**: 4 spaces (no tabs)
- **Line length**: 120 characters maximum
- **Naming conventions**:
  - Classes: `PascalCase`
  - Methods/variables: `camelCase`
  - Constants: `UPPER_SNAKE_CASE`
- **Comments**: Use meaningful comments, especially for security-related code

### XML Resources

- **Indentation**: 4 spaces
- **Attributes**: One per line for readability
- **Naming**: Use descriptive names with proper prefixes

## Testing

### Running Tests

```bash
# Unit tests
make test

# Instrumentation tests (requires device/emulator)
make test-instrumentation

# All tests
make test-all
```

### Writing Tests

- Write unit tests for utility functions
- Test security-critical code thoroughly
- Include edge cases and error conditions
- Test with different Android versions when relevant

## Submitting Changes

### Pull Request Process

1. **Fork the repository**
2. **Create a feature branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. **Make your changes** following the code style
4. **Test your changes** thoroughly
5. **Update documentation** if needed
6. **Commit with clear messages**:
   ```bash
   git commit -m "Add: Description of your change"
   ```
7. **Push to your fork**:
   ```bash
   git push origin feature/your-feature-name
   ```
8. **Open a pull request** with:
   - Clear description of changes
   - Link to related issues
   - Screenshots for UI changes
   - Test results

### Commit Message Format

Use conventional commit messages:
- `Add: New feature or functionality`
- `Fix: Bug fixes`
- `Update: Improvements to existing features`
- `Remove: Deleted functionality`
- `Docs: Documentation changes`

## Translation

andOTP supports many languages via [Crowdin](https://crowdin.com/project/andotp).

To contribute translations:
1. Create a Crowdin account
2. Join the [andOTP project](https://crowdin.com/project/andotp)
3. Select your language and start translating
4. Follow the translation guidelines on Crowdin

## Security Considerations

⚠️ **Important**: andOTP handles sensitive authentication data.

- **Never log sensitive information** (secrets, passwords, tokens)
- **Use Android KeyStore** when available for cryptographic operations
- **Validate all user inputs** thoroughly
- **Test encryption/decryption** paths carefully
- **Follow Android security best practices**

## Getting Help

- **Issues**: Check existing issues or create a new one
- **Discussions**: Use GitHub Discussions for questions
- **Chat**: 
  - Telegram: [@andOTP](https://t.me/andOTP)
  - Matrix: [#andOTP:tchncs.de](https://matrix.to/#/#andOTP:tchncs.de)

## License

By contributing to andOTP, you agree that your contributions will be licensed under the same [MIT License](LICENSE.txt) that covers the project.

---

Thank you for contributing to andOTP! 🔐
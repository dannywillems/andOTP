# Makefile for andOTP Android project

# Configuration
ANDROID_API_LEVEL = 35

help: ## Ask for help!
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

# Build targets
.PHONY: build-debug
build-debug: ## Build debug APK for both flavors
	./gradlew assembleDebug

.PHONY: build-release
build-release: ## Build release APK for both flavors
	./gradlew assembleRelease

.PHONY: build-fdroid-debug
build-fdroid-debug: ## Build F-Droid debug APK
	./gradlew assembleFdroidDebug

.PHONY: build-fdroid-release
build-fdroid-release: ## Build F-Droid release APK
	./gradlew assembleFdroidRelease

.PHONY: build-play-debug
build-play-debug: ## Build Google Play debug APK
	./gradlew assemblePlayDebug

.PHONY: build-play-release
build-play-release: ## Build Google Play release APK
	./gradlew assemblePlayRelease

# Test targets
.PHONY: test
test: ## Run unit tests
	./gradlew test

.PHONY: test-debug
test-debug: ## Run unit tests with debug output
	./gradlew test --debug

.PHONY: test-instrumentation
test-instrumentation: ## Run Android instrumentation tests (requires connected device/emulator)
	./gradlew connectedAndroidTest

.PHONY: test-all
test-all: test test-instrumentation ## Run all tests (unit + instrumentation)

# Development targets
.PHONY: clean
clean: ## Clean build artifacts
	./gradlew clean

.PHONY: install-debug
install-debug: build-fdroid-debug ## Build and install F-Droid debug APK to connected device
	adb install -r app/build/outputs/apk/fdroid/debug/app-fdroid-debug.apk

.PHONY: uninstall
uninstall: ## Uninstall app from connected device
	adb uninstall org.shadowice.flocke.andotp.dev || true
	adb uninstall org.shadowice.flocke.andotp || true

.PHONY: lint
lint: ## Run Android lint checks
	./gradlew lint

# Code quality targets
.PHONY: format
format: ## Format Java and XML code using Spotless
	./gradlew spotlessApply

.PHONY: format-check
format-check: ## Check code formatting without applying changes
	./gradlew spotlessCheck

.PHONY: checkstyle
checkstyle: ## Run Checkstyle linter on Java code
	./gradlew checkstyleMain

.PHONY: check
check: lint checkstyle format-check test ## Run all checks (lint + checkstyle + format + tests)

# Utility targets
.PHONY: gradle-wrapper
gradle-wrapper: ## Update Gradle wrapper
	./gradlew wrapper

.PHONY: dependencies
dependencies: ## Show project dependencies
	./gradlew dependencies

.PHONY: tasks
tasks: ## Show available Gradle tasks
	./gradlew tasks

.PHONY: device-list
device-list: ## List connected Android devices
	adb devices

.PHONY: logcat
logcat: ## Show logcat output filtered for andOTP
	adb logcat | grep -i andotp

# Emulator targets
.PHONY: emulator-list
emulator-list: ## List available Android emulators
	@avdmanager list avd

.PHONY: emulator-create
emulator-create: ## Create a new Android emulator (API 35)
	@if avdmanager list avd | grep -q "Name: andotp_test"; then \
		echo "Emulator 'andotp_test' already exists. Use 'make emulator-delete' to remove it first."; \
	else \
		echo "Creating Android emulator with API $(ANDROID_API_LEVEL)..."; \
		echo "no" | avdmanager create avd -n andotp_test -k "system-images;android-$(ANDROID_API_LEVEL);google_apis;x86_64" || \
		(echo "Failed! Make sure you have installed the system image with:" && \
		echo "sdkmanager \"system-images;android-$(ANDROID_API_LEVEL);google_apis;x86_64\""); \
	fi

.PHONY: emulator-delete
emulator-delete: ## Delete the andotp_test emulator
	@avdmanager delete avd -n andotp_test

.PHONY: emulator-start
emulator-start: ## Start the andotp_test emulator
	@echo "Starting emulator 'andotp_test'..."
	@if [ -f "$$ANDROID_HOME/emulator/emulator" ]; then \
		$$ANDROID_HOME/emulator/emulator -avd andotp_test -no-audio -no-boot-anim & \
		echo "Emulator started in background. Use 'make emulator-wait' to wait for boot completion."; \
	else \
		echo "Error: Emulator not found. Make sure ANDROID_HOME is set and emulator is installed."; \
		echo "Try: export ANDROID_HOME=/path/to/android/sdk"; \
		exit 1; \
	fi

.PHONY: emulator-wait
emulator-wait: ## Wait for emulator to boot completely
	@echo "Waiting for emulator to boot..."
	@adb wait-for-device
	@echo "Waiting for system to be ready..."
	@while [ "`adb shell getprop sys.boot_completed 2>/dev/null`" != "1" ]; do \
		sleep 2; \
		echo "Still waiting for boot..."; \
	done
	@echo "Emulator is ready!"

.PHONY: emulator-stop
emulator-stop: ## Stop all running emulators
	@echo "Stopping all emulators..."
	@adb devices | grep emulator | cut -f1 | xargs -I {} adb -s {} emu kill

.PHONY: emulator-install-debug
emulator-install-debug: build-fdroid-debug emulator-wait ## Build and install debug APK to emulator
	@echo "Installing debug APK to emulator..."
	@adb install -r app/build/outputs/apk/fdroid/debug/app-fdroid-debug.apk
	@echo "App installed successfully!"

.PHONY: emulator-run
emulator-run: emulator-install-debug ## Build, install, and launch andOTP in emulator
	@echo "Launching andOTP..."
	@adb shell am start -n org.shadowice.flocke.andotp.dev/org.shadowice.flocke.andotp.Activities.MainActivity
	@echo "andOTP launched! Check the emulator screen."

.PHONY: emulator-test-full
emulator-test-full: emulator-start emulator-run ## Complete emulator test: start emulator, build, install, and run app
	@echo "Complete emulator test completed!"

# APK information
.PHONY: apk-info
apk-info: ## Show information about built APKs
	@echo "Looking for APK files..."
	@find app/build/outputs/apk -name "*.apk" -exec echo "APK: {}" \; -exec aapt dump badging {} \; 2>/dev/null || echo "No APK files found. Run 'make build-debug' first."

# Cleanup targets
.PHONY: clean-all
clean-all: clean ## Clean everything including Gradle cache
	rm -rf ~/.gradle/caches/
	./gradlew --stop

.PHONY: reset
reset: clean-all ## Complete reset - clean all build artifacts and caches
	rm -rf app/build/
	rm -rf build/
	rm -rf .gradle/

.DEFAULT_GOAL := help
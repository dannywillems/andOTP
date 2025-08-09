# Makefile for andOTP Android project

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

.PHONY: check
check: lint test ## Run all checks (lint + tests)

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
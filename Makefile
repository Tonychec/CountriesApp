.PHONY: bootstrap format lint build test guards verify codegen

PROJECT = CountriesTestApp/CountriesTestApp.xcodeproj
SCHEME = CountriesTestApp
DESTINATION = platform=iOS Simulator,name=iPhone 18 Pro,OS=27.0
XCODEBUILD = xcodebuild -project $(PROJECT) -scheme $(SCHEME) -destination '$(DESTINATION)' -quiet
# Packages with test targets; each is tested through its auto-generated SwiftPM scheme.
TEST_PACKAGES = CountriesData CountriesUI

bootstrap:
	brew install swiftformat swiftlint

format:
	swiftformat .
	swiftlint lint --fix --quiet

lint:
	swiftlint lint --strict --quiet
	swiftformat --lint .

# Fetches the schema and regenerates Packages/CountriesData/Sources/CountriesAPI.
codegen:
	scripts/codegen.sh

build:
	$(XCODEBUILD) build

test:
	@set -e; log=$$(mktemp); trap 'rm -f "$$log"' EXIT; \
	for pkg in $(TEST_PACKAGES); do \
		printf "Testing %s: " "$$pkg"; \
		if (cd Packages/$$pkg && xcodebuild test -scheme $$pkg -destination '$(DESTINATION)' >"$$log" 2>&1); then \
			grep -E "Test run with|Executed [0-9]+ test" "$$log" | tail -1 | sed 's/^[^A-Za-z]*//'; \
		else \
			echo "FAILED"; grep -v "\[MT\]" "$$log" | tail -60; exit 1; \
		fi; \
	done

# Architecture guards: each grep must find nothing.
guards:
	@! grep -rn "import Apollo\|import CountriesAPI" Packages/CountriesUI --exclude-dir=.build
	@! grep -rnE "Color\(red:|UIColor\(red:|#[0-9A-Fa-f]{6}" Packages CountriesTestApp --exclude-dir=.build
	@! grep -rn "completion:\|@escaping (" Packages/*/Sources
	@! grep -rn "@unchecked Sendable\|nonisolated(unsafe)" Packages/*/Sources

verify: build lint guards test

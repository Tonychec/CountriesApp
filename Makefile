.PHONY: bootstrap format lint build test guards verify codegen

PROJECT = CountriesTestApp/CountriesTestApp.xcodeproj
SCHEME = CountriesTestApp
DESTINATION = platform=iOS Simulator,name=iPhone 18 Pro,OS=27.0
XCODEBUILD = xcodebuild -project $(PROJECT) -scheme $(SCHEME) -destination '$(DESTINATION)' -quiet

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
	$(XCODEBUILD) test

# Architecture guards (PLAN.md §2.1): each grep must find nothing.
guards:
	@! grep -rn "import Apollo\|import CountriesAPI" Packages/CountriesUI --exclude-dir=.build
	@! grep -rnE "Color\(red:|UIColor\(red:|#[0-9A-Fa-f]{6}" Packages CountriesTestApp --exclude-dir=.build
	@! grep -rn "completion:\|@escaping (" Packages/*/Sources
	@! grep -rn "@unchecked Sendable\|nonisolated(unsafe)" Packages/*/Sources

verify: build lint guards test

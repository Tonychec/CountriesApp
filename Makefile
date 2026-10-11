.PHONY: bootstrap format lint

bootstrap:
	brew install swiftformat swiftlint

format:
	swiftformat .
	swiftlint lint --fix --quiet

lint:
	swiftlint lint --strict --quiet
	swiftformat --lint .

#!/bin/sh
# Fetches the Countries schema and generates CountriesAPI with apollo-ios-cli.
# The CLI is installed by Apollo's own SPM plugin, so its version always matches Package.resolved.
#
# Usage: scripts/codegen.sh               fetch the schema, then generate code
#        scripts/codegen.sh --fetch-only  only download graphql/schema.graphqls
set -eu

cd "$(dirname "$0")/../Packages/CountriesData"

swift package resolve

# Kept in .build so it's never committed and stays out of lint and guards.
CLI=.build/apollo-ios-cli
RESOLVED_VERSION=$(sed -n '/"apollo-ios"/,/"version"/s/.*"version" *: *"\(.*\)".*/\1/p' Package.resolved)

if [ ! -x "$CLI" ] || [ "$("$CLI" --version)" != "$RESOLVED_VERSION" ]; then
    rm -f "$CLI"
    swift package --allow-writing-to-package-directory --allow-network-connections all apollo-cli-install
    mv apollo-ios-cli "$CLI"
fi

"$CLI" fetch-schema --path apollo-codegen-config.json

if [ "${1:-}" != "--fetch-only" ]; then
    "$CLI" generate --path apollo-codegen-config.json
fi

import CountriesDomain
import SwiftUI

struct CountryRow: View {
    let country: CountrySummary

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @ScaledMetric(relativeTo: .title) private var flagSize = 32

    var body: some View {
        // Side by side normally; stacked at accessibility sizes so long names keep the full width.
        let layout = dynamicTypeSize.isAccessibilitySize
            ? AnyLayout(VStackLayout(alignment: .leading))
            : AnyLayout(HStackLayout())

        layout {
            Text(country.emoji)
                .font(.system(size: flagSize))
                // The name follows; VoiceOver would otherwise say "flag: Germany, Germany".
                .accessibilityHidden(true)
            VStack(alignment: .leading) {
                Text(country.name)
                    .font(.body)
                Text(country.continent.name)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

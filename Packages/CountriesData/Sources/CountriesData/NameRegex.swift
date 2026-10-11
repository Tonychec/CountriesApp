import Foundation

/// Builds the `regex` name filter for the Countries API, which matches case-sensitively and
/// rejects the `(?i)` flag. Each letter becomes a `[xX]` class instead, after escaping metacharacters.
enum NameRegex {
    private static let metacharacters: Set<Character> = [
        "\\", "^", "$", ".", "|", "?", "*", "+", "(", ")", "[", "]", "{", "}",
    ]

    /// Returns `nil` when `name` is blank, meaning "send no filter".
    static func caseInsensitivePattern(for name: String) -> String? {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        return trimmed.map(pattern(for:)).joined()
    }

    private static func pattern(for character: Character) -> String {
        if metacharacters.contains(character) {
            return "\\\(character)"
        }
        let lower = character.lowercased()
        let upper = character.uppercased()
        // Digits, punctuation and letters without a one-character pair (e.g. "ß" → "SS") match as-is.
        guard lower != upper, lower.count == 1, upper.count == 1 else {
            return String(character)
        }
        return "[\(lower)\(upper)]"
    }
}

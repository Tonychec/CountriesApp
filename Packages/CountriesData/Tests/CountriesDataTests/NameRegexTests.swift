@testable import CountriesData
import Testing

struct NameRegexTests {
    @Test(arguments: [
        ("ger", "[gG][eE][rR]"),
        ("GER", "[gG][eE][rR]"),
        ("  ger \n", "[gG][eE][rR]"),
        ("(", #"\("#),
        ("St.", #"[sS][tT]\."#),
        ("Å", "[åÅ]"),
        ("ß", "ß"),
        ("a b", "[aA] [bB]"),
    ])
    func buildsCaseInsensitivePattern(input: String, expected: String) {
        #expect(NameRegex.caseInsensitivePattern(for: input) == expected)
    }

    @Test(arguments: ["", "  ", "\n\t"])
    func blankInputMeansNoFilter(input: String) {
        #expect(NameRegex.caseInsensitivePattern(for: input) == nil)
    }
}

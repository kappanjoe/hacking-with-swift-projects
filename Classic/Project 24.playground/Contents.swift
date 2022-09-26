import UIKit

let name = "Taylor"

for letter in name {
    print("Give me a \(letter)!")
}

// Can't read characters like:
// print(name[3])

let letter = name[name.index(name.startIndex, offsetBy: 3)]

// someString.count iterates over entire length
// use .isEmpty to check instead

let password = "12345"
password.hasPrefix("123")
password.hasSuffix("345")

extension String {
    // remove prefix if it exists
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
    // remove a suffix if it exists
    func deletingSuffix(_ suffix: String) -> String {
        guard self.hasSuffix(suffix) else { return self }
        return String(self.dropLast(suffix.count))
    }
}
print(password.deletingPrefix("123"))
print(password.deletingSuffix("345"))

let weather = "it's going to rain"
print(weather.capitalized)

extension String {
    var capitalizedFirst: String {
        guard let firstLetter = self.first else { return "" }
        return firstLetter.uppercased() + self.dropFirst()
    }
    // .uppercased is a method on Character, but returns a String! (For reasons such as “ß” becomes “SS” in German)
}
print(weather.capitalizedFirst)

let input = "Swift is like Objective-C without the C"
input.contains("Swift")

let languages = ["Python", "Ruby", "Swift"]
languages.contains("Swift")

// Works, but inelegant:
extension String {
    func containsAny(of array: [String]) -> Bool {
        for item in array {
            if self.contains(item) {
                return true
            }
        }
        
        return false
    }
}

input.containsAny(of: languages)

// input.contains matches the same signature contants(where:) is expecting, so contains(where:) will automatically iterate over the elements in languages, passing them in as the argument for input.contains
languages.contains(where: input.contains)

let string = "This is a test string."
let attributes: [NSAttributedString.Key: Any] = [
    .foregroundColor: UIColor.white,
    .backgroundColor: UIColor.red,
    .font: UIFont.boldSystemFont(ofSize: 36)
]
let attributedString = NSAttributedString(string: string, attributes: attributes)

let attributedString2 = NSMutableAttributedString(string: string)
attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 8), range: NSRange(location: 0, length: 4))
attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 16), range: NSRange(location: 5, length: 2))
attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 24), range: NSRange(location: 8, length: 1))
attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 32), range: NSRange(location: 10, length: 4))
attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 40), range: NSRange(location: 15, length: 6))

// There are lots of formatting options for attributed strings, including but not limited to:
//
// Set .underlineStyle to a value from NSUnderlineStyle to strike out characters.
// Set .strikethroughStyle to a value from NSUnderlineStyle (no, that’s not a typo) to strike out characters.
// Set .paragraphStyle to an instance of NSMutableParagraphStyle to control text alignment and spacing.
// Set .link to be a URL to make clickable links in your strings.

extension String {
    func withPrefix(_ prefix: String) -> String {
        guard !self.hasPrefix(prefix) else { return self }
        return String(prefix + self)
    }
}
"pet".withPrefix("car")

extension String {
    var isNumeric: Bool {
        for character in self {
            if character.isNumber {
                return true
            } else {
                continue
            }
        }
        return false
    }
}
"alpha5beta2".isNumeric
"alphabet".isNumeric

extension String {
    var lines: [String] {
        guard self.contains("\n") else { return [] }
        return self.split(separator: "\n").map({ line in
            return String(line)
        })
    }
}
"this\nis\na\ntest".lines

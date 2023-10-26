//: [Previous](@previous)

import Foundation

/// An example of grouping a collection of words by ranges of first character and querying it by those ranges.
///
/// First, build character ranges by which to group words.
/// Then read in words from file at `url` (expected one word per line) and shuffle them.
/// Finally, select a subset of randomized words, group them by first character range
/// and turn the resulting dictionary into a `RangeMap` so that we can efficiently query values
/// within an artbirary range of first characters.
///
/// Turning Dictionaries into RangeMaps has a toll of having to sort the keys.

let url = URL(fileURLWithPath: "/usr/share/dict/words")
var sampleSize: Int = 250

// build character ranges by which to group words
let firstCharCode = "a".unicodeScalars.first!.value
let lastCharCode = "z".unicodeScalars.first!.value
let charRanges: [Range<Character>] = stride(from: firstCharCode, through: lastCharCode, by: 3).compactMap { aCode in
    guard let fromCode = Unicode.Scalar(aCode) else { return nil }
    guard let toCode = Unicode.Scalar(min(aCode + 3, lastCharCode + 1)) else { return nil }
    return Character(fromCode)..<Character(toCode)
}

// read in words from a file, removing short strings and shuffling the result
var words = String(data: try! Data(contentsOf: url), encoding: .utf8)!
    .split(separator: "\n")
    .filter { $0.count > 1 }
    .shuffled()

// build `RangeMap` from a dictionary of words grouped by first character ranges
let wordMap = try! words[0..<sampleSize]
    .map { String($0).lowercased() }
    .grouped { aWord in
        charRanges.first { $0.contains(aWord.first!) }!
    }
    .rangeMap()

let fromXToZ = wordMap.values(in: Character("x")..<Character("z")).flatMap { $0 }
print("From x-z: \(fromXToZ)")

//: [Next](@next)

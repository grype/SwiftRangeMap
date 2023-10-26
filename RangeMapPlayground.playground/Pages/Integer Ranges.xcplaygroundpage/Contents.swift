//: [Previous](@previous)

import Foundation
import RangeMap

/// 

let map: RangeMap<Int, String> = .init()

map.set(in: 1..<3, "b")
map.set(in: 5..<8, "c")
map.set(in: 0..<2, "a")
map.set(in: 6..<7, "d")

// values within given range
map.values(in: 0..<8) == ["a", "b", "c", "d", "c"]

// values within sequential subranges formed by striding within a given range
// (i.e. 0..<1, 1..<2, ... 7..<8)
map.values(in: 0..<8, by: 1) == [["a"], ["a"], ["b"], [], [], ["c"], ["d"], ["c"]]

// (i.e. 0..<2, 2..<4, 4..<6, 6..<8)
map.values(in: 0..<8, by: 2) == [["a"], ["b"], ["c"], ["d", "c"]]

map.value(at: 0) == "a"
map.value(at: 2) == "b"

// values at given values 
map.values(from: 0, to: 8, by: 1) == ["a", "a", "b", nil, nil, "c", "d", "c"]

//: [Next](@next)

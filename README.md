# RangeMap

In some form or another, this question gets asked in job interviews:

Create a data structure that can store and recall values by ranges. There are many ways to do this, all depend on the application of such data structure. For example - in some cases we want to optimize on space, in some - on time to store associations, in others - to recall them, and yet in others - to be able to undo the operations.

This is a basic data structure that aims to optimize on space by only storing ranges and associated values, breaking up overlapping ranges as needed. It also aims to optimize on retrieval by keeping a sorted array of ranges. That being said - there's a slight penalty incurred during insertion, required to insert new ranges into a sorted array.

`SortedArray` was added to keep the array sorted. It is a partial implementation as it doesn't fully conform to Collection protocol.

`RangeMap` is essentially a dictionary and a sorted array of keys into that array. This also provides a way to convert to/fro a normal `Dictionary`, with an added penalty of sorting the keys when converting it into a `RangeMap`.

Example:

```
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
```

This works with anything that can be used to define a range - e.g. `Date`s, etc. See the included Playground for more examples.
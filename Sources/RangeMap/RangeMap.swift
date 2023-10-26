import Foundation

/**
 I map values by key ranges.
 
 Setting new values for overlapping ranges will result in the removal of existing range, splitting it is possible to preserve non-overlapping subranges.
 
 I can be initialized to a blank state with - e.g. `RangeMap<Int,String>()`, or with existing collection of paired values - e.g. `RangeMap<Int,String>([0..<1>:"One"])`. The only penalty incurred in the second method is initialization of a sorted key array.
 
 **Example**
 ```
 let map: RangeMap<Int,String> = .init()
 map.set(in: 0..<42, "Meaning")
 map.values(in: 0..<3) // ["Meaning"]
 
 map.set(in: 9..<10, "Hidden")
 map.values(in: 0..<10) // ["Meaning", "Hidden"]
 map.values(in: 0..<100) // ["Meaning", "Hidden", "Meaning"]
 ```
 */
public class RangeMap<Key, Value> where Key: Comparable & Hashable {
    // MARK: - Properties

    public private(set) var ranges: SortableArray<Range<Key>>
    
    public private(set) var store: [Range<Key>: Value]
    
    // MARK: - Init
    
    public init() {
        ranges = SortableArray(sortBlock: { $0 < $1 })
        store = [:]
    }
    
    public init(_ aDictionary: [Range<Key>: Value]) throws {
        ranges = try SortableArray(aDictionary.keys, sortBlock: { $0 < $1 })
        store = aDictionary
    }
    
    // MARK: - Accessing
    
    public var firstRange: Range<Key>? { ranges.first }
    
    public var lastRange: Range<Key>? { ranges.last }

    public func set(in aRange: Range<Key>, _ aValue: Value) {
        guard var index = ranges.firstIndex(where: { $0.overlaps(aRange) }) else {
            unsafeInsert(in: aRange, aValue)
            return
        }
        
        repeat {
            let oldRange = ranges[index]
            guard oldRange != aRange else {
                store[aRange] = aValue
                continue
            }
            
            let oldValue = store.removeValue(forKey: oldRange)!
            ranges.remove(at: index)
            
            if oldRange.lowerBound < aRange.lowerBound {
                unsafeInsert(in: oldRange.lowerBound..<aRange.lowerBound, oldValue)
                index += 1
            }
            if aRange.upperBound < oldRange.upperBound {
                unsafeInsert(in: aRange.upperBound..<oldRange.upperBound, oldValue)
            }
        } while index < ranges.endIndex && ranges[index].overlaps(aRange)
        
        unsafeInsert(in: aRange, aValue)
    }
    
    public func value(at aKey: Key) -> Value? where Key: Strideable  {
        let range = aKey..<aKey.advanced(by: 1)
        guard let index = ranges.firstIndex(where: { $0.overlaps(range) }) else {
            return nil
        }
        return store[ranges[index]]
    }

    public func values(in aRange: Range<Key>) -> [Value] {
        ranges.filter { $0.overlaps(aRange) }.compactMap { store[$0] }
    }
    
    public func values(in aRange: Range<Key>, by aStride: Key.Stride) -> [[Value]] where Key: Strideable {
        guard let from = ranges.first?.lowerBound, let to = ranges.last?.upperBound else { return [] }
        return stride(from: from, to: to, by: aStride).map { aLowerBound in
            values(in: aLowerBound..<aLowerBound.advanced(by: aStride))
        }
    }
    
    public func values(from: Key, to: Key, by aStride: Key.Stride) -> [Value?] where Key: Strideable {
        return stride(from: from, to: to, by: aStride).map { aLowerBound in
            values(in: aLowerBound..<aLowerBound.advanced(by: 1)).first
        }
    }
    
    // MARK: - Private
    
    private func unsafeInsert(in aRange: Range<Key>, _ aValue: Value) {
        store[aRange] = aValue
        ranges.add(aRange)
    }
}

// MARK: - Extensions

extension Range: Comparable where Bound: Comparable {
    public static func < (lhs: Range<Bound>, rhs: Range<Bound>) -> Bool {
        lhs.lowerBound < rhs.lowerBound || lhs.upperBound < rhs.upperBound
    }
}

public extension Dictionary {
    func rangeMap<K>() throws -> RangeMap<K, Value> where Key == Range<K>, K: Hashable & Comparable {
        try RangeMap(self)
    }
}

public extension RangeMap {
    var dictionary: [Range<Key>:Value] {
        return store
    }
}

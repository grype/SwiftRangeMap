import Foundation

/**
 I am a sortable array.

 I behave like a collection of Comparable elements that I keep sorted using a given block.

 **Notes**

 I am a partial implementation, missing a lot of methods that should be proxied over to my internal `store`.

 **Example**
 ```
 var sortable = [1, 4, 2].sortable { $0 < $1 }
 print(sortable)    // [1, 2, 4]
 sortable.add(3)
 print(sortable)    // [1, 2, 3, 4]

 print(sortable[2]) // 3
 ```
 */

public struct SortableArray<Element: Comparable>: Collection {
    public typealias Index = Array<Element>.Index

    public var sortBlock: (Element, Element) throws -> Bool

    fileprivate var store: [Element] = []

    // MARK: - Init

    public init(sortBlock: @escaping (Element, Element) throws -> Bool) {
        self.sortBlock = sortBlock
    }

    public init<A: Collection<Element>>(_ aCollection: A, sortBlock: @escaping (Element, Element) throws -> Bool) throws {
        self.sortBlock = sortBlock
        store = try aCollection.sorted(by: sortBlock)
    }

    // MARK: - Collection

    public subscript(position: Index) -> Element {
        store[position]
    }

    public var startIndex: Index { store.startIndex }

    public var endIndex: Index { store.endIndex }

    public func index(after i: Index) -> Index {
        store.index(after: i)
    }

    // MARK: - Accessing

    var first: Element? { store.first }

    var last: Element? { store.last }

    // MARK: - Adding

    public mutating func add(_ anElement: Element) {
        guard let index = store.firstIndex(where: {
            guard let result = try? sortBlock(anElement, $0) else { return false }
            return result
        }) else {
            store.append(anElement)
            return
        }
        store.insert(anElement, at: index)
    }

    public func adding(_ anElement: Element) throws -> SortableArray<Element> {
        try SortableArray(store + [anElement], sortBlock: sortBlock)
    }

    // MARK: - Removing

    public mutating func remove(at anIndex: Int) {
        store.remove(at: anIndex)
    }

    public mutating func removeAll() {
        store.removeAll()
    }
}

extension SortableArray: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String { store.description }
    public var debugDescription: String { store.debugDescription }
}

public extension Array where Element: Comparable {
    func sortable(using aBlock: @escaping (Element, Element) -> Bool) -> SortableArray<Element>? {
        try? SortableArray(self, sortBlock: aBlock)
    }
}

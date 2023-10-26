import Foundation

extension Collection {
    /// Groups elements by result of given block
    public func grouped<Key>(by aBlock: (Element) -> Key) -> [Key: [Element]] where Key: Hashable {
        var result: [Key: [Element]] = .init()
        forEach { anElement in
            let key = aBlock(anElement)
            var values = result[key] ?? []
            values.append(anElement)
            result[key] = values
        }
        return result
    }
}

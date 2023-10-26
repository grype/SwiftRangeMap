@testable import RangeMap
import XCTest

final class RangeMapTests: XCTestCase {
    var map: RangeMap<Int, String>!
    
    override func setUp() {
        super.setUp()
        map = .init()
    }
    
    override func tearDown() {
        map = nil
    }
    
    func testInsertingSingleValue() {
        map.set(in: 0..<2, "a")
        XCTAssert(Array(map.ranges) == [0..<2])
        XCTAssert(map.store == [0..<2: "a"])
    }
    
    func testInsertingNonOverlappingRange() {
        map.set(in: 0..<2, "a")
        map.set(in: 5..<8, "c")
        XCTAssert(Array(map.ranges) == [0..<2, 5..<8])
        XCTAssert(map.store == [0..<2: "a", 5..<8: "c"])
        print(map.store)
    }
    
    func testInsertingCompletelyOverlappingRange() {
        map.set(in: 1..<2, "a")
        map.set(in: 0..<3, "b")
        XCTAssert(Array(map.ranges) == [0..<3])
        XCTAssert(map.store == [0..<3: "b"])
        print(map.store)
    }
    
    func testInsertingPartiallyOverlappingRange() {
        map.set(in: 0..<2, "a")
        map.set(in: 1..<3, "b")
        XCTAssert(Array(map.ranges) == [0..<1, 1..<3])
        XCTAssert(map.store == [0..<1: "a", 1..<3: "b"])
        print(map.store)
    }
    
    func testInsertingRangeThatPartiallyOverlapsTwoOthers() {
        map.set(in: 0..<2, "a")
        map.set(in: 4..<6, "b")
        map.set(in: 1..<5, "c")
        XCTAssert(Array(map.ranges) == [0..<1, 1..<5, 5..<6])
        XCTAssert(map.store == [0..<1: "a", 1..<5: "c", 5..<6: "b"])
        print(map.store)
    }
}

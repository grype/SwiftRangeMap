import Foundation
import RangeMap

/// Using date ranges to store values.
///
/// In this example, we associate "Work" with an 8-hour period from now
/// We then associate 5-minute "Break" periods every 15 minutes from now
/// And finally associate 15-minute "Long Break" periods every 90 minutes from now

// MARK: - Dates

let dates: RangeMap<Date, String> = .init()

let now = Date.now
let workDuration: TimeInterval = 8*60*60

dates.set(in: now..<now+workDuration, "Work")

stride(from: now, to: now+workDuration, by: 15*60).reduce(now) { partialResult, aDate in
    if aDate != now {
        dates.set(in: aDate..<aDate+5, "Break")
    }
    return aDate
}

stride(from: now, to: now+workDuration, by: 90*60).reduce(now) { partialResult, aDate in
    if aDate != now {
        dates.set(in: aDate..<aDate+15, "Long Break")
    }
    return aDate
}

// print the entire schedule
dates.ranges.forEach { aRange in
    print("\(aRange.lowerBound): \(dates.store[aRange]!)")
}

// print out what's happening every 5 minutes within the next hour
print(dates.values(from: now, to: now+60*60, by: 5*60))

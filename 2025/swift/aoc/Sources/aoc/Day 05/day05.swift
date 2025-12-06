struct day05 {
    static func run(isExample: Bool = false) {
        let input = readLinesFromFile(at: "Sources/aoc/Day 05/\(isExample ? "example" : "input").txt");


        let index = input.firstIndex(of: "");

        let freshRanges = input[0 ..< index!].compactMap { line -> ClosedRange<Int> in
            let parts = line.split(separator: "-").map { Int($0)! }
            return parts[0]...parts[1]
        }

        var freshCount = 0;

        for id in input[index! + 1 ..< input.count - 1] {
            if freshRanges.contains(where: { $0.contains(Int(id)!) }) {
                freshCount += 1
            }
        }

        print("Fresh IDs count: \(freshCount)")

        var uniqueRanges: [ClosedRange<Int>] = []

        func clampRange(range: ClosedRange<Int>) -> [ClosedRange<Int>] {
            let overlap = uniqueRanges.first(where: { $0.overlaps(range) })
            if overlap == nil { return [range] }
            if overlap!.contains(range.lowerBound) && overlap!.contains(range.upperBound) {
                return []
            }
            if range.upperBound > overlap!.upperBound && range.lowerBound < overlap!.lowerBound {
                let lower = clampRange(range: ClosedRange(uncheckedBounds: (lower: range.lowerBound, upper: overlap!.lowerBound - 1)))
                let upper = clampRange(range: ClosedRange(uncheckedBounds: (lower: overlap!.upperBound + 1, upper: range.upperBound)))
                return [lower, upper].flatMap({ $0 })
            }
            if range.upperBound >= overlap!.lowerBound && overlap!.lowerBound > range.lowerBound  {
                return clampRange(range: ClosedRange(uncheckedBounds: (lower: range.lowerBound, upper: overlap!.lowerBound - 1)))
            }
            if range.lowerBound <= overlap!.upperBound && overlap!.upperBound < range.upperBound {
                return clampRange(range: ClosedRange(uncheckedBounds: (lower: overlap!.upperBound + 1, upper: range.upperBound)))
            }
            print("This shouldn't happen")
            return []
        }

        for i in freshRanges.indices {
            let range = clampRange(range: freshRanges[i])
            uniqueRanges.append(contentsOf: range)
        }

        print(uniqueRanges)
        

        let freshIdCount = uniqueRanges
        .reduce(0) { partialResult, range in
            partialResult + (range.upperBound - range.lowerBound + 1)
        }
        print("Number of Fresh IDs: \(freshIdCount)")
    }
}

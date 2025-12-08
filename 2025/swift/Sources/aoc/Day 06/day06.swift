struct day06 {
    static func run(context: DayContext) {
        let input = context.input
        guard !input.isEmpty else {
            print("Day 06 received empty input.")
            return
        }

        if context.runPartTwo {
            var part2Total: Int128 = 0
            var operations: [[String]] = []

            for x in 0..<input[0].count {
                var column: [String] = []
                for line in input {
                    guard x < line.count else { continue }
                    let index = line.index(line.startIndex, offsetBy: x)
                    column.append(String(line[index]))
                }
                operations.append(column)
            }

            var operation = ""
            var currentCalc: Int128? = nil

            for op in operations {
                let newOperation = op[op.count - 1]
                let numbers = Int128(op[0 ..< op.count - 1].joined().trimmingCharacters(in: .whitespacesAndNewlines))

                if newOperation != " " {
                    operation = newOperation
                    part2Total += currentCalc ?? 0
                    currentCalc = numbers
                    continue
                }

                if currentCalc == nil {
                    currentCalc = numbers
                    continue
                }

                if numbers == nil { continue }

                switch operation {
                case "+":
                    currentCalc! += numbers!
                case "*":
                    currentCalc! *= numbers!
                default:
                    print("Unknown operation: \(operation)")
                }
            }
            part2Total += currentCalc ?? 0

            print("Part 2 Total: \(part2Total)")
            return
        }

        let transposed: [[String]] = input
            .map({ $0.split(separator: " ").map(String.init) })
            .filter({ $0.count > 0 })
            .reduce(into: [[String]]()) { partialResult, row in
                for (i, value) in row.enumerated() {
                    if partialResult.count <= i {
                        partialResult.append([])
                    }
                    partialResult[i].append(value)
                }
            }

        var total: Int128 = 0

        for column in transposed {
            let operation = column[column.count - 1]
            let numbers = column[0 ..< column.count - 1].compactMap { Int128($0) }

            switch operation {
            case "+":
                total += numbers.reduce(0, +)
            case "*":
                total += numbers.reduce(1, *)
            default:
                print("Unknown operation: \(operation)")
            }
        }

        print("Total: \(total)")
    }
}
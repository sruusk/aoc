struct day07 {
    static func run(context: DayContext) {
        var input = context.input.map { Array($0) }
        if input.last?.isEmpty == true { input.removeLast() }

        let startIndex: Int = input[0].count / 2

        guard input[0][startIndex] == "S" else {
            print("Could not find starting position in input")
            return
        }

        if context.runPartTwo {
            var memo = Array(repeating: Array<Int?>(repeating: nil, count: input[0].count), count: input.count)
            let beamCount: Int = splitBeamsPart2(input: input, height: 1, pos: startIndex, memo: &memo) + 1
            print("Total beam count (part 2): \(beamCount)")
        } else {
            let beamCount: Int = splitBeams(input: &input, height: 1, pos: startIndex)
            print("Total beam count: \(beamCount)")
        }
    }

    private static func splitBeams(input: inout [[Character]], height: Int, pos index: Int) -> Int {
        guard height < input.count, index >= 0, index < input[height].count else {
            return 0
        }

        switch input[height][index] {
            case ".":
                input[height][index] = "|"
                return splitBeams(input: &input, height: height + 1, pos: index)
            case "^":
                return 1 +
                    splitBeams(input: &input, height: height + 1, pos: index - 1) +
                    splitBeams(input: &input, height: height + 1, pos: index + 1)
            case "|":
                return 0
            default:
                print("Unknown beam character: \(input[height][index])")
                return 0
        }
    }

    private static func splitBeamsPart2(input: [[Character]], height: Int, pos index: Int, memo: inout [[Int?]]) -> Int {
        guard height < input.count, index >= 0, index < input[height].count else {
            return 0
        }

        if let cached = memo[height][index] {
            return cached
        }

        let result: Int
        switch input[height][index] {
        case ".":
            result = splitBeamsPart2(input: input, height: height + 1, pos: index, memo: &memo)
        case "^":
            result = 1 +
                splitBeamsPart2(input: input, height: height + 1, pos: index - 1, memo: &memo) +
                splitBeamsPart2(input: input, height: height + 1, pos: index + 1, memo: &memo)
        default:
            print("Unknown beam character: \(input[height][index])")
            result = 0
        }

        memo[height][index] = result
        return result
    }
}
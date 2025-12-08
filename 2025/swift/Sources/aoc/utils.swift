import Foundation

func readLinesFromFile(at path: String) -> [String] {
    guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
        print("Error opening file at \(path)")
        return []
    }
    guard let content = String(data: data, encoding: .utf8) else {
        print("Unable to decode file as UTF-8")
        return []
    }
    return content.components(separatedBy: .newlines)
}

struct DayContext {
    let input: [String]
    let isExample: Bool
    let runPartTwo: Bool
    private let restartTimerHandler: () -> Void

    init(input: [String], isExample: Bool, runPartTwo: Bool, restartTimer: @escaping () -> Void) {
        self.input = input
        self.isExample = isExample
        self.runPartTwo = runPartTwo
        self.restartTimerHandler = restartTimer
    }

    func restartTimer() {
        restartTimerHandler()
    }
}

func paddedDayNumber(_ number: Int) -> String {
    String(format: "%02d", number)
}

func dayFolderPath(for number: Int) -> String {
    "Sources/aoc/Day \(paddedDayNumber(number))"
}

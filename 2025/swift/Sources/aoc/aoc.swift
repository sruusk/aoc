import Foundation

struct DayDescriptor {
    let number: Int
    let run: (DayContext) -> Void

    var label: String {
        "Day \(paddedDayNumber(number))"
    }
}

struct DayTemplateGenerator {
    enum TemplateError: Error {
        case alreadyExists
    }

    static func create(dayNumber: Int) throws {
        let folder = dayFolderPath(for: dayNumber)
        let fileManager = FileManager.default

        if fileManager.fileExists(atPath: folder) {
            throw TemplateError.alreadyExists
        }

        try fileManager.createDirectory(atPath: folder, withIntermediateDirectories: true)

        let structName = "day\(paddedDayNumber(dayNumber))"
        let swiftPath = "\(folder)/\(structName).swift"
        let dayLabel = paddedDayNumber(dayNumber)
        let template = """
struct \(structName) {
    static func run(context: DayContext) {
        var input = context.input
        if input.last == "" { input.removeLast() }

        if context.runPartTwo {
            print("Day \(dayLabel) part 2 not implemented yet.")
            return
        }

        context.restartTimer()
        print("Day \(dayLabel) not implemented yet. Lines: \\(input.count)")
    }
}
"""

        try template.write(toFile: swiftPath, atomically: true, encoding: .utf8)
        try "".write(toFile: "\(folder)/example.txt", atomically: true, encoding: .utf8)
        try "".write(toFile: "\(folder)/input.txt", atomically: true, encoding: .utf8)
    }
}

@main
@MainActor
struct aoc {
    private static let registeredDays: [DayDescriptor] = [
        DayDescriptor(number: 5, run: day05.run(context:)),
        DayDescriptor(number: 6, run: day06.run(context:)),
        DayDescriptor(number: 7, run: day07.run(context:)),
        DayDescriptor(number: 8, run: day08.run(context:)),
    ]

    static func main() {
        let days = registeredDays.sorted { $0.number < $1.number }
        guard let defaultDay = days.last?.number else {
            print("No days registered yet. Add a day before running.")
            return
        }

        print("Registered days: \(days.map { paddedDayNumber($0.number) }.joined(separator: ", "))")

        guard let targetDay = selectDay(defaultDay: defaultDay) else {
            return
        }

        guard let descriptor = days.first(where: { $0.number == targetDay }) else {
            print("Day \(paddedDayNumber(targetDay)) has not been registered yet.")
            return
        }

        let useExample = askRunExample(defaultValue: true)
        let runPartTwo = askPartSelection(defaultPart: 1)
        let path = "\(dayFolderPath(for: descriptor.number))/\(useExample ? "example" : "input").txt"
        let input = readLinesFromFile(at: path)

        var startTime = DispatchTime.now()
        let context = DayContext(input: input, isExample: useExample, runPartTwo: runPartTwo) {
            startTime = DispatchTime.now()
        }

        descriptor.run(context)

        let elapsedMs = Double(DispatchTime.now().uptimeNanoseconds - startTime.uptimeNanoseconds) / 1_000_000
        print("\(descriptor.label) finished in \(String(format: "%.3f", elapsedMs)) ms.")
    }

    private static func selectDay(defaultDay: Int) -> Int? {
        var selection: Int?

        while selection == nil {
            let defaultDisplay = paddedDayNumber(defaultDay)
            guard let response = prompt("Which day should run? (type 'new' to scaffold)", default: defaultDisplay) else {
                return nil
            }
            let normalized = response.lowercased()

            if normalized == "new" {
                guard let newDay = promptForInteger("New day number", defaultValue: defaultDay + 1) else {
                    print("Please enter a numeric day value.")
                    continue
                }

                do {
                    try DayTemplateGenerator.create(dayNumber: newDay)
                    print("Created template for Day \(paddedDayNumber(newDay)). Add it to the registry to enable running.")
                } catch DayTemplateGenerator.TemplateError.alreadyExists {
                    print("Day \(paddedDayNumber(newDay)) already exists.")
                } catch {
                    print("Failed to create day template: \(error.localizedDescription)")
                }

                continue
            }

            guard let numeric = Int(response) else {
                print("Please enter a numeric day or 'new'.")
                continue
            }

            selection = numeric
        }

        return selection
    }

    private static func askRunExample(defaultValue: Bool) -> Bool {
        let suffix = defaultValue ? "Y/n" : "y/N"
        let defaultLiteral = defaultValue ? "y" : "n"

        guard let response = prompt("Run with example input? (\(suffix))", default: defaultLiteral) else {
            return defaultValue
        }

        let normalized = response.lowercased()

        if ["y", "yes"].contains(normalized) { return true }
        if ["n", "no"].contains(normalized) { return false }

        print("Response not recognized, defaulting to \(defaultValue ? "Yes" : "No").")
        return defaultValue
    }

    private static func askPartSelection(defaultPart: Int) -> Bool {
        let normalizedDefault = (defaultPart == 2) ? 2 : 1
        let defaultLiteral = String(normalizedDefault)

        guard let response = prompt("Run which part? (1/2)", default: defaultLiteral) else {
            return normalizedDefault == 2
        }

        let sanitized = response
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
            .replacingOccurrences(of: " ", with: "")

        if ["1", "part1"].contains(sanitized) { return false }
        if ["2", "part2"].contains(sanitized) { return true }

        print("Response not recognized, defaulting to Part \(normalizedDefault).")
        return normalizedDefault == 2
    }

    private static func promptForInteger(_ message: String, defaultValue: Int?) -> Int? {
        let defaultText = defaultValue.map(String.init)
        guard let response = prompt(message, default: defaultText) else {
            return defaultValue
        }
        return Int(response)
    }

    private static func prompt(_ message: String, default defaultValue: String?) -> String? {
        if let defaultValue = defaultValue {
            print("\(message) [\(defaultValue)]: ", terminator: "")
        } else {
            print("\(message): ", terminator: "")
        }

        guard let raw = readLine() else {
            return defaultValue
        }

        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? defaultValue : trimmed
    }
}

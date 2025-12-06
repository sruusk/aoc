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

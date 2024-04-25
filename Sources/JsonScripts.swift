import Foundation

func shell(_ command: String) throws -> String {
  let task: Process = Process()
  let pipe: Pipe = Pipe()

  task.standardOutput = pipe
  task.standardError = pipe
  task.arguments = ["-c", command]
  task.executableURL = URL(fileURLWithPath: "/bin/sh")
  task.standardInput = nil

  try task.run()

  let data: Data = pipe.fileHandleForReading.readDataToEndOfFile()
  let output: String = String(data: data, encoding: .utf8)!

  return output
}

@main
struct JsonScripts {
  struct Scripts: Codable {
    let version: Int
    let value: String
  }

  static func main() {
    do {
      let fileURL = URL(fileURLWithPath: "./scripts.json")
      let fileHandle = try FileHandle(forReadingFrom: fileURL)
      defer {
        fileHandle.closeFile()
      }

      let data = fileHandle.readDataToEndOfFile()
      if let contents = String(data: data, encoding: .utf8) {
        let jsonData = contents.data(using: .utf8)!
        let decoder = JSONDecoder()
        let scripts = try decoder.decode(Scripts.self, from: jsonData)

        print("Version: \(scripts.version)")

        let command = scripts.value.split(separator: " ").map { String($0) }

        let program = try shell("command -v \(command[0])").trimmingCharacters(
          in: .whitespacesAndNewlines)
        print("Program: \(program)")

        let process = Process()
        process.executableURL = URL(fileURLWithPath: program)
        process.arguments = Array(command[1...])

        try process.run()
        process.waitUntilExit()
      } else {
        print("Failed to read file contents")
      }
    } catch {
      print("Error: \(error)")
    }
  }
}

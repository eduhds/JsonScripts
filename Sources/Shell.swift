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

/* let commandArr = commandStr.split(separator: " ").map { String($0) }

let program = try shell("command -v \(commandArr[0])").trimmingCharacters(
  in: .whitespacesAndNewlines)
print("Program: \(program)")

let process = Process()
process.executableURL = URL(fileURLWithPath: program)
process.arguments = Array(commandArr[1...])

try process.run()
process.waitUntilExit() */

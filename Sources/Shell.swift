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

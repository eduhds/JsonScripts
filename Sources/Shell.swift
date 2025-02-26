import Foundation

func shellTask(_ command: String) throws -> String {
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

func shellExec(_ commandStr: String) throws {
  let shellCmd = ProcessInfo.processInfo.environment["SHELL"] ?? "/bin/sh"

  let args = [shellCmd, "-c", commandStr]

  // Array of UnsafeMutablePointer<Int8>
  let cargs = args.map { strdup($0) } + [nil]

  execv(shellCmd, cargs)
}

func shellProcess(_ commandStr: String) throws {
  let commandArr = commandStr.split(separator: " ").map { String($0) }

  let program = try shellTask("command -v \(commandArr[0])").trimmingCharacters(
    in: .whitespacesAndNewlines)

  let process = Process()
  process.executableURL = URL(fileURLWithPath: program)
  process.arguments = Array(commandArr[1...])

  try process.run()
  process.waitUntilExit()
}

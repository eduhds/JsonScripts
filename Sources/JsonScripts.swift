import ArgumentParser
import Figlet
import Foundation

// TODO: Shell snippets (contexto pasta local/global, variáveis, add, list, search, run, config file)

@main
struct JsonScripts: ParsableCommand {
  @Argument(help: "Specify the command")
  public var command: String

  @Option(help: "Specify the file")
  public var file: String?

  struct JsonDefinition: Codable {
    let version: Int
    let variables: [String: String]
    let scripts: [String: String]
  }

  public func run() throws {
    Figlet.say("JsonScripts")

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
        let json = try decoder.decode(JsonDefinition.self, from: jsonData)

        print("> Version: \(json.version)")

        if let commandStr = json.scripts[command] {
          print("> \(commandStr)")

          let output = try shell(commandStr).trimmingCharacters(
            in: .whitespacesAndNewlines)

          print(output)

          /* let commandArr = commandStr.split(separator: " ").map { String($0) }

          let program = try shell("command -v \(commandArr[0])").trimmingCharacters(
            in: .whitespacesAndNewlines)
          print("Program: \(program)")

          let process = Process()
          process.executableURL = URL(fileURLWithPath: program)
          process.arguments = Array(commandArr[1...])

          try process.run()
          process.waitUntilExit() */
        } else {
          print("Command not found")
        }
      } else {
        print("Failed to read file contents")
      }
    } catch {
      print("Error: \(error)")
    }
  }
}

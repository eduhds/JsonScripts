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

  public func run() throws {
    Figlet.say("JsonScripts")

    let definition = Definition()

    do {

      try definition.open(path: file ?? definition.defaultPath)
    } catch {
      print("Error: Failed to read file contents \(error)")
      return

    }

    do {
      print("> Version: \(definition.json!.version)")

      if let commandStr = definition.json!.scripts[command] {
        print("> \(commandStr)")

        let output = try shell(commandStr).trimmingCharacters(
          in: .whitespacesAndNewlines)

        print(output)

      } else {
        print("Command not found")
      }
    } catch {
      print("Error: \(error)")
    }
  }
}

import ArgumentParser
import Figlet
import Foundation

@main
struct JsonScripts: ParsableCommand {
  @Argument(help: "Specify the command alias/key")
  public var command: String

  @Option(help: "Specify the json file, defaul is \"./scripts.json\"")
  public var file: String?

  @Flag(help: "Silent mode")
  public var silent: Bool = false

  public func run() throws {
    if !silent {
      Figlet.say("JsonScripts")
    }

    let definition = Definition()

    do {
      try definition.open(path: file ?? definition.defaultPath)
    } catch {
      tuiError("\(error)")
      return
    }

    do {
      try definition.checkVersion()

      if !silent {
        tuiInfo("Version: \(definition.json!.version)")
      }

      if var commandStr = definition.json!.scripts[command] {

        if commandStr.contains("{{") && commandStr.contains("}}") {
          for variable in definition.json!.variables {
            commandStr = commandStr.replacingOccurrences(
              of: "{{\(variable.key)}}", with: variable.value)
          }
        }

        if !silent {
          tuiInfo("Command: \(commandStr)")
        }

        let output = try shell(commandStr).trimmingCharacters(
          in: .whitespacesAndNewlines)

        print(output)

      } else {
        tuiError("Command not found")
      }
    } catch {
      tuiError("Error: \(error)")
    }
  }
}

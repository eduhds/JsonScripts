import ArgumentParser
import Figlet
import Foundation

@main
struct JsonScripts: ParsableCommand {
  static let configuration = CommandConfiguration(
    commandName: "jsonscripts",
    version: "0.0.3"
  )

  @Argument(help: "Specify the command alias/key")
  public var command: String

  @Option(help: "Specify the json file, default is \"./scripts.json\"")
  public var file: String?

  @Flag(help: "Silent mode")
  public var silent: Bool = false

  public func run() throws {
    #if DEBUG
      if !silent {
        Figlet.say("JsonScripts")
      }
    #endif

    let definition = Definition()

    if command == "init" {
      do {
        try definition.initJson()
        tuiSuccess("scripts.json created")
      } catch {
        tuiError("\(error)")
      }
      return
    }

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

        try shellExec(commandStr)
      } else {
        tuiError("Command not found")
      }
    } catch {
      tuiError("Error: \(error)")
    }
  }
}

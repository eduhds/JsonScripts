import ArgumentParser
import Figlet
import Foundation

@main
struct JsonScripts: ParsableCommand {
  static let configuration = CommandConfiguration(
    commandName: "jsonscripts",
    version: "0.0.4"
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

    if command == "list" {
      do {
        try definition.listScripts()

        print("\nSelect an option by number: ", terminator: "")
        let input = readLine()!

        if let option = Int(input) {
          var commandStr = try definition.commandForIndex(option)
          commandStr = definition.replaceVars(commandStr)

          if !silent {
            tuiInfo("Command: \(commandStr)")
          }

          try shellExec(commandStr)
        } else {
          tuiError("Invalid option")
        }
      } catch {
        tuiError("\(error)")
      }
      return
    }

    do {
      try definition.checkVersion()

      if !silent {
        tuiInfo("Version: \(definition.json!.version)")
      }

      if var commandStr = definition.json!.scripts[command] {

        commandStr = definition.replaceVars(commandStr)

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

import ArgumentParser
import Figlet
import Foundation

let VERSION = "0.0.6"

@main
struct JsonScripts: ParsableCommand {
  static let configuration = CommandConfiguration(
    commandName: "jsonscripts",
    version: VERSION
  )

  @Argument(
    help: "init|list|<alias> Specify a builtin command or a command alias from scripts.json")
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

    if !silent {
      tuiInfo("JsonScripts v\(VERSION)")
    }

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
        print("\n> Available scripts:")
        try definition.listScripts()

        print("\n> Select an option by number: ", terminator: "")
        let input = readLine()!

        if let option = Int(input) {
          var commandStr = try definition.commandForIndex(option)
          commandStr = definition.replaceVars(commandStr)

          if !silent {
            print("")
            tuiInfo(commandStr)
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
        tuiInfo("Scripts version: \(definition.json!.version)")
      }

      if var commandStr = definition.json!.scripts[command] {

        commandStr = definition.replaceVars(commandStr)

        if !silent {
          tuiInfo(commandStr)
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

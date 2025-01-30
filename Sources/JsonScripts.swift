import ArgumentParser
import Figlet
import Foundation

let VERSION = "0.0.8"

@main
struct JsonScripts: ParsableCommand {
  static let configuration = CommandConfiguration(
    commandName: "jnss",
    version: VERSION
  )

  @Argument(
    help: "init|list|<alias> Specify a builtin command or a command alias from scripts.json")
  public var command: String

  @Option(name: .shortAndLong, help: "Specify the json file, default is \"./scripts.json\"")
  public var file: String?

  @Flag(help: "Verbose mode")
  public var verbose: Bool = false

  @Argument(help: "Command arguments")
  public var arguments: [String] = []

  public func run() throws {
    #if DEBUG
      Figlet.say("JsonScripts")
    #endif

    if verbose {
      tuiInfo("JsonScripts v\(VERSION)")
    }

    let definition = Definition()

    do {
      if command != "init" {
        try definition.open(path: file ?? definition.defaultPath)
        try definition.checkVersion()

        if verbose {
          tuiInfo("Scripts version: \(definition.json!.version)")
        }
      }

      switch command {
      case "init":
        try definition.initJson()
        tuiSuccess("scripts.json created")
      case "list":
        print("\n> Available scripts:")
        try definition.listScripts()

        print("\n> Select an option by number: ", terminator: "")
        let input = readLine()!

        if let option = Int(input) {
          var commandStr = try definition.commandForIndex(option)
          commandStr = definition.replaceVars(commandStr)

          if verbose {
            print("")
            tuiInfo(commandStr)
          }

          try shellExec(commandStr)
        } else {
          tuiError("Invalid option")
        }
      default:
        if var commandStr = definition.json!.scripts[command] {

          commandStr = definition.replaceVars(commandStr)

          if !arguments.isEmpty {
            commandStr += " " + arguments.joined(separator: " ")
          }

          if verbose {
            tuiInfo(commandStr)
          }

          try shellExec(commandStr)
        } else {
          tuiError("Command not found")
        }
      }
    } catch {
      tuiError("\(error)")
    }
  }
}

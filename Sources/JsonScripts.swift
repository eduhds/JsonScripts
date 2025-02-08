import ArgumentParser
import Figlet
import Foundation

let VERSION = "0.0.9"

struct KeyValueOption: ExpressibleByArgument {
  let key: String
  let value: String

  init?(argument: String) {
    let components = argument.split(separator: "=", maxSplits: 1).map(String.init)
    guard components.count == 2 else { return nil }
    self.key = components[0]
    self.value = components[1]
  }
}

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

  @Option(
    name: .customLong("var", withSingleDash: true), parsing: .upToNextOption,
    help: "Specify multiple key-value pairs in the format 'key=value'.")
  var variables: [KeyValueOption] = []

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
        var vars: [String: String] = [:]

        for variable in variables {
          vars[variable.key] = variable.value
        }

        if var commandStr = definition.json!.scripts[command] {

          commandStr = definition.replaceVars(commandStr, variables: vars)

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

import Foundation

struct JsonFormat: Codable {
  let version: Int
  let variables: [String: String]
  let scripts: [String: String]
}

enum DefinitionError: Error {
  case fileContentNotFound
  case versionUnsupported
  case fileAlreadyExists
  case noScriptsAvailable
}

class Definition {
  let currentVersion: Int = 1

  let defaultPath: String = "./scripts.json"

  var json: JsonFormat?

  func open(path: String) throws {
    let fileURL: URL = URL(fileURLWithPath: path)
    let fileHandle: FileHandle = try FileHandle(forReadingFrom: fileURL)

    defer {
      fileHandle.closeFile()
    }

    let fileData: Data = fileHandle.readDataToEndOfFile()

    if let content: String = String(data: fileData, encoding: .utf8) {
      let jsonContent: Data = content.data(using: .utf8)!
      let decoder = JSONDecoder()
      json = try decoder.decode(JsonFormat.self, from: jsonContent)
    } else {
      throw DefinitionError.fileContentNotFound
    }
  }

  func checkVersion() throws {
    if json!.version < currentVersion {
      throw DefinitionError.versionUnsupported
    }
  }

  func initJson() throws {
    if fileExists(defaultPath) {
      throw DefinitionError.fileAlreadyExists
    } else {
      let jsonContent = """
        {
          "jnss": "https://github.com/eduhds/JsonScripts",
          "version": \(currentVersion),
          "variables": {
            "name": "JsonScripts"
          },
          "scripts": {
            "hello": "echo 'Hello from {{name}}'"
          }
        }
        """

      let url = URL(fileURLWithPath: defaultPath)
      try jsonContent.write(to: url, atomically: false, encoding: .utf8)
    }
  }

  func listScripts() throws {
    if let scripts = json?.scripts {
      let count = scripts.count
      var num = 0
      for (key, _) in scripts.sorted(by: { $0.key < $1.key }) {
        num += 1
        var ind = String(num)
        if ind.count < String(count).count {
          ind =
            "".padding(toLength: String(count).count - ind.count, withPad: " ", startingAt: 0)
            + String(num)
        }
        tuiTitle("[\(ind)] \(key)")
      }
    } else {
      throw DefinitionError.noScriptsAvailable
    }
  }

  func commandForIndex(_ index: Int) throws -> String {
    if let scripts = json?.scripts {
      var count = 1
      for (_, value) in scripts.sorted(by: { $0.key < $1.key }) {
        if count == index {
          return value
        }
        count += 1
      }

      throw DefinitionError.noScriptsAvailable
    } else {
      throw DefinitionError.noScriptsAvailable
    }
  }

  func replaceVars(_ command: String, variables: [String: String] = [:]) -> String {
    if command.contains("{{") && command.contains("}}") {
      var commandStr = command
      var commandVars = variables
      commandVars.merge(json!.variables){ (curr, _) in curr }
      for variable in commandVars {
        commandStr = commandStr.replacingOccurrences(
          of: "{{\(variable.key)}}", with: variable.value)
      }
      return commandStr
    }
    return command
  }
}

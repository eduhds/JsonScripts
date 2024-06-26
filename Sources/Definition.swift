import Foundation

struct JsonFormat: Codable {
  let version: Int
  let variables: [String: String]
  let scripts: [String: String]
}

enum OpenError: Error {
  case fileContentNotFound
  case versionUnsupported
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
      throw OpenError.fileContentNotFound
    }
  }

  func checkVersion() throws {
    if json!.version < currentVersion {
      throw OpenError.versionUnsupported
    }
  }
}

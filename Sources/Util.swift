import Foundation

func fileExists(_ path: String) -> Bool {
  return FileManager.default.fileExists(atPath: path)
}

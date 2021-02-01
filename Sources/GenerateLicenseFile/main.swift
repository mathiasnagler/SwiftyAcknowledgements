#!/usr/bin/env xcrun --sdk macosx swift

import Foundation

// MARK: String Extensions

extension String {
    func ends(with str: String) -> Bool {
        let lc = self.lowercased()
        let lcStr = str.lowercased()
        if let range = lc.range(of: lcStr, options: .backwards) {
            return range.upperBound == lc.endIndex
        }
        return false
    }
}

// MARK: Internal functions
let fm = FileManager.default

func locateLicense(inFolder folder: URL) -> URL? {
    guard let subpaths = try? fm.contentsOfDirectory(at: folder, includingPropertiesForKeys: nil, options: []) else { return nil }
//    guard let subpaths = try? fm.subpathsOfDirectory(atPath: folder) else {
//        return nil
//    }

    let licenseFiles = subpaths.filter {
        $0.lastPathComponent.lowercased().range(of: "license", options: .regularExpression, range: nil, locale: nil) != nil
    }
    
//    var filteredPaths = subpaths.filter { $0.ends(with: "LICENSE") || $0.ends(with: "LICENSE.txt") || $0.ends(with: "LICENSE.md") }
//    filteredPaths = filteredPaths.map { folder + "/" + $0 }
    return licenseFiles.first
}

func exitWithUsage(_ scriptFileName: String) -> Never {
    fatalError("Invalid parameters. Usage: ./\(scriptFileName) <inputDirectory> <outputFile>")
}

func getArguments() -> (inputDirs: [URL], outputFile: URL) {
    // Grab command line arguments
    let arguments = CommandLine.arguments

    // Get the filename of the swift script for logging purposes
    let scriptFileName = arguments[0].components(separatedBy: "/").last!

    // Check argument count
    if arguments.count < 3 {
        exitWithUsage(scriptFileName)
    }

    let allURLs = arguments[1...].map(URL.init(fileURLWithPath:))

    let inputDirs = Array(allURLs[..<(allURLs.endIndex - 1)])
    guard let outFile = allURLs.last else {
        exitWithUsage(scriptFileName)
    }

    return (inputDirs, outFile)
}

// MARK: Main
func main() {

    let (inputDirs, outputFile) = getArguments()

    // Get subpaths (libraries at path)
    guard let libraries = try? fm.contentsOfDirectory(at: inputDirs.first!, includingPropertiesForKeys: nil, options: []) else {
        fatalError("Could not access directory at path \(inputDirs.first!).")
    }
//    guard let libraries = try? filemanager.contentsOfDirectory(atPath: inDict), libraries.count > 0 else {
//        print("Could not access directory at path \(inDict).")
//        exit(1)
//    }

    // Result array
    var licenses = Array<Dictionary<String, String>>()

    // Load license for each library and add it to the result array
    libraries.forEach({ library in
        guard
            let licensePath = locateLicense(inFolder: library),
//            let licence = try? String(contentsOfFile: licensePath, encoding: .utf8)
            let license = try? String(contentsOf: licensePath, encoding: .utf8)
        else {
            return
        }

        licenses.append(["title" : library.lastPathComponent, "text" : license])
    })

    // Generate plist from result array
    let plist = try! PropertyListSerialization.data(fromPropertyList: licenses, format: .xml, options: 0) as NSData

    // Write plist to disk
    do {
        try plist.write(to: outputFile)
    } catch {
        print("Error saving plist to disk: \(error)")
        exit(1)
    }
}


main()

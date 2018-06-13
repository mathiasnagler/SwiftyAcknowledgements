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

func locateLicense(inFolder folder: String) -> String? {
    let filemanager = FileManager.default
    
    guard let subpaths = try? filemanager.subpathsOfDirectory(atPath: folder) else {
        return nil
    }
    
	var filteredPaths = subpaths.filter { $0.ends(with: "LICENSE") || $0.ends(with: "LICENSE.txt") || $0.ends(with: "LICENSE.md") }
    filteredPaths = filteredPaths.map { folder + "/" + $0 }
    return filteredPaths.first
}

// MARK: Main

// Grab command line arguments
let arguments = CommandLine.arguments

// Get the filename of the swift script for logging purposes
let scriptFileName = arguments[0].components(separatedBy: "/").last!

// Check argument count
if arguments.count != 3 {
    print("Invalid parameters. Usage: ./\(scriptFileName) <inputDirectory> <outputFile>")
    exit(1)
}

var inDict = arguments[1]
let outFile = arguments[2]

let outURL = URL(fileURLWithPath: outFile)

// Add '/' to inDict if it is missing, otherwise the script will not find any subpaths
if !inDict.ends(with: "/") {
    inDict += "/"
}

// Initialize default NSFileManager
let filemanager = FileManager.default

// Get subpaths (libraries at path)
guard let libraries = try? filemanager.contentsOfDirectory(atPath: inDict), libraries.count > 0 else {
    print("Could not access directory at path \(inDict).")
    exit(1)
}

// Result array
var licenses = Array<Dictionary<String, String>>()

// Load license for each library and add it to the result array
libraries.forEach({ (library: String) in
    guard
        let licensePath = locateLicense(inFolder: inDict + library),
        let licence = try? String(contentsOfFile: licensePath, encoding: .utf8)
    else {
        return
    }

    licenses.append(["title" : library, "text" : licence])
})

// Generate plist from result array
let plist = try! PropertyListSerialization.data(fromPropertyList: licenses, format: .xml, options: 0) as NSData

// Write plist to disk
do {
    try plist.write(to: outURL)
} catch {
    print("Error saving plist to disk: \(error)")
    exit(1)
}

#!/usr/bin/env xcrun --sdk macosx swift

import Foundation

// MARK: String Extensions

extension String {
    func endsWith(str: String) -> Bool {
        if let range = self.range(of: str, options:NSString.CompareOptions.backwardsSearch) {
            return range.upperBound == self.endIndex
        }
        return false
    }
}

// MARK: Internal functions

func locateLicenseInFolder(folder: String) -> String? {
    let filemanager = FileManager.default()
    
    guard let subpaths = try? filemanager.subpathsOfDirectory(atPath: folder) else {
        return nil
    }
    
    var filteredPaths = subpaths.filter { $0.endsWith(str: "LICENSE") || $0.endsWith(str: "LICENSE.txt") }
    filteredPaths = filteredPaths.map { folder + "/" + $0 }
    return filteredPaths.first
}

// MARK: Main

// Grab command line arguments
let arguments = Process.arguments

// Get the filename of the swift script for logging purposes
let scriptFileName = arguments[0].components(separatedBy: "/").last!

// Check argument count
if arguments.count != 3 {
    print("Invalid parameters. Usage: ./\(scriptFileName) <inputDirectory> <outputFile>")
    exit(1)
}

var inDict = arguments[1]
let outFile = arguments[2]

// Add '/' to inDict if it is missing, otherwise the script will not find any subpaths
if !inDict.endsWith(str: "/") {
    inDict += "/"
}

// Initialize default NSFileManager
let filemanager = FileManager.default()

// Get subpaths (libraries at path)
guard let libraries = try? filemanager.contentsOfDirectory(atPath: inDict) where libraries.count > 0 else {
    print("Could not access directory at path \(inDict).")
    exit(1)
}

// Result array
var licenses = Array<Dictionary<String, String>>()

// Load license for each library and add it to the result array
libraries.forEach({ (library: String) in
    guard let
        licensePath = locateLicenseInFolder(folder: inDict + library),
        licence = try? String(contentsOfFile: licensePath, encoding: String.Encoding.utf8)
        else {
            return
    }

    licenses.append(["title" : library, "text" : licence])
})

// Generate plist from result array
let plist = try! PropertyListSerialization.data(fromPropertyList: licenses, format: PropertyListSerialization.PropertyListFormat.xmlFormat_v1_0, options: 0)

// Write plist to disk
if let url = URL(string: outFile) {
    try plist.write(to: url, options: NSData.WritingOptions.atomicWrite)
}

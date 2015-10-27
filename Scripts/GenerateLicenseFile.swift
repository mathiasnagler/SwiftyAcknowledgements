#!/usr/bin/env xcrun --sdk macosx swift

import Foundation

// MARK: String Extensions

extension String {
    func endsWith(str: String) -> Bool {
        if let range = self.rangeOfString(str, options:NSStringCompareOptions.BackwardsSearch) {
            return range.endIndex == self.endIndex
        }
        return false
    }
}

// MARK: Internal functions

func locateLicenseInFolder(folder: String) -> String? {
    let filemanager = NSFileManager.defaultManager()
    
    guard let subpaths = try? filemanager.subpathsOfDirectoryAtPath(folder) else {
        return nil
    }
    
    var filteredPaths = subpaths.filter { $0.endsWith("LICENSE") || $0.endsWith("LICENSE.txt") }
    filteredPaths = filteredPaths.map { folder + "/" + $0 }
    return filteredPaths.first
}

// MARK: Main

// Grab command line arguments
let arguments = Process.arguments

// Get the filename of the swift script for logging purposes
let scriptFileName = arguments[0].componentsSeparatedByString("/").last!

// Check argument count
if arguments.count != 3 {
    print("Invalid parameters. Usage: ./\(scriptFileName) <inputDirectory> <outputFile>")
    exit(1)
}

var inDict = arguments[1]
let outFile = arguments[2]

// Add '/' to inDict if it is missing, otherwise the script will not find any subpaths
if !inDict.endsWith("/") {
    inDict += "/"
}

// Initialize default NSFileManager
let filemanager = NSFileManager.defaultManager()

// Get subpaths (libraries at path)
guard let libraries = try? filemanager.contentsOfDirectoryAtPath(inDict) where libraries.count > 0 else {
    print("Could not access directory at path \(inDict).")
    exit(1)
}

// Result array
var licenses = Array<Dictionary<String, String>>()

// Load license for each library and add it to the result array
libraries.forEach({ (library: String) in
    guard let
        licensePath = locateLicenseInFolder(inDict + library),
        licence = try? NSString(contentsOfFile: licensePath, encoding: NSUTF8StringEncoding) as String
        else {
            return
    }

    licenses.append(["title" : library, "text" : licence])
})

// Generate plist from result array
let plist = try! NSPropertyListSerialization.dataWithPropertyList(licenses, format: NSPropertyListFormat.XMLFormat_v1_0, options: NSPropertyListWriteInvalidError)

// Write plist to disk
plist.writeToFile(outFile, atomically: true)

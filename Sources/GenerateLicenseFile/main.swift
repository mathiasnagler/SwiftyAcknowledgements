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

extension IteratorProtocol {
    func forEach(_ body: (Element) -> ()) {
        var copy = self
        while let current = copy.next() {
            body(current)
        }
    }

    func map<Output>(_ body: (Element) -> Output) -> [Output] {
        var copy = self
        var result = [Output]()
        while let current = copy.next() {
            result.append(body(current))
        }
        return result
    }
}

// MARK: Internal functions
let fm = FileManager.default

func locateLicense(inProject projectFolder: URL) -> URL? {
    var isDir: ObjCBool = false
    fm.fileExists(atPath: projectFolder.path, isDirectory: &isDir)
    guard
        isDir.boolValue == true,
        let subpathEnumerator = fm.enumerator(at: projectFolder, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])?.makeIterator()
    else { return nil }

    let licenseFiles = subpathEnumerator
        .map { $0 as? URL }
        .compactMap { $0 }
        .filter {
            $0.lastPathComponent.lowercased().range(of: "license", options: .regularExpression, range: nil, locale: nil) != nil
        }

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
    let libraries = inputDirs.compactMap {
        try? fm.contentsOfDirectory(at: $0, includingPropertiesForKeys: nil, options: [])
    }
    .flatMap { $0 }

    // Load license for each library and add it to a dictionary, removing potential duplicates
    let lics = libraries.reduce(into: [String: String]()) {
        guard
            let licensePath = locateLicense(inProject: $1),
            let license = try? String(contentsOf: licensePath, encoding: .utf8)
        else { return }

        $0[$1.lastPathComponent] = license
    }

    // Convert dictionary to expected data structuring, but alphabetized
    let combinedLicenses: [[String: String]] = lics
        .keys
        .sorted()
        .map {
            let value = lics[$0, default: ""]
            return [
                "title": $0,
                "text": value
            ]
        }

    // Generate plist from result array
    // Write plist to disk
    do {
        let plist = try PropertyListSerialization.data(fromPropertyList: combinedLicenses, format: .xml, options: 0)
        try plist.write(to: outputFile)
    } catch {
        fatalError("Error saving plist to disk: \(error)")
    }
}


main()

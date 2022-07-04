import Foundation

public struct LicenseFileGenerator {
	private static let fm = FileManager.default
	private var fm: FileManager { Self.fm }

	public init() {}

	public func generatePlist(inputDirs: [URL], outputFile: URL) throws {
		// Get subpaths (libraries at paths)
		let libraryPaths = getAllLibraryPaths(from: inputDirs)

		// Load license for each library and add it to a dictionary, removing potential duplicates
		let libraryLicenses = loadAllLicenses(from: libraryPaths)

		// Convert dictionary to expected data structuring, but alphabetized
		let exportDictionary = formatDataForExport(with: libraryLicenses)

		// Generate plist from result array
		// Write plist to disk
//		do {
			let plist = try PropertyListSerialization.data(fromPropertyList: exportDictionary, format: .xml, options: 0)
			try plist.write(to: outputFile)
//		} catch {
//			fatalError("Error saving plist to disk: \(error)")
//		}
		print("Saved license info to \(outputFile.path)")
	}

	// MARK: Internal functions
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

	func getAllLibraryPaths(from inputDirs: [URL]) -> [URL] {
		inputDirs.compactMap {
			try? fm.contentsOfDirectory(at: $0, includingPropertiesForKeys: nil, options: [])
		}
		.flatMap { $0 }
	}

	func loadAllLicenses(from libraryPaths: [URL]) -> [String: String] {
		libraryPaths.reduce(into: [String: String]()) {
			guard
				let licensePath = locateLicense(inProject: $1),
				let license = try? String(contentsOf: licensePath, encoding: .utf8)
			else { return }

			$0[$1.lastPathComponent] = license
		}
	}

	func formatDataForExport(with libraryLicenses: [String: String]) -> [[String: String]] {
		libraryLicenses
			.keys
			.sorted()
			.map {
				let value = libraryLicenses[$0, default: ""]
				return [
					"title": $0,
					"text": value
				]
			}
	}
}

// MARK: Convenience Extensions
extension IteratorProtocol {
	func map<Output>(_ body: (Element) -> Output) -> [Output] {
		var copy = self
		var result = [Output]()
		while let current = copy.next() {
			result.append(body(current))
		}
		return result
	}
}

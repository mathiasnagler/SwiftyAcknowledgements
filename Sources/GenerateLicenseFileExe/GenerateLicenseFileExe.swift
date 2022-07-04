import Foundation
import ArgumentParser
import LicenseFileGenerator

@main
struct GenerateLicenseFileExe: ParsableCommand {
	@Argument(
		help: "Source Directories",
		completion: .directory,
		transform: URL.init(fileURLWithPath:))
	var sourceDirectories: [URL]

	@Option(
		name: .customShort("o"),
		help: "Destination File",
		completion: .file(),
		transform: URL.init(fileURLWithPath:))
	var destinationFile: URL

	func run() throws {
		try LicenseFileGenerator().generatePlist(inputDirs: sourceDirectories, outputFile: destinationFile)
	}
}

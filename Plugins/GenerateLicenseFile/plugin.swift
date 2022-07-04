import Foundation
import PackagePlugin


/**
 Right now this only works on SPM projects and not in Xcode projects. No idea if that will be fixed later as it plain just doesn't run in Xcode projects.
 */
@main
struct GenerateLicenseFile: CommandPlugin {
	func performCommand(context: PluginContext, arguments: [String]) async throws {
		let tool = try context.tool(named: "GenerateLicenseFileExe")
		let toolUrl = URL(fileURLWithPath: tool.path.string)

		var updatedArguments: [String] = []
		var skip = false
		for argument in arguments {
			guard skip == false else {
				skip = false
				continue
			}
			if argument == "--target" {
				skip = true
			} else {
				updatedArguments.append(argument)
			}
		}

		var directories = ["\(context.package.directory)"]
		if updatedArguments.contains("-b") {
			directories = []
		}

		updatedArguments.removeAll(where: { $0 == "-b" })

		directories += updatedArguments

		let process = Process()
		process.executableURL = toolUrl
		process.arguments = directories + ["-o", "Acknowledgements.plist"]

		try process.run()
		process.waitUntilExit()
	}
}

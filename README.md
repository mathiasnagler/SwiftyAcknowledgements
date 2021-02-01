# SwiftyAcknowledgements
[![Build Status](https://travis-ci.org/mathiasnagler/SwiftyAcknowledgements.svg?branch=develop)](https://travis-ci.org/mathiasnagler/SwiftyAcknowledgements)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
![Platform](https://img.shields.io/badge/platform-iOS%20%7C%20tvOS-lightgrey.svg)

SwiftyAcknowledgements makes it easy to integrate acknowledgements for third party libraries into your iOS Apps.

## Requirements

- iOS 8.0 or higher
- tvOS 9.0 or higher
- Xcode 8.2 or higher

## Components

SwiftyAcknowledgements consists of two components.

### Script

`GenerateLicenseFile.swift` is a Swift script that scans a directory for files named `LICENSE` or `LICENSE.txt` and generates a property list containing the content of every license along with a name. The name will be set to the name of the folder that the corresponding license file is contained in.

### Framework

**SwiftyAcknowledgements** comes with a framework `SwiftyAcknowledgements.framework` that can be used to visualize the generated license file within an iOS App. The framework contains a **TableViewController** and a **DetailViewController** and can be integrated programatically or using a **Storyboard**.

## Installation

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

To integrate **SwiftyAcknowledgements** into your Xcode projekct using **Carthage**, specify it in your `Cartfile`:

```
github "mredig/SwiftyAcknowledgements"
```

Follow the instructions in the [Carthage Documentation](https://github.com/Carthage/Carthage) to install the built framework into your Xcode project.

### Swift Package Manger
```
https://github.com/mredig/SwiftyAcknowledgements.git
```
**Note:** these urls will need to be updated if the PR is accepted.

### Script

To integrate the script into your Xcode project create a subfolder `Scripts` in the folder that contains your Xcode project. Then, copy `GenerateLicenseFile.swift` to that subfolder. In your target, create a new `Run Script Build Phase` like this:

```sh
${SRCROOT}/Scripts/GenerateLicenseFile.swift ${SRCROOT}/Libraries/ ${PROJECT_DIR}/iOS\ Example/Acknowledgements.plist
```
*Alternatively* if using SPM, you may set the path to Xcode's SPM checkout directory like this:

```sh
$BUILD_DIR/../../SourcePackages/checkouts/SwiftyAcknowledgements/Sources/GenerateLicenseFile/main.swift $BUILD_DIR/../../SourcePackages/checkouts ${SRCROOT}/Carthage/Checkouts ${PROJECT_DIR}/Poop/Acknowledgements.plist
```

**Note:** The parameters for the script are the input directories that should be scanned for license files, followed by the last parameter being the output file that should be generated by the script.

After that, build your project and add the generated license file to your Xcode project.

## Usage

The framework contains `AcknowledgementsTableViewController.swift` that can be pushed onto a `UINavigationController` or presented modally. The `AcknowledgementsTableViewController` will automatically look for a file `Acknowledgements.plist` and display its contents. If your license file is named differently, you can specify your custom name using the property `acknowledgementsPlistName: String`.

## Customization

There are several ways you can customize the appearance of SwiftyAcknowledgements ViewControllers. The easiest possibility is to integrate using a storyboard and setting the provided IBInspectables on AcknowledgementsTableViewController. Using this method you can customize *font sizes* and the text for the *table header* and *footer*.

If you need additional customization options, you can always build a custom subclasses for the provided ViewControllers and override the desired methods.

## Credits

**SwiftyAcknowledgements** was inspired by Vincent Tourraine's [VTAcknowledgementsViewController](https://github.com/vtourraine/VTAcknowledgementsViewController).

## License

**SwiftyAcknowledgements** is available under the MIT license. See the LICENSE file for more info.

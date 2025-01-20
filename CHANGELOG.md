# Kount SDK iOS Source

## [4.2.1] - 2024-09-02

### Public Notes

- Fixed an error within the Privacy Manifest who triggered a warning in the App Store when submitting an app.

## [4.2.0] - 2024-07-15

### Public Notes

- Introduced a 'modulemap' file to our iOS library.
  - This update enables Swift projects to import our library without the need for Bridging-Header.
  - Enhances compatibility and simplifies the integration process for our clients.

### Internal Notes

- Updated automation script for generate XCFramework for cocoapods.
- Updated R&D Sample App with programatic view. [Alejandro Villalobos](alejandro.villalobos1@equifax.com)
- CHANGELOG updated.

## [4.1.10] - 2024-04-08

### Public Notes

- Update with new sessionID business rules.
- Update with new merchantID business rules.
- Deployment Target: iOS 12.0+
- Added the Manifest file to the project.

### Internal Notes

- CHANGELOG updated.
- Gitlab CI rule changed repository name, branch and TAG.
- Gitlab CI rule changed to trigger on events by [Mario Espinoza](mario.espinoza@equifax.com).
- Change the UI of the new sample app. [Felipe Plaza](felipe.plaza@equifax.com).
- The new sample app with the implementation of the first R&D with acceleration, attitude, gyro, pedometer, magnetic fields sensors and logs view. [Felipe Plaza](felipe.plaza@equifax.com).
- Unit Tests were created for the merchantID. [Felipe Plaza](felipe.plaza@equifax.com).
- Unit Tests were created for the sessionID. [Felipe Plaza](felipe.plaza@equifax.com).
- Added support to analytics files to be part of the whole code coverage test and xconfig files. [Daniel Govea](daniel.govea@equifax.com).
- In SampleAppSwift project for R&D was added "Change Language" button for redirect to app settings. [Felipe Plaza](felipe.plaza@equifax.com).
- Added automation folder who contain two scripts for Artifact generation and integration. [Daniel Govea](daniel.govea@equifax.com).
- Gitlab CI rule changed to only trigger when pull request is open on "Master" and "Development branch". [Daniel Govea](daniel.govea@equifax.com).
- Change matchRegEx validation to a Util Class. [Felipe Plaza](felipe.plaza@equifax.com).
- Added arm64 from Excluded Architectures (with non Excluded Architectures, is not posible to generate .a file in Universal Library).
- Update matchRegEx validation from NSPredicate to NSRegularExpression. [Felipe Plaza](felipe.plaza@equifax.com).
- Remove arm64 from Excluded Architectures. [Felipe Plaza](felipe.plaza@equifax.com).
- Failing Unit Tests from KLocationCollector and KDataCollector fixed. [Daniel Govea](daniel.govea@equifax.com).
- Moved the RegEx and Network validation logic to a Util class and restructured it to pass the Unit Tests. [Felipe Plaza](felipe.plaza@equifax.com).
- Extract Debug Message, Error handling and Completion Block from KountAnaliticsViewController to a Util Classes. [Felipe Plaza](felipe.plaza@equifax.com).
- Removed all disk space collection in the project. [Felipe Plaza](felipe.plaza@equifax.com).

## [4.1.9] - 2023-02-09

### Public Notes

- Fixes an issue where the collection process forces the user language to English

## [4.1.8] - 2022-11-29

### Fixed

- Prevented runtime issue in Location collector
- Removed all bitcode settings in Xcode 14 and set bitcode to “No”
- Added optional methods for the status of device data collection

## [4.1.7] - 2022-09-19

### Fixed

- Resolved potential crash (KDataCollector.m, NSDictionary error) when an iOS application running the Device Data Collector goes offline in the middle of transmitting data to Kount

## [4.1.6] - 2022-09-09

- Updated to support iOS16. Kount's SDK still supports iOS versions back to iOS 11. Current versions of XCode and the AppStore require iOS11 and newer for new applications & updates.
- Removal of iOS10 and lower support. armv7 architectures were removed after iOS10
- Removed Paste Clipboard functionality. This removes the need for additional permissions that would be required with iOS16 to publish an App in the AppStore.
- Fixed occasional issue with Location collection not being asynchronous which caused an application to crash when the location service took too long.

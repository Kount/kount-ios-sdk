# iOS SDK Release Notes

## [6.0.0] - 2026-08-12

### Public Notes

* Migrated device fingerprint cookies to Keychain storage for enhanced security
* Implemented Keychain-based cookie persistence with plist fallback migration
* Renamed ObjC SDK module from KountDataCollector to KountSDK
* Comprehensive test coverage for Keychain integration and module structure

## [4.2.1] - 2024-09-02

### Public Notes

* Fixed an error within the Privacy Manifest who triggered a warning in the App Store when submitting an app.

## [4.2.0] - 2024-07-15

### Public Notes

* Introduced a 'modulemap' file to our iOS library.
* This update enables Swift projects to import our library without the need for Bridging-Header.
* Enhances compatibility and simplifies the integration process for our clients.

## [4.1.10] - 2024-04-08

### Public Notes

* Update with new sessionID business rules.
* Update with new merchantID business rules.
* Deployment Target: iOS 12.0+
* Added the Manifest file to the project.

## [4.1.9] - 2023-02-09

### Public Notes

* Fixes an issue where the collection process forces the user language to English

## [4.1.8] - 2022-11-29

### Fixed

* Prevented runtime issue in Location collector
* Removed all bitcode settings in Xcode 14 and set bitcode to “No”
* Added optional methods for the status of device data collection

## [4.1.7] - 2022-09-19

### Fixed

* Resolved potential crash (KDataCollector.m, NSDictionary error) when an iOS application running the Device Data Collector goes offline in the middle of transmitting data to Kount

## [4.1.6] - 2022-09-09

* Updated to support iOS16. Kount's SDK still supports iOS versions back to iOS 11. Current versions of XCode and the AppStore require iOS11 and newer for new applications & updates.
* Removal of iOS10 and lower support. armv7 architectures were removed after iOS10
* Removed Paste Clipboard functionality. This removes the need for additional permissions that would be required with iOS16 to publish an App in the AppStore.
* Fixed occasional issue with Location collection not being asynchronous which caused an application to crash when the location service took too long.

## 4.1.0

* Added new UI element collection capabilities for analytics

## 4.0.4.1

* Documentation update

## 4.0.4

* Fix ARCH issues

## 4.0.3

* Fix C-Flag issue in library which was preventing Archiving

## 4.0.2

* Enabled bitcode flag in library
* Enabled bitcode flag in example apps for testing

## 4.0.1

* Changed Library to a Universal Debug Library to support other platforms like x86 for testing
* Updated Readme documentation for new XCode header changes in swift.

## 4.0

* Enhancements to the iOS SDK for Kount customers including:
  * City Level location information
  * Enhanced timing metrics
  * iOS 13 updates
  * Security and Bug fixes
  * Kount's iOS SDK 4.0.0 is compatible with:

Minimum Version of iOS in application: 9.3
Recommended Target Version of iOS in application: 13
Tested on the following iOS OS Versions:

  * 12.4.4
  * 13
  * 13.1
  * 13.2
  * 13.2.3

## 4.0.0

Enhancements to the iOS SDK for Kount customers including:

* City Level location information
* Enhanced timing metrics
* iOS 13 updates
* Security and Bug fixes

Kount's iOS SDK 4.0.0 is compatible with:

* Minumum Version of iOS in application: 9.3
* Recommended Target Version of iOS in application: 13
* Tested on the following iOS OS Versions:
  * 12.4.4
  * 13
  * 13.1
  * 13.2
  * 13.2.3

## 3.2 

* Resolved Failure to deallocate CLLocationManager
* Resolved Invalid address exception in KCollectorTaskBase
* Resolved Locale reporting information
* Added performance improvements
* Minor updates to keep up to date with XCode

## 3.1

* Updated SDK in preparation for future enhancements. No coding interface changes implemented, completely compatible with established 3.0 integrations.
* Tested with iOS 10
* Bumped deployment target to iOS 8.0

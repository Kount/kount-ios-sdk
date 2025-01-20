# ⚙️ Kount iOS SDK Source

This repository includes a workspace containing four main components:

- **KountDataCollector**: The core SDK.
- **TestApp**: An older method for testing the SDK (to be deprecated).
- **SampleAppSwift**: The current approach to test the SDK.
- **Pods**: Generated upon running 'pod install'.

## Getting Started

### Prerequisites

Ensure you have Xcode installed an CocoaPods for managing dependencies. Before working with the workspace, run 'pod install' in the repository folder to set up the workspace correctly.

### Running the Test App (To be deprecated) & Sample App Swift

To test the SDK using the Test App:

1. In Xcode, select the Sample App Swift project.
2. Choose the scheme selector and pick SampleAppSwift.
3. Choose the device you'd like to run on from the device simulator.
4. Navigate to 'Product > Run' in the menu.

### SDK Testing and Coverage

To test the KountDataCollector SDK:

1. Select 'KountDataCollector' from the scheme selector.
2. Choose 'Edit Scheme' and select 'Test' on the left.
3. Ensure 'Gather Coverage Data' is checked.
4. Close the dialog and select 'Product > Test' from the menu to run the tests.

#### Viewing Coverage Results

1. Select the report navigation icon (resembles a message bubble) in the project view.
2. Choose the last test run under 'KountDataCollector' on the left.
3. Click on the 'Coverage' tab in the middle pane to review results.

### Building the Universal Library + XCFramework

To build the universal library for distribution:

- Execute the specified command from the repository folder: './automation/ios-sdk-generation-script.sh'

## 🤝🏻 Developer Agreements

Please adhere to our developer agreements, including commit and PR templates. These can be fount at:

- Commit Template: https://equifax.atlassian.net/wiki/spaces/MDA/pages/3448046169/Commit+Template
- PR Template: https://equifax.atlassian.net/wiki/spaces/MDA/pages/3448242219/PR+Template

## 📐 Roadmap

For upcoming features and improvements, refer to the App Roadmap  https://equifax.atlassian.net/wiki/spaces/MDA/pages/3286025810/KountDevice+-+Roadmap.

## 🏗️ Coding Standards

Code contributions should follow Clean Architecture, SOLID principles, TDD, linting rules, and general best coding practices.

## 📄 Documentation

For further documentation, please visit https://developer.kount.com/hc/en-us/categories/14340226536596-Device.

## ⚠️ DISCLAIMER

This repository hosts proprietary source code and is intended to remain strictly private. Access is confined to authorized individuals who have explicitly agreed to adhere to confidentiality measures. Unauthorized distribution, copying, or disclosure of its contents is prohibited and may result in legal action.

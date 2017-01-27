iOS Client SDK Setup
====================

Kount's SDK for iOS helps integrate Kount's fraud fighting solution into
your iOS app.

## Requirements

-   [Kount integration](http://www.kount.com/fraud-detection-software)
-   [Xcode 8 and iOS 10 SDK](https://developer.apple.com/xcode/download/)
-   iOS 8.0+ deployment target

## Installation

Download the [Kount iOS SDK](https://github.com/Kount/kount-ios-sdk) and
unzip the file in a folder separate from your project.

Open up your app in Xcode.
In Finder, drag the KountDataCollector folder into the top level of your project, and
check *Copy If Needed*.
Modify your build settings **App Target** &gt; **Build Settings**.
Update Header Search Paths:
-   Add `$(PROJECT_DIR)/KountDataCollector`

## Initialization

To set up the data collector, you'll need to set the merchant ID,
configuration for location collection, and the Kount environment. While
testing your integration you'll want to use the *Test* environment,
switching to *Production* when your app is ready to release.

### Setup

In your AppDelegate add the initialization code:

##### Objective-C

``` 
#import "KDataCollector.h"
              
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  ...
  [[KDataCollector sharedCollector] setMerchantID:<MERCHANT_ID>]; 
  [[KDataCollector sharedCollector] setLocationCollectorConfig:KLocationCollectorConfigRequestPermission];
  // For Test Environment
  [[KDataCollector sharedCollector] setEnvironment:KEnvironmentTest];
  // For Production Environment
  [[KDataCollector sharedCollector] setEnvironment:KEnvironmentProduction];
  ...
}
```

##### Swift:

``` 
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
  ...
        KDataCollector.shared().merchantID = <MERCHANT_ID>
        KDataCollector.shared().locationCollectorConfig = KLocationCollectorConfig.requestPermission
        // For test Environment
	KDataCollector.shared().environment = KEnvironment.test
        // For Production Environment
	KDataCollector.shared().environment = KEnvironment.production
  ...
}
```

### Location Permissions

For location collection support you'll need to add this key to your
**Info.plist** file:

``` 
<key>NSLocationWhenInUseUsageDescription</key>
<string></string>
```

If you choose `KLocationCollectorConfigRequestPermission` the collector
will request permission for you if needed. If you choose
`KLocationCollectorConfigPassive` the collector will only gather
location information if your app has requested permission and the user has granted it permission.

## Collection

Early in the checkout process you'll want to start the data collection
with a unique session ID tied to the transaction, and collect once per unique session ID. For example, in the
viewDidAppear method of a controller early in your transaction workflow,
add the following:

##### Objective-C

``` 
#import "KDataCollector.h"

- (void)viewDidAppear:(BOOL)animated {
  ...
  [[KDataCollector sharedCollector] collectForSession:<SESSION_ID> 
                                           completion:^(NSString * _Nonnull sessionID,  
                                                        BOOL success, 
                                                        NSError * _Nullable error) {
    // Add handler code here if desired. The completion block is optional.
  }];
  ...
}
```

##### Swift:

``` 
override func viewDidAppear(animated: Bool) {
  ...
        KDataCollector.shared().collect(forSession: <SESSION_ID>) { (sessionID, success, error) in
            // Add handler code here if desired. The completion block is optional.
        }
  ...
}
```

## Examples

Open `Examples.xcworkspace` in Xcode to open up the workspace with the following example projects:

### CheckoutExampleObj

A simple example of using the SDK in an Objective C project.

### CheckoutExampleSwift

A simple example of using the SDK in a Swift project.

## Migrating to version 3.x

The interface and workflow of the SDK has changed between version 2 and
version 3. The old version would have you create an instance of the Data
Collector, configure it, make a call to collect, and then implement the
delegate methods if you wished to receive feedback regarding the
collection.

With the new version, the Data Collector is implemented as a singleton
and is configured when your app is created. The collect call is now a
method on the Data Collector singleton and has an optional callback
block you can implement if you wish to get additional information on the
collection. Here are the steps to upgrade to version 3.x:

-   Remove the old library and header file from your project and replace
    it with the new library and header file.
-   Remove the old initialization code and replace it with the new
    initialization code methods on the DataCollector singleton in
    your AppDelegate.
-   Remove the old call to collect and corresponding delegate methods
    and replace it with the collect method on the DataCollector
    singleton, and optionally implement the completion block.

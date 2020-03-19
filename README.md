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
  //[[KDataCollector sharedCollector] setEnvironment:KEnvironmentProduction];
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
        // KDataCollector.shared().environment = KEnvironment.production
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

Early in the checkout process, start the data collection with a unique 
session ID tied to the transaction, and collect once per unique session
ID.

**NOTE:** Only run collection during the checkout process (and the call
should be made early in the collection process). Calling collection
outside of the checkout process may result in a high proportion of 
collection to RIS calls. This may be misinterpreted by our services as a
DDOS attack. While this is rare, we highlight this to emphasize the
importance that collection only be placed at the beginning of the
checkout process.

Below is an example adding the controller to the viewDidAppear method:

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

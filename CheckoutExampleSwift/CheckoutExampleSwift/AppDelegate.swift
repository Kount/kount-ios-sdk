import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //// Configure the Data Collector
        //
        KDataCollector.sharedCollector().debug = true
        // TODO Set your Merchant ID
        KDataCollector.sharedCollector().merchantID = 0 // Insert your valid merchant ID
        // TODO Set the location collection configuration
        KDataCollector.sharedCollector().locationCollectorConfig = KLocationCollectorConfig.RequestPermission
        // For a released app, you'll want to set this to KEnvironment.Production
        KDataCollector.sharedCollector().environment = KEnvironment.Test
        
        return true
    }
}


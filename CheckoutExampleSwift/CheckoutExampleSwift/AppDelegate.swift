import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //// Configure the Data Collector
        //
        KDataCollector.shared().debug = true
        // TODO Set your Merchant ID
        KDataCollector.shared().merchantID = 0 // Insert your valid merchant ID
        // TODO Set the location collection configuration
        KDataCollector.shared().locationCollectorConfig = KLocationCollectorConfig.requestPermission
        // For a released app, you'll want to set this to KEnvironment.Production
        KDataCollector.shared().environment = KEnvironment.test
        
        return true
    }
}


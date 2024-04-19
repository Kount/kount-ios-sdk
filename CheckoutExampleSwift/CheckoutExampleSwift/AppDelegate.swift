import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var sessionID : String = ""

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //// Configure the Data Collector
        //
//        sessionID = UUID().uuidString
//        sessionID = sessionID.replacingOccurrences(of: "-", with: "")
        KDataCollector.shared().debug = true
        // TODO Set your Merchant ID
        KDataCollector.shared().merchantID = "0" // Insert your valid merchant ID
        // TODO Set the location collection configuration
        KDataCollector.shared().locationCollectorConfig = KLocationCollectorConfig.requestPermission
        // For a released app, you'll want to set this to KEnvironment.Production
        KDataCollector.shared().environment = KEnvironment.test
        // To collect Analytics Data, you'll want set this analyticsData to true or else false
        let analyticsData = true
        KountAnalyticsViewController().setEnvironmentForAnalytics(KDataCollector.shared().environment)
        KountAnalyticsViewController().collect(sessionID, analyticsSwitch: analyticsData) {
            (sessionID, success, error) in
                if (success) {
                    print("Collection Successful")
                }
                else {
                    if((error) != nil) {
                        print("Collection failed with error",error?.localizedDescription as Any)
                    }
                    else {
                        print("Collection failed without error")
                    }
                }
            }
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        if #available(*, iOS 12.4.7) {
            KountAnalyticsViewController().registerBackgroundTask()
        }
    }
}


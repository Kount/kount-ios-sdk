import UIKit
import KountSDK

class ViewController: KountAnalyticsViewController, CheckoutViewControllerDelegate  {

    @IBOutlet weak var merchant: UILabel?
    @IBOutlet weak var environment: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        merchant!.text = KDataCollector.shared.merchantID
        
        switch KDataCollector.shared.environment {
        case KountEnvironment.test:
            environment!.text = "Test"
        case KountEnvironment.production:
            environment!.text = "Production"
        default:
            environment!.text = "Unknown"
        }
    }

    func didFinish(_ sender: CheckoutViewController) {
        self.dismiss(animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Checkout" {
            let navigationController = segue.destination
            //To capture Analytics data starting from iOS version 13.0 or later, the modal presentation style should be fullscreen.
            navigationController.modalPresentationStyle = .fullScreen
            let controller :CheckoutViewController = navigationController.childViewControllers[0] as! CheckoutViewController
            controller.checkoutDelegate = self
        }
        
    }
}


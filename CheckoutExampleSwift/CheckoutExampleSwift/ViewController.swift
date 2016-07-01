import UIKit

class ViewController: UIViewController, CheckoutViewControllerDelegate  {

    @IBOutlet weak var merchant: UILabel?
    @IBOutlet weak var environment: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        merchant!.text = String(format:"%ld", KDataCollector.sharedCollector().merchantID)
        
        switch KDataCollector.sharedCollector().environment {
        case KEnvironment.Test:
            environment!.text = "Test"
        case KEnvironment.Production:
            environment!.text = "Production"
        default:
            environment!.text = "Unknown"
        }
    }

    func didFinish(sender: CheckoutViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Checkout" {
            let navigationController = segue.destinationViewController
            let controller :CheckoutViewController = navigationController.childViewControllers[0] as! CheckoutViewController
            controller.delegate = self
        }
        
    }
}


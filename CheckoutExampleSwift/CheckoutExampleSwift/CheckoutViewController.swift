import UIKit

protocol CheckoutViewControllerDelegate: class {
    func didFinish(sender: CheckoutViewController)
}

class CheckoutViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView?
    weak var delegate:CheckoutViewControllerDelegate?
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        var sessionID = NSUUID().UUIDString
        sessionID = sessionID.stringByReplacingOccurrencesOfString("-", withString: "")
        textView!.text = "Collection Starting\n\n"
        textView!.text = textView!.text.stringByAppendingFormat("Session ID:\n%@\n\n", sessionID)
        KDataCollector.sharedCollector().collectForSession(sessionID) { (sessionID, success, error) in
            if success {
                self.textView!.text = self.textView!.text.stringByAppendingString("Collection Successful")
            } else {
                self.textView!.text = self.textView!.text.stringByAppendingString("Collection Failed\n\n")
                if ((error) != nil) {
                  self.textView!.text = self.textView!.text.stringByAppendingString(error!.description)
                }
            }
        }
        
    }
    
    @IBAction func done(sender: AnyObject) {
        self.delegate?.didFinish(self)
    }
}

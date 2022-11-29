import UIKit

protocol CheckoutViewControllerDelegate: class {
    func didFinish(_ sender: CheckoutViewController)
}

class CheckoutViewController: KountAnalyticsViewController {
    
    @IBOutlet weak var textView: UITextView?
    weak var delegate:CheckoutViewControllerDelegate?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        var sessionID = UUID().uuidString
        sessionID = sessionID.replacingOccurrences(of: "-", with: "")
        textView!.text = "Collection Starting\n\n"
        textView!.text = textView!.text.appendingFormat("Session ID:\n%@\n\n", sessionID)
        KDataCollector.shared().collect(forSession: sessionID) { (sessionID, success, error) in
            if success {
                self.textView!.text = self.textView!.text + "Collection Successful"
                print(KountAnalyticsViewController.getKDataCollectionStatus() as Any)
            } else {
                self.textView!.text = self.textView!.text + "Collection Failed\n\n"
                if ((error) != nil) {
                  self.textView!.text = self.textView!.text + error!.localizedDescription
                    print(KountAnalyticsViewController.getKDataCollectionError() as Any)
                }
            }
        }
        
    }
    
    @IBAction func done(_ sender: AnyObject) {
        self.delegate?.didFinish(self)
    }
}

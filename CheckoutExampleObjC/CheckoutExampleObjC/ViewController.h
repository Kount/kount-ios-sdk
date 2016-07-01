#import <UIKit/UIKit.h>
#import "CheckoutViewController.h"

@import CoreLocation;

@interface ViewController : UIViewController <CheckoutViewControllerDelegate, CLLocationManagerDelegate>
@property IBOutlet UILabel *merchant;
@property IBOutlet UILabel *environment;
@end


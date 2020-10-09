#import <UIKit/UIKit.h>
#import "CheckoutViewController.h"
#import "KountAnalyticsViewController.h"

@import CoreLocation;

@interface ViewController : KountAnalyticsViewController <CheckoutViewControllerDelegate, CLLocationManagerDelegate>
@property IBOutlet UILabel *merchant;
@property IBOutlet UILabel *environment;
@end


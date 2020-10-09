#import <UIKit/UIKit.h>
#import "KountAnalyticsViewController.h"

@class CheckoutViewController;

@protocol CheckoutViewControllerDelegate <NSObject>
- (void)checkoutViewControllerDidFinish:(CheckoutViewController *)controller;
@end

@interface CheckoutViewController : KountAnalyticsViewController
@property (nonatomic, weak) id <CheckoutViewControllerDelegate> delegate;
@property (nonatomic) IBOutlet UITextView *textView;
- (IBAction)done:(id)sender;
@end

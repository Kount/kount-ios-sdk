#import <UIKit/UIKit.h>

@class CheckoutViewController;

@protocol CheckoutViewControllerDelegate <NSObject>
- (void)checkoutViewControllerDidFinish:(CheckoutViewController *)controller;
@end

@interface CheckoutViewController : UIViewController
@property (nonatomic, weak) id <CheckoutViewControllerDelegate> delegate;
@property (nonatomic) IBOutlet UITextView *textView;
- (IBAction)done:(id)sender;
@end

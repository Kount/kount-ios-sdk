#import "ViewController.h"
#import "KDataCollector.h"

@implementation ViewController

- (void)viewDidLoad 
{
    [super viewDidLoad];

    switch ([[KDataCollector sharedCollector] environment]) {
        case KEnvironmentProduction:
            self.environment.text = @"Production";
            break;
        case KEnvironmentTest:
            self.environment.text = @"Test";
            break;
        default:
            self.environment.text = @"Unknown";
    }
    
    self.merchant.text = [NSString stringWithFormat:@"%06ld", [[KDataCollector sharedCollector] merchantID]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Checkout"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        CheckoutViewController *controller = [navigationController viewControllers][0];
        controller.delegate = self;
    }
}

- (void)checkoutViewControllerDidFinish:(CheckoutViewController *)controller 
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

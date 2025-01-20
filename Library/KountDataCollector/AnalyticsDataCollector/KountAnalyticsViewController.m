//
//  KountAnalyticsViewController.m
//  KountDataCollector
//
//  Created by Vamsi Krishna on 07/08/20.
//  Copyright © 2020 Kount Inc. All rights reserved.
//

#import "KountAnalyticsViewController.h"
#import "UIViewController+TouchControl.h"
#import "CustomWindow.h"
#import "UIControl+CustomControl.h"
#import "PostPayloadKeys.h"
#import "DeviceDataPayload.h"
#import "PostRequest.h"
#import "StoreUIContolsData.h"
#import "RegExValidation.h"
#import "NetworkValidation.h"

@interface KountAnalyticsViewController ()

@end

@implementation KountAnalyticsViewController

//Variable declaration for KEnvironment
NSString *postEnvironmentURL;

//viewDidLoad one time execution
int countViewDidLoad;

//Variable declaration for KEnvironment
NSString *postEnvironmentURL;

//Variable Declaration for Form Session
NSDictionary *dataFromDeviceSDK;
BOOL isDeviceDataCollected;
BOOL isDeviceJailBroken;
NSNumber *copyIsDeviceJailBroken;
static NSString *appSessionID;
NSString *appMerchantID;
BOOL analyticsDataFlag;
NSString *activeViewName;
int64_t activeVCStartTimestamp;
int64_t copyActiveVCStartTimestamp;
int64_t activeVCStopTimestamp;
int64_t totalActiveVCTime;
NSString *formSessionID;
int64_t formSubmissionTimestamp;
BOOL flagViewAppear;
BOOL flagViewDisappear;
CMMotionManager *motionManager;
NSNumber *isAccelerometerData;
NSNumber *isGyroData;
NSNumber *isMagnetometerData;
NSNumber *isDeviceMotion;
BOOL isForm;
NSData *jsonData;
int64_t *touchTimeStamp;
NSData *formJSONData;
NSMutableDictionary *formDataDict;

//Variable Declaration for TextField Session
NSInteger *deletionCount;
int64_t focusStartTime;
int64_t focusStopTime;
int64_t totalTimeFocused;
NSUInteger countChar;
int textFieldCount;
NSString *textFieldPlaceholder;
int64_t currentMSPerCharacter;
NSMutableArray *inputSessionArray;
NSMutableArray *storeCharactersEnteringTime;
NSMutableArray *differenceBetweenTwoCharacters;
NSMutableArray *storeCharacterDeletionTime;
NSMutableArray *keyPressingTime;
NSMutableArray *differenceBetweenTwoKeyPresses;
float inputSessionHeight;
float inputSessionWidth;

//Variable Declaration for TextView Session
BOOL isTextView;

//Variable Declaration for SearchBar Session
BOOL isSearchBarTextField;

//Variable Declaration for Button Session
int64_t buttonStartTime;
int64_t buttonElapsedTime;
int64_t button_timestamp;
int buttonCount;
BOOL isButtonClicked;
NSMutableArray *buttonSessionArray;
NSString *UIButtonTypeString;

//Variable Declaration for Login Session
int logInAttempts;
NSMutableArray *logInEvents;

//Variable Declaration for Slider Session
Float64 startingXCoordinate;
Float64 startingYCoordinate;
Float64 endingXCoordinate;
Float64 endingYCoordinate;
int64_t sliderStartTimeStamp;
float sliderStartValue;
NSMutableArray *sliderSessionArray;

//Variable declaration for Stepper session
int64_t stepperStartTime;
int64_t stepperElapsedTime;
double stepperOldValue;
NSMutableArray *stepperSessionArray;

//Variable declaration for PageControl session
int64_t pageControlStartTime;
NSInteger previousPage;
NSMutableArray *pageControlSessionArray;

//Variable declaration for UIColorWell session
NSString *colorWellButtonType;


//Variable declaration for UIImageView session
NSMutableArray *imageViewSessionArray;

//Variable Declaration for Battery Session
BOOL isLowPowerMode;
NSString *batteryState;
float batteryLevel;
int batteryObserverCount;
NSMutableArray *batterySessionArray;

//Variable Declaraion for Device Orientation Session
int deviceOrientationObserverCount;
NSString *deviceOrientation;
NSMutableArray *deviceOrientationArray;

//Variable Declaration for Device Data Collector
NSMutableDictionary *deviceDataDict;
//DMD-352
//Variable Declaration for Collection Status
NSString *kDataCollectionStatus;

//Variable Declaration for Collection Error
NSError *kDataCollectionError;

//Variable Declaration for Touch Coordinates
NSMutableArray *touchCoordinatesArray;

BOOL isDebugEnabled;//DMD-750

// MARK: ViewController Life Cycle Methods

- (void)viewDidLoad {
    countViewDidLoad += 1;
    [super viewDidLoad];
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
    if (countViewDidLoad == 1) {
        [self setKDataCollectionStatus:KDataCollectorStatusNotStarted];
        motionManager = [[CMMotionManager alloc] init];
        [motionManager startAccelerometerUpdates];
        [motionManager startGyroUpdates];
        [motionManager startMagnetometerUpdates];
        [motionManager startDeviceMotionUpdates];
        motionManager.deviceMotionUpdateInterval = 1.0;
        logInEvents = [[NSMutableArray alloc] init];
        storeCharactersEnteringTime = [NSMutableArray array];
        storeCharacterDeletionTime = [NSMutableArray array];
        differenceBetweenTwoCharacters = [NSMutableArray array];
        keyPressingTime = [NSMutableArray array];
        differenceBetweenTwoKeyPresses = [NSMutableArray array];
        inputSessionArray = [[NSMutableArray alloc] init];
        deviceOrientationArray = [[NSMutableArray alloc] init];
        batterySessionArray = [[NSMutableArray alloc] init];
        touchCoordinatesArray = [[NSMutableArray alloc] init];
        buttonSessionArray = [[NSMutableArray alloc] init];
        sliderSessionArray = [[NSMutableArray alloc] init];
        stepperSessionArray = [[NSMutableArray alloc] init];
        pageControlSessionArray = [[NSMutableArray alloc] init];
        imageViewSessionArray = [[NSMutableArray alloc] init];
        formDataDict = [[NSMutableDictionary alloc] init];
    }
    self.touchDelegate = self;
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    flagViewAppear = YES;
    [self appear];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if(flagViewAppear == NO) {
        [self appear];
    }
    flagViewAppear = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    flagViewDisappear = YES;
    [self disappear];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if(flagViewDisappear == NO) {
        [self disappear];
    }
    flagViewDisappear = NO;
}

// Method to detect active Viewcontroller name and it's start timestamp
- (void)appear {
    // Checking Core Motion data.
    [self checkForDeviceMotion];
    // Return if device is jailbroken or not.
    isDeviceJailBroken  = [self checkIsDeviceJailbroken];
    copyIsDeviceJailBroken = [NSNumber numberWithBool:isDeviceJailBroken];
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    batteryObserverCount += 1;
    if(batteryObserverCount == 1) {
        // Calling method to initialize observers for battery session data only once when application is launched
        [self collectBatteryData];
    }
    [self assignBatteryData];
    
    deviceOrientationObserverCount += 1;
    if (deviceOrientationObserverCount == 1) {
        // Calling method to initialize observers for device orientation data only once when application is launched
        [self collectDeviceOrientationData];
    }
    else {
        [self getDeviceOrientationData];
    }
    
    UIViewController *topMostViewController = [self topViewController];
    NSString *nameSpaceClassName = NSStringFromClass(topMostViewController.class);
    activeViewName = nameSpaceClassName;
    activeVCStartTimestamp = [self getEpochTime];
    copyActiveVCStartTimestamp = activeVCStartTimestamp;
    formSessionID = [self getSessionID];
    // Create and send form data after view controller appears.
    [self assignFormData];
    
    // Resetting the data
    copyIsDeviceJailBroken = nil;
    activeVCStartTimestamp = 0;
    isAccelerometerData = nil;
    isGyroData = nil;
    isMagnetometerData = nil;
    isDeviceMotion = nil;
}

// Method to detect end timestamp of active Viewcontroller and total time this VC was active.
- (void)disappear {
    [self.view endEditing:YES];
    activeVCStartTimestamp = copyActiveVCStartTimestamp;
    activeVCStopTimestamp = [self getEpochTime];
    if(activeVCStartTimestamp > 0 && activeVCStopTimestamp > 0) {
        totalActiveVCTime = activeVCStopTimestamp - activeVCStartTimestamp;
    }
    else {
        totalActiveVCTime = 0;
    }
    // Check if it is form then calculate timestamp when form is submitted
    if (isForm) {
        formSubmissionTimestamp = [self getEpochTime];
    }
    else {
        formSubmissionTimestamp = 0;
    }
    // Create and send form data after view controller disappears.
    [self assignFormData];
    
    //Resetting to zero
    totalActiveVCTime = 0;
    activeVCStopTimestamp = 0;
    activeVCStartTimestamp = 0;
    formSubmissionTimestamp = 0;
}

+ (id)sharedInstance {
    static KountAnalyticsViewController *kountAnalyticsObj = nil;
    kountAnalyticsObj = [[self alloc] init];
    return kountAnalyticsObj;
}

// MARK: Device Orientation Methods

- (void)collectDeviceOrientationData {
    [self getDeviceOrientationData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceDidRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

// Get's called when there is a change in device orientation

- (void)deviceDidRotate:(NSNotification *)notification {
    [self getDeviceOrientationData];
    // Create and send form data when there is a change in device orientation.
    [self assignFormData];
}

- (void)getDeviceOrientationData {
    UIDeviceOrientation currentOrientation = [[UIDevice currentDevice] orientation];
    switch (currentOrientation) {
        case UIDeviceOrientationUnknown:
            deviceOrientation = @"UNKNOWN";
            break;
        case UIDeviceOrientationPortrait:
            deviceOrientation = @"PORTRAIT";
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            deviceOrientation = @"PORTRAIT UPSIDE DOWN";
            break;
        case UIDeviceOrientationLandscapeLeft:
            deviceOrientation = @"LANDSCAPE LEFT";
            break;
        case UIDeviceOrientationLandscapeRight:
            deviceOrientation = @"LANDSCAPE RIGHT";
            break;
        case UIDeviceOrientationFaceUp:
            deviceOrientation = @"FACE UP";
            break;
        case UIDeviceOrientationFaceDown:
            deviceOrientation = @"FACE DOWN";
            break;
        default:
            deviceOrientation = @"UNABLE TO CAPTURE THE ORIENTATION";
            break;
    }
    [self assignDeviceOrientationData];
}

- (void)assignDeviceOrientationData {
    NSMutableDictionary *deviceOrientationDict;
    deviceOrientationDict = [[NSMutableDictionary alloc] init];
    [deviceOrientationDict setValue:[self getSessionID] forKey:DeviceOrientationSessionID];
    [deviceOrientationDict setValue:deviceOrientation forKey:DeviceOrientation];
    [deviceOrientationDict setValue:[NSNumber numberWithLongLong:[self getEpochTime]] forKey:DeviceOrientationTimestamp];
    [deviceOrientationArray addObject:deviceOrientationDict];
}

// MARK: Battey Session Methods

- (void)collectBatteryData {
    [self getBatteryLevel];
    [self getBatteryState];
    [self getLowPowerModeStatus];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeBatteryState:) name:UIDeviceBatteryStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeBatteryLevel:) name:UIDeviceBatteryLevelDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangePowerMode:)
        name:NSProcessInfoPowerStateDidChangeNotification object:nil];
}

// Get's called when there is a change in level
- (void)getBatteryLevel {
    batteryLevel = [[UIDevice currentDevice] batteryLevel];
}

//Get's called when there is a change in state
- (void)getBatteryState {
    switch ([[UIDevice currentDevice] batteryState]) {
        case UIDeviceBatteryStateUnknown:
            batteryState = @"UNKNOWN";
            break;
        case UIDeviceBatteryStateCharging:
            batteryState = @"CHARGING";
            break;
        case UIDeviceBatteryStateFull:
            batteryState = @"FULL";
            break;
        case UIDeviceBatteryStateUnplugged:
            batteryState = @"UNPLUGGED";
            break;
        default:
            batteryState = @"UNABLE TO CAPTURE THE STATE";
            break;
    }
}

- (void)getLowPowerModeStatus {
    isLowPowerMode = [[NSProcessInfo processInfo] isLowPowerModeEnabled];
}

- (void)didChangeBatteryState:(NSNotification *)notification {
    [self getBatteryState];
    [self assignBatteryData];
    // Create and send form data when there is a change in battery state.
    [self assignFormData];
}

- (void)didChangeBatteryLevel:(NSNotification *)notification {
    [self getBatteryLevel];
    [self assignBatteryData];
    // Create and send form data when there is a change in battery level.
    [self assignFormData];
}

- (void)didChangePowerMode:(NSNotification *)notification {
    [self getLowPowerModeStatus];
    [self assignBatteryData];
    // Create and send form data when there is a change in power mode status.
    [self assignFormData];
}

- (void)assignBatteryData {
    NSMutableDictionary *batterySessionDict;
    batterySessionDict = [[NSMutableDictionary alloc] init];
    [batterySessionDict setValue:[self getSessionID] forKey:BatterySessionID];
    [batterySessionDict setValue:[NSNumber numberWithLongLong:[self getEpochTime]] forKey:BatteryTimestamp];
    [batterySessionDict setValue:[NSNumber numberWithBool:[[UIDevice currentDevice] isBatteryMonitoringEnabled]]  forKey:IsBatteryMonitoringEnabled];
    [batterySessionDict setValue:[NSNumber numberWithFloat:batteryLevel] forKey:BatteryLevel];
    [batterySessionDict setValue:batteryState forKey:BatteryState];
    [batterySessionDict setValue:[NSNumber numberWithBool:isLowPowerMode] forKey:IsLowPowermode];
    [batterySessionArray addObject:batterySessionDict];
}

// MARK: Data Collection Status Methods

// DMD-352
- (void)setKDataCollectionStatus:(KDataCollectorStatus)collectionStatus {
    switch (collectionStatus) {
        case KDataCollectorStatusNotStarted:
            kDataCollectionStatus = @"Not Started";
            break;
        case KDataCollectorStatusStarted:
            kDataCollectionStatus = @"Started";
            break;
        case KDataCollectorStatusCompleted:
            kDataCollectionStatus = @"Completed";
            break;
        case KDataCollectorStatusFailedWithError:
            kDataCollectionStatus = @"Failed With Error";
            break;
        case KDataCollectorStatusFailedWithOutError:
            kDataCollectionStatus = @"Failed Without Error";
            break;
        default:
            kDataCollectionStatus = @"Not Started";
            break;
    }
}

+ (nullable NSString *)getKDataCollectionStatus {
    return kDataCollectionStatus;
}

- (void)setKDataCollectionError:(NSError * _Nullable)error {
    kDataCollectionError = error;
}

+ (nullable NSError *)getKDataCollectionError {
    return kDataCollectionError;
}

// MARK: LogIn Session Method

// Method to store login events and number of login attempts.
- (void)storeLogInEvents:(BOOL)logInStatus {
    logInAttempts = logInAttempts + 1;
    NSMutableDictionary *logInSessionDict;
    logInSessionDict = [[NSMutableDictionary alloc] init];
    [logInSessionDict setValue:[self getSessionID] forKey:LogInSessionID];
    [logInSessionDict setValue:[NSNumber numberWithLongLong:[self getEpochTime]] forKey:LogInTimeStamp];
    [logInSessionDict setValue:[NSNumber numberWithBool:logInStatus] forKey:LogInSuccess];
    [logInSessionDict setValue:[NSNumber numberWithBool:!logInStatus] forKey:LogInFailure];
    [logInSessionDict setValue:[NSNumber numberWithInt:logInAttempts] forKey:LogInAttempts];
    [logInEvents addObject:logInSessionDict];
    //Create and send form data when login events get captured
    [self assignFormData];
}

// MARK: Session Id generation Methods

// Method to create and return specific session ID's
- (NSString *)getSessionID {
    CFUUIDRef uuidRef = CFUUIDCreate(nil);
    CFStringRef uuidStrRef = CFUUIDCreateString(nil, uuidRef);
    CFRelease(uuidRef);
    NSString *uniqueSessionId = [(__bridge NSString *)uuidStrRef stringByReplacingOccurrencesOfString:@"-" withString:@""];
    CFRelease(uuidStrRef);
    return uniqueSessionId;
}

// Metod to access AppSessionID global to application
+ (NSString *)getAppSessionID {
    return appSessionID;
}

// MARK: Collection and Setting Environment Methods

- (void)collect:(NSString *)sessionID analyticsSwitch:(BOOL)analyticsData completion:(void (^)(NSString * _Nonnull, BOOL success, NSError * _Nullable))completionBlock {
    analyticsDataFlag = analyticsData;
    appMerchantID = [[KDataCollector sharedCollector] merchantID];
    isDebugEnabled = [[KDataCollector sharedCollector] debug];//DMD-750
    if(sessionID == nil || [sessionID isEqualToString:@""]) {
        sessionID = [self getSessionID];
        appSessionID = sessionID;
    } else {
        appSessionID = sessionID;
    }
    
    if ([RegExValidation validSessionID:appSessionID isDebug:isDebugEnabled completion:completionBlock debugDelegate:self]
        && [RegExValidation validMerchantID:appSessionID isDebug:isDebugEnabled merchantID:appMerchantID completion:completionBlock debugDelegate:self]
        && [RegExValidation validURL:appSessionID isDebug:isDebugEnabled server:postEnvironmentURL completion:completionBlock debugDelegate:self]
        && [NetworkValidation validateNetwork:appSessionID isDebug:isDebugEnabled completion:completionBlock debugDelegate:self]) {
        //DataCollector collection gets started here
        [self setKDataCollectionStatus:KDataCollectorStatusStarted];
        deviceDataDict = [[NSMutableDictionary alloc] init];//DMD-751
        [[KDataCollector sharedCollector] collectForSession:sessionID completion:^(NSString * _Nonnull sessionID, BOOL success, NSError * _Nullable error) {
            if (success) {
                isDeviceDataCollected = YES;
                [self createJsonObjectFormat];
                [self setKDataCollectionStatus:KDataCollectorStatusCompleted];
                completionBlock(sessionID, success, error);
                if (isDebugEnabled) {
                    NSLog(@"Collection Successful");
                }
            } else {
                if(error != nil) {
                    if (isDebugEnabled) {
                        NSLog(@"Collection Failed with error");
                    }
                    [self setKDataCollectionStatus:KDataCollectorStatusFailedWithError];
                    [self setKDataCollectionError:error];
                    completionBlock(sessionID, success, error);
                } else {
                    if (isDebugEnabled) {
                        NSLog(@"Collection Failed without error");
                    }
                    [self setKDataCollectionStatus:KDataCollectorStatusFailedWithOutError];
                    completionBlock(sessionID, success, error);
                }
            }
            // Add handler code here if desired. The completion block is optional.
        }];
    }
}

// Method to set the post URL on the basis of what environment is used.
- (void)setEnvironmentForAnalytics:(KEnvironment)env {
    switch (env) {
        case KEnvironmentTest:
            postEnvironmentURL = @"https://tst.kaptcha.com/formAnalytics/";
            break;
        case KEnvironmentProduction:
            postEnvironmentURL = @"https://ssl.kaptcha.com/formAnalytics/";
            break;
        default:
            //Development
            postEnvironmentURL = @"https://mbl.kaptcha.com/formAnalytics/";
            break;
    }
}

// MARK: Check Device Jail Break Method

// Method to check if device is jailbroken or not.
- (BOOL)checkIsDeviceJailbroken {
#if !(TARGET_IPHONE_SIMULATOR)
    // Check 1 : existence of files that are common for jailbroken devices
    NSURL *url = [NSURL URLWithString:@"cydia://package/com.example.package"];
    NSString *path1 = @"/Applications/Cydia.app";
    NSString *path2 = @"/Library/MobileSubstrate/MobileSubstrate.dylib";
    NSString *path3 = @"/bin/bash";
    NSString *path4 = @"/usr/sbin/sshd";
    NSString *path5 = @"/etc/apt";
    NSString *path6 = @"/private/var/lib/apt/";
    if ([[NSFileManager defaultManager] fileExistsAtPath: path1]
        || [[NSFileManager defaultManager] fileExistsAtPath: path2]
        || [[NSFileManager defaultManager] fileExistsAtPath: path3]
        || [[NSFileManager defaultManager] fileExistsAtPath: path4]
        || [[NSFileManager defaultManager] fileExistsAtPath: path5]
        || [[NSFileManager defaultManager] fileExistsAtPath: path6]
        || [[UIApplication sharedApplication] canOpenURL: url]) {
        return YES;
    }
    FILE *f = NULL ;
    if ((f = fopen("/bin/bash", "r"))
        || (f = fopen("/Applications/Cydia.app", "r"))
        || (f = fopen("/Library/MobileSubstrate/MobileSubstrate.dylib", "r"))
        || (f = fopen("/usr/sbin/sshd", "r"))
        || (f = fopen("/etc/apt", "r"))) {
        fclose(f);
        return YES;
    }
    fclose(f);
    // Check 2 : Reading and writing in system directories (sandbox violation)
    NSError *error;
    NSString *stringToBeWritten = @"Jailbreak Test";
    [stringToBeWritten writeToFile:@"/private/jailbreak.txt" atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if(error == nil){
        //Device is jailbroken
        return YES;
    }
    else {
        [[NSFileManager defaultManager] removeItemAtPath:@"/private/jailbreak.txt" error:nil];
    }
#endif
    return NO;
}

//Returns EpochTime
- (int64_t)getEpochTime {
    NSDate *date = [NSDate date]; // current date
    int64_t epochTime = [date timeIntervalSince1970] * 1000;
    return epochTime;
}

//MARK: TextView Delegate Methods

- (void)textViewDidBeginEditing:(UITextView *)textView {
    //Converting UITextView to UITextField for capturing UITextView data by using UITextField methods
    UITextField *myTextField = (UITextField *) textView;
    [self textFieldDidBeginEditing:myTextField];
    isTextView = YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    //Converting UITextView to UITextField for capturing UITextView data by using UITextField methods
    UITextField *myTextField = (UITextField *) textView;
    [self textField:myTextField shouldChangeCharactersInRange:range replacementString:text];
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    //Converting UITextView to UITextField for capturing UITextView data by using UITextField methods
    UITextField *myTextField = (UITextField *) textView;
    [self textFieldDidEndEditing:myTextField];
}

//MARK: SearchBar Delegate Methods

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    //Converting UISearchBar to UITextField for capturing UITextView data by using UITextField methods
    UITextField *myTextField = (UITextField *) searchBar;
    [self textFieldDidBeginEditing:myTextField];
    isSearchBarTextField = YES;
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    //Converting UISearchBar to UITextField for capturing UITextView data by using UITextField methods
    UITextField *myTextField = (UITextField *) searchBar;
    [self textField:myTextField shouldChangeCharactersInRange:range replacementString:text];
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    //Converting UISearchBar to UITextField for capturing UITextView data by using UITextField methods
    UITextField *myTextField = (UITextField *) searchBar;
    [self textFieldDidEndEditing:myTextField];
}

//MARK: TextField Session Methods

// Method to store the start time when key is tapped.
- (void)storeStartingTime {
    int64_t epochTime = [self getEpochTime];
    NSNumber *numberFormat = [NSNumber numberWithLongLong:epochTime];
    [keyPressingTime addObject:numberFormat];
    [storeCharactersEnteringTime addObject:numberFormat];
}

// Method to store the time when deletion key is tapped.
- (void)storeDeletionTime {
    int64_t epochTime = [self getEpochTime];
    NSNumber *numberFormat = [NSNumber numberWithLongLong:epochTime];
    [storeCharacterDeletionTime addObject:numberFormat];
}

// This method finds the time difference in ms between two keys entered excluding deletion key.
- (void)msDifferenceBetweenCharacter {
    // Resetting the count of deleted characters to 0.
    deletionCount = 0;
    // If textfield is not empty, it will calculate the difference (in ms) between each character.
    if(storeCharactersEnteringTime.count > 0) {
        for(int i = 0; i < (storeCharactersEnteringTime.count - 1); i++) {
            NSNumber *numberFormat = [NSNumber numberWithLongLong:[[storeCharactersEnteringTime objectAtIndex:i+1] longLongValue] - [[storeCharactersEnteringTime objectAtIndex:i] longLongValue]];
            [differenceBetweenTwoCharacters addObject:numberFormat];
        }
    }
}

// This Method finds the time difference in ms between two keys entered including deletion key.
- (void)allMsDifferenceBetweenKeys {
    if(keyPressingTime.count > 0) {
        for(int i = 0; i < (keyPressingTime.count - 1); i++) {
            NSNumber *numberFormat = [NSNumber numberWithLongLong:[[keyPressingTime objectAtIndex:i+1] longLongValue] - [[keyPressingTime objectAtIndex:i] longLongValue]];
            [differenceBetweenTwoKeyPresses addObject:numberFormat];
        }
    }
}

//MARK: TextField Delegate Methods

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    focusStartTime = [self getEpochTime];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    isForm = YES;
    if(string.length == 0 && range.length > 0) {
        deletionCount += 1;
        [self storeDeletionTime];
        if(storeCharactersEnteringTime.count >0) {
            [storeCharactersEnteringTime removeLastObject];
        }
        return YES;
    }
    [self storeStartingTime];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    inputSessionHeight = [textField bounds].size.height;
    inputSessionWidth = [textField bounds].size.width;
    focusStopTime =  [self getEpochTime];
    // Calculate total time focused
    if(focusStartTime > 0 && focusStopTime > 0) {
        totalTimeFocused = focusStopTime - focusStartTime;
    }
    else {
        totalTimeFocused = 0;
    }
    // Setting count of characters to count of characters entered in textfield.
    countChar = textField.text.length;
    // If textfield is not empty
    if(storeCharactersEnteringTime.count > 0) {
        NSString *textFieldCountString = [NSString stringWithFormat: @"%i", textFieldCount];
        NSString *textFieldPlaceHolderName;
        if(isTextView) {
            // Create and send the textView Element Id.
            textFieldPlaceholder = [NSString stringWithFormat:@"input_textView_session_%@",textFieldCountString];
        }
        else {
            textFieldPlaceHolderName = textField.placeholder;
            if(textField.placeholder == nil) {
                // Create and send the textfield placeholder to Element Id.
                if(isSearchBarTextField) {
                    textFieldPlaceholder = [NSString stringWithFormat:@"input_searchBarTextField_session_%@",textFieldCountString];
                }
                else {
                    textFieldPlaceholder = [NSString stringWithFormat:@"input_textField_session_%@",textFieldCountString];
                }
            }
            else {
                textFieldPlaceholder = [NSString stringWithFormat:@"input_%@",textFieldPlaceHolderName];
            }
        }
        [self allMsDifferenceBetweenKeys];
        [self msDifferenceBetweenCharacter];
        // If characters entered are more than one then calculating average
        if(differenceBetweenTwoCharacters.count > 1) {
            // Calculate average typing speed for characters entered.
            int64_t average = 0;
            for(int i = 0; i < differenceBetweenTwoCharacters.count; i++) {
                NSNumber *numberFormat = [NSNumber numberWithLongLong: [[differenceBetweenTwoCharacters objectAtIndex:i] longLongValue]];
                average = average + [numberFormat intValue];
            }
            currentMSPerCharacter = average / differenceBetweenTwoCharacters.count;
        }
        textFieldCount = textFieldCount + 1;
        [self assignInputData];
        // Resetting count of characters to 0
        countChar = 0;
        // Resetting average typing speed to 0
        currentMSPerCharacter = 0;
        // Reset to empty arrays.
        [storeCharactersEnteringTime removeAllObjects];
        [storeCharacterDeletionTime removeAllObjects];
        [keyPressingTime removeAllObjects];
        [differenceBetweenTwoCharacters removeAllObjects];
        [differenceBetweenTwoKeyPresses removeAllObjects];
        // Resetting textView and searchBarTextField
        isTextView = NO;
        isSearchBarTextField = NO;
    }
}

// Method to assign input session data values to dictionary.
- (void)assignInputData {
    NSArray *copyOfStoreCharactersEnteringTime = [storeCharactersEnteringTime copy];
    NSArray *copyOfStoreCharacterDeletionTime = [storeCharacterDeletionTime copy];
    NSArray *copyOfKeyPressingTime = [keyPressingTime copy];
    NSArray *copyOfDifferenceBetweenTwoCharacters = [differenceBetweenTwoCharacters copy];
    NSArray *copyOfDifferenceBetweenTwoKeyPresses = [differenceBetweenTwoKeyPresses copy];
    NSMutableDictionary *inputSessionDict;
    inputSessionDict = [[NSMutableDictionary alloc] init];
    [inputSessionDict setValue:[self getSessionID] forKey:InputSessionID];
    [inputSessionDict setValue:[NSNumber numberWithLongLong:focusStartTime] forKey:InputSessionStartTimestamp];
    [inputSessionDict setValue:textFieldPlaceholder forKey:ElementID];
    [inputSessionDict setValue:[NSNumber numberWithLongLong:focusStartTime] forKey:FocusStartTimestamp];
    [inputSessionDict setValue:[NSNumber numberWithLongLong:focusStopTime] forKey:FocusStopTimestamp];
    [inputSessionDict setValue:[NSNumber numberWithLongLong:totalTimeFocused] forKey:MSTotalTimeFocused];
    [inputSessionDict setValue:copyOfStoreCharactersEnteringTime forKey:EpochInputKeys];
    [inputSessionDict setValue:copyOfKeyPressingTime forKey:EpochAllInputKeys];
    [inputSessionDict setValue:[storeCharactersEnteringTime firstObject] forKey:FirstCharacterTimestamp];
    [inputSessionDict setValue:[storeCharactersEnteringTime lastObject] forKey:LastCharacterTimestamp];
    [inputSessionDict setValue:[NSNumber numberWithLongLong:currentMSPerCharacter] forKey:CurrentMSPerCharacter];
    [inputSessionDict setValue:[NSNumber numberWithLongLong:countChar] forKey:InputLength];
    [inputSessionDict setValue:copyOfDifferenceBetweenTwoCharacters forKey:MSDifferenceBetweenCharacters];
    [inputSessionDict setValue:[NSNumber numberWithLongLong:keyPressingTime.count] forKey:NumberOfKeysTapped];
    [inputSessionDict setValue:copyOfDifferenceBetweenTwoKeyPresses forKey:AllMSDifferenceBetweenCharacters];
    [inputSessionDict setValue:copyOfStoreCharacterDeletionTime forKey:EpochDeletions];
    [inputSessionDict setValue:[NSNumber numberWithFloat:inputSessionHeight] forKey:Height];
    [inputSessionDict setValue:[NSNumber numberWithFloat:inputSessionWidth] forKey:Width];
    // Setting control type to identify each UIControl
    if(isTextView) {
        [inputSessionDict setValue:(isTextView) ? @"UITextView" : nil forKey:ControlType];
    }
    if(isSearchBarTextField) {
        [inputSessionDict setValue:(isSearchBarTextField) ? @"UISearchBar" : nil forKey:ControlType];
    }
    [inputSessionArray addObject:inputSessionDict];
    
    // Create and send form data when input (TextField) events get captured.
    [self assignFormData];
}

// MARK: Creating JSON Object Method

// This method assigns device data and analytics data and arrange them in an object to send to server on the basis of various conditions.
- (void)createJsonObjectFormat {
    if(isDeviceDataCollected) {
        dataFromDeviceSDK = [[KDataCollector sharedCollector] deviceDataForAnalytics];
        DeviceDataPayload *deviceDataObject = [[DeviceDataPayload alloc] init];
        deviceDataDict = [deviceDataObject transformingDeviceData:dataFromDeviceSDK];
        isDeviceDataCollected = NO;
    }
    
    NSMutableDictionary *postPayLoadDict = [[NSMutableDictionary alloc] init];
    [postPayLoadDict setValue:appMerchantID forKey:MerchantID];
    [postPayLoadDict setValue:appSessionID forKey:SessionID];
    [postPayLoadDict setValue:([deviceDataDict count] != 0) ? deviceDataDict : nil forKey:DeviceData];
    //If it's true then form data will be sent every time (Flag)
    if(analyticsDataFlag) {
        [postPayLoadDict setValue:([formDataDict count] != 0) ? formDataDict : nil forKey:FormData];
    }
    //Else form data will not be sent so, it will be empty (Kill switch)
    else {
        [formDataDict removeAllObjects];
        [postPayLoadDict setValue:nil forKey:FormData];
    }
    //Converting Payload to Data
    NSData *postPayLoadData;
    @try {
        postPayLoadData = [NSJSONSerialization dataWithJSONObject:postPayLoadDict options:NSJSONWritingPrettyPrinted error:nil];
    }
    @catch (NSException *exception) {
        //NSLog(@"%@", exception.name);
        //NSLog(@"%@", exception.reason);
        NSMutableDictionary *errorDict = [[NSMutableDictionary alloc] init];
        [errorDict setValue:exception.name forKey:@"error_name"];
        [errorDict setValue:exception.reason forKey:@"error_reason"];
        postPayLoadData = [NSJSONSerialization dataWithJSONObject:errorDict options:NSJSONWritingPrettyPrinted error:nil];
    }
    //Calling Post request and validate merchantID
    if([deviceDataDict count] != 0 || analyticsDataFlag) {
        PostRequest *postRequestObject = [[PostRequest alloc] init];
        [postRequestObject postingDataToServer:postPayLoadData postURL:postEnvironmentURL];
    }
    //Resetting data
    [formDataDict removeAllObjects];
    [deviceDataDict removeAllObjects];
}

// MARK: Create and send Form Session Method

- (void)assignFormData {
    NSArray *copyOfInputSessionArray = [inputSessionArray copy];
    NSArray *copyOfDeviceOrientationArray = [deviceOrientationArray copy];
    NSArray *copyOfBatterySessionArray = [batterySessionArray copy];
    NSArray *copyOfLogInEvents = [logInEvents copy];
    NSArray *copyOfTouchCoordinatesArray = [touchCoordinatesArray copy];
    NSArray *copyOfButtonSessionArray = [buttonSessionArray copy];
    NSArray *copyOfSliderSessionArray = [sliderSessionArray copy];
    NSArray *copyOfStepperSessionArray = [stepperSessionArray copy];
    NSArray *copyOfPageControlSessionArray = [pageControlSessionArray copy];
    NSArray *copyOfImageViewSessionArray = [imageViewSessionArray copy];
    [formDataDict setValue:([copyOfLogInEvents count] != 0) ? copyOfLogInEvents :nil forKey:LogInSession];
    [formDataDict setValue:formSessionID forKey:FormSessionID];
    [formDataDict setValue:copyIsDeviceJailBroken forKey:IsJailBroken];
    [formDataDict setValue:(formSubmissionTimestamp == 0) ? nil : [NSNumber numberWithLongLong:formSubmissionTimestamp] forKey:SubmissionTimeStamp];
    [formDataDict setValue:activeViewName forKey:ScreenName];
    [formDataDict setValue:(activeVCStartTimestamp == 0) ? nil : [NSNumber numberWithLongLong:activeVCStartTimestamp] forKey:ScreenStartTimestamp];
    [formDataDict setValue:(activeVCStopTimestamp == 0) ? nil : [NSNumber numberWithLongLong:activeVCStopTimestamp] forKey:ScreenStopTimestamp];
    [formDataDict setValue:(totalActiveVCTime == 0) ? nil : [NSNumber numberWithLongLong:totalActiveVCTime] forKey:MSScreenTotalTime];
    [formDataDict setValue:isAccelerometerData forKey:IsAccelerometer];
    [formDataDict setValue:isGyroData forKey:IsGyroscope];
    [formDataDict setValue:isMagnetometerData forKey:IsMagnetometer];
    [formDataDict setValue:isDeviceMotion forKey:IsDeviceMotion];
    [formDataDict setValue:([copyOfDeviceOrientationArray count] != 0)? copyOfDeviceOrientationArray : nil forKey:DeviceOrientationSessions];
    [formDataDict setValue:([copyOfTouchCoordinatesArray count] != 0) ? copyOfTouchCoordinatesArray : nil forKey:TouchLocationCoordinates];
    [formDataDict setValue:([copyOfInputSessionArray count] != 0) ? copyOfInputSessionArray : nil forKey:InputSessions];
    [formDataDict setValue:([copyOfButtonSessionArray count] != 0) ? copyOfButtonSessionArray : nil forKey:ButtonSessions];
    [formDataDict setValue:([copyOfSliderSessionArray count] != 0) ? copyOfSliderSessionArray : nil forKey:SliderSessions];
    [formDataDict setValue:([copyOfStepperSessionArray count] != 0) ? copyOfStepperSessionArray : nil forKey:StepperSessions];
    [formDataDict setValue:([copyOfPageControlSessionArray count] != 0) ? copyOfPageControlSessionArray : nil forKey:PageControlSessions];
    [formDataDict setValue:([copyOfImageViewSessionArray count] != 0) ? copyOfImageViewSessionArray : nil forKey:ImageViewSessions];
    [formDataDict setValue:([copyOfBatterySessionArray count] != 0) ? copyOfBatterySessionArray : nil forKey:BatterySessions];
    
    // Create final Payload to be sent to server.
    [self createJsonObjectFormat];
    
    //Resetting data
    [logInEvents removeAllObjects];
    [inputSessionArray removeAllObjects];
    [deviceOrientationArray removeAllObjects];
    [batterySessionArray removeAllObjects];
    [touchCoordinatesArray removeAllObjects];
    [buttonSessionArray removeAllObjects];
    [sliderSessionArray removeAllObjects];
    [stepperSessionArray removeAllObjects];
    [pageControlSessionArray removeAllObjects];
    [imageViewSessionArray removeAllObjects];
}

- (UIViewController*)topViewController {
    return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

// Gives name of present ViewController that user in.
- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}


// MARK: Post Data to Server on App Termination

// Method to register the background task to start watching it.
-(void)registerBackgroundTask {
    UIApplication* app = [UIApplication sharedApplication];
    UIBackgroundTaskIdentifier task = UIBackgroundTaskInvalid;
    task = [app beginBackgroundTaskWithExpirationHandler:^{
    }];
    [self appInBackground];
    [app endBackgroundTask:task];
}

-(void)appInBackground {
    [self disappear];
}

// MARK: Device Motion Detection Methods

// Method to check when accelerometer/gyro/magnetometer/devicemotion data is detected
- (void)checkForDeviceMotion {
    CMDeviceMotion *deviceMotion = motionManager.deviceMotion;
    if(deviceMotion == nil) {
        return;
    }
    
    if (motionManager.accelerometerData) {
        isAccelerometerData = [NSNumber numberWithBool:YES];
    }
    else {
        isAccelerometerData = [NSNumber numberWithBool:NO];
    }
    if (motionManager.gyroData) {
        isGyroData = [NSNumber numberWithBool:YES];
    }
    else {
        isGyroData = [NSNumber numberWithBool:NO];
    }
    if (motionManager.magnetometerData) {
        isMagnetometerData = [NSNumber numberWithBool:YES];
    }
    else {
        isMagnetometerData = [NSNumber numberWithBool:NO];
    }
    if (motionManager.deviceMotion) {
        isDeviceMotion = [NSNumber numberWithBool:YES];
    }
    else {
        isDeviceMotion = [NSNumber numberWithBool:NO];
    }
}

// MARK:  CustomWindow Protocol Methods

// This method will be called for any other usual touch on view

-(void)touchesBeganCalledOfWindow:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)touchesEndedCalledOfWindow:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)touchesMovedCalledOfWindow:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

// MARK:  CustomControl Delegate

// These method will be called when any UIControl object like UIButton / UISlider will be touched

-(void)touchBeganCalledWith:(NSSet<UITouch *> *_Nullable)touches withEvent:(UIEvent *_Nullable)event {
    UITouch *touch = [[event allTouches] anyObject];
    if (touch != nil) {
        CGPoint location = [touch locationInView:self.inputView];
        int64_t touchTimeStamp = [self getEpochTime];
        NSDictionary *touchCoordinatesDict;
        touchCoordinatesDict = [[NSMutableDictionary alloc] init];
        [touchCoordinatesDict setValue:[NSNumber numberWithLongLong:touchTimeStamp] forKey:TouchTimestamp];
        [touchCoordinatesDict setValue:[NSNumber numberWithFloat:location.x] forKey:XCoordinate];
        [touchCoordinatesDict setValue:[NSNumber numberWithFloat:location.y] forKey:YCoordinate];
        [touchCoordinatesArray addObject:touchCoordinatesDict];
        //Create and send form data when touch events get captured.
        [self assignFormData];
        if ([self.view hitTest:location withEvent:nil] != nil) {
            UIView *hitView = [self.view hitTest:location withEvent:nil];
            // If user touches UIButton
            if ([hitView isKindOfClass:UIButton.class]) {
                buttonStartTime = [self getEpochTime];
                return;
            }
            // If user touches UISlider
            if ([hitView isKindOfClass:UISlider.class]) {
                UIView *mySlider = hitView;
                CGPoint tapPoint = [touch locationInView:mySlider];
                startingXCoordinate = tapPoint.x;
                startingYCoordinate = tapPoint.y;
                sliderStartTimeStamp = [self getEpochTime];
                Float64 fraction = tapPoint.x/mySlider.bounds.size.width;
                UISlider *slider = (UISlider*) mySlider;
                float oldValue = (slider.maximumValue - slider.minimumValue) * fraction + slider.minimumValue;
                if (oldValue != slider.value) {
                    slider.value = oldValue;
                    sliderStartValue = slider.value;
                    return;
                }
            }
            // if user touches UIStepper
            if ([hitView isKindOfClass:UIStepper.class]) {
                stepperStartTime = [self getEpochTime];
                UIView *myStepper = hitView;
                UIStepper *stepper = (UIStepper*) myStepper;
                stepperOldValue = stepper.value;
                return;
            }
            // if user touches UIPageControl
            if ([hitView isKindOfClass:UIPageControl.class]) {
                UIView *myPageControl = hitView;
                UIPageControl *pageControl = (UIPageControl*) myPageControl;
                pageControlStartTime = [self getEpochTime];
                previousPage = pageControl.currentPage;
                return;
            }
            // if user touches on UIImageView
            if([hitView isKindOfClass:UIImageView.class]) {
                int64_t tapTimeStamp = [self getEpochTime];
                UIView *myImageView = hitView;
                CGPoint tapPoint = [touch locationInView: myImageView];
                UIImageView *imageView = (UIImageView*) myImageView;
                float height = [imageView bounds].size.height;
                float width = [imageView bounds].size.width;
                NSMutableDictionary *imageViewSessionDict;
                imageViewSessionDict = [[NSMutableDictionary alloc] init];
                [imageViewSessionDict setValue:[self getSessionID] forKey:ImageViewSessionID];
                [imageViewSessionDict setValue:[NSNumber numberWithLongLong:tapTimeStamp] forKey:ImageViewTapTimeStamp];
                [imageViewSessionDict setValue:[NSNumber numberWithBool:imageView.isHighlighted] forKey:IsImageViewHiglighted];
                [imageViewSessionDict setValue:[NSNumber numberWithBool:imageView.isHidden] forKey:IsImageViewHidden];
                [imageViewSessionDict setValue:[NSNumber numberWithBool:imageView.isAnimating] forKey:IsImageViewAnimating];
                [imageViewSessionDict setValue:[NSNumber numberWithBool:imageView.isFocused] forKey:IsImageViewFocused];
                [imageViewSessionDict setValue:[NSNumber numberWithFloat:tapPoint.x] forKey:ImageViewXCoordinate];
                [imageViewSessionDict setValue:[NSNumber numberWithFloat:tapPoint.y] forKey:ImageViewYCoordinate];
                [imageViewSessionDict setValue:[NSNumber numberWithFloat:height] forKey:Height];
                [imageViewSessionDict setValue:[NSNumber numberWithFloat:width] forKey:Width];
                [imageViewSessionArray addObject:imageViewSessionDict];
                //Create and send form data when image view tap event gets captured.
                [self assignFormData];
                return;
            }
        }
    }
}

-(void)touchMovedCalledWith:(NSSet<UITouch *> *_Nullable)touches withEvent:(UIEvent *_Nullable)event {
    UITouch *touch = [[event allTouches] anyObject];
    if (touch != nil) {
        CGPoint location = [touch locationInView:self.inputView];
        UIView *hitView = [self.view hitTest:location withEvent:nil];
        if (hitView != nil) {
            // If user touches UIButton
            if ([hitView isKindOfClass:UIButton.class]) {
                StoreUIContolsData *storeUIControlsDataObj = [[StoreUIContolsData alloc] init];
                buttonSessionArray = [[storeUIControlsDataObj storeButtonEvents:hitView touchesOnButton:touch startTimeOfButton:buttonStartTime] mutableCopy];
                [self assignFormData];
                colorWellButtonType = nil;
                return;
            }
        }
    }
    return;
}

-(void)touchEndedCalledWith:(NSSet<UITouch *> *_Nullable)touches withEvent:(UIEvent *_Nullable)event {
    StoreUIContolsData *storeUIControlsDataObj = [[StoreUIContolsData alloc] init];
    UITouch *touch = [[event allTouches] anyObject];
    if (touch != nil) {
        CGPoint location = [touch locationInView:self.inputView];
        UIView *hitView = [self.view hitTest:location withEvent:nil];
        if (hitView != nil) {
            // If user touches UIButton
            if ([hitView isKindOfClass:UIButton.class]) {
                buttonSessionArray = [[storeUIControlsDataObj storeButtonEvents:hitView touchesOnButton:touch startTimeOfButton:buttonStartTime] mutableCopy];
                [self assignFormData];
                colorWellButtonType = nil;
                return;
            }
            // If user touches UISlider
            if ([hitView isKindOfClass:UISlider.class]) {
                sliderSessionArray = [[storeUIControlsDataObj storeSliderEvents:hitView touchesOnSlider:touch startTimeOfSlider:sliderStartTimeStamp xCoordinate:startingXCoordinate yCoordinate:startingYCoordinate startValueOfSlider:sliderStartValue] mutableCopy];
                [self assignFormData];
                return;
            }
            // if user touches UIStepper
            if ([hitView isKindOfClass:UIStepper.class]) {
                stepperSessionArray = [[storeUIControlsDataObj storeStepperEvents:hitView touchesOnStepper:touch startTimeOfStepper:stepperStartTime oldValueStepper:stepperOldValue] mutableCopy];
                [self assignFormData];
                return;
            }
            // if user touches UIPageControl
            if ([hitView isKindOfClass:UIPageControl.class]) {
                pageControlSessionArray = [[storeUIControlsDataObj storePageControlEvents:hitView touchesOnPageControl:touch startTimeOfPageControl:pageControlStartTime previousPageOfControl:previousPage] mutableCopy];
                [self assignFormData];
                return;
            }
        }
    }
}

+ (void)setColorWellButtonType {
    colorWellButtonType = @"UIColorWell";
}

- (NSString *)getColorWellButtonType {
    return colorWellButtonType;
}

@end

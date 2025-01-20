//
//  PostPayloadKeys.h
//  KountDataCollector
//
//  Created by Vamsi Krishna on 26/08/20.
//  Copyright © 2020 Kount Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// Collector POST keys
extern NSString *const MerchantID;
extern NSString *const SessionID;
extern NSString *const FormData;
extern NSString *const DeviceData;

// Form session keys
extern NSString *const LogInSession;
extern NSString *const FormSessionID;
extern NSString *const IsJailBroken;
extern NSString *const SubmissionTimeStamp;
extern NSString *const ScreenName;
extern NSString *const ScreenStartTimestamp;
extern NSString *const ScreenStopTimestamp;
extern NSString *const MSScreenTotalTime;
extern NSString *const IsAccelerometer;
extern NSString *const IsGyroscope;
extern NSString *const IsMagnetometer;
extern NSString *const IsDeviceMotion;
extern NSString *const TouchLocationCoordinates;
extern NSString *const InputSessions;
extern NSString *const ButtonSessions;
extern NSString *const SliderSessions;
extern NSString *const BatterySessions;
extern NSString *const DeviceOrientationSessions;
extern NSString *const StepperSessions;
extern NSString *const PageControlSessions;
extern NSString *const ImageViewSessions;

// Input session keys
extern NSString *const InputSessionID;
extern NSString *const InputSessionStartTimestamp;
extern NSString *const ElementID;
extern NSString *const FocusStartTimestamp;
extern NSString *const FocusStopTimestamp;
extern NSString *const MSTotalTimeFocused;
extern NSString *const EpochInputKeys;
extern NSString *const EpochAllInputKeys;
extern NSString *const FirstCharacterTimestamp;
extern NSString *const LastCharacterTimestamp;
extern NSString *const CurrentMSPerCharacter;
extern NSString *const InputLength;
extern NSString *const MSDifferenceBetweenCharacters;
extern NSString *const NumberOfKeysTapped;
extern NSString *const AllMSDifferenceBetweenCharacters;
extern NSString *const EpochDeletions;

// Device orientation session keys
extern NSString *const DeviceOrientationSessionID;
extern NSString *const DeviceOrientation;
extern NSString *const DeviceOrientationTimestamp;

// Battery session keys
extern NSString *const BatterySessionID;
extern NSString *const BatteryTimestamp;
extern NSString *const IsBatteryMonitoringEnabled;
extern NSString *const BatteryLevel;
extern NSString *const BatteryState;
extern NSString *const IsLowPowermode;

// LogIn session keys
extern NSString *const LogInSessionID;
extern NSString *const LogInTimeStamp;
extern NSString *const LogInSuccess;
extern NSString *const LogInFailure;
extern NSString *const LogInAttempts;

// Button session keys
extern NSString *const ButtonSessionID;
extern NSString *const ButtonTitle;
extern NSString *const ButtonTapBeginTimestamp;
extern NSString *const ButtonTapEndTimestamp;
extern NSString *const IsLongPressed;
extern NSString *const ButtonXCoordinate;
extern NSString *const ButtonYCoordinate;
extern NSString *const ButtonType;

// Control Type key
extern NSString *const ControlType;

// Slider session keys
extern NSString *const SliderSessionID;
extern NSString *const SliderStartTimestamp;
extern NSString *const SliderStopTimestamp;
extern NSString *const SliderStartValue;
extern NSString *const SliderStopValue;
extern NSString *const SliderTouchLocationCoordinates;
extern NSString *const StartingXCoordinate;
extern NSString *const StartingYCoordinate;
extern NSString *const EndingXCoordinate;
extern NSString *const EndingYCoordinate;

// Stepper session keys
extern NSString *const StepperSessionID;
extern NSString *const StepperTapBeginTimestamp;
extern NSString *const StepperTapEndTimestamp;
extern NSString *const IsStepperLongPressed;
extern NSString *const StepperXCoordinate;
extern NSString *const StepperYCoordinate;
extern NSString *const StepperOldValue;
extern NSString *const StepperNewValue;
extern NSString *const StepperStepValue;

// PageControl session keys
extern NSString *const PageControlSessionID;
extern NSString *const PageControlTapBeginTimestamp;
extern NSString *const PageControlTapEndTimestamp;
extern NSString *const PageControlXCoordinate;
extern NSString *const PageControlYCoordinate;
extern NSString *const PageControlPreviousPage;
extern NSString *const PageControlCurrentPage;
extern NSString *const PageControlNumberOfPages;

// ImageView session keys
extern NSString *const ImageViewSessionID;
extern NSString *const ImageViewTapTimeStamp;
extern NSString *const ImageViewXCoordinate;
extern NSString *const ImageViewYCoordinate;
extern NSString *const IsImageViewHiglighted;
extern NSString *const IsImageViewHidden;
extern NSString *const IsImageViewAnimating;
extern NSString *const IsImageViewFocused;

// Touch session keys
extern NSString *const TouchTimestamp;
extern NSString *const XCoordinate;
extern NSString *const YCoordinate;

// Height and Width
extern NSString *const Height;
extern NSString *const Width;

// Device data keys
extern NSString *const TotalClientTime;
extern NSString *const TotalClientTimeElapsedTime;
extern NSString *const Latitude;
extern NSString *const Longitude;
extern NSString *const LastModifiedTime;
extern NSString *const LocationCollectorElapsedTime;
extern NSString *const City;
extern NSString *const Region;
extern NSString *const Country;
extern NSString *const ISOCountryCode;
extern NSString *const PostalCode;
extern NSString *const OrganisationName;
extern NSString *const Street;
extern NSString *const GeocodingElapsedTime;
extern NSString *const SDKType;
extern NSString *const SDKVersion;
extern NSString *const Model;
extern NSString *const ModelElapsedTime;
extern NSString *const OSVersion;
extern NSString *const OSVersionElapsedTime;
extern NSString *const TotalDisk;
extern NSString *const TotalDiskElapsedTime;
extern NSString *const TotalMemory;
extern NSString *const TotalMemoryElapsedTime;
extern NSString *const Language;
extern NSString *const LanguageElapsedTime;
extern NSString *const TimezoneNow;
extern NSString *const TimezoneNowElapsedTime;
extern NSString *const TimezoneFebruary;
extern NSString *const TimezoneFebruaryElapsedTime;
extern NSString *const TimezoneAugust;
extern NSString *const TimezoneAugustElapsedTime;
extern NSString *const ScreenAvailable;
extern NSString *const ScreenAvailableElapsedTime;
extern NSString *const SystemCollectorElapsedTime;
extern NSString *const DeviceCookie;
extern NSString *const DeviceCookieElapsedTime;
extern NSString *const OldDeviceCookie;
extern NSString *const OldDeviceCookieElapsedTime;
extern NSString *const FingerprintCollectorElapsedTime;


@interface PostPayloadKeys : NSObject

@end

NS_ASSUME_NONNULL_END

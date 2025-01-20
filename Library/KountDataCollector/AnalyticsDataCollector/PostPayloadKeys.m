//
//  PostPayloadKeys.m
//  KountDataCollector
//
//  Created by Vamsi Krishna on 26/08/20.
//  Copyright © 2020 Kount Inc. All rights reserved.
//

#import "PostPayloadKeys.h"

// Collector POST keys
NSString *const MerchantID = @"merchant_id";
NSString *const SessionID = @"session_id";
NSString *const FormData = @"form_data";
NSString *const DeviceData = @"device_data";

// Form session keys
NSString *const LogInSession = @"login_sessions";
NSString *const FormSessionID = @"form_session_id";
NSString *const IsJailBroken = @"is_jailbroken";
NSString *const SubmissionTimeStamp = @"submission_timestamp";
NSString *const ScreenName = @"screen_name";
NSString *const ScreenStartTimestamp  = @"screen_start_timestamp";
NSString *const ScreenStopTimestamp = @"screen_stop_timestamp";
NSString *const MSScreenTotalTime = @"ms_screen_total_time";
NSString *const IsAccelerometer = @"is_accelerometer";
NSString *const IsGyroscope = @"is_gyroscope";
NSString *const IsMagnetometer = @"is_magnetometer";
NSString *const IsDeviceMotion = @"is_device_motion";
NSString *const TouchLocationCoordinates = @"touch_location_coordinates";
NSString *const InputSessions = @"input_sessions";
NSString *const ButtonSessions = @"button_sessions";
NSString *const SliderSessions = @"slider_sessions";
NSString *const BatterySessions = @"battery_sessions";
NSString *const DeviceOrientationSessions = @"device_orientation_sessions";
NSString *const StepperSessions = @"stepper_sessions";
NSString *const PageControlSessions = @"page_control_sessions";
NSString *const ImageViewSessions = @"image_view_sessions";

// Input session keys
NSString *const InputSessionID = @"input_session_id";
NSString *const InputSessionStartTimestamp = @"input_session_start_timestamp";
NSString *const ElementID = @"element_id";
NSString *const FocusStartTimestamp = @"focus_start_timestamp";
NSString *const FocusStopTimestamp = @"focus_stop_timestamp";
NSString *const MSTotalTimeFocused = @"ms_total_time_focused";
NSString *const EpochInputKeys = @"epoch_input_keys";
NSString *const EpochAllInputKeys = @"epoch_all_input_keys";
NSString *const FirstCharacterTimestamp = @"first_character_timestamp";
NSString *const LastCharacterTimestamp = @"last_character_timestamp";
NSString *const CurrentMSPerCharacter = @"current_ms_per_character";
NSString *const InputLength = @"input_length";
NSString *const MSDifferenceBetweenCharacters = @"ms_difference_between_characters";
NSString *const NumberOfKeysTapped = @"number_of_keys_tapped";
NSString *const AllMSDifferenceBetweenCharacters = @"all_ms_difference_between_characters";
NSString *const EpochDeletions = @"epoch_deletions";

// Device orientation session keys
NSString *const DeviceOrientationSessionID = @"device_orientation_session_id";
NSString *const DeviceOrientation = @"device_orientation";
NSString *const DeviceOrientationTimestamp = @"device_orientation_timestamp";

// Battery session keys
NSString *const BatterySessionID = @"battery_session_id";
NSString *const BatteryTimestamp = @"battery_timestamp";
NSString *const IsBatteryMonitoringEnabled = @"is_battery_monitoring_enabled";
NSString *const BatteryLevel = @"battery_level";
NSString *const BatteryState = @"battery_state";
NSString *const IsLowPowermode = @"is_low_power_mode";

// Control Type key
NSString *const ControlType = @"control_type";

// LogIn session keys
NSString *const LogInSessionID = @"login_session_id";
NSString *const LogInTimeStamp = @"login_timestamp";
NSString *const LogInSuccess = @"login_success";
NSString *const LogInFailure = @"login_failure";
NSString *const LogInAttempts = @"login_attempts";

// Button session keys
NSString *const ButtonSessionID = @"button_session_id";
NSString *const ButtonTitle = @"button_title";
NSString *const ButtonTapBeginTimestamp = @"button_tap_begin_timestamp";
NSString *const ButtonTapEndTimestamp = @"button_tap_end_timestamp";
NSString *const IsLongPressed = @"is_long_pressed";
NSString *const ButtonXCoordinate = @"x_coordinate";
NSString *const ButtonYCoordinate = @"y_coordinate";
NSString *const ButtonType = @"button_type";

// Slider session keys
NSString *const SliderSessionID = @"slider_session_id";
NSString *const SliderStartTimestamp = @"slider_start_timestamp";
NSString *const SliderStopTimestamp = @"slider_stop_timestamp";
NSString *const SliderStartValue = @"slider_start_value";
NSString *const SliderStopValue = @"slider_stop_value";
NSString *const SliderTouchLocationCoordinates = @"touch_location_coordinates";
NSString *const StartingXCoordinate = @"starting_x_coordinate";
NSString *const StartingYCoordinate = @"starting_y_coordinate";
NSString *const EndingXCoordinate = @"ending_x_coordinate";
NSString *const EndingYCoordinate = @"ending_y_coordinate";

// Stepper session keys
NSString *const StepperSessionID = @"stepper_session_id";
NSString *const StepperTapBeginTimestamp = @"stepper_tap_begin_timestamp";
NSString *const StepperTapEndTimestamp = @"stepper_tap_end_timestamp";
NSString *const IsStepperLongPressed = @"is_long_pressed";
NSString *const StepperXCoordinate = @"x_coordinate";
NSString *const StepperYCoordinate = @"y_coordinate";
NSString *const StepperOldValue = @"old_value";
NSString *const StepperNewValue = @"new_value";
NSString *const StepperStepValue = @"step_value";

// PageControl session keys
NSString *const PageControlSessionID = @"page_control_session_id";
NSString *const PageControlTapBeginTimestamp = @"page_control_tap_begin_timestamp";
NSString *const PageControlTapEndTimestamp = @"page_control_tap_end_timestamp";
NSString *const PageControlXCoordinate = @"x_coordinate";
NSString *const PageControlYCoordinate = @"y_coordinate";
NSString *const PageControlPreviousPage = @"previous_page";
NSString *const PageControlCurrentPage = @"current_page";
NSString *const PageControlNumberOfPages = @"number_of_pages";

// ImageView session keys
NSString *const ImageViewSessionID = @"image_view_session_id";
NSString *const ImageViewTapTimeStamp = @"image_view_tap_timestamp";
NSString *const ImageViewXCoordinate = @"x_coordinate";
NSString *const ImageViewYCoordinate = @"y_coordinate";
NSString *const IsImageViewHiglighted = @"is_highlighted";
NSString *const IsImageViewHidden = @"is_hidden";
NSString *const IsImageViewAnimating = @"is_animating";
NSString *const IsImageViewFocused = @"is_focused";

// Touch session keys
NSString *const TouchTimestamp = @"touch_timestamp";
NSString *const XCoordinate = @"x_coordinate";
NSString *const YCoordinate = @"y_coordinate";

// Height and Width
NSString *const Height = @"height";
NSString *const Width = @"width";

// Device data keys
NSString *const TotalClientTime = @"total_client_time";
NSString *const TotalClientTimeElapsedTime = @"total_client_time_elapsed_time";
NSString *const Latitude = @"latitude";
NSString *const Longitude = @"longitude";
NSString *const LastModifiedTime = @"last_modified_time";
NSString *const LocationCollectorElapsedTime = @"location_collector_elapsed_time";
NSString *const City = @"city";
NSString *const Region = @"region";
NSString *const Country = @"country";
NSString *const ISOCountryCode = @"iso_country_code";
NSString *const PostalCode = @"postal_code";
NSString *const OrganisationName = @"org_name";
NSString *const Street = @"street";
NSString *const GeocodingElapsedTime = @"geocoding_elapsed_time";
NSString *const SDKType = @"sdk_type";
NSString *const SDKVersion = @"sdk_version";
NSString *const Model = @"model";
NSString *const ModelElapsedTime = @"model_elapsed_time";
NSString *const OSVersion = @"os_version";
NSString *const OSVersionElapsedTime = @"os_version_elapsed_time";
NSString *const TotalDisk = @"total_disk";
NSString *const TotalDiskElapsedTime = @"total_disk_elapsed_time";
NSString *const TotalMemory = @"total_memory";
NSString *const TotalMemoryElapsedTime = @"total_memory_elapsed_time";
NSString *const Language = @"language";
NSString *const LanguageElapsedTime = @"language_elapsed_time";
NSString *const TimezoneNow = @"timezone_now";
NSString *const TimezoneNowElapsedTime = @"timezone_now_elapsed_time";
NSString *const TimezoneFebruary = @"timezone_february";
NSString *const TimezoneFebruaryElapsedTime = @"timezone_february_elapsed_time";
NSString *const TimezoneAugust = @"timezone_august";
NSString *const TimezoneAugustElapsedTime = @"timezone_august_elapsed_time";
NSString *const ScreenAvailable = @"screen_available";
NSString *const ScreenAvailableElapsedTime = @"screen_available_elapsed_time";
NSString *const SystemCollectorElapsedTime = @"system_collector_elapsed_time";
NSString *const DeviceCookie = @"device_cookie";
NSString *const DeviceCookieElapsedTime = @"device_cookie_elapsed_time";
NSString *const OldDeviceCookie = @"old_device_cookie";
NSString *const OldDeviceCookieElapsedTime = @"old_device_cookie_elapsed_time";
NSString *const FingerprintCollectorElapsedTime = @"fingerprint_collector_elapsed_time";

@implementation PostPayloadKeys

@end

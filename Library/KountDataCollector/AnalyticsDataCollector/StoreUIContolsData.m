//
//  StoreUIContolsData.m
//  KountDataCollector
//
//  Created by Vamsi Krishna on 25/01/21.
//  Copyright © 2021 Kount Inc. All rights reserved.
//

#import "StoreUIContolsData.h"

@implementation StoreUIContolsData

// Common method to store button events
- (NSMutableArray *)storeButtonEvents:(UIView *)myView touchesOnButton:(UITouch *)touches startTimeOfButton:(int64_t)buttonStartTime; {
    NSMutableArray *buttonSessionArray = [[NSMutableArray alloc] init];
    UIView *hitView = myView;
    UITouch *touch = touches;
    int64_t endTime = [[KountAnalyticsViewController sharedInstance] getEpochTime];
    int64_t buttonElapsedTime;
    NSString *UIButtonTypeString;
    if (buttonStartTime > 0 && endTime > 0) {
        buttonElapsedTime = endTime - buttonStartTime;
    }
    else {
        buttonElapsedTime = 0;
    }
    UIView *myButton = hitView;
    CGPoint tapPoint = [touch locationInView: myButton];
    UIButton *button = (UIButton*) myButton;
    switch (button.buttonType) {
        case UIButtonTypeSystem:
            UIButtonTypeString = @"UIButtonTypeSystem";
            break;
        case UIButtonTypeClose:
            UIButtonTypeString = @"UIButtonTypeClose";
            break;
        case UIButtonTypeCustom:
            UIButtonTypeString = @"UIButtonTypeCustom";
            break;
        case UIButtonTypeInfoLight:
            UIButtonTypeString = @"UIButtonTypeInfoLight";
            break;
        case UIButtonTypeInfoDark:
            UIButtonTypeString = @"UIButtonTypeInfoDark";
            break;
        case UIButtonTypeContactAdd:
            UIButtonTypeString = @"UIButtonTypeContactAdd";
            break;
        case UIButtonTypeDetailDisclosure:
            UIButtonTypeString = @"UIButtonTypeDetailDisclosure";
            break;
        default:
            UIButtonTypeString = nil;
            break;
    }
    float height = [button bounds].size.height;
    float width = [button bounds].size.width;
    NSString *buttonName;
    if (button.titleLabel.text == nil) {
        buttonName = nil;
    }
    else {
        buttonName = button.titleLabel.text;
    }
    BOOL flag = NO;
    if (buttonElapsedTime > 2000) {
        flag = YES;
    }
    NSMutableDictionary *buttonSessionDict;
    buttonSessionDict = [[NSMutableDictionary alloc] init];
    [buttonSessionDict setValue:[[KountAnalyticsViewController sharedInstance] getSessionID] forKey:ButtonSessionID];
    [buttonSessionDict setValue:buttonName forKey:ButtonTitle];
    [buttonSessionDict setValue:UIButtonTypeString forKey:ButtonType];
    [buttonSessionDict setValue:[NSNumber numberWithLongLong:buttonStartTime] forKey:ButtonTapBeginTimestamp];
    [buttonSessionDict setValue:[NSNumber numberWithLongLong:endTime] forKey:ButtonTapEndTimestamp];
    [buttonSessionDict setValue:[NSNumber numberWithBool:flag]  forKey:IsLongPressed];
    [buttonSessionDict setValue:[NSNumber numberWithFloat:tapPoint.x] forKey:ButtonXCoordinate];
    [buttonSessionDict setValue:[NSNumber numberWithFloat:tapPoint.y] forKey:ButtonYCoordinate];
    [buttonSessionDict setValue:[NSNumber numberWithFloat:height] forKey:Height];
    [buttonSessionDict setValue:[NSNumber numberWithFloat:width] forKey:Width];
    // This data point will be added whenever there is a touch on UIColorWell.
    [buttonSessionDict setValue:[[KountAnalyticsViewController sharedInstance] getColorWellButtonType] forKey:ControlType];
    [buttonSessionArray addObject:buttonSessionDict];
    return  buttonSessionArray;
}

- (NSMutableArray *)storeSliderEvents:(UIView *)myView touchesOnSlider:(UITouch *)touches startTimeOfSlider:(int64_t)sliderStartTimeStamp xCoordinate:(Float64)startingXCoordinate yCoordinate:(Float64)startingYCoordinate startValueOfSlider:(float)sliderStartValue {
    NSMutableArray *sliderSessionArray = [[NSMutableArray alloc] init];
    UIView *mySlider = myView;
    CGPoint tapPoint = [touches locationInView: mySlider];
    NSDictionary *touchCoordinatesDict;
    touchCoordinatesDict = [[NSMutableDictionary alloc] init];
    [touchCoordinatesDict setValue:[NSNumber numberWithFloat:startingXCoordinate] forKey:StartingXCoordinate];
    [touchCoordinatesDict setValue:[NSNumber numberWithFloat:startingYCoordinate] forKey:StartingYCoordinate];
    [touchCoordinatesDict setValue:[NSNumber numberWithFloat:tapPoint.x] forKey:EndingXCoordinate];
    [touchCoordinatesDict setValue:[NSNumber numberWithFloat:tapPoint.y] forKey:EndingYCoordinate];
    UISlider *slider = (UISlider*) mySlider;
    int height = [slider bounds].size.height;
    int width = [slider bounds].size.width;
    NSMutableDictionary *sliderSessionDict;
    sliderSessionDict = [[NSMutableDictionary alloc] init];
    [sliderSessionDict setValue:[[KountAnalyticsViewController sharedInstance] getSessionID] forKey:SliderSessionID];
    [sliderSessionDict setValue:[NSNumber numberWithLongLong:sliderStartTimeStamp] forKey:SliderStartTimestamp];
    [sliderSessionDict setValue:[NSNumber numberWithLongLong:[[KountAnalyticsViewController sharedInstance] getEpochTime]] forKey:SliderStopTimestamp];
    [sliderSessionDict setValue:[NSNumber numberWithFloat:sliderStartValue] forKey:SliderStartValue];
    [sliderSessionDict setValue:[NSNumber numberWithFloat:slider.value] forKey:SliderStopValue];
    [sliderSessionDict setValue:[NSNumber numberWithFloat:height] forKey:Height];
    [sliderSessionDict setValue:[NSNumber numberWithFloat:width] forKey:Width];
    [sliderSessionDict setValue:touchCoordinatesDict forKey:SliderTouchLocationCoordinates];
    [sliderSessionArray addObject:sliderSessionDict];
    return sliderSessionArray;
}

- (NSMutableArray *)storeStepperEvents:(UIView *)myView touchesOnStepper:(UITouch *)touches startTimeOfStepper:(int64_t)stepperStartTime oldValueStepper:(double)stepperOldValue {
    NSMutableArray *stepperSessionArray = [[NSMutableArray alloc] init];
    int64_t endTime = [[KountAnalyticsViewController sharedInstance] getEpochTime];
    int64_t stepperElapsedTime;
    if (stepperStartTime > 0 && endTime > stepperStartTime) {
        stepperElapsedTime = endTime - stepperStartTime;
    }
    else {
        stepperElapsedTime = 0;
    }
    BOOL flag = NO;
    if (stepperElapsedTime > 2000) {
        flag = YES;
    }
    UIView *myStepper = myView;
    CGPoint tapPoint = [touches locationInView:myStepper];
    UIStepper *stepper = (UIStepper*) myStepper;
    int height = [stepper bounds].size.height;
    int width = [stepper bounds].size.width;
    double stepperNewValue = stepper.value;
    double stepperStepValue = stepper.stepValue;
    NSMutableDictionary *stepperSessionDict;
    stepperSessionDict = [[NSMutableDictionary alloc] init];
    [stepperSessionDict setValue:[[KountAnalyticsViewController sharedInstance] getSessionID] forKey:StepperSessionID];
    [stepperSessionDict setValue:[NSNumber numberWithDouble:stepperOldValue] forKey:StepperOldValue];
    [stepperSessionDict setValue:[NSNumber numberWithDouble:stepperNewValue] forKey:StepperNewValue];
    [stepperSessionDict setValue:[NSNumber numberWithDouble:stepperStepValue] forKey:StepperStepValue];
    [stepperSessionDict setValue:[NSNumber numberWithLongLong:stepperStartTime] forKey:StepperTapBeginTimestamp];
    [stepperSessionDict setValue:[NSNumber numberWithLongLong:endTime] forKey:StepperTapEndTimestamp];
    [stepperSessionDict setValue:[NSNumber numberWithBool:flag]  forKey:IsStepperLongPressed];
    [stepperSessionDict setValue:[NSNumber numberWithFloat:tapPoint.x] forKey:StepperXCoordinate];
    [stepperSessionDict setValue:[NSNumber numberWithFloat:tapPoint.y] forKey:StepperYCoordinate];
    [stepperSessionDict setValue:[NSNumber numberWithFloat:height] forKey:Height];
    [stepperSessionDict setValue:[NSNumber numberWithFloat:width] forKey:Width];
    [stepperSessionArray addObject:stepperSessionDict];
    return stepperSessionArray;
}

- (NSMutableArray *)storePageControlEvents:(UIView *)myView touchesOnPageControl:(UITouch *)touches startTimeOfPageControl:(int64_t)pageControlStartTime previousPageOfControl:(NSInteger)previousPage {
    NSMutableArray *pageControlSessionArray = [[NSMutableArray alloc] init];
    int64_t endTime = [[KountAnalyticsViewController sharedInstance] getEpochTime];
    UIView *myPageControl = myView;
    CGPoint tapPoint = [touches locationInView:myPageControl];
    UIPageControl *pageControl = (UIPageControl*) myPageControl;
    int height = [pageControl bounds].size.height;
    int width = [pageControl bounds].size.width;
    NSInteger numberOfpages = pageControl.numberOfPages;
    NSInteger currentPage = pageControl.currentPage;
    NSMutableDictionary *pageControlSessionDict;
    pageControlSessionDict = [[NSMutableDictionary alloc] init];
    [pageControlSessionDict setValue:[[KountAnalyticsViewController sharedInstance] getSessionID] forKey:PageControlSessionID];
    [pageControlSessionDict setValue:[NSNumber numberWithLongLong:pageControlStartTime] forKey:PageControlTapBeginTimestamp];
    [pageControlSessionDict setValue:[NSNumber numberWithLongLong:endTime] forKey:PageControlTapEndTimestamp];
    [pageControlSessionDict setValue:[NSNumber numberWithFloat:tapPoint.x] forKey:PageControlXCoordinate];
    [pageControlSessionDict setValue:[NSNumber numberWithFloat:tapPoint.y] forKey:PageControlYCoordinate];
    [pageControlSessionDict setValue:[NSNumber numberWithFloat:height] forKey:Height];
    [pageControlSessionDict setValue:[NSNumber numberWithFloat:width] forKey:Width];
    [pageControlSessionDict setValue:[NSNumber numberWithInteger:previousPage] forKey:PageControlPreviousPage];
    [pageControlSessionDict setValue:[NSNumber numberWithInteger:currentPage] forKey:PageControlCurrentPage];
    [pageControlSessionDict setValue:[NSNumber numberWithInteger:numberOfpages] forKey:PageControlNumberOfPages];
    [pageControlSessionArray addObject:pageControlSessionDict];
    return pageControlSessionArray;
}

@end

//
//  StoreUIContolsData.h
//  KountDataCollector
//
//  Created by Vamsi Krishna on 25/01/21.
//  Copyright © 2021 Kount Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "KountAnalyticsViewController.h"
#import "PostPayloadKeys.h"

NS_ASSUME_NONNULL_BEGIN

@interface StoreUIContolsData : NSObject

- (NSMutableArray *)storeButtonEvents:(UIView *)myView touchesOnButton:(UITouch *)touches startTimeOfButton:(int64_t)buttonStartTime;
- (NSMutableArray *)storeSliderEvents:(UIView *)myView touchesOnSlider:(UITouch *)touches startTimeOfSlider:(int64_t)sliderStartTimeStamp xCoordinate:(Float64)startingXCoordinate yCoordinate:(Float64)startingYCoordinate startValueOfSlider:(float)sliderStartValue;
- (NSMutableArray *)storeStepperEvents:(UIView *)myView touchesOnStepper:(UITouch *)touches startTimeOfStepper:(int64_t)stepperStartTime oldValueStepper:(double)stepperOldValue;
- (NSMutableArray *)storePageControlEvents:(UIView *)myView touchesOnPageControl:(UITouch *)touches startTimeOfPageControl:(int64_t)pageControlStartTime previousPageOfControl:(NSInteger)previousPage;

@end

NS_ASSUME_NONNULL_END

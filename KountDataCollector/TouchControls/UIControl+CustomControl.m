//
//  UIControl+CustomControl.m
//  TouchDemo
//
//  Created by Astha Ameta on 19/08/20.
//  Copyright © 2020 Kount Inc. All rights reserved.
//

#import "UIControl+CustomControl.h"

@implementation UIButton (CustomButton)

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.nextResponder touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    [self.nextResponder touchesEnded:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    [self.nextResponder touchesMoved:touches withEvent:event];
}

@end

@implementation UISlider (CustomSlider)

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    UIResponder *next = self.nextResponder;
    while (next.nextResponder != nil) {
        if([next isKindOfClass:[UIViewController class]]){
            break;
        }
        next = next.nextResponder;
    }
    [next touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    UIResponder *next = self.nextResponder;
    while (next.nextResponder != nil) {
        if([next isKindOfClass:[UIViewController class]]){
            break;
        }
        next = next.nextResponder;
    }
    [next touchesEnded:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    UIResponder *next = self.nextResponder;
    while (next.nextResponder != nil) {
        if([next isKindOfClass:[UIViewController class]]){
            break;
        }
        next = next.nextResponder;
    }
    [next touchesMoved:touches withEvent:event];
}

@end

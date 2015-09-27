//
//  NYSegmentedControl+CBDSettings.m
//  SmartMathsMP
//
//  Created by Colas on 11/08/2015.
//  Copyright (c) 2015 cassiopeia. All rights reserved.
//

#import "NYSegmentedControl+CBDSettings.h"

@implementation NYSegmentedControl (CBDSettings)


- (void)setUpForSegmentColor:(UIColor *)segmentColor
                  titleColor:(UIColor *)titleColor
          selectedTitleColor:(UIColor *)selectedTitleColor
                        font:(UIFont *)font
                cornerRadius:(CGFloat)cornerRadius
{
    /*
     Normal
     */
    self.titleFont = font ;
    self.titleTextColor = titleColor ;
    
    /*
     Selected
     */
    self.selectedTitleFont = font ;
    self.selectedTitleTextColor = selectedTitleColor ;
    
 //   self.segmentIndicatorBackgroundColor = segmentColor ;
    
    self.segmentIndicatorGradientTopColor = segmentColor ;//[UIColor colorWithRed:0.30 green:0.50 blue:0.88f alpha:1.0f];
    self.segmentIndicatorGradientBottomColor = segmentColor ; //[UIColor colorWithRed:0.20 green:0.35 blue:0.75f alpha:1.0f];
    self.drawsGradientBackground = YES ;
//    self.segmentIndicatorBorderColor = segmentColor ;
//    self.segmentIndicatorBorderWidth = 0.0f ;
//    
    /*
     General
     */
//    self.borderWidth = 0.0f ;
//    self.borderColor = [UIColor clearColor] ;
//    self.backgroundColor = [UIColor clearColor] ;
//    self.cornerRadius = cornerRadius ;
//    
//    self.segmentIndicatorInset = 0.0f ;
//    
//    self.drawsGradientBackground = NO;
//    self.drawsSegmentIndicatorGradientBackground = NO;

}

@end

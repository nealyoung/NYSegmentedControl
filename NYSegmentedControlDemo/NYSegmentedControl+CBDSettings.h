//
//  NYSegmentedControl+CBDSettings.h
//  SmartMathsMP
//
//  Created by Colas on 11/08/2015.
//  Copyright (c) 2015 cassiopeia. All rights reserved.
//

#import "NYSegmentedControl.h"

@interface NYSegmentedControl (CBDSettings)

- (void)setUpForSegmentColor:(UIColor *)segmentColor
                  titleColor:(UIColor *)titleColor
          selectedTitleColor:(UIColor *)selectedTitleColor
                        font:(UIFont *)font
                cornerRadius:(CGFloat)cornerRadius ;

@end

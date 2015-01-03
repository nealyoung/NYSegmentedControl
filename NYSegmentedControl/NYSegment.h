//
//  NYSegment.h
//  NYSegmentedControl
//
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//
//  https://github.com/nealyoung/NYSegmentedControl
//

#import <UIKit/UIKit.h>

@class NYSegment;
@class NYSegmentLabel;

@interface NYSegment : UIView

@property (nonatomic) NYSegmentLabel *titleLabel;

- (instancetype)initWithTitle:(NSString *)title;

@end

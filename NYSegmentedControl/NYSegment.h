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

@interface NYSegment : UIView

@property (nonatomic) UILabel *titleLabel;

- (instancetype)initWithTitle:(NSString *)title;

@end

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

@protocol NYSegmentDelegate <NSObject>

- (void)segmentSelected:(NYSegment *)segment;

@end

@interface NYSegment : UIView

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic, assign) id <NYSegmentDelegate> delegate;

- (instancetype)initWithTitle:(NSString *)title;

@end

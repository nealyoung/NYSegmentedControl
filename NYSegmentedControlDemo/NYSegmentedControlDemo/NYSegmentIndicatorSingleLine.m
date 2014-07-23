//
//  NYSegmentIndicatorSingleLine.m
//
//  Created by Andrew Podkovyrin on 22/07/14.
//  Copyright (c) 2014 Neal Young. All rights reserved.
//

#import "NYSegmentIndicatorSingleLine.h"

@interface NYSegmentIndicatorSingleLine ()

@property (strong, readwrite, nonatomic) UIView *bottomLineView;

@end


@implementation NYSegmentIndicatorSingleLine

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
        self.userInteractionEnabled = NO;
        
        self.bottomLineView = [[UIView alloc] initWithFrame:CGRectZero];
        self.bottomLineView.backgroundColor = [UIColor redColor];
        [self addSubview:self.bottomLineView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.bottomLineView.frame = CGRectMake(0.f, CGRectGetHeight(self.bounds) - 1.f, CGRectGetWidth(self.bounds), 1.f);
}

@end

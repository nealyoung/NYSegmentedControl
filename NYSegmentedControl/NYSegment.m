//
//  NYSegment.m
//  NYSegmentedControl
//
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//
//  https://github.com/nealyoung/NYSegmentedControl
//

#import "NYSegment.h"

@implementation NYSegment

- (instancetype)initWithTitle:(NSString *)title {
    self = [self initWithFrame:CGRectZero];
    if (self) {
        self.titleLabel.text = title;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
        self.titleLabel = [[UILabel alloc] initWithFrame:self.frame];
        self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize sizeThatFits = [self.titleLabel sizeThatFits:size];
    return CGSizeMake(sizeThatFits.width * 1.4f, sizeThatFits.height);
}

@end

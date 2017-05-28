//
//  NYSegmentIndicator.m
//  NYSegmentedControl
//
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//
//  https://github.com/nealyoung/NYSegmentedControl
//

#import "NYSegmentIndicator.h"


@interface NYSegmentIndicator ()
@property (nonatomic, strong, readwrite) CALayer * gradientLayer ;
@end


@implementation NYSegmentIndicator

+ (Class)layerClass {
    return [CAGradientLayer class];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
        self.drawsGradientBackground = NO;
        self.opaque = NO;
        self.cornerRadius = 4.0f;
        self.gradientTopColor = [UIColor colorWithRed:0.27f green:0.54f blue:0.21f alpha:1.0f];
        self.gradientBottomColor = [UIColor colorWithRed:0.22f green:0.43f blue:0.16f alpha:1.0f];
        self.borderColor = [UIColor lightGrayColor];
        self.borderWidth = 1.0f;
    }
    return self;
}



#pragma mark - Getters and Setters

- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = [borderColor CGColor];
}

- (UIColor *)borderColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}

- (CGFloat)borderWidth {
    return self.layer.borderWidth;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
    [self setNeedsDisplay];
}

- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}


- (void)setDrawsGradientBackground:(BOOL)drawsGradientBackground {
    _drawsGradientBackground = drawsGradientBackground;
    
    if (drawsGradientBackground)
    {
        CAGradientLayer * gradientLayer = [[CAGradientLayer alloc] init] ;
        gradientLayer = [[CAGradientLayer alloc] init] ;
        gradientLayer.frame = self.layer.frame ;
        
        gradientLayer.colors = @[(__bridge id)[self.gradientTopColor CGColor],
                                 (__bridge id)[self.gradientBottomColor CGColor]];
        
        [self.layer addSublayer:gradientLayer] ;
        [self.gradientLayer removeFromSuperlayer] ;
        self.gradientLayer = gradientLayer ;
    }
    else
    {
        [self.gradientLayer removeFromSuperlayer] ;
        self.gradientLayer = nil ;
    }
}


- (void)setGradientTopColor:(UIColor *)gradientTopColor {
    _gradientTopColor = gradientTopColor;
    
    // recreate the gradient layer
    [self setDrawsGradientBackground:self.drawsGradientBackground] ;
}

- (void)setGradientBottomColor:(UIColor *)gradientBottomColor {
    _gradientBottomColor = gradientBottomColor;
    
    // recreate the gradient layer
    [self setDrawsGradientBackground:self.drawsGradientBackground] ;
}



@end

//
//  NYSegmentIndicator.m
//  NYSegmentedControl
//
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//
//  https://github.com/nealyoung/NYSegmentedControl
//

#import "NYSegmentIndicator.h"

@interface NYSegmentIndicator () {
    UIColor *_backgroundColor;
}

@end

@implementation NYSegmentIndicator

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = NO;
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

- (void)drawRect:(CGRect)rect {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPathAddArcToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMinY(rect), CGRectGetMaxX(rect), CGRectGetMaxY(rect), self.cornerRadius);
    CGPathAddArcToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMaxY(rect), CGRectGetMinX(rect), CGRectGetMaxY(rect), self.cornerRadius);
    CGPathAddArcToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMaxY(rect), CGRectGetMinX(rect), CGRectGetMinY(rect), self.cornerRadius);
    CGPathAddArcToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetMaxX(rect), CGRectGetMinY(rect), self.cornerRadius);
    CGPathCloseSubpath(path);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(ctx);
    CGContextAddPath(ctx, path);
    if (self.drawsGradientBackground) {
        CGContextClip(ctx);
        
        CGFloat topGradientComponents[4];
        [self.gradientTopColor getRed:&topGradientComponents[0]
                                green:&topGradientComponents[1]
                                 blue:&topGradientComponents[2]
                                alpha:&topGradientComponents[3]];
        
        CGFloat bottomGradientComponents[4];
        [self.gradientBottomColor getRed:&bottomGradientComponents[0]
                                   green:&bottomGradientComponents[1]
                                    blue:&bottomGradientComponents[2]
                                   alpha:&bottomGradientComponents[3]];
        
        CGFloat gradientColors [] = {
            topGradientComponents[0], topGradientComponents[1], topGradientComponents[2], topGradientComponents[3],
            bottomGradientComponents[0], bottomGradientComponents[1], bottomGradientComponents[2], bottomGradientComponents[3]
        };
        
        CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, gradientColors, NULL, 2);
        
        CGContextDrawLinearGradient(ctx,
                                    gradient,
                                    CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect)),
                                    CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect)),
                                    0);
        
        CGGradientRelease(gradient);
        CGColorSpaceRelease(baseSpace);
    } else {
        CGContextSetFillColorWithColor(ctx, [self.backgroundColor CGColor]);
        CGContextFillPath(ctx);
    }
    
    if (self.borderWidth > 0.0f) {
        CGRect strokeRect = CGRectInset(self.bounds, self.borderWidth / 2.0f, self.borderWidth / 2.0f);
        CGMutablePathRef strokePath = CGPathCreateMutable();
        CGPathMoveToPoint(strokePath, NULL, CGRectGetMidX(strokeRect), CGRectGetMinY(strokeRect));
        CGPathAddArcToPoint(strokePath, NULL, CGRectGetMaxX(strokeRect), CGRectGetMinY(strokeRect), CGRectGetMaxX(strokeRect), CGRectGetMaxY(strokeRect), self.cornerRadius);
        CGPathAddArcToPoint(strokePath, NULL, CGRectGetMaxX(strokeRect), CGRectGetMaxY(strokeRect), CGRectGetMinX(strokeRect), CGRectGetMaxY(strokeRect), self.cornerRadius);
        CGPathAddArcToPoint(strokePath, NULL, CGRectGetMinX(strokeRect), CGRectGetMaxY(strokeRect), CGRectGetMinX(strokeRect), CGRectGetMinY(strokeRect), self.cornerRadius);
        CGPathAddArcToPoint(strokePath, NULL, CGRectGetMinX(strokeRect), CGRectGetMinY(strokeRect), CGRectGetMaxX(strokeRect), CGRectGetMinY(strokeRect), self.cornerRadius);
        CGPathCloseSubpath(strokePath);
        CGContextAddPath(ctx, strokePath);
        
        CGContextSetLineWidth(ctx, self.borderWidth);
        CGContextSetStrokeColorWithColor(ctx, [self.borderColor CGColor]);
        CGContextStrokePath(ctx);
    }
    
    CGContextRestoreGState(ctx);
    CGPathRelease(path);
}

#pragma mark - Getters and Setters

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    _backgroundColor = backgroundColor;
    [self setNeedsDisplay];
}

- (UIColor *)backgroundColor {
    return _backgroundColor;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    [self setNeedsDisplay];
}

- (void)setDrawsGradientBackground:(BOOL)drawsGradientBackground {
    _drawsGradientBackground = drawsGradientBackground;
    [self setNeedsDisplay];
}

- (void)setGradientTopColor:(UIColor *)gradientTopColor {
    _gradientTopColor = gradientTopColor;
    [self setNeedsDisplay];
}

- (void)setGradientBottomColor:(UIColor *)gradientBottomColor {
    _gradientBottomColor = gradientBottomColor;
    [self setNeedsDisplay];
}

@end

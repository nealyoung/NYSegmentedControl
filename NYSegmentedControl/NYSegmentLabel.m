//
//  NYSegmentLabel.m
//  NYSegmentLabel
//
//  Copyright (c) 2015 Peter Gammelgaard. All rights reserved.
//
//  https://github.com/nealyoung/NYSegmentedControl
//

#import "NYSegmentLabel.h"

@implementation NYSegmentLabel

- (void)setMaskFrame:(CGRect)maskFrame {
    _maskFrame = maskFrame;

    [self setNeedsDisplay];
}

- (void)setMaskCornerRadius:(CGFloat)maskCornerRadius {
    _maskCornerRadius = maskCornerRadius;

    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();

    // Draw text normally
    [super drawTextInRect:rect];

    if (self.alternativeTextColor) {
        CGImageRef mask = NULL;

        // Create a mask from the text
        mask = CGBitmapContextCreateImage(context);

        CGContextSaveGState(context);
        CGContextTranslateCTM(context, 0, self.frame.size.height);
        CGContextScaleCTM(context, 1.0, (CGFloat) -1.0);

        // Clip the current context to our mask
        CGContextClipToMask(context, rect, mask);

        // Set fill color
        CGContextSetFillColorWithColor(context, [self.alternativeTextColor CGColor]);

        // Path from mask
        CGPathRef path;
        
        if (CGRectIsEmpty(self.maskFrame)) {
            path = CGPathCreateMutable();
        } else {
            UIBezierPath *roundRectBezierPath = [UIBezierPath bezierPathWithRoundedRect:self.maskFrame
                                                                           cornerRadius:self.maskCornerRadius];
            path = CGPathCreateCopy([roundRectBezierPath CGPath]);
        }
        
        CGContextAddPath(context, path);
        
        // Fill the path
        CGContextFillPath(context);
        CFRelease(path);

        // Clean up
        CGContextRestoreGState(context);
        CGImageRelease(mask);
    }
}

- (UIColor *)alternativeTextColor {
    if (!_alternativeTextColor) {
        _alternativeTextColor = self.textColor;
    }
    
    return _alternativeTextColor;
}

@end

//
//  NYSegmentLabel.m
//  NYSegmentLabel
//
//  Copyright (c) 2015 Peter Gammelgaard. All rights reserved.
//
//  https://github.com/nealyoung/NYSegmentedControl
//

#import "NYSegmentLabel.h"

@interface NYSegmentLabel ()
@property(nonatomic, strong) NSDictionary *normalAttributes;
@property(nonatomic, strong) NSDictionary *alternativeAttributes;
@end

@implementation NYSegmentLabel

- (instancetype)init {
    self = [super init];
    if (self) {
        _alternativeTextColor = self.textColor;
        _alternativeFont = self.font;

        [self setupAlternativeAttributes];
    }

    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _alternativeTextColor = self.textColor;
        _alternativeFont = self.font;

        [self setupAlternativeAttributes];
    }

    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        _alternativeTextColor = self.textColor;
        _alternativeFont = self.font;

        [self setupAlternativeAttributes];
    }

    return self;
}


- (void)drawRect:(CGRect)rect {
    CGSize size = [self.text sizeWithAttributes:self.normalAttributes];

    // Centered rect
    CGRect drawRect = CGRectMake(rect.origin.x,
        rect.origin.y + (rect.size.height - size.height)/2,
        rect.size.width,
        (size.height));

    // Get current context
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);

    if (!CGRectIsEmpty(self.maskFrame)) {
        // Frames to draw normal text within
        CGRect beforeMaskFrame = CGRectMake(0, 0, CGRectGetMinX(self.maskFrame), CGRectGetHeight(self.frame));
        CGRect afterMaskFrame = CGRectMake(CGRectGetMaxX(self.maskFrame), 0, CGRectGetWidth(self.frame) - CGRectGetMaxX(self.maskFrame), CGRectGetHeight(self.frame));
        CGRect rects[2] =  {beforeMaskFrame, afterMaskFrame};

        // Clip to those frames
        CGContextClipToRects(context, rects, 2);
    }

    [self.text drawInRect:drawRect withAttributes:self.normalAttributes];

    // Restore state
    CGContextRestoreGState(context);

    if (!CGRectIsEmpty(self.maskFrame)) {
        context = UIGraphicsGetCurrentContext();

        // Clip to mask
        CGContextClipToRect(context, self.maskFrame);

        // Draw masked text
        [self.text drawInRect:drawRect withAttributes:self.alternativeAttributes];
    }
}

#pragma mark - Private

- (void)setupAlternativeAttributes {
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.alignment = NSTextAlignmentCenter;

    NSDictionary *alternativeAttributes = @{ NSFontAttributeName: self.alternativeFont,
        NSForegroundColorAttributeName : self.alternativeTextColor,
        NSParagraphStyleAttributeName: paragraphStyle
    };

    self.alternativeAttributes = alternativeAttributes;
}

- (void)setupNormalAttributes {
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.alignment = NSTextAlignmentCenter;

    NSDictionary *normalAttributes = @{ NSFontAttributeName: self.font,
        NSForegroundColorAttributeName : self.textColor,
        NSParagraphStyleAttributeName: paragraphStyle
    };

    self.normalAttributes = normalAttributes;
}

#pragma mark - Setters

- (void)setMaskFrame:(CGRect)maskFrame {
    _maskFrame = maskFrame;

    [self setNeedsDisplay];
}

- (void)setMaskCornerRadius:(CGFloat)maskCornerRadius {
    _maskCornerRadius = maskCornerRadius;

    [self setNeedsDisplay];
}

- (void)setTextColor:(UIColor *)textColor {
    [super setTextColor:textColor];

    [self setupNormalAttributes];
}

- (void)setAlternativeTextColor:(UIColor *)alternativeTextColor {
    _alternativeTextColor = alternativeTextColor;

    [self setupAlternativeAttributes];
}

- (void)setAlternativeFont:(UIFont *)alternativeFont {
    _alternativeFont = alternativeFont;

    [self setupAlternativeAttributes];
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];

    [self setupNormalAttributes];
}

@end

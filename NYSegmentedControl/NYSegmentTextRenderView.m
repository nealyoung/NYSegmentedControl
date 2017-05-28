#import "NYSegmentTextRenderView.h"

@interface NYSegmentTextRenderView ()

@property (nonatomic, strong) NSDictionary *normalAttributes;
@property (nonatomic, strong) NSDictionary *alternativeAttributes;

@end

@implementation NYSegmentTextRenderView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }

    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }

    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }

    return self;
}

- (void)commonInit {
    _font = [UIFont systemFontOfSize:14.0f];
    _textColor = [UIColor darkGrayColor];

    _alternativeTextColor = self.textColor;
    _alternativeFont = self.font;

    [self setupAlternativeAttributes];
}

- (void)drawRect:(CGRect)rect {
    CGSize textRectSize = [self.text sizeWithAttributes:self.normalAttributes];

    // Centered rect
    CGRect drawRect = CGRectMake(rect.origin.x,
                                 rect.origin.y + (rect.size.height - textRectSize.height) / 2.0f,
                                 rect.size.width,
                                 textRectSize.height);

    // Get current context
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);

    if (!CGRectIsEmpty(self.maskFrame)) {
        // Frames to draw normal text within
        CGRect beforeMaskFrame = CGRectMake(0, 0, CGRectGetMinX(self.maskFrame), CGRectGetHeight(self.frame));
        CGRect afterMaskFrame = CGRectMake(CGRectGetMaxX(self.maskFrame),
                                           0,
                                           CGRectGetWidth(self.frame) - CGRectGetMaxX(self.maskFrame),
                                           CGRectGetHeight(self.frame));
        CGRect rects[2] = {beforeMaskFrame, afterMaskFrame};

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


- (CGSize)sizeThatFits:(CGSize)size {
    return [self.text sizeWithAttributes:self.normalAttributes];
}

#pragma mark - Private

- (void)setupAlternativeAttributes {
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.alignment = NSTextAlignmentCenter;

    NSDictionary *alternativeAttributes = @{ NSFontAttributeName: self.alternativeFont,
                                             NSForegroundColorAttributeName: self.alternativeTextColor,
                                             NSParagraphStyleAttributeName: paragraphStyle };

    self.alternativeAttributes = alternativeAttributes;
}

- (void)setupNormalAttributes {
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.alignment = NSTextAlignmentCenter;

    NSDictionary *normalAttributes = @{ NSFontAttributeName: self.font,
                                        NSForegroundColorAttributeName: self.textColor,
                                        NSParagraphStyleAttributeName: paragraphStyle };

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
    _textColor = textColor;

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
    _font = font;
    
    [self setupNormalAttributes];
}

@end

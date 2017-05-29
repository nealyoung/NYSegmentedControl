#import "NYSegmentTextRenderView.h"

@interface NYSegmentTextRenderView ()

@property (nonatomic, strong) NSDictionary *unselectedTextAttributes;
@property (nonatomic, strong) NSDictionary *selectedTextAttributes;

@end

@implementation NYSegmentTextRenderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        _font = [UIFont systemFontOfSize:14.0f];
        _textColor = [UIColor darkGrayColor];

        _selectedTextColor = _textColor;
        _selectedFont = _font;

        [self setupSelectedAttributes];
    }

    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);

    if (!CGRectIsEmpty(self.selectedTextDrawingRect)) {
        // Frames to draw normal text within
        CGRect beforeMaskFrame = CGRectMake(0, 0, CGRectGetMinX(self.selectedTextDrawingRect), CGRectGetHeight(self.frame));
        CGRect afterMaskFrame = CGRectMake(CGRectGetMaxX(self.selectedTextDrawingRect),
                                           0,
                                           CGRectGetWidth(self.frame) - CGRectGetMaxX(self.selectedTextDrawingRect),
                                           CGRectGetHeight(self.frame));
        CGRect rects[2] = {beforeMaskFrame, afterMaskFrame};

        // Clip to those frames
        CGContextClipToRects(context, rects, 2);
    }

    CGSize textRectSize = [self.text sizeWithAttributes:self.unselectedTextAttributes];

    // Centered rect
    CGRect drawRect = CGRectMake(rect.origin.x,
                                 rect.origin.y + (rect.size.height - textRectSize.height) / 2.0f,
                                 rect.size.width,
                                 textRectSize.height);

    [self.text drawInRect:drawRect withAttributes:self.unselectedTextAttributes];

    // Restore state
    CGContextRestoreGState(context);

    if (!CGRectIsEmpty(self.selectedTextDrawingRect)) {
        context = UIGraphicsGetCurrentContext();

        // Clip to mask
        CGContextClipToRect(context, self.selectedTextDrawingRect);

        // Draw masked text
        [self.text drawInRect:drawRect withAttributes:self.selectedTextAttributes];
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    return [self.text sizeWithAttributes:self.unselectedTextAttributes];
}

#pragma mark - Private

- (void)setupSelectedAttributes {
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.alignment = NSTextAlignmentCenter;

    NSDictionary *selectedAttributes = @{ NSFontAttributeName: self.selectedFont,
                                             NSForegroundColorAttributeName: self.selectedTextColor,
                                             NSParagraphStyleAttributeName: paragraphStyle };

    self.selectedTextAttributes = selectedAttributes;
}

- (void)setupNormalAttributes {
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.alignment = NSTextAlignmentCenter;

    NSDictionary *normalAttributes = @{ NSFontAttributeName: self.font,
                                        NSForegroundColorAttributeName: self.textColor,
                                        NSParagraphStyleAttributeName: paragraphStyle };

    self.unselectedTextAttributes = normalAttributes;
}

#pragma mark - Setters

- (void)setSelectedTextDrawingRect:(CGRect)selectedTextDrawingRect {
    _selectedTextDrawingRect = selectedTextDrawingRect;

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

- (void)setSelectedTextColor:(UIColor *)selectedTextColor {
    _selectedTextColor = selectedTextColor;
    
    [self setupSelectedAttributes];
}

- (void)setSelectedFont:(UIFont *)selectedFont {
    _selectedFont = selectedFont;
    
    [self setupSelectedAttributes];
}

- (void)setFont:(UIFont *)font {
    _font = font;
    
    [self setupNormalAttributes];
}

@end

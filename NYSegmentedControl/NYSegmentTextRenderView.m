#import "NYSegmentTextRenderView.h"

@interface NYSegmentTextRenderView ()

@property (nonatomic, strong, nonnull) NSDictionary<NSString *, id> *unselectedTextAttributes;
@property (nonatomic, strong, nonnull) NSDictionary<NSString *, id> *selectedTextAttributes;

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
        [self setupUnselectedAttributes];
    }

    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);

    if (!CGRectIsEmpty(self.selectedTextDrawingRect)) {
        CGRect beforeMaskFrame = CGRectMake(0, 0, CGRectGetMinX(self.selectedTextDrawingRect), CGRectGetHeight(self.frame));
        CGRect afterMaskFrame = CGRectMake(CGRectGetMaxX(self.selectedTextDrawingRect),
                                           0,
                                           CGRectGetWidth(self.frame) - CGRectGetMaxX(self.selectedTextDrawingRect),
                                           CGRectGetHeight(self.frame));
        CGRect unselectedTextDrawingRects[2] = {beforeMaskFrame, afterMaskFrame};
        CGContextClipToRects(context, unselectedTextDrawingRects, 2);
    }

    CGFloat unselectedTextRectHeight = [self.text sizeWithAttributes:self.unselectedTextAttributes].height;
    CGRect unselectedTextDrawingRect = CGRectMake(rect.origin.x,
                                                  rect.origin.y + (rect.size.height - unselectedTextRectHeight) / 2.0f,
                                                  rect.size.width,
                                                  unselectedTextRectHeight);

    [self.text drawInRect:unselectedTextDrawingRect withAttributes:self.unselectedTextAttributes];

    CGContextRestoreGState(context);

    if (!CGRectIsEmpty(self.selectedTextDrawingRect)) {
        CGFloat selectedTextRectHeight = [self.text sizeWithAttributes:self.selectedTextAttributes].height;
        CGRect selectedTextDrawingRect = CGRectMake(rect.origin.x,
                                                    rect.origin.y + (rect.size.height - selectedTextRectHeight) / 2.0f,
                                                    rect.size.width,
                                                    selectedTextRectHeight);
        CGContextClipToRect(context, self.selectedTextDrawingRect);

        [self.text drawInRect:selectedTextDrawingRect withAttributes:self.selectedTextAttributes];
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

- (void)setupUnselectedAttributes {
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.alignment = NSTextAlignmentCenter;

    NSDictionary *unselectedAttributes = @{ NSFontAttributeName: self.font,
                                            NSForegroundColorAttributeName: self.textColor,
                                            NSParagraphStyleAttributeName: paragraphStyle };

    self.unselectedTextAttributes = unselectedAttributes;
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

    [self setupUnselectedAttributes];
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
    
    [self setupUnselectedAttributes];
}

@end

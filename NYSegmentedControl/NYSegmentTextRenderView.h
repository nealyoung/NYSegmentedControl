#import <Foundation/Foundation.h>

@interface NYSegmentTextRenderView : UIView

@property (nonatomic, strong, nullable) NSString *text;
@property (nonatomic, strong, nonnull) UIFont *font;
@property (nonatomic, strong, nonnull) UIColor *textColor;

@property (nonatomic, strong, nonnull) UIColor *selectedTextColor;
@property (nonatomic, strong, nonnull) UIFont *selectedFont;

@property (nonatomic, assign) CGRect selectedTextDrawingRect;
@property (nonatomic, assign) CGFloat maskCornerRadius;

@end

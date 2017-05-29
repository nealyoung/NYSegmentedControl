#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NYSegmentTextRenderView : UIView

@property (nonatomic, strong, nullable) NSString *text;

@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic, strong) UIColor *selectedTextColor;
@property (nonatomic, strong) UIFont *selectedFont;

@property (nonatomic, assign) CGRect selectedTextDrawingRect;
@property (nonatomic, assign) CGFloat maskCornerRadius;

@end

NS_ASSUME_NONNULL_END

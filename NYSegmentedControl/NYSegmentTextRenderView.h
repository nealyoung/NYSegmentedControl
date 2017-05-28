#import <Foundation/Foundation.h>

@interface NYSegmentTextRenderView : UIView

@property (nonatomic, strong, nullable) NSString *text;
@property (nonatomic, strong, nonnull) UIFont *font;
@property (nonatomic, strong, nonnull) UIColor *textColor;

@property (nonatomic, strong, nonnull) UIColor *alternativeTextColor;
@property (nonatomic, strong, nonnull) UIFont *alternativeFont;

@property (nonatomic, assign) CGRect maskFrame;
@property (nonatomic, assign) CGFloat maskCornerRadius;

@end

#import <UIKit/UIKit.h>

@class NYSegment;
@class NYSegmentTextRenderView;

@interface NYSegment : UIView

@property (nonatomic) NYSegmentTextRenderView *titleLabel;

- (instancetype)initWithTitle:(NSString *)title;

@end

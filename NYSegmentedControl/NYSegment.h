#import <UIKit/UIKit.h>

@class NYSegment;
@class NYSegmentTextRenderView;

@interface NYSegment : UIView

@property (nonatomic) NYSegmentTextRenderView *titleLabel;
@property (nonatomic) BOOL selected;

- (instancetype)initWithTitle:(NSString *)title;

@end

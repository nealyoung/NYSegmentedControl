#import "NYSegment.h"
#import "NYSegmentTextRenderView.h"

static CGFloat const kMinimumSegmentWidth = 64.0f;

@implementation NYSegment

- (instancetype)initWithTitle:(NSString *)title {
    self = [self initWithFrame:CGRectZero];
    if (self) {
        self.titleLabel.text = title;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.isAccessibilityElement = YES;
        self.accessibilityTraits = UIAccessibilityTraitButton;

        self.userInteractionEnabled = NO;
        self.titleLabel = [[NYSegmentTextRenderView alloc] initWithFrame:self.frame];
        self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize sizeThatFits = [self.titleLabel sizeThatFits:size];
    return CGSizeMake(MAX(sizeThatFits.width * 1.4f, kMinimumSegmentWidth), sizeThatFits.height);
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    if (selected) {
        self.accessibilityTraits = self.accessibilityTraits | UIAccessibilityTraitSelected;
    } else {
        self.accessibilityTraits = self.accessibilityTraits & ~UIAccessibilityTraitSelected;
    }
}

- (NSString *)accessibilityLabel {
    return self.titleLabel.text;
}

@end

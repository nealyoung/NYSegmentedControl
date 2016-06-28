//
//  NYSegmentedControl.m
//  NYSegmentedControl
//
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//
//  https://github.com/nealyoung/NYSegmentedControl
//

#import "NYSegmentedControl.h"
#import "NYSegment.h"
#import "NYSegmentIndicator.h"
#import "NYSegmentLabel.h"

@interface NYSegmentedControl ()

@property (nonatomic) NSArray *segments;
@property NYSegmentIndicator *selectedSegmentIndicator;
@property (nonatomic, getter=isAnimating) BOOL animating;

- (void)moveSelectedSegmentIndicatorToSegmentAtIndex:(NSInteger)index animated:(BOOL)animated;
- (CGRect)indicatorFrameForSegment:(NYSegment *)segment;

- (void)panGestureRecognized:(UIPanGestureRecognizer *)panGestureRecognizer;
- (void)tapGestureRecognized:(UITapGestureRecognizer *)tapGestureRecognizer;

@end

@implementation NYSegmentedControl

+ (Class)layerClass {
    return [CAGradientLayer class];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self initialize];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initialize];
    }
    
    return self;
}

- (instancetype)initWithItems:(NSArray *)items {
    self = [self initWithFrame:CGRectZero];
    
    if (self) {
        NSMutableArray *mutableSegments = [NSMutableArray array];
        
        for (NSString *segmentTitle in items) {
            NYSegment *segment = [[NYSegment alloc] initWithTitle:segmentTitle];
            segment.titleLabel.maskCornerRadius = self.cornerRadius;
            [self addSubview:segment];
            [mutableSegments addObject:segment];
        }
        
        self.segments = [NSArray arrayWithArray:mutableSegments];
        self.selectedSegmentIndex = 0;
    }
    
    return self;
}

- (void)initialize {
    // We need to directly access the ivars for UIAppearance properties in the initializer
    _titleFont = [UIFont systemFontOfSize:13.0f];
    _titleTextColor = [UIColor blackColor];
    _selectedTitleFont = [UIFont boldSystemFontOfSize:13.0f];
    _selectedTitleTextColor = [UIColor blackColor];
    _stylesTitleForSelectedSegment = YES;
    _segmentIndicatorInset = 0.0f;
    _segmentIndicatorAnimationDuration = 0.15f;
    _gradientTopColor = [UIColor colorWithRed:0.21f green:0.21f blue:0.21f alpha:1.0f];
    _gradientBottomColor = [UIColor colorWithRed:0.16f green:0.16f blue:0.16f alpha:1.0f];
    _usesSpringAnimations = NO;
    _springAnimationDuration = 0.25f;
    _springAnimationDampingRatio = 0.7f;
    _springAnimationVelocity = 0.2f;
    
    self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 4.0f;
    self.layer.borderWidth = 1.0f;
    
    self.backgroundColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    self.drawsGradientBackground = NO;
    self.opaque = NO;
    
    self.selectedSegmentIndicator = [[NYSegmentIndicator alloc] initWithFrame:CGRectZero];
    self.drawsSegmentIndicatorGradientBackground = YES;
    [self addSubview:self.selectedSegmentIndicator];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
    [panGestureRecognizer setMinimumNumberOfTouches:1];
    [panGestureRecognizer setMaximumNumberOfTouches:1];
    [self.selectedSegmentIndicator addGestureRecognizer:panGestureRecognizer];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognized:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tapGestureRecognizer];
}

- (void)reloadData {
    if (self.dataSource) {
        for (NYSegment *segment in self.segments) {
            [segment removeFromSuperview];
        }
        self.segments = [self buildSegmentsFromDataSource];
    }
}

- (NSArray *)buildSegmentsFromDataSource {
    if (self.dataSource) {
        NSUInteger numberOfSegments = [self.dataSource numberOfSegmentsOfControl:self];
        NSMutableArray *segmentsArray = [NSMutableArray arrayWithCapacity:numberOfSegments];
        
        for (int i = 0; i < numberOfSegments; i++) {
            NSString *title = [self.dataSource segmentedControl:self titleAtIndex:i];
            NYSegment *segment = [[NYSegment alloc] initWithTitle:title];
            [self addSubview:segment];
            [segmentsArray addObject:segment];
        }
        
        return [segmentsArray copy];
    } else {
        return nil;
    }
}

- (NSArray *)segments {
    if (!_segments) {
        _segments = [self buildSegmentsFromDataSource];
    }
    
    return _segments;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat maxSegmentWidth = 0.0f;
    
    for (NYSegment *segment in self.segments) {
        CGFloat segmentWidth = [segment sizeThatFits:size].width;
        if (segmentWidth > maxSegmentWidth) {
            maxSegmentWidth = segmentWidth;
        }
    }
    
    return CGSizeMake(maxSegmentWidth * [self.segments count], 30.0f);
}

- (CGSize)intrinsicContentSize {
    return [self sizeThatFits:self.bounds.size];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat segmentWidth = CGRectGetWidth(self.frame) / [self.segments count];
    CGFloat segmentHeight = CGRectGetHeight(self.frame);
    for (int i = 0; i < [self.segments count]; i++) {
        NYSegment *segment = self.segments[i];
        segment.frame = CGRectMake(segmentWidth * i, 0.0f, segmentWidth, segmentHeight);
        
        if (self.stylesTitleForSelectedSegment) {
            if (self.selectedSegmentIndex == i) {
                segment.titleLabel.font = self.selectedTitleFont;
                segment.titleLabel.maskFrame = segment.titleLabel.bounds;
            } else {
                segment.titleLabel.font = self.titleFont;
            }
            
            segment.titleLabel.alternativeTextColor = self.selectedTitleTextColor;
            segment.titleLabel.textColor = self.titleTextColor;
        } else {
            segment.titleLabel.font = self.titleFont;
            segment.titleLabel.textColor = self.titleTextColor;
        }
    }
    
    if (self.selectedSegmentIndex != UISegmentedControlNoSegment) {
        self.selectedSegmentIndicator.frame = [self indicatorFrameForSegment:self.segments[self.selectedSegmentIndex]];
    }
}

- (void)drawRect:(CGRect)rect {
    if (self.drawsGradientBackground) {
        CAGradientLayer *gradientLayer = (CAGradientLayer *)self.layer;
        gradientLayer.colors = @[(__bridge id)[self.gradientTopColor CGColor],
                                 (__bridge id)[self.gradientBottomColor CGColor]];
    } else {
        self.layer.backgroundColor = [self.backgroundColor CGColor];
    }
}

- (void)insertSegmentWithTitle:(NSString *)title atIndex:(NSUInteger)index {
    if (index >= [self.segments count]) {
        index = [self.segments count];
    }
    
    NYSegment *newSegment = [[NYSegment alloc] initWithTitle:title];
    newSegment.titleLabel.maskCornerRadius = self.cornerRadius;
    [self addSubview:newSegment];
    
    NSMutableArray *mutableSegments = [NSMutableArray arrayWithArray:self.segments];
    [mutableSegments insertObject:newSegment atIndex:index];
    self.segments = [NSArray arrayWithArray:mutableSegments];
    
    [self setNeedsLayout];
}

- (void)removeSegmentAtIndex:(NSUInteger)index {
    if (index >= self.numberOfSegments) {
        index = self.numberOfSegments - 1;
    }
    
    NYSegment *segment = self.segments[index];
    [segment removeFromSuperview];
    
    NSMutableArray *mutableSegments = [NSMutableArray arrayWithArray:self.segments];
    [mutableSegments removeObjectAtIndex:index];
    self.segments = [NSArray arrayWithArray:mutableSegments];
    
    [self setNeedsLayout];
}

- (void)removeAllSegments {
    for (NYSegment *segment in self.segments) {
        [segment removeFromSuperview];
    }
    
    self.segments = [NSArray array];
    [self setNeedsLayout];
}

- (void)setTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)index {
    NYSegment *segment = self.segments[index];
    segment.titleLabel.text = title;
}

- (NSString *)titleForSegmentAtIndex:(NSUInteger)index {
    NYSegment *segment = self.segments[index];
    return segment.titleLabel.text;
}

- (void)moveSelectedSegmentIndicatorToSegmentAtIndex:(NSInteger)index animated:(BOOL)animated {
    if (index == UISegmentedControlNoSegment) {
        //Hide segment indicator
        self.selectedSegmentIndicator.hidden = YES;
        return;
    } else {
        self.selectedSegmentIndicator.hidden = NO;
    }
    
    NYSegment *selectedSegment = self.segments[index];

    // If we're moving the indicator back to the originally selected segment, don't change the segment's font style
    if (index != self.selectedSegmentIndex && self.stylesTitleForSelectedSegment) {
        if (self.selectedSegmentIndex != UISegmentedControlNoSegment) {
            NYSegment *previousSegment = self.segments[self.selectedSegmentIndex];
            
            [UIView transitionWithView:previousSegment.titleLabel
                              duration:self.segmentIndicatorAnimationDuration
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                previousSegment.titleLabel.font = self.titleFont;
                                previousSegment.titleLabel.textColor = self.titleTextColor;
                                previousSegment.titleLabel.maskFrame = CGRectZero;
                            }
                            completion:nil];
        }
        
        [UIView transitionWithView:selectedSegment.titleLabel
                          duration:self.segmentIndicatorAnimationDuration
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            selectedSegment.titleLabel.font = self.selectedTitleFont;
                            selectedSegment.titleLabel.textColor = self.selectedTitleTextColor;
                            
                            if (self.drawsSegmentIndicatorGradientBackground) {
                                //selectedSegment.titleLabel.shadowColor = [UIColor darkGrayColor];
                            }
                        }
                        completion:nil];
    }
    
    if (_selectedSegmentIndex == UISegmentedControlNoSegment) {
        self.selectedSegmentIndicator.frame = [self indicatorFrameForSegment:selectedSegment];
    }
    
    if (animated) {
        void (^animationsBlock)(void) = ^{
            self.selectedSegmentIndicator.frame = [self indicatorFrameForSegment:selectedSegment];
            
            if (self.stylesTitleForSelectedSegment) {
                [self.segments enumerateObjectsUsingBlock:^(NYSegment *segment, NSUInteger index, BOOL *stop) {
                    segment.titleLabel.maskFrame = CGRectZero;
                }];
                
                selectedSegment.titleLabel.maskFrame = selectedSegment.titleLabel.bounds;
            }
        };
        
        [self.selectedSegmentIndicator setNeedsDisplay];
        if (NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_6_1 || !self.usesSpringAnimations) {
            [UIView animateWithDuration:self.segmentIndicatorAnimationDuration
                             animations:animationsBlock
                             completion:nil];
        } else {
            [UIView animateWithDuration:self.springAnimationDuration
                                  delay:0.f
                 usingSpringWithDamping:self.springAnimationDampingRatio
                  initialSpringVelocity:self.springAnimationVelocity
                                options:kNilOptions
                             animations:animationsBlock
                             completion:nil];
        }
    } else {
        [self.selectedSegmentIndicator setNeedsDisplay];
        self.selectedSegmentIndicator.frame = [self indicatorFrameForSegment:selectedSegment];
        
        if (self.stylesTitleForSelectedSegment) {
            selectedSegment.titleLabel.font = self.selectedTitleFont;
            selectedSegment.titleLabel.maskFrame = selectedSegment.titleLabel.bounds;
        }
    }
}

#pragma mark - Touch Tracking

- (void)panGestureRecognized:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint translation = [panGestureRecognizer translationInView:panGestureRecognizer.view.superview];
    
    if (self.stylesTitleForSelectedSegment) {
        // Style the segment the center of the indicator is covering
        [self.segments enumerateObjectsUsingBlock:^(NYSegment *segment, NSUInteger index, BOOL *stop) {
            if (CGRectContainsPoint(segment.frame, self.selectedSegmentIndicator.center)) {
                segment.titleLabel.font = self.selectedTitleFont;
            } else {
                segment.titleLabel.font = self.titleFont;
            }
            
            CGRect segmentFrame = segment.frame;
            CGRect intersection = CGRectIntersection(segmentFrame, self.selectedSegmentIndicator.frame);
            CGAffineTransform transform = CGAffineTransformMakeTranslation(-CGRectGetMinX(segmentFrame), -CGRectGetMinY(segmentFrame));
            CGRect maskFrame = CGRectApplyAffineTransform(intersection, transform);
            segment.titleLabel.maskFrame = maskFrame;
        }];
    }
    
    // Find the difference in horizontal position between the current and previous touches
    CGFloat xDiff = translation.x;
    
    // Check that the indicator doesn't exit the bounds of the control
    CGRect newSegmentIndicatorFrame = self.selectedSegmentIndicator.frame;
    newSegmentIndicatorFrame.origin.x += xDiff;
    
    if (CGRectContainsRect(CGRectInset(self.bounds, self.segmentIndicatorInset, 0), newSegmentIndicatorFrame)) {
        self.selectedSegmentIndicator.center = CGPointMake(self.selectedSegmentIndicator.center.x + xDiff, self.selectedSegmentIndicator.center.y);
    }
    
    [panGestureRecognizer setTranslation:CGPointMake(0, 0) inView:panGestureRecognizer.view.superview];
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self.segments enumerateObjectsUsingBlock:^(NYSegment *segment, NSUInteger index, BOOL *stop) {
            if (CGRectContainsPoint(segment.frame, self.selectedSegmentIndicator.center)) {
                [self moveSelectedSegmentIndicatorToSegmentAtIndex:index animated:YES];
                
                if (index != self.selectedSegmentIndex) {
                    _selectedSegmentIndex = index;
                    [self sendActionsForControlEvents:UIControlEventValueChanged];
                }
            }
        }];
    }
}

- (void)tapGestureRecognized:(UITapGestureRecognizer *)tapGestureRecognizer {
    CGPoint location = [tapGestureRecognizer locationInView:self];
    [self.segments enumerateObjectsUsingBlock:^(NYSegment *segment, NSUInteger index, BOOL *stop) {
        if (CGRectContainsPoint(segment.frame, location)) {
            if (index != self.selectedSegmentIndex) {
                [self setSelectedSegmentIndex:index animated:YES];
                [self sendActionsForControlEvents:UIControlEventValueChanged];
            }
        }
    }];
}

#pragma mark - Helpers

- (CGRect)indicatorFrameForSegment:(NYSegment *)segment {
    return CGRectMake(CGRectGetMinX(segment.frame) + self.segmentIndicatorInset,
                      CGRectGetMinY(segment.frame) + self.segmentIndicatorInset,
                      CGRectGetWidth(segment.frame) - (2.0f * self.segmentIndicatorInset),
                      CGRectGetHeight(segment.frame) - (2.0f * self.segmentIndicatorInset));
}

#pragma mark - Getters and Setters

- (NSUInteger)numberOfSegments {
    return [self.segments count];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    self.layer.backgroundColor = [backgroundColor CGColor];
}

- (UIColor *)backgroundColor {
    return [UIColor colorWithCGColor:self.layer.backgroundColor];
}

- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = [borderColor CGColor];
}

- (UIColor *)borderColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}

- (CGFloat)borderWidth {
    return self.layer.borderWidth;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    for (NYSegment *segment in self.segments) {
        segment.titleLabel.maskCornerRadius = cornerRadius;
    }
    
    self.layer.cornerRadius = cornerRadius;
    self.selectedSegmentIndicator.cornerRadius = cornerRadius * ((self.frame.size.height - self.segmentIndicatorInset * 2) / self.frame.size.height);
    [self setNeedsDisplay];
}

- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}

- (void)setDrawsSegmentIndicatorGradientBackground:(BOOL)drawsSegmentIndicatorGradientBackground {
    self.selectedSegmentIndicator.drawsGradientBackground = drawsSegmentIndicatorGradientBackground;
}

- (BOOL)drawsSegmentIndicatorGradientBackground {
    return self.selectedSegmentIndicator.drawsGradientBackground;
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    self.selectedSegmentIndicator.cornerRadius = self.cornerRadius * ((self.frame.size.height - self.segmentIndicatorInset * 2) / self.frame.size.height);
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.selectedSegmentIndicator.cornerRadius = self.cornerRadius * ((self.frame.size.height - self.segmentIndicatorInset * 2) / self.frame.size.height);
}

- (void)setSegmentIndicatorBackgroundColor:(UIColor *)segmentIndicatorBackgroundColor {
    self.selectedSegmentIndicator.backgroundColor = segmentIndicatorBackgroundColor;
}

- (UIColor *)segmentIndicatorBackgroundColor {
    return self.selectedSegmentIndicator.backgroundColor;
}

- (void)setSegmentIndicatorInset:(CGFloat)segmentIndicatorInset {
    _segmentIndicatorInset = segmentIndicatorInset;
    self.selectedSegmentIndicator.cornerRadius = self.cornerRadius * ((self.frame.size.height - self.segmentIndicatorInset * 2) / self.frame.size.height);
    [self setNeedsLayout];
}

- (void)setSegmentIndicatorGradientTopColor:(UIColor *)segmentIndicatorGradientTopColor {
    self.selectedSegmentIndicator.gradientTopColor = segmentIndicatorGradientTopColor;
}

- (UIColor *)segmentIndicatorGradientTopColor {
    return self.selectedSegmentIndicator.gradientTopColor;
}

- (void)setSegmentIndicatorGradientBottomColor:(UIColor *)segmentIndicatorGradientBottomColor {
    self.selectedSegmentIndicator.gradientBottomColor = segmentIndicatorGradientBottomColor;
}

- (UIColor *)segmentIndicatorGradientBottomColor {
    return self.selectedSegmentIndicator.gradientBottomColor;
}

- (void)setSegmentIndicatorBorderColor:(UIColor *)segmentIndicatorBorderColor {
    self.selectedSegmentIndicator.borderColor = segmentIndicatorBorderColor;
}

- (UIColor *)segmentIndicatorBorderColor {
    return self.selectedSegmentIndicator.borderColor;
}

- (void)setSegmentIndicatorBorderWidth:(CGFloat)segmentIndicatorBorderWidth {
    self.selectedSegmentIndicator.borderWidth = segmentIndicatorBorderWidth;
}

- (CGFloat)segmentIndicatorBorderWidth {
    return self.selectedSegmentIndicator.borderWidth;
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    [self setNeedsLayout];
}

- (void)setTitleTextColor:(UIColor *)titleTextColor {
    _titleTextColor = titleTextColor;
    [self setNeedsLayout];
}

- (void)setSelectedTitleFont:(UIFont *)selectedTitleFont {
    _selectedTitleFont = selectedTitleFont;
    [self setNeedsLayout];
}

- (void)setSelectedTitleTextColor:(UIColor *)selectedTitleTextColor {
    _selectedTitleTextColor = selectedTitleTextColor;
    [self setNeedsLayout];
}

- (void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex {
    if (selectedSegmentIndex >= (NSInteger)self.numberOfSegments) {
        selectedSegmentIndex = self.numberOfSegments - 1;
    } else if (selectedSegmentIndex < 0) {
        if (selectedSegmentIndex != UISegmentedControlNoSegment) {
            selectedSegmentIndex = 0;
        }
    }
    
    [self moveSelectedSegmentIndicatorToSegmentAtIndex:selectedSegmentIndex animated:NO];
    _selectedSegmentIndex = selectedSegmentIndex;
}

- (void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex animated:(BOOL)animated {
    if (selectedSegmentIndex >= (NSInteger)self.numberOfSegments) {
        selectedSegmentIndex = self.numberOfSegments - 1;
    } else if (selectedSegmentIndex < 0) {
        if (selectedSegmentIndex != UISegmentedControlNoSegment) {
            selectedSegmentIndex = 0;
        }
    }
    
    [self moveSelectedSegmentIndicatorToSegmentAtIndex:selectedSegmentIndex animated:animated];
    _selectedSegmentIndex = selectedSegmentIndex;
}

@end

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

@interface NYSegmentedControl ()

@property NSArray *segments;
@property NYSegmentIndicator *selectedSegmentIndicator;

- (void)moveSelectedSegmentIndicatorToSegmentAtIndex:(NSUInteger)index animated:(BOOL)animated;
- (CGRect)indicatorFrameForSegment:(NYSegment *)segment;

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
    
    self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 4.0f;
    self.layer.borderWidth = 1.0f;
    
    self.backgroundColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    self.drawsGradientBackground = NO;
    self.opaque = NO;
    self.segments = [NSArray array];
    
    self.selectedSegmentIndicator = [[NYSegmentIndicator alloc] initWithFrame:CGRectZero];
    self.drawsSegmentIndicatorGradientBackground = YES;
    [self addSubview:self.selectedSegmentIndicator];
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
        
        if (self.stylesTitleForSelectedSegment && self.selectedSegmentIndex == i) {
            segment.titleLabel.font = self.selectedTitleFont;
            segment.titleLabel.textColor = self.selectedTitleTextColor;
        } else {
            segment.titleLabel.font = self.titleFont; 
            segment.titleLabel.textColor = self.titleTextColor;
        }
    }

    self.selectedSegmentIndicator.frame = [self indicatorFrameForSegment:self.segments[self.selectedSegmentIndex]];
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

- (void)moveSelectedSegmentIndicatorToSegmentAtIndex:(NSUInteger)index animated:(BOOL)animated {
    // If we're moving the indicator back to the originally selected segment, don't change the segment's font style
    if (index != self.selectedSegmentIndex) {
        NYSegment *previousSegment = self.segments[self.selectedSegmentIndex];
        previousSegment.titleLabel.font = self.titleFont;
        previousSegment.titleLabel.textColor = self.titleTextColor;
    }
    
    NYSegment *selectedSegment = self.segments[index];
    
    if (animated) {
        [UIView animateWithDuration:self.segmentIndicatorAnimationDuration
                         animations:^{
                             self.selectedSegmentIndicator.frame = [self indicatorFrameForSegment:selectedSegment];
                         }
                         completion:^(BOOL finished) {
                             if (self.stylesTitleForSelectedSegment) {
                                 selectedSegment.titleLabel.font = self.selectedTitleFont;
                                 selectedSegment.titleLabel.textColor = self.selectedTitleTextColor;
                                 
                                 if (self.drawsSegmentIndicatorGradientBackground) {
                                     //selectedSegment.titleLabel.shadowColor = [UIColor darkGrayColor];
                                 }
                             }
                         }];
    } else {
        self.selectedSegmentIndicator.frame = [self indicatorFrameForSegment:selectedSegment];

        if (self.stylesTitleForSelectedSegment) {
            selectedSegment.titleLabel.font = self.selectedTitleFont;
            selectedSegment.titleLabel.textColor = self.selectedTitleTextColor;
        }
    }
}

#pragma mark - Touch Tracking

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    // If the user is touching the slider, start tracking the drag. Otherwise, select the segement that was tapped
    if (CGRectContainsPoint(self.selectedSegmentIndicator.bounds, [touch locationInView:self.selectedSegmentIndicator])) {
        return YES;
    } else {
        // Otherwise, find the segment that the user touched, and select it
        [self.segments enumerateObjectsUsingBlock:^(NYSegment *segment, NSUInteger index, BOOL *stop) {
            if (CGRectContainsPoint(segment.frame, [touch locationInView:self])) {
                if (index != self.selectedSegmentIndex) {
                    [self setSelectedSegmentIndex:index animated:YES];
                    [self sendActionsForControlEvents:UIControlEventValueChanged];
                }
            }
        }];
    }
    
    return NO;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    if (self.stylesTitleForSelectedSegment) {
        // Style the segment the center of the indicator is covering
        [self.segments enumerateObjectsUsingBlock:^(NYSegment *segment, NSUInteger index, BOOL *stop) {
            if (CGRectContainsPoint(segment.frame, self.selectedSegmentIndicator.center)) {
                segment.titleLabel.font = self.selectedTitleFont;
                segment.titleLabel.textColor = self.selectedTitleTextColor;
            } else {
                segment.titleLabel.font = self.titleFont;
                segment.titleLabel.textColor = self.titleTextColor;
            }
        }];
    }
    
    // Find the difference in horizontal position between the current and previous touches
    CGFloat xDiff = [touch locationInView:self.selectedSegmentIndicator].x - [touch previousLocationInView:self.selectedSegmentIndicator].x;
    
    // Check that the indicator doesn't exit the bounds of the control
    CGRect newSegmentIndicatorFrame = self.selectedSegmentIndicator.frame;
    newSegmentIndicatorFrame.origin.x += xDiff;
    
    if (CGRectContainsRect(CGRectInset(self.bounds, self.segmentIndicatorInset, 0), newSegmentIndicatorFrame)) {
        self.selectedSegmentIndicator.center = CGPointMake(self.selectedSegmentIndicator.center.x + xDiff, self.selectedSegmentIndicator.center.y);
    }
    
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    // Select the segment containing the indicator's center
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

- (void)setSelectedSegmentIndex:(NSUInteger)selectedSegmentIndex {
    if (selectedSegmentIndex >= self.numberOfSegments) {
        selectedSegmentIndex = self.numberOfSegments - 1;
    }
    
    [self moveSelectedSegmentIndicatorToSegmentAtIndex:selectedSegmentIndex animated:NO];
    _selectedSegmentIndex = selectedSegmentIndex;
}

- (void)setSelectedSegmentIndex:(NSUInteger)selectedSegmentIndex animated:(BOOL)animated {
    if (selectedSegmentIndex >= self.numberOfSegments) {
        selectedSegmentIndex = self.numberOfSegments - 1;
    }
    
    [self moveSelectedSegmentIndicatorToSegmentAtIndex:selectedSegmentIndex animated:animated];
    _selectedSegmentIndex = selectedSegmentIndex;
}

@end

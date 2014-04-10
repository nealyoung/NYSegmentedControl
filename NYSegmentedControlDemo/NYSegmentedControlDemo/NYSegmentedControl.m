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

@interface NYSegmentedControl () {
    UIColor *_backgroundColor;
}

@property NSArray *segments;
@property NYSegmentIndicator *selectedSegmentIndicator;

- (void)moveSelectedSegmentIndicatorToSegmentAtIndex:(NSUInteger)index animated:(BOOL)animated;
- (CGRect)indicatorFrameForSegment:(NYSegment *)segment;

@end

@implementation NYSegmentedControl

@dynamic numberOfSegments;
@dynamic drawsSegmentIndicatorGradientBackground;
@dynamic segmentIndicatorBackgroundColor;
@dynamic segmentIndicatorGradientTopColor;
@dynamic segmentIndicatorGradientBottomColor;
@dynamic segmentIndicatorBorderColor;
@dynamic segmentIndicatorBorderWidth;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        // We need to directly access the ivars for UIAppearance properties in the initializer
        _titleFont = [UIFont systemFontOfSize:13.0f];
        _titleTextColor = [UIColor blackColor];
        _selectedTitleFont = [UIFont boldSystemFontOfSize:13.0f];
        _selectedTitleTextColor = [UIColor blackColor];
        _stylesTitleForSelectedSegment = YES;
        _cornerRadius = 4.0f;
        _segmentIndicatorInset = 0.0f;
        _segmentIndicatorAnimationDuration = 0.15f;
        _gradientTopColor = [UIColor colorWithRed:0.21f green:0.21f blue:0.21f alpha:1.0f];
        _gradientBottomColor = [UIColor colorWithRed:0.16f green:0.16f blue:0.16f alpha:1.0f];

        _borderColor = [UIColor lightGrayColor];
        _borderWidth = 1.0f;
        
        self.backgroundColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
        self.drawsGradientBackground = NO;
        self.drawsSegmentIndicatorGradientBackground = NO;
        self.opaque = NO;
        self.segments = [NSArray array];
        
        self.selectedSegmentIndicator = [[NYSegmentIndicator alloc] initWithFrame:CGRectZero];
        [self addSubview:self.selectedSegmentIndicator];
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
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:self.cornerRadius];
    CGPathRef path = [bezierPath CGPath];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(ctx);
    CGContextAddPath(ctx, path);
    if (self.drawsGradientBackground) {
        CGContextClip(ctx);
        
        CGFloat topGradientComponents[4];
        [self.gradientTopColor getRed:&topGradientComponents[0]
                                green:&topGradientComponents[1]
                                 blue:&topGradientComponents[2]
                                alpha:&topGradientComponents[3]];
        
        CGFloat bottomGradientComponents[4];
        [self.gradientBottomColor getRed:&bottomGradientComponents[0]
                                   green:&bottomGradientComponents[1]
                                    blue:&bottomGradientComponents[2]
                                   alpha:&bottomGradientComponents[3]];
        
        CGFloat gradientColors [] = {
            topGradientComponents[0], topGradientComponents[1], topGradientComponents[2], topGradientComponents[3],
            bottomGradientComponents[0], bottomGradientComponents[1], bottomGradientComponents[2], bottomGradientComponents[3]
        };
        
        CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, gradientColors, NULL, 2);
        
        CGContextDrawLinearGradient(ctx,
                                    gradient,
                                    CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect)),
                                    CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect)),
                                    0);
        
        CGGradientRelease(gradient);
        CGColorSpaceRelease(baseSpace);
    } else {
        CGContextSetFillColorWithColor(ctx, [self.backgroundColor CGColor]);
        CGContextFillPath(ctx);
    }
    
    if (self.borderWidth > 0.0f) {
        // Create an inset rectange so the stroke is not clipped around the edges
        CGRect strokeRect = CGRectInset(self.bounds, self.borderWidth / 2.0f, self.borderWidth / 2.0f);
        UIBezierPath *strokeBezierPath = [UIBezierPath bezierPathWithRoundedRect:strokeRect cornerRadius:self.cornerRadius];
        CGPathRef strokePath = [strokeBezierPath CGPath];
        CGContextAddPath(ctx, strokePath);
        CGContextSetLineWidth(ctx, self.borderWidth);
        CGContextSetStrokeColorWithColor(ctx, [self.borderColor CGColor]);
        CGContextStrokePath(ctx);
    }
    
    CGContextRestoreGState(ctx);
    //CGPathRelease(path);
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
    if (index >= [self.segments count]) {
        return;
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
    NYSegment *previousSegment = self.segments[self.selectedSegmentIndex];
    previousSegment.titleLabel.font = self.titleFont;
    previousSegment.titleLabel.textColor = self.titleTextColor;
    
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
        if (self.stylesTitleForSelectedSegment) {
            NYSegment *previousSegment = self.segments[self.selectedSegmentIndex];
            previousSegment.titleLabel.font = self.titleFont;
            previousSegment.titleLabel.textColor = self.titleTextColor;
        }
        
        return YES;
    } else {
        [self.segments enumerateObjectsUsingBlock:^(NYSegment *segment, NSUInteger index, BOOL *stop) {
            if (CGRectContainsPoint(segment.frame, [touch locationInView:self])) {
                if (index != self.selectedSegmentIndex) {
                    [self moveSelectedSegmentIndicatorToSegmentAtIndex:index animated:YES];
                    _selectedSegmentIndex = index;
                    [self sendActionsForControlEvents:UIControlEventValueChanged];
                }
            }
        }];
    }
    
    return NO;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGFloat xDiff = [touch locationInView:self.selectedSegmentIndicator].x - [touch previousLocationInView:self.selectedSegmentIndicator].x;
    
    // Reposition the indicator as long as it doesn't exit the bounds of the control
    CGRect segmentIndicatorFrame = self.selectedSegmentIndicator.frame;
    segmentIndicatorFrame.origin.x += xDiff;
    
    if (CGRectContainsRect(CGRectInset(self.bounds, self.segmentIndicatorInset, 0), segmentIndicatorFrame)) {
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
    _backgroundColor = backgroundColor;
    [self setNeedsDisplay];
}

- (UIColor *)backgroundColor {
    return _backgroundColor;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    self.selectedSegmentIndicator.cornerRadius = cornerRadius * ((self.frame.size.height - self.segmentIndicatorInset * 2) / self.frame.size.height);
    [self setNeedsDisplay];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.selectedSegmentIndicator.cornerRadius = self.cornerRadius * ((self.frame.size.height - self.segmentIndicatorInset * 2) / self.frame.size.height);
}

- (void)setDrawsSegmentIndicatorGradientBackground:(BOOL)drawsSegmentIndicatorGradientBackground {
    self.selectedSegmentIndicator.drawsGradientBackground = drawsSegmentIndicatorGradientBackground;
}

- (BOOL)drawsSegmentIndicatorGradientBackground {
    return self.selectedSegmentIndicator.drawsGradientBackground;
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
    [self moveSelectedSegmentIndicatorToSegmentAtIndex:selectedSegmentIndex animated:NO];
    _selectedSegmentIndex = selectedSegmentIndex;
}

@end

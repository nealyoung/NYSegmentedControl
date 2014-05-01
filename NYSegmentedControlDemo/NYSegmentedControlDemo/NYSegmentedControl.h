//
//  NYSegmentedControl.m
//  NYSegmentedControl
//
//  Copyright (c) 2014 Nealon Young. All rights reserved.
//
//  https://github.com/nealyoung/NYSegmentedControl
//

#import <UIKit/UIKit.h>

@interface NYSegmentedControl : UIControl

/**
 If set to YES, selectedTitleFont and SelectedTitleTextColor are used for the selected segment's title label
 */
@property (nonatomic) BOOL stylesTitleForSelectedSegment;

@property (nonatomic) UIFont *titleFont UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIColor *titleTextColor UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIFont *selectedTitleFont UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIColor *selectedTitleTextColor UI_APPEARANCE_SELECTOR;

@property (nonatomic) CGFloat cornerRadius UI_APPEARANCE_SELECTOR;

@property (nonatomic) UIColor *borderColor UI_APPEARANCE_SELECTOR;
@property (nonatomic) CGFloat borderWidth UI_APPEARANCE_SELECTOR;

/**
 If set to YES, the control's background will be drawn with a background gradient specified by the gradientTopColor and gradientBottomColor properties
 */
@property (nonatomic) BOOL drawsGradientBackground;
@property (nonatomic) UIColor *gradientTopColor UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIColor *gradientBottomColor UI_APPEARANCE_SELECTOR;

@property (nonatomic) CGFloat segmentIndicatorAnimationDuration UI_APPEARANCE_SELECTOR;
@property (nonatomic) CGFloat segmentIndicatorInset UI_APPEARANCE_SELECTOR;

/**
 If set to YES, the selected segment indicator will be drawn with a background gradient specified by the selectedSegmentIndicatorGradientTopColor and selectedSegmentIndicatorGradientBottomColor properties.  If set to NO, the indicator will be filled with the color specified by the selectedSegmentIndicatorBackgroundColor property.
 */
@property (nonatomic) BOOL drawsSegmentIndicatorGradientBackground;
@property (nonatomic) UIColor *segmentIndicatorBackgroundColor UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIColor *segmentIndicatorGradientTopColor UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIColor *segmentIndicatorGradientBottomColor UI_APPEARANCE_SELECTOR;

@property (nonatomic) UIColor *segmentIndicatorBorderColor UI_APPEARANCE_SELECTOR;
@property (nonatomic) CGFloat segmentIndicatorBorderWidth UI_APPEARANCE_SELECTOR;

@property (nonatomic, readonly) NSUInteger numberOfSegments;
@property (nonatomic) NSUInteger selectedSegmentIndex;

- (instancetype)initWithItems:(NSArray *)items;

- (void)insertSegmentWithTitle:(NSString *)title atIndex:(NSUInteger)index;
- (void)removeSegmentAtIndex:(NSUInteger)index;
- (void)removeAllSegments;

- (void)setTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)index;
- (NSString *)titleForSegmentAtIndex:(NSUInteger)index;

- (void)setSelectedSegmentIndex:(NSUInteger)selectedSegmentIndex animated:(BOOL)animated;

@end

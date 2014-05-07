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
 If YES, selectedTitleFont and SelectedTitleTextColor are used for the selected segment's title label. The default value is YES.
 */
@property (nonatomic) BOOL stylesTitleForSelectedSegment;

/**
 The font used for the segment titles
 */
@property (nonatomic) UIFont *titleFont UI_APPEARANCE_SELECTOR;

/**
 The color of the segment titles
 */
@property (nonatomic) UIColor *titleTextColor UI_APPEARANCE_SELECTOR;

/**
 The font used for the selected segment's title
 */
@property (nonatomic) UIFont *selectedTitleFont UI_APPEARANCE_SELECTOR;

/**
 The color of the selected segment's title
 */
@property (nonatomic) UIColor *selectedTitleTextColor UI_APPEARANCE_SELECTOR;

/**
 The radius of the control's corners
 */
@property (nonatomic) CGFloat cornerRadius UI_APPEARANCE_SELECTOR;

/**
 The color of the control's border
 */
@property (nonatomic) UIColor *borderColor UI_APPEARANCE_SELECTOR;

/**
 The width of the control's border
 */
@property (nonatomic) CGFloat borderWidth UI_APPEARANCE_SELECTOR;

/**
 If YES, the control's background will be drawn with a background gradient specified by the gradientTopColor and gradientBottomColor properties. The default value is YES.
 
 @see gradientTopColor
 @see gradientBottomColor
 */
@property (nonatomic) BOOL drawsGradientBackground;

/**
 The start (top) color of the control's background gradient.
 
 @see drawsGradientBackground
 */
@property (nonatomic) UIColor *gradientTopColor UI_APPEARANCE_SELECTOR;

/**
 The end (bottom) color of the control's background gradient.
 
 @see drawsGradientBackground
 */
@property (nonatomic) UIColor *gradientBottomColor UI_APPEARANCE_SELECTOR;

/**
 The duration of the segment change animation.
 */
@property (nonatomic) CGFloat segmentIndicatorAnimationDuration UI_APPEARANCE_SELECTOR;

/**
 The amount the selected segment indicator should be inset from the outer edge of the control.
 */
@property (nonatomic) CGFloat segmentIndicatorInset UI_APPEARANCE_SELECTOR;

/**
 If YES, the selected segment indicator will be drawn with a background gradient specified by the selectedSegmentIndicatorGradientTopColor and selectedSegmentIndicatorGradientBottomColor properties.  If set to NO, the indicator will be filled with the color specified by the selectedSegmentIndicatorBackgroundColor property. The default value is YES.
 
 @see segmentIndicatorGradientTopColor
 @see segmentIndicatorGradientBottomColor
 */
@property (nonatomic) BOOL drawsSegmentIndicatorGradientBackground;

/**
 The color of the selected segment indicator.
 */
@property (nonatomic) UIColor *segmentIndicatorBackgroundColor UI_APPEARANCE_SELECTOR;

/**
 The start color of the gradient filling the selected segment indicator.
 
 @see drawsSegmentIndicatorGradientBackground
 */
@property (nonatomic) UIColor *segmentIndicatorGradientTopColor UI_APPEARANCE_SELECTOR;

/**
 The end color of the gradient filling the selected segment indicator.
 
 @see drawsSegmentIndicatorGradientBackground
 */
@property (nonatomic) UIColor *segmentIndicatorGradientBottomColor UI_APPEARANCE_SELECTOR;

/**
 The color of the selected segment indicator's border
 */
@property (nonatomic) UIColor *segmentIndicatorBorderColor UI_APPEARANCE_SELECTOR;

/**
 The width of the selected segment indicator's border
 */
@property (nonatomic) CGFloat segmentIndicatorBorderWidth UI_APPEARANCE_SELECTOR;

/**
 The number of segments in the control (read-only)
 */
@property (nonatomic, readonly) NSUInteger numberOfSegments;

/**
 The index of the currently selected segment
 */
@property (nonatomic) NSUInteger selectedSegmentIndex;

/**
 Initializes and returns a control with segments having the specified titles.
 
 @param items An array of NSString objects representing the titles of segments in the control.
 
 @return An initialized NYSegmentedControl object, or nil if it could not be created.
 */
- (instancetype)initWithItems:(NSArray *)items;

/**
 Inserts a segment at the specified index.
 
 @param title A string to use as the segment's title.
 @param index The index of the segment. It must be a number between 0 and the number of segments (numberOfSegments); values exceeding this upper range are pinned to it.
 */
- (void)insertSegmentWithTitle:(NSString *)title atIndex:(NSUInteger)index;

/**
 Removes the segment at the specified index.
 
 @param index The index of the segment. It must be a number between 0 and the number of segments (numberOfSegments) minus 1; values exceeding this upper range are pinned to it.
 */
- (void)removeSegmentAtIndex:(NSUInteger)index;

/**
 Removes all segments from the control.
 */
- (void)removeAllSegments;

/**
 Sets the title for a segment in the control
 
 @param title A string to display in the segment as its title.
 @param index The index of the segment. It must be a number between 0 and the number of segments (numberOfSegments) minus 1; values exceeding this upper range are pinned to it.
 */
- (void)setTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)index;

/**
 Gets the title of a segment in the control.
 
 @param index The index of the segment. It must be a number between 0 and the number of segments (numberOfSegments) minus 1; values exceeding this upper range are pinned to it.
 
 @return The title of the specified segment.
 */
- (NSString *)titleForSegmentAtIndex:(NSUInteger)index;

/**
 Sets the selected segment index.
 
 @param selectedSegmentIndex The index of the segment to select. It must be a number between 0 and the number of segments (numberOfSegments) minus 1; values exceeding this upper range are pinned to it.
 @param animated Specify YES if the selected segment indicator should animate its position change.
 */
- (void)setSelectedSegmentIndex:(NSUInteger)selectedSegmentIndex animated:(BOOL)animated;

@end

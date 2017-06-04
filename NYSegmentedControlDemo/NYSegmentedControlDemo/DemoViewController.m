//
//  DemoViewController.m
//  NYSegmentedControlDemo
//
//  Created by Nealon Young on 3/22/14.
//  Copyright (c) 2014 Neal Young. All rights reserved.
//

#import "DemoViewController.h"
#import "NYSegmentedControl.h"

@interface DemoViewController ()

@property (nonatomic, strong) UIStackView *stackView;

@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.stackView = [[UIStackView alloc] init];
    self.stackView.axis = UILayoutConstraintAxisVertical;
    self.stackView.distribution = UIStackViewDistributionFillEqually;
    [self.view addSubview:self.stackView];
    self.stackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.stackView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.stackView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [self.stackView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.stackView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;

    [self addSegmentedControlExample:[self graySegmentedControl] withBackgroundColor:[UIColor colorWithWhite:0.96f alpha:1.0f]];
    [self addSegmentedControlExample:[self blueSegmentedControl] withBackgroundColor:[UIColor colorWithRed:0.36f green:0.64f blue:0.88f alpha:1.0f]];
    [self addSegmentedControlExample:[self flatGraySegmentedControl] withBackgroundColor:[UIColor colorWithRed:0.12f green:0.12f blue:0.15f alpha:1.0f]];
    [self addSegmentedControlExample:[self purpleSegmentedControl] withBackgroundColor:[UIColor colorWithWhite:0.24f alpha:1.0f]];
    [self addSegmentedControlExample:[self switchSegmentedControl] withBackgroundColor:[UIColor colorWithWhite:0.18f alpha:1.0f]];
}

- (void)addSegmentedControlExample:(NYSegmentedControl *)segmentedControl withBackgroundColor:(UIColor *)backgroundColor {
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth([UIScreen mainScreen].bounds), 44.0f)];
    backgroundView.backgroundColor = backgroundColor;
    [self.stackView addArrangedSubview:backgroundView];

    [backgroundView addSubview:segmentedControl];
    segmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
    [segmentedControl.centerXAnchor constraintEqualToAnchor:backgroundView.centerXAnchor].active = YES;
    [segmentedControl.centerYAnchor constraintEqualToAnchor:backgroundView.centerYAnchor].active = YES;
}

- (NYSegmentedControl *)graySegmentedControl {
    NYSegmentedControl *graySegmentedControl = [[NYSegmentedControl alloc] initWithItems:@[@"Popular", @"Following", @"News"]];
    graySegmentedControl.backgroundColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    graySegmentedControl.segmentIndicatorBackgroundColor = [UIColor whiteColor];
    graySegmentedControl.segmentIndicatorInset = 0.0f;
    graySegmentedControl.titleTextColor = [UIColor lightGrayColor];
    graySegmentedControl.selectedTitleTextColor = [UIColor darkGrayColor];

    return graySegmentedControl;
}

- (NYSegmentedControl *)blueSegmentedControl {
    NYSegmentedControl *blueSegmentedControl = [[NYSegmentedControl alloc] initWithItems:@[@"Nearby", @"Worldwide"]];
    blueSegmentedControl.titleTextColor = [UIColor colorWithRed:0.38f green:0.68f blue:0.93f alpha:1.0f];
    blueSegmentedControl.selectedTitleTextColor = [UIColor whiteColor];
    blueSegmentedControl.segmentIndicatorBackgroundColor = [UIColor colorWithRed:0.38f green:0.68f blue:0.93f alpha:1.0f];
    blueSegmentedControl.backgroundColor = [UIColor colorWithRed:0.31f green:0.53f blue:0.72f alpha:1.0f];
    blueSegmentedControl.borderWidth = 0.0f;
    blueSegmentedControl.segmentIndicatorBorderWidth = 0.0f;
    blueSegmentedControl.segmentIndicatorInset = 2.0f;
    blueSegmentedControl.segmentIndicatorBorderColor = self.view.backgroundColor;
    blueSegmentedControl.cornerRadius = blueSegmentedControl.intrinsicContentSize.height / 2.0f;
    blueSegmentedControl.usesSpringAnimations = YES;

    return blueSegmentedControl;
}

- (NYSegmentedControl *)flatGraySegmentedControl {
    NYSegmentedControl *flatGraySegmentedControl = [[NYSegmentedControl alloc] initWithItems:@[@"ENGLISH", @"中文文学"]];
    flatGraySegmentedControl.backgroundColor = [UIColor colorWithRed:0.09f green:0.09f blue:0.12f alpha:1.0f];
    flatGraySegmentedControl.selectedTitleFont = [UIFont systemFontOfSize:12.0f weight:UIFontWeightSemibold];
    flatGraySegmentedControl.titleFont = [UIFont systemFontOfSize:12.0f weight:UIFontWeightSemibold];
    flatGraySegmentedControl.borderColor = [UIColor colorWithRed:0.18f green:0.18f blue:0.22f alpha:1.0f];
    flatGraySegmentedControl.borderWidth = 2.0f;
    flatGraySegmentedControl.segmentIndicatorBorderColor = [UIColor clearColor];
    flatGraySegmentedControl.segmentIndicatorBackgroundColor = [UIColor colorWithRed:0.18f green:0.18f blue:0.22f alpha:1.0f];
    flatGraySegmentedControl.segmentIndicatorInset = 5.0f;
    flatGraySegmentedControl.titleTextColor = [UIColor colorWithRed:0.30f green:0.31f blue:0.36f alpha:1.0f];
    flatGraySegmentedControl.selectedTitleTextColor = [UIColor whiteColor];
    flatGraySegmentedControl.cornerRadius = 22.0f;
    [flatGraySegmentedControl.widthAnchor constraintEqualToConstant:240.0f].active = YES;
    [flatGraySegmentedControl.heightAnchor constraintEqualToConstant:44.0f].active = YES;

    return flatGraySegmentedControl;
}

- (NYSegmentedControl *)purpleSegmentedControl {
    NYSegmentedControl *purpleSegmentedControl = [[NYSegmentedControl alloc] initWithItems:@[@"Lists", @"Followers"]];
    purpleSegmentedControl.borderWidth = 2.0f;
    purpleSegmentedControl.borderColor = [UIColor colorWithWhite:0.15f alpha:1.0f];
    purpleSegmentedControl.titleFont = [UIFont fontWithName:@"AvenirNext-Medium" size:14.0f];
    purpleSegmentedControl.titleTextColor = [UIColor colorWithWhite:0.34f alpha:1.0f];
    purpleSegmentedControl.selectedTitleFont = [UIFont fontWithName:@"AvenirNext-DemiBold" size:14.0f];
    purpleSegmentedControl.selectedTitleTextColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    purpleSegmentedControl.borderWidth = 0.0f;
    purpleSegmentedControl.drawsGradientBackground = YES;
    purpleSegmentedControl.gradientTopColor = [UIColor colorWithWhite:0.17f alpha:1.0f];
    purpleSegmentedControl.gradientBottomColor = [UIColor colorWithWhite:0.05f alpha:1.0f];
    purpleSegmentedControl.segmentIndicatorInset = 4.0f;
    purpleSegmentedControl.segmentIndicatorBackgroundColor = [UIColor clearColor];
    purpleSegmentedControl.segmentIndicatorBorderWidth = 0.0f;
    purpleSegmentedControl.drawsSegmentIndicatorGradientBackground = YES;
    purpleSegmentedControl.segmentIndicatorGradientTopColor = [UIColor colorWithRed:0.65f green:0.25f blue:0.95f alpha:1.0f];
    purpleSegmentedControl.segmentIndicatorGradientBottomColor = [UIColor colorWithRed:0.4f green:0.15f blue:0.8f alpha:1.0f];
    [purpleSegmentedControl.widthAnchor constraintEqualToConstant:200.0f].active = YES;
    [purpleSegmentedControl.heightAnchor constraintEqualToConstant:40.0f].active = YES;

    return purpleSegmentedControl;
}

- (NYSegmentedControl *)switchSegmentedControl {
    NYSegmentedControl *switchSegmentedControl = [[NYSegmentedControl alloc] initWithItems:@[@"On", @"Off"]];
    switchSegmentedControl.borderWidth = 2.0f;
    switchSegmentedControl.borderColor = [UIColor colorWithWhite:0.15f alpha:1.0f];
    switchSegmentedControl.titleFont = [UIFont fontWithName:@"AvenirNext-Medium" size:16.0f];
    switchSegmentedControl.titleTextColor = [UIColor colorWithWhite:0.3f alpha:1.0f];
    switchSegmentedControl.selectedTitleFont = [UIFont fontWithName:@"AvenirNext-DemiBold" size:18.0f];
    switchSegmentedControl.selectedTitleTextColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
    switchSegmentedControl.drawsGradientBackground = YES;
    switchSegmentedControl.gradientTopColor = [UIColor colorWithWhite:0.17f alpha:1.0f];
    switchSegmentedControl.gradientBottomColor = [UIColor colorWithWhite:0.05f alpha:1.0f];
    switchSegmentedControl.segmentIndicatorAnimationDuration = 0.2f;
    switchSegmentedControl.segmentIndicatorInset = 6.0f;
    switchSegmentedControl.drawsSegmentIndicatorGradientBackground = YES;
    switchSegmentedControl.segmentIndicatorGradientTopColor = [UIColor colorWithRed:0.75f green:0.9f blue:0.4f alpha:1.0f];
    switchSegmentedControl.segmentIndicatorGradientBottomColor = [UIColor colorWithRed:0.47f green:0.72f blue:0.29f alpha:1.0f];
    switchSegmentedControl.segmentIndicatorBorderWidth = 0.0f;
    switchSegmentedControl.cornerRadius = 35.0f;
    switchSegmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
    [switchSegmentedControl.widthAnchor constraintEqualToConstant:140.0f].active = YES;
    [switchSegmentedControl.heightAnchor constraintEqualToConstant:70.0f].active = YES;

    return switchSegmentedControl;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end

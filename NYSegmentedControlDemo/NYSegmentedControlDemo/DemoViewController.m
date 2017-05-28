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

@property NYSegmentedControl *segmentedControl;
@property UIView *visibleExampleView;
@property NSArray *exampleViews;

@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
    //self.navigationController.navigationBar.barTintColor = [UIColor colorWithWhite:0.26f alpha:1.0f];
    //self.navigationController.navigationBar.translucent = NO;
    //self.extendedLayoutIncludesOpaqueBars = YES;

    // Control in navigation bar
    self.segmentedControl = [[NYSegmentedControl alloc] initWithItems:@[@"Light", @"Dark"]];
    [self.segmentedControl addTarget:self action:@selector(segmentSelected) forControlEvents:UIControlEventValueChanged];
    self.segmentedControl.titleFont = [UIFont fontWithName:@"AvenirNext-Medium" size:14.0f];
    self.segmentedControl.titleTextColor = [UIColor colorWithWhite:0.5f alpha:1.0f];
    self.segmentedControl.selectedTitleFont = [UIFont fontWithName:@"AvenirNext-DemiBold" size:14.0f];
    self.segmentedControl.selectedTitleTextColor = [UIColor whiteColor];
    self.segmentedControl.borderWidth = 1.0f;
    self.segmentedControl.borderColor = [UIColor colorWithWhite:0.15f alpha:1.0f];
    self.segmentedControl.drawsGradientBackground = YES;
    self.segmentedControl.segmentIndicatorInset = 2.0f;
    self.segmentedControl.segmentIndicatorGradientTopColor = [UIColor colorWithRed:0.30 green:0.50 blue:0.88f alpha:1.0f];
    self.segmentedControl.segmentIndicatorGradientBottomColor = [UIColor colorWithRed:0.20 green:0.35 blue:0.75f alpha:1.0f];
    self.segmentedControl.drawsSegmentIndicatorGradientBackground = YES;
    self.segmentedControl.segmentIndicatorBorderWidth = 0.0f;
    self.segmentedControl.selectedSegmentIndex = 0;
    [self.segmentedControl sizeToFit];
    self.navigationItem.titleView = self.segmentedControl;
    
    UIView *lightControlExampleView = [[UIView alloc] initWithFrame:self.view.bounds];
    lightControlExampleView.backgroundColor = [UIColor colorWithWhite:0.96f alpha:1.0f];
    self.visibleExampleView = lightControlExampleView;
    [self.view addSubview:lightControlExampleView];

    NYSegmentedControl *instagramSegmentedControl = [[NYSegmentedControl alloc] initWithItems:@[@"Following", @"News"]];
    instagramSegmentedControl.backgroundColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    instagramSegmentedControl.segmentIndicatorBackgroundColor = [UIColor whiteColor];
    instagramSegmentedControl.segmentIndicatorInset = 0.0f;
    instagramSegmentedControl.titleTextColor = [UIColor lightGrayColor];
    instagramSegmentedControl.selectedTitleTextColor = [UIColor darkGrayColor];
    [instagramSegmentedControl sizeToFit];
    instagramSegmentedControl.center = CGPointMake(lightControlExampleView.center.x, lightControlExampleView.center.y - 30.0f);
    [lightControlExampleView addSubview:instagramSegmentedControl];
    
    UIView *foursquareSegmentedControlBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.0f,
                                                                                                0.0f,
                                                                                                CGRectGetWidth([UIScreen mainScreen].bounds),
                                                                                                44.0f)];
    foursquareSegmentedControlBackgroundView.backgroundColor = [UIColor colorWithRed:0.36f green:0.64f blue:0.88f alpha:1.0f];
    [lightControlExampleView addSubview:foursquareSegmentedControlBackgroundView];
    
    NYSegmentedControl *foursquareSegmentedControl = [[NYSegmentedControl alloc] initWithItems:@[@"Nearby", @"Worldwide"]];
    foursquareSegmentedControl.titleTextColor = [UIColor colorWithRed:0.38f green:0.68f blue:0.93f alpha:1.0f];
    foursquareSegmentedControl.selectedTitleTextColor = [UIColor whiteColor];
    foursquareSegmentedControl.selectedTitleFont = [UIFont systemFontOfSize:13.0f];
    foursquareSegmentedControl.segmentIndicatorBackgroundColor = [UIColor colorWithRed:0.38f green:0.68f blue:0.93f alpha:1.0f];
    foursquareSegmentedControl.backgroundColor = [UIColor colorWithRed:0.31f green:0.53f blue:0.72f alpha:1.0f];
    foursquareSegmentedControl.borderWidth = 0.0f;
    foursquareSegmentedControl.segmentIndicatorBorderWidth = 0.0f;
    foursquareSegmentedControl.segmentIndicatorInset = 2.0f;
    foursquareSegmentedControl.segmentIndicatorBorderColor = self.view.backgroundColor;
    [foursquareSegmentedControl sizeToFit];
    foursquareSegmentedControl.cornerRadius = CGRectGetHeight(foursquareSegmentedControl.frame) / 2.0f;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
    foursquareSegmentedControl.usesSpringAnimations = YES;
#endif
    foursquareSegmentedControl.center = CGPointMake(lightControlExampleView.center.x, lightControlExampleView.center.y + 30.0f);
    foursquareSegmentedControlBackgroundView.center = foursquareSegmentedControl.center;
    foursquareSegmentedControl.selectedSegmentIndex = UISegmentedControlNoSegment;
    [lightControlExampleView addSubview:foursquareSegmentedControl];
    
    UIView *darkControlExampleView = [[UIView alloc] initWithFrame:self.view.bounds];
    darkControlExampleView.backgroundColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
    darkControlExampleView.hidden = YES;
    [self.view addSubview:darkControlExampleView];
    
    NYSegmentedControl *purpleSegmentedControl = [[NYSegmentedControl alloc] initWithItems:@[@"Lists", @"Followers"]];
    purpleSegmentedControl.borderWidth = 2.0f;
    purpleSegmentedControl.borderColor = [UIColor colorWithWhite:0.15f alpha:1.0f];
    purpleSegmentedControl.titleFont = [UIFont fontWithName:@"AvenirNext-Medium" size:14.0f];
    purpleSegmentedControl.titleTextColor = [UIColor colorWithWhite:0.3f alpha:1.0f];
    purpleSegmentedControl.selectedTitleFont = [UIFont fontWithName:@"AvenirNext-DemiBold" size:14.0f];
    purpleSegmentedControl.selectedTitleTextColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    purpleSegmentedControl.borderWidth = 0.0f;
    purpleSegmentedControl.drawsGradientBackground = YES;
    purpleSegmentedControl.gradientTopColor = [UIColor colorWithWhite:0.17f alpha:1.0f];
    purpleSegmentedControl.gradientBottomColor = [UIColor colorWithWhite:0.05f alpha:1.0f];
    purpleSegmentedControl.segmentIndicatorInset = 2.0f;
    purpleSegmentedControl.segmentIndicatorBackgroundColor = [UIColor clearColor];
    purpleSegmentedControl.segmentIndicatorBorderWidth = 0.0f;
    purpleSegmentedControl.drawsSegmentIndicatorGradientBackground = YES;
    purpleSegmentedControl.segmentIndicatorGradientTopColor = [UIColor colorWithRed:0.65f green:0.25f blue:0.95f alpha:1.0f];
    purpleSegmentedControl.segmentIndicatorGradientBottomColor = [UIColor colorWithRed:0.4f green:0.15f blue:0.8f alpha:1.0f];
    purpleSegmentedControl.frame = CGRectMake(0.0f, 0.0f, 200.0f, 40.0f);
    purpleSegmentedControl.center = CGPointMake(darkControlExampleView.center.x, darkControlExampleView.center.y - 50.0f);
    [darkControlExampleView addSubview:purpleSegmentedControl];
    
    // UISwitch style
    NYSegmentedControl *roundedGreenSegmentedControl = [[NYSegmentedControl alloc] initWithItems:@[@"On", @"Off"]];
    roundedGreenSegmentedControl.borderWidth = 2.0f;
    roundedGreenSegmentedControl.borderColor = [UIColor colorWithWhite:0.15f alpha:1.0f];
    roundedGreenSegmentedControl.titleFont = [UIFont fontWithName:@"AvenirNext-Medium" size:16.0f];
    roundedGreenSegmentedControl.titleTextColor = [UIColor colorWithWhite:0.3f alpha:1.0f];
    roundedGreenSegmentedControl.selectedTitleFont = [UIFont fontWithName:@"AvenirNext-DemiBold" size:16.0f];
    roundedGreenSegmentedControl.selectedTitleTextColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
    roundedGreenSegmentedControl.drawsGradientBackground = YES;
    roundedGreenSegmentedControl.gradientTopColor = [UIColor colorWithWhite:0.17f alpha:1.0f];
    roundedGreenSegmentedControl.gradientBottomColor = [UIColor colorWithWhite:0.05f alpha:1.0f];
    roundedGreenSegmentedControl.segmentIndicatorAnimationDuration = 0.2f;
    roundedGreenSegmentedControl.segmentIndicatorInset = 6.0f;
    roundedGreenSegmentedControl.drawsSegmentIndicatorGradientBackground = YES;
    roundedGreenSegmentedControl.segmentIndicatorGradientTopColor = [UIColor colorWithRed:0.75f green:0.9f blue:0.4f alpha:1.0f];
    roundedGreenSegmentedControl.segmentIndicatorGradientBottomColor = [UIColor colorWithRed:0.47f green:0.72f blue:0.29f alpha:1.0f];
    roundedGreenSegmentedControl.segmentIndicatorBorderWidth = 0.0f;
    roundedGreenSegmentedControl.frame = CGRectMake(0, 0, 140.0f, 70.0f);
    roundedGreenSegmentedControl.cornerRadius = CGRectGetHeight(roundedGreenSegmentedControl.frame) / 2.0f;
    roundedGreenSegmentedControl.center = CGPointMake(darkControlExampleView.center.x, darkControlExampleView.center.y + 50.0f);
    [darkControlExampleView addSubview:roundedGreenSegmentedControl];
    
    self.exampleViews = @[lightControlExampleView, darkControlExampleView];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)segmentSelected {
    UIView *exampleViewToShow = self.exampleViews[self.segmentedControl.selectedSegmentIndex];
    if (self.visibleExampleView == exampleViewToShow) {
        return;
    }
    
    self.visibleExampleView.hidden = YES;
    exampleViewToShow.hidden = NO;
    self.visibleExampleView = exampleViewToShow;
}

@end

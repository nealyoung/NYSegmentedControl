//
//  AppDelegate.m
//  NYSegmentedControlDemo
//
//  Created by Nealon Young on 3/22/14.
//  Copyright (c) 2014 Neal Young. All rights reserved.
//

#import "AppDelegate.h"
#import "DemoViewController.h"
#import "NYSegmentedControl.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    DemoViewController *viewController = [[DemoViewController alloc] initWithNibName:nil bundle:nil];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end

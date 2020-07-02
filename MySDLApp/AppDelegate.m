//
//  AppDelegate.m
//  MySDLApp
//
//  Created by Don Mag on 7/2/20.
//  Copyright © 2020 DonMag. All rights reserved.
//

#import "AppDelegate.h"

#import "MainMenuViewController.h"

@implementation SDLUIKitDelegate (customDelegate)

// hijack the the SDL_UIKitAppDelegate to use the UIApplicationDelegate we implement here
+ (NSString *)getAppDelegateClassName {
	return @"AppDelegate";
}

@end

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize mainViewController, uiwindow;

#pragma mark -
#pragma mark AppDelegate methods
- (id)init {
	if ((self = [super init])) {
		mainViewController = nil;
		uiwindow = nil;
	}
	return self;
}

// override the direct execution of SDL_main to allow us to implement our own frontend
- (void)postFinishLaunch
{
	
	[self performSelector:@selector(hideLaunchScreen) withObject:nil afterDelay:0.0];
	
	self.uiwindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.uiwindow.backgroundColor = [UIColor blackColor];
	
	self.mainViewController = [MainMenuViewController new];
	
#if 0
	
	self.uiwindow.rootViewController = mainViewController;
	
#else
	
	UINavigationController *navVC = [UINavigationController new];
	
	[navVC setViewControllers:@[self.mainViewController]];
	
	self.uiwindow.rootViewController = navVC;
	
#endif
	
	[self.uiwindow makeKeyAndVisible];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	NSLog(@"Memory Warning!!!");
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end

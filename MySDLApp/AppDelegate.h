//
//  AppDelegate.h
//  MySDLApp
//
//  Created by Don Mag on 7/2/20.
//  Copyright © 2020 DonMag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "include/SDL.h"
#import "include/SDL_syswm.h"
#import "src/video/uikit/SDL_uikitappdelegate.h"

@class MainMenuViewController;

@interface AppDelegate : SDLUIKitDelegate {
	
	MainMenuViewController *mainViewController;     // required to dismiss the SettingsBaseViewController
	UIWindow *uiwindow;
	
}

@property (nonatomic, strong) MainMenuViewController *mainViewController;
@property (strong, nonatomic) UIWindow *uiwindow;

@end


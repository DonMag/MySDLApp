//
//  SDLInterfaceBridge.h
//  MySDLApp
//
//  Created by Don Mag on 6/30/20.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "RunViewDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLInterfaceBridge : NSObject
{
	UIView *blackView;
}

@property (nonatomic, weak) id <RunViewDelegate> rvDelegate;

@property (nonatomic, strong) UIView *blackView;

+ (void)startWith:(NSInteger)n andDelegate:(id<RunViewDelegate>)d;

+ (void)registerCallingController:(UIViewController *)controller;

@end

NS_ASSUME_NONNULL_END

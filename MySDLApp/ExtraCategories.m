//
//  ExtraCategories.m
//  MySDLApp
//
//  Created by Don Mag on 7/1/20.
//  Copyright © 2020 DonMag. All rights reserved.
//

#import "ExtraCategories.h"

#pragma mark -
@implementation UIScreen (safe)

- (CGFloat)safeScale {
	CGFloat theScale = 1.0f;
	if ([self respondsToSelector:@selector(scale)])
		theScale = [self scale];
	return theScale;
}

- (CGRect)safeBounds {
	return [self bounds];
	//    CGRect original = [self bounds];
	//    if (IS_ON_PORTRAIT())
	//        return original;
	//    else
	//        return CGRectMake(original.origin.x, original.origin.y, original.size.height, original.size.width);
}

@end


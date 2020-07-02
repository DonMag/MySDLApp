//
//  ExtraCategories.h
//  MySDLApp
//
//  Created by Don Mag on 7/1/20.
//  Copyright © 2020 DonMag. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef ExtraCategories_h
#define ExtraCategories_h

@interface UIScreen (safe)

- (CGFloat)safeScale;
- (CGRect)safeBounds;

@end


#endif /* ExtraCategories_h */

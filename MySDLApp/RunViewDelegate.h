//
//  RunViewDelegate.h
//  MySDLApp
//
//  Created by Don Mag on 7/2/20.
//  Copyright © 2020 DonMag. All rights reserved.
//

#ifndef RunViewDelegate_h
#define RunViewDelegate_h

@protocol RunViewDelegate <NSObject>

- (void) finsihedSDL;

@optional
- (void)testAlert:(UIViewController *)vc;

@end

#endif /* RunViewDelegate_h */

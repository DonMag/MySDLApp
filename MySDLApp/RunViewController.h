//
//  RunViewController.h
//  MySDLApp
//
//  Created by Don Mag on 7/2/20.
//  Copyright © 2020 DonMag. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RunViewController : UIViewController

@property (assign, readwrite) NSInteger iMode;

-(id)initWithMode:(NSInteger)n;

@end

NS_ASSUME_NONNULL_END

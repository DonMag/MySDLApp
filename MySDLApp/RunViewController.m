//
//  RunViewController.m
//  MySDLApp
//
//  Created by Don Mag on 7/2/20.
//  Copyright © 2020 DonMag. All rights reserved.
//

#import "RunViewController.h"
#import "RunViewDelegate.h"

#import "SDLInterfaceBridge.h"

@interface RunViewController () <RunViewDelegate>
{
}

@property (assign, readwrite) BOOL bDidRun;

@end

@implementation RunViewController

-(id)initWithMode:(NSInteger)n {
	if (self = [super init]) {
		_iMode = n;
		_bDidRun = NO;
	}
	return self;
}

- (BOOL)prefersStatusBarHidden {
	return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor blackColor];
	
	[self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	if (!_bDidRun) {
		_bDidRun = YES;
		dispatch_async(dispatch_get_main_queue(), ^{
			[SDLInterfaceBridge registerCallingController:self];
			[SDLInterfaceBridge startWith:self->_iMode andDelegate:self];
		});
	}
	
}

- (void)testAlert:(UIViewController *)vc {
	
	__block UIViewController *_vc = vc;
	
	dispatch_block_t mainBlock = ^{
		UIAlertController *alertController = [UIAlertController
											  alertControllerWithTitle:@"Testing"
											  message:@"This is a test of the alert controller being displayed."
											  preferredStyle:UIAlertControllerStyleAlert];
		
		[alertController addAction:[UIAlertAction
									actionWithTitle:@"OK"
									style:UIAlertActionStyleDefault
									handler:^(UIAlertAction *action)
									{
			NSLog(@"Alert OK tapped.");
		}]
		 ];
		
		NSLog(@"Presenting Test Alert...");
		[_vc presentViewController:alertController animated:YES completion:nil];
	};
	
	dispatch_async(dispatch_get_main_queue(), mainBlock);
	

}
- (void)finsihedSDL {
	dispatch_async(dispatch_get_main_queue(), ^{
		[self.navigationController popViewControllerAnimated:YES];
	});
}

@end

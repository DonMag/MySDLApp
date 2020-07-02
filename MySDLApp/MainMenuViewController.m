//
//  MainMenuViewController.m
//  MySDLApp
//
//  Created by Don Mag on 6/10/20.
//

#import "MainMenuViewController.h"
#import "RunViewController.h"

@interface MainMenuViewController ()
{
}
@end

@implementation MainMenuViewController

- (BOOL)prefersStatusBarHidden {
	return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];

	self.view.backgroundColor = [UIColor colorWithRed:1.0 green:0.75 blue:0.5 alpha:1.0];
	
	UILabel *v = [UILabel new];
	v.backgroundColor = [UIColor greenColor];
	v.text = @"Main Menu";
	v.textAlignment = NSTextAlignmentCenter;
	v.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:v];
	
	UIButton *rectsButton = [UIButton new];
	[rectsButton setTitle:@"Show Rectangles" forState:UIControlStateNormal];
	[rectsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	rectsButton.backgroundColor = [UIColor blueColor];
	rectsButton.translatesAutoresizingMaskIntoConstraints = NO;
	rectsButton.tag = 0;
	[self.view addSubview:rectsButton];
	
	UIButton *linesButton = [UIButton new];
	[linesButton setTitle:@"Draw Lines" forState:UIControlStateNormal];
	[linesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	linesButton.backgroundColor = [UIColor blueColor];
	linesButton.translatesAutoresizingMaskIntoConstraints = NO;
	linesButton.tag = 1;
	[self.view addSubview:linesButton];
	
	// respect safe area
	UILayoutGuide *g = self.view.layoutMarginsGuide;
	
	[NSLayoutConstraint activateConstraints:@[
		
		[v.leadingAnchor constraintEqualToAnchor:g.leadingAnchor constant:8.0],
		[v.trailingAnchor constraintEqualToAnchor:g.trailingAnchor constant:-8.0],
		[v.topAnchor constraintEqualToAnchor:g.topAnchor constant:80.0],
		
		[rectsButton.leadingAnchor constraintEqualToAnchor:g.leadingAnchor constant:48.0],
		[rectsButton.trailingAnchor constraintEqualToAnchor:g.trailingAnchor constant:-48.0],
		[rectsButton.topAnchor constraintEqualToAnchor:v.bottomAnchor constant:30.0],
		
		[linesButton.leadingAnchor constraintEqualToAnchor:g.leadingAnchor constant:48.0],
		[linesButton.trailingAnchor constraintEqualToAnchor:g.trailingAnchor constant:-48.0],
		[linesButton.topAnchor constraintEqualToAnchor:rectsButton.bottomAnchor constant:30.0],
		
	]];

	[rectsButton addTarget:self action:@selector(didTap:) forControlEvents:UIControlEventTouchUpInside];
	
	[linesButton addTarget:self action:@selector(didTap:) forControlEvents:UIControlEventTouchUpInside];
	
}

- (void)didTap:(id) sender {
	NSLog(@"Tapped");

	UIButton *b = (UIButton *)sender;
	
	RunViewController *vc = [[RunViewController alloc] initWithMode:b.tag];
	
	[self.navigationController pushViewController:vc animated:YES];
	
	return;

}

@end

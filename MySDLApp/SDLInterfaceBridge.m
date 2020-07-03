//
//  SDLInterfaceBridge.m
//  MySDLApp
//
//  Created by Don Mag on 6/30/20.
//

#import "SDLInterfaceBridge.h"

static UIViewController *callingController;

#define BRUSH_SIZE 32           /* width and height of the brush */
#define PIXELS_PER_ITERATION 5  /* number of pixels between brush blots when forming a line */

#define BUTTON_WIDTH 120
#define BUTTON_HEIGHT 50

@interface SDLInterfaceBridge ()
{
	SDL_Window *window;
	SDL_Renderer *renderer;
	int done;
	int x, y, dx, dy;           /* mouse location          */
	Uint8 state;                /* mouse (touch) state */
	SDL_Event event;
	int windowW;
	int windowH;

	SDL_Rect topRect;
	SDL_Rect drawingRect;
	SDL_Rect doneRect;
	SDL_Rect alertRect;

	SDL_Texture *brush;       /* texture for the brush */
	
	SDL_Texture *doneButton;	/* texture for the Done button */
	SDL_Texture *alertButton;	/* texture for the Alert button */

	CGFloat width, height;
	CGFloat screenScale;

}
@end

@implementation SDLInterfaceBridge
@synthesize blackView;

- (UIViewController *)findSDLViewController:(SDL_Window *)sdlWindow
{
	SDL_SysWMinfo systemWindowInfo;
	SDL_VERSION(&systemWindowInfo.version);
	if ( ! SDL_GetWindowWMInfo(sdlWindow, &systemWindowInfo)) {
		// consider doing some kind of error handling here
		return nil;
	}
	UIWindow * appWindow = systemWindowInfo.info.uikit.window;
	UIViewController * rootViewController = appWindow.rootViewController;
	return rootViewController;
}

#pragma mark -
#pragma mark Class methods for setting up the engine from outsite
+ (void)registerCallingController:(UIViewController *)controller {
	callingController = controller;
}
- (void)setRunViewDelegate:(id<RunViewDelegate>)d {
	self.rvDelegate = d;
}
+ (void)startWith:(NSInteger)n andDelegate:(id<RunViewDelegate>)d {
	
	id bridge = [[self alloc] init];
	
	[bridge setRunViewDelegate:d];
	
	[bridge sdlLaunch];

	switch (n) {
		case 0:
			[bridge showRects];
			break;
			
		case 1:
			[bridge drawLines];
			break;
			
		default:
			break;
	}
	
	[bridge engineStop];

}

- (void)sdlLaunch {
	screenScale = [[UIScreen mainScreen] safeScale];
	
	CGRect screenBounds = [[UIScreen mainScreen] safeBounds];
	width = screenBounds.size.width;
	height = screenBounds.size.height;
	
	if (SDL_Init(SDL_INIT_VIDEO) < 0) {
		[NSException raise:@"SDL_Error" format:@"Could not init SDL"];
	}
	
	window = SDL_CreateWindow(NULL, 0, 0, (width * screenScale), (height * screenScale), SDL_WINDOW_ALLOW_HIGHDPI);
	if (window == 0) {
		[NSException raise:@"SDL_Error" format:@"Could not create window"];
	}
	
	renderer = SDL_CreateRenderer(window, -1, 0);
	if (!renderer) {
		[NSException raise:@"SDL_Error" format:@"Could not create renderer"];
	}
	
	SDL_GetWindowSize(window, &windowW, &windowH);
	SDL_RenderSetLogicalSize(renderer, windowW, windowH);
	
	/* Fill screen with medium blue */
	SDL_SetRenderDrawColor(renderer, 0, 150, 255, 255);
	SDL_RenderClear(renderer);

	// draw white rect at top
//	SDL_Rect r = { 0, 0, windowW, 80 };
//	topRect = r;
//	SDL_Rect d = { 20, r.h + 20, windowW - 40, windowH - (r.h + 40) };
//	drawingRect = d;
//	SDL_Rect db = { windowW - (DONEBUTTON_WIDTH + 20), 20, DONEBUTTON_WIDTH, DONEBUTTON_HEIGHT };
//	doneRect = db;

	topRect		= (SDL_Rect){ 0, 0, windowW, 80 };
	drawingRect	= (SDL_Rect){ 20, topRect.h + 20, windowW - 40, windowH - (topRect.h + 40) };
	doneRect	= (SDL_Rect){ windowW - (BUTTON_WIDTH + 20), 20, BUTTON_WIDTH, BUTTON_HEIGHT };
	alertRect	= (SDL_Rect){ 20, 20, BUTTON_WIDTH, BUTTON_HEIGHT };

	SDL_SetRenderDrawColor(renderer, 255, 255, 255, 255);
	SDL_RenderFillRect(renderer, &topRect);
	
	SDL_SetRenderDrawColor(renderer, 80, 80, 0, 255);
	SDL_RenderFillRect(renderer, &drawingRect);
	
	[self initializeButtonTextures:renderer];
	SDL_RenderCopy(renderer, alertButton, NULL, &alertRect);
	SDL_RenderCopy(renderer, doneButton, NULL, &doneRect);

	/* update screen */
	SDL_RenderPresent(renderer);

	drawingRect.x += 1;
	drawingRect.y += 1;
	drawingRect.w -= 2;
	drawingRect.h -= 2;

}

- (void)engineStop {
	SDL_Quit();
	
	// notify views below that they are getting the spotlight again
	[[[AppDelegate sharedAppDelegate] uiwindow] makeKeyAndVisible];
	[callingController viewWillAppear:YES];
	
	if (_rvDelegate && [_rvDelegate respondsToSelector:@selector(finsihedSDL)]) {
		[_rvDelegate finsihedSDL];
	}
}

- (void)testAlert {
	
	NSLog(@"test alert");
	return;
	
	// this shows an alert view, but it does not respond to OK button tap

	UIViewController *vc = [self findSDLViewController:window];
	
	UIAlertController *alertController = [UIAlertController
										  alertControllerWithTitle:@"Testing"
										  message:@"This is a test of the alert controller being displayed."
										  preferredStyle:UIAlertControllerStyleAlert];
	
	[alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
		NSLog(@"Alert OK tapped.");
	}]];
	
	[vc presentViewController:alertController animated:YES completion:nil];

}

- (int)randomIntBetween:(int)a and:(int)b {
	return arc4random_uniform(b - a) + a;
}

- (void)initializeButtonTextures:(SDL_Renderer *)renderer
{
	SDL_Surface *bmp_surface;
	bmp_surface = SDL_LoadBMP("doneButton.bmp");
	if (bmp_surface == NULL) {
		[NSException raise:@"Error" format:@"could not load doneButton.bmp"];
	}
	doneButton = SDL_CreateTextureFromSurface(renderer, bmp_surface);
	SDL_FreeSurface(bmp_surface);
	if (doneButton == 0) {
		[NSException raise:@"Error" format:@"could not create doneButton texture"];
	}
	/* additive blending -- laying strokes on top of eachother makes them brighter */
	SDL_SetTextureBlendMode(doneButton, SDL_BLENDMODE_NONE);

	bmp_surface = SDL_LoadBMP("alertButton.bmp");
	if (bmp_surface == NULL) {
		[NSException raise:@"Error" format:@"could not load alertButton.bmp"];
	}
	alertButton = SDL_CreateTextureFromSurface(renderer, bmp_surface);
	SDL_FreeSurface(bmp_surface);
	if (alertButton == 0) {
		[NSException raise:@"Error" format:@"could not create alertButton texture"];
	}
	/* additive blending -- laying strokes on top of eachother makes them brighter */
	SDL_SetTextureBlendMode(alertButton, SDL_BLENDMODE_NONE);

}

- (void)showRects
{
	/* Enter render loop, waiting for user to quit */
	done = 0;
	while (!done) {
		while (SDL_PollEvent(&event)) {
			switch (event.type) {
				case SDL_QUIT:
					done = 1;
					break;
				case SDL_FINGERUP:
				{
					state = SDL_GetMouseState(&x, &y);  /* get its location */
					SDL_Rect tap = { x, y, 1, 1 };
					if (SDL_HasIntersection(&(doneRect), &tap)) {
						done = 1;
					} else if (SDL_HasIntersection(&(alertRect), &tap)) {
						[self testAlert];
					}
				}
					break;
			}
		}
		[self renderRect:renderer];
		SDL_Delay(100);
	}

}

- (void)drawLines
{

	/* load brush texture */
	[self initializeBrushTexture:renderer];
	
	/* Enter render loop, waiting for user to quit */
	done = 0;
	while (!done && SDL_WaitEvent(&event)) {
		switch (event.type) {
			case SDL_QUIT:
				done = 1;
				break;
			case SDL_FINGERUP:
			{
				state = SDL_GetMouseState(&x, &y);  /* get its location */
				SDL_Rect tap = { x, y, 1, 1 };
				if (SDL_HasIntersection(&(doneRect), &tap)) {
					done = 1;
				} else if (SDL_HasIntersection(&(alertRect), &tap)) {
					[self testAlert];
				}
			}
				break;
			case SDL_FINGERMOTION:
			{
				state = SDL_GetMouseState(&x, &y);  /* get its location */
				SDL_GetRelativeMouseState(&dx, &dy);        /* find how much the mouse moved */
				SDL_Rect tapS = { x, y, 1, 1 };
				SDL_Rect tapE = { dx, dy, 1, 1 };
				if (SDL_HasIntersection(&(drawingRect), &tapS) && SDL_HasIntersection(&(drawingRect), &tapS)) {
					if (state & SDL_BUTTON_LMASK) {     /* is the mouse (touch) down? */
						[self drawLine:renderer from:CGPointMake(x - dx, y - dy) to:CGPointMake(dx, dy)];
						SDL_RenderPresent(renderer);
					}
				}
			}
				break;
		}
	}
	SDL_DestroyTexture(brush);
	
}

- (void)renderRect:(SDL_Renderer *)renderer
{
	Uint8 r, g, b;
	int renderW;
	int renderH;
	
	SDL_RenderGetLogicalSize(renderer, &renderW, &renderH);
	
	/*  Come up with a random rectangle */
	SDL_Rect rect;
	rect.w = [self randomIntBetween:64 and:128];
	rect.h = [self randomIntBetween:64 and:128];
	rect.x = [self randomIntBetween:0 and:drawingRect.w - rect.w];
	rect.y = [self randomIntBetween:0 and:drawingRect.h - rect.h];
	rect.x += drawingRect.x;
	rect.y += drawingRect.y;

	
	/* Come up with a random color */
	r = [self randomIntBetween:50 and:255];
	g = [self randomIntBetween:50 and:255];
	b = [self randomIntBetween:50 and:255];
	
	/*  Fill the rectangle in the color */
	SDL_SetRenderDrawColor(renderer, r, g, b, 255);
	SDL_RenderFillRect(renderer, &rect);
	
	/* update screen */
	SDL_RenderPresent(renderer);
}

- (void)drawLine:(SDL_Renderer *)renderer from:(CGPoint)pFrom to:(CGPoint)pTo
{
	
	float distance = sqrt(pTo.x * pTo.x + pTo.y * pTo.y);   /* length of line segment (pythagoras) */
	int iterations = distance / PIXELS_PER_ITERATION + 1;       /* number of brush sprites to draw for the line */
	float dx_prime = dx / iterations;   /* x-shift per iteration */
	float dy_prime = dy / iterations;   /* y-shift per iteration */
	SDL_Rect dstRect;           /* rect to draw brush sprite into */
	float x;
	float y;
	int i;
	
	dstRect.w = BRUSH_SIZE;
	dstRect.h = BRUSH_SIZE;
	
	/* setup x and y for the location of the first sprite */
	x = pFrom.x - BRUSH_SIZE / 2.0f;
	y = pFrom.y - BRUSH_SIZE / 2.0f;
	
	/* draw a series of blots to form the line */
	for (i = 0; i < iterations; i++) {
		dstRect.x = x;
		dstRect.y = y;
		/* shift x and y for next sprite location */
		x += dx_prime;
		y += dy_prime;
		/* draw brush blot */
		SDL_RenderCopy(renderer, brush, NULL, &dstRect);
	}
}

- (void)initializeBrushTexture:(SDL_Renderer *)renderer
{
	SDL_Surface *bmp_surface;
	bmp_surface = SDL_LoadBMP("stroke.bmp");
	if (bmp_surface == NULL) {
		[NSException raise:@"Error" format:@"could not load stroke.bmp"];
	}
	brush = SDL_CreateTextureFromSurface(renderer, bmp_surface);
	SDL_FreeSurface(bmp_surface);
	if (brush == 0) {
		[NSException raise:@"Error" format:@"could not create brush texture"];
	}
	/* additive blending -- laying strokes on top of eachother makes them brighter */
	SDL_SetTextureBlendMode(brush, SDL_BLENDMODE_ADD);
	/* set brush color (red) */
	SDL_SetTextureColorMod(brush, 255, 100, 100);
}

@end

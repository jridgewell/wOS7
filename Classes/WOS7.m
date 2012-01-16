#import "WOS7.h"

#define BACKGROUND_FADE		.30
#define BACKGROUND_TAG		100
#define TOGGLE_NORMAL		.3

@implementation WOS7
@synthesize applications, mainView, subView;
static WOS7* sharedInstance;

- (void)updateBadge:(NSString*)leafId {
	for(id app in tileScrollView.subviews)
		if ([app isKindOfClass:[WOS7HomeApp class]] && [[app leafIdentifier] isEqualToString:leafId]) {
			[app updateBadge];
		}
}

- (id)initWithWindow:(UIWindow*)_window array:(NSMutableArray*)_apps {

	self = [super init];
	sharedInstance = self;
	if (self) {
		window = _window;
		applications = _apps;

		//create views
		mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
		subView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 574, 480)];

		mainView.opaque = YES;
		mainView.backgroundColor = [UIColor blackColor];
		[subView.layer setOpaque:NO];
		subView.opaque = NO;
		subView.backgroundColor = [UIColor clearColor];

		tileScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
		[tileScrollView setDelegate:self];
		appList = [[UIScrollView alloc] initWithFrame:CGRectMake(320, 0, 254, 480)];
		[appList setDelegate:self];
		[subView addSubview:appList];
		[subView addSubview:tileScrollView];
		[mainView addSubview:subView];

		//add background
		if ([[NSFileManager defaultManager] fileExistsAtPath:@LIBRARY_DIR"/Background.png"]) {
			UIImageView* bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
			bgView.tag = BACKGROUND_TAG;
			bgView.image = [UIImage imageWithContentsOfFile:@LIBRARY_DIR"/Background.png"];
			[mainView insertSubview:bgView atIndex:0];
			[bgView release];
		}

		//add listapps to the applist
		int y = 0;
		for(int i = 0; i < (int)applications.count; i++) {
			NSString* leafIdentifier = [[[[WOS7 sharedInstance] applications] objectAtIndex:i] leafIdentifier];
			if (![leafIdentifier isEqualToString:@"com.apple.fieldtest"] && ![leafIdentifier isEqualToString:@"com.apple.purplebuddy"]) {
				WOS7ListApp* listApp = [[WOS7ListApp alloc] initWithFrame:CGRectMake(0, (46 * y) + 75, 254, 40) index:i];
				[appList addSubview:listApp];
				[listApp release];
				[appList setContentSize:CGSizeMake(254, (46 * (y + 1)) + 75)];
				y++;
			}
		}


		//add the arrow
		toggleInterface = [[UIButton alloc] initWithFrame:CGRectMake(254, 60, 66, 66)];
		[toggleInterface addTarget:self action:@selector(toggle) forControlEvents:UIControlEventTouchUpInside];
		[toggleInterface setImage:[UIImage imageWithContentsOfFile:@LIBRARY_DIR"/Images/Arrow.png"] forState:UIControlStateNormal];
		[subView addSubview:toggleInterface];
		[toggleInterface release];
		toggled = NO;
		isAnimatingBounce = NO;

		//make sure there are no scrollbars
		appList.showsVerticalScrollIndicator = NO;
		tileScrollView.showsVerticalScrollIndicator = NO;

		//allow scrollToTop on status bar tap
		[appList setScrollsToTop:NO];

		UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
		[subView addGestureRecognizer:pan];
		[pan release];

		[self updateTiles];
		[window addSubview:mainView];
	}
	return self;
}

- (void)updateTiles {

	NSArray* tilesArray = [[NSArray alloc] initWithContentsOfFile:@LIBRARY_DIR"/Tiles.plist"];

	//remove old tiles
	for(id app in tileScrollView.subviews)
		if ([app isKindOfClass:[WOS7HomeApp class]] && ![tilesArray containsObject:[app leafIdentifier]]) {
			[app removeFromSuperview];
		}

	int a = 0;
	int j = 0;
	for(int i = 0; i < (int)tilesArray.count; i++) {
		NSString* bundleId = [tilesArray objectAtIndex:i];

		//see if this tile is large
		BOOL isLarge = NO;
		if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@LIBRARY_DIR"/Tiles/%@/Info.plist", bundleId]]) {
			NSDictionary* info = [[NSDictionary alloc] initWithContentsOfFile:[NSString stringWithFormat:@LIBRARY_DIR"/Tiles/%@/Info.plist", bundleId]];
			if ([[info allKeys] containsObject:@"isLargeTile"]) {
				isLarge = [[info valueForKey:@"isLargeTile"] isEqualToString:@"YES"];
			}
			[info release];
		}

		//find our tile, if it's there
		for (id app in tileScrollView.subviews)
			if ([app isKindOfClass:[WOS7HomeApp class]] && [[app leafIdentifier] isEqualToString:bundleId]) {

				if (isLarge && j % 2 != 0) {
					j++;
				}

				//if we find our tiles, update it's positioning.
				[UIView animateWithDuration:.5
								 animations:^{
									 [app setFrame:CGRectMake((j % 2 == 0) ? 13 : 136, (123 * (j / 2)) + 75, (isLarge) ? 238 : 115, 115)];
								 }];

				if (isLarge) {
					j += 2;
				} else {
					j++;
				}

				goto end;
			}

		//we didn't find our tile, so let's add it.
		WOS7HomeApp* tile = nil;

		//find the corresponding SBApplication
		for(; a < (int)applications.count; a++)
			if ([[[applications objectAtIndex:a] leafIdentifier] isEqualToString:bundleId]) {
				if (isLarge && j % 2 != 0) {
					j++;
				}
				tile = [[WOS7HomeApp alloc] initWithFrame:CGRectMake((j % 2 == 0) ? 13 : 136, (123 * (j / 2)) + 75, (isLarge) ? 238 : 115, 115) appIndex:a];
				break;
			}

		if (!tile) {
			continue;
		}

		[tileScrollView addSubview:tile];
		[tile release];

		if (isLarge) {
			j += 2;
		} else {
			j++;
		}

	end:
		// this is here so that the compiler doesn't yell at me for
		// having a label at the end
		a = 0;
	}
	[tileScrollView setContentSize:CGSizeMake(320, (123 * ((j + 1) / 2)) + 75)];
}


- (void)dealloc {
	[tileScrollView release];
	[appList release];
	[subView release];
	[mainView removeFromSuperview];
	[mainView release];
	[super dealloc];
}

- (void)didPan:(UIPanGestureRecognizer*)recognizer {
	if (recognizer.state == UIGestureRecognizerStateBegan || recognizer.state == UIGestureRecognizerStateChanged) {
		CGPoint d = [recognizer translationInView:recognizer.view];
		[recognizer setTranslation:CGPointZero inView:recognizer.view];
		CGFloat scaleLeftMovement = 0;

		if (subView.frame.origin.x + d.x >= -254 && subView.frame.origin.x + d.x <= 0) {
			scaleLeftMovement = subView.frame.origin.x / -254;
			subView.center = CGPointMake(subView.center.x + d.x, subView.center.y);
			toggleInterface.transform = CGAffineTransformMakeRotation(scaleLeftMovement * -1 * (CGFloat)M_PI);
			[[mainView viewWithTag:BACKGROUND_TAG] setAlpha:(1 - (scaleLeftMovement * (1 - (CGFloat)BACKGROUND_FADE)))];
		}
	} else if (recognizer.state == UIGestureRecognizerStateEnded) {
		CGPoint vel = [recognizer velocityInView:recognizer.view];
		BOOL leftRight = (subView.center.x <= 160); // ([subView width] / 2) - (254 / 2)
		double speed;

		if (vel.x < -500) {
			speed = fabs(-254 - subView.frame.origin.x) / fabs(vel.x);
			[self toggleLeft:speed];
		} else if (vel.x >= 500) {
			speed = fabs(subView.frame.origin.x) / vel.x;
			[self toggleRight:speed];
		} else if (leftRight) {
			[self toggleLeft:TOGGLE_NORMAL];
		} else {
			[self toggleRight:TOGGLE_NORMAL];
		}
	}
}

- (void)toggle {
	if (toggled) {
		[self toggleRight:TOGGLE_NORMAL];
	} else {
		[self toggleLeft:TOGGLE_NORMAL];
	}
}

- (void)toggleLeft:(double)t {
	[UIView animateWithDuration:t
						  delay:0
						options:(UIViewAnimationOptionAllowUserInteraction |
								 UIViewAnimationOptionBeginFromCurrentState |
								 UIViewAnimationOptionAllowAnimatedContent |
								 UIViewAnimationCurveEaseOut)
					 animations:^{
						 subView.frame = CGRectMake(-254,0,574,480);
						 toggleInterface.transform = CGAffineTransformMakeRotation((CGFloat)M_PI);
						 [[mainView viewWithTag:BACKGROUND_TAG] setAlpha:(CGFloat)BACKGROUND_FADE];
					 }
					 completion:^(BOOL finished) {
						 [tileScrollView setScrollsToTop:NO];
						 [appList setScrollsToTop:YES];
					 }];

	toggled = YES;
}

- (void)toggleRight:(double)t {
	[UIView animateWithDuration:t
						  delay:0
						options:(UIViewAnimationOptionAllowUserInteraction |
								 UIViewAnimationOptionBeginFromCurrentState |
								 UIViewAnimationOptionAllowAnimatedContent |
								 UIViewAnimationCurveEaseOut)
					 animations:^{
						 subView.frame = CGRectMake(0,0,574,480);
						 toggleInterface.transform = CGAffineTransformMakeRotation(0);
						 [[mainView viewWithTag:BACKGROUND_TAG] setAlpha:1];
					 }
					 completion:^(BOOL finished) {
						 [tileScrollView setScrollsToTop:YES];
						 [appList setScrollsToTop:NO];
					 }];

	toggled = NO;
}

- (void)didHold:(UILongPressGestureRecognizer*)gesture tile:(id)sender {
	WOS7CustomActionSheet* actionSheet = [[WOS7CustomActionSheet alloc] initWithTitle:[[applications objectAtIndex:[(UIView*)sender tag]] leafIdentifier]
																	 delegate:self
																		width:270];
	NSString* buttonLabels;
	if ([sender isKindOfClass:[WOS7HomeApp class]]) {
		buttonLabels = @"Unpin, Move Up, Move Down";
	} else if ([sender isKindOfClass:[WOS7ListApp class]]) {
		NSArray* tilesArray = [[NSArray alloc] initWithContentsOfFile:@LIBRARY_DIR"/Tiles.plist"];
		if (![tilesArray containsObject:[[applications objectAtIndex:[(UIView*)sender tag]] leafIdentifier]]) {
			buttonLabels = @"Pin to Start Menu";
		}
		[tilesArray release];
	}
	buttonLabels = [[buttonLabels autorelease] stringByAppendingString:@", Cancel"];
	for (NSString* label in [buttonLabels componentsSeparatedByString:@", "]) {
		[actionSheet addButtonWithTitle:label];
	}
	[actionSheet showInView:window atPoint:[gesture locationInView:window]];
	[actionSheet release];
}

- (void)dismissActionSheet:(id)actionSheet withButtonIndex:(NSInteger)buttonIndex {
	NSString* title = [actionSheet buttonTitleAtIndex:buttonIndex];
	NSString* leafIdentifier = [actionSheet title];

	NSMutableArray* ray = [[NSMutableArray alloc] initWithContentsOfFile:@LIBRARY_DIR"/Tiles.plist"];
	if ([title isEqualToString:@"Unpin"]) {
		[ray removeObject:leafIdentifier];
	} else if ([title isEqualToString:@"Move Up"]) {
		int i = [ray indexOfObject:leafIdentifier];
		int newI = (i == 0) ? 0 : i - 1;
		[ray exchangeObjectAtIndex:i withObjectAtIndex:newI];
	} else if ([title isEqualToString:@"Move Down"]) {
		int i = [ray indexOfObject:leafIdentifier];
		int newI = (i == (int)ray.count - 1) ? (int)ray.count - 1 : i + 1;
		[ray exchangeObjectAtIndex:i withObjectAtIndex:newI];
	} else if ([title isEqualToString:@"Pin to Start Menu"]) {
		[ray addObject:leafIdentifier];
	}

	[ray writeToFile:@LIBRARY_DIR"/Tiles.plist" atomically:NO];
	[ray release];

	[self updateTiles];

	if ([title isEqualToString:@"Pin to Start Menu"] && toggled) {
		[self toggle];
	}
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView {
	if(!isAnimatingBounce && [scrollView contentOffset].y >= ([scrollView contentSize].height - [scrollView frame].size.height)) {
		isAnimatingBounce = YES;
		CGRect frame = [toggleInterface frame];
		CGRect newFrame = frame;
		if (toggled) {
			newFrame.origin = CGPointMake((frame.origin.x - 10),
									   frame.origin.y);
		} else {
			newFrame.origin = CGPointMake((frame.origin.x + 10),
									   frame.origin.y);
		}

		[UIView animateWithDuration:.3
						 animations:^{
							 [toggleInterface setFrame:newFrame];
						 }
						 completion:^(BOOL finished) {
							 [UIView animateWithDuration:.3
											  animations:^{
												  [toggleInterface setFrame:frame];
											  } completion:^(BOOL done) {
											  }];
						 }];
	}
}

- (void)scrollViewDidEndDragging:(UIScrollView*)scrollView willDecelerate:(BOOL)decelerate {
	CMLog(@"scrollViewDidEndDragging:willDecelerate:, %i", isAnimatingBounce)
	if (isAnimatingBounce) {
		isAnimatingBounce = NO;
	}
}

+(WOS7*)sharedInstance {
	return sharedInstance;
}

+(UIImage*)maskImage:(UIImage*)image withMask:(UIImage*)maskImage {

	CGImageRef maskRef = maskImage.CGImage;

	CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
										CGImageGetHeight(maskRef),
										CGImageGetBitsPerComponent(maskRef),
										CGImageGetBitsPerPixel(maskRef),
										CGImageGetBytesPerRow(maskRef),
										CGImageGetDataProvider(maskRef), NULL, false);

	CGImageRef masked = CGImageCreateWithMask([image CGImage], mask);
	return [UIImage imageWithCGImage:masked];

}

@end

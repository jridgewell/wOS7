#import "WOS7HomeApp.h"

@implementation WOS7HomeApp

@synthesize leafIdentifier;

- (id)initWithFrame:(CGRect)frame appIndex:(int)i {
	self = [super initWithFrame:frame];
	if (self) {
		id app = [[[WOS7 sharedInstance] applications] objectAtIndex:i];
		appIndex = i;
		self.leafIdentifier = [app leafIdentifier];


		//background image
		UIImageView* bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		bgImageView.image = [UIImage imageWithContentsOfFile:@LIBRARY_DIR"/Images/Background.png"];
		[self addSubview:bgImageView];
		[bgImageView release];

		//check if tile has an info.plist
		if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@LIBRARY_DIR"/Tiles/%@/Info.plist", leafIdentifier]]) {
			//load our plist
			NSDictionary* dict = [[NSDictionary alloc] initWithContentsOfFile:[NSString stringWithFormat:@LIBRARY_DIR"/Tiles/%@/Info.plist", leafIdentifier]];

			//check if uses html
			if ([dict objectForKey:@"usesHTML"] && [[dict objectForKey:@"usesHTML"] isEqualToString:@"YES"]) {
				if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@LIBRARY_DIR"/Tiles/%@/%@", leafIdentifier, [dict objectForKey:@"widgetFile"]]]) {

					//load the html
					UIWebDocumentView* webView = [[UIWebDocumentView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
					[webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@LIBRARY_DIR"/Tiles/%@/%@", leafIdentifier, [dict objectForKey:@"widgetFile"]]]]];
					[webView setBackgroundColor:[UIColor clearColor]];
					[webView setDrawsBackground:NO];
					[self addSubview:webView];
					[webView release];
				}
			} else {
				//otherwise load the tile image
				tileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
				tileImageView.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@LIBRARY_DIR"/Tiles/%@/Tile.png", leafIdentifier]];
				[self addSubview:tileImageView];
				[tileImageView release];
			}

			//name label
			UILabel* appDisplayLabel = [[UILabel alloc] initWithFrame:CGRectMake(6, 98, 105, 14)];
			appDisplayLabel.font = [UIFont boldSystemFontOfSize:13];
			appDisplayLabel.textColor = [UIColor whiteColor];
			appDisplayLabel.text = [app displayName];
			appDisplayLabel.backgroundColor = [UIColor clearColor];

			//custom name
			if ([dict objectForKey:@"displayName"]) {
				appDisplayLabel.text = [dict objectForKey:@"displayName"];
			}

			[self addSubview:appDisplayLabel];
			[appDisplayLabel release];
			[dict release];
		} else {
			NSArray* splited = [[[app application] path] componentsSeparatedByString:@"/"];
			tileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(28, 28, 60, 60)];

			//if this is an app store app, it will have a large itunesartwork
			if ([[splited objectAtIndex:1] isEqualToString:@"private"]) {
				tileImageView.frame = CGRectMake(-17, -17, 150, 150);
				tileImageView.image = [WOS7 maskImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@iTunesArtwork", [[[app application] path] substringWithRange:NSMakeRange(0, 70)]]] withMask:[UIImage imageWithContentsOfFile:@LIBRARY_DIR"/Images/BigIconMask.png"]];
				[self addSubview:tileImageView];
			} else {
				tileImageView.image = [WOS7 maskImage:[app getIconImage:2] withMask:[UIImage imageWithContentsOfFile:@LIBRARY_DIR"/Images/IconMask.png"]];
				[self addSubview:tileImageView];

				UIImageView* over = [[UIImageView alloc] initWithFrame:CGRectMake(28, 28, 60, 60)];
				over.image = [UIImage imageWithContentsOfFile:@LIBRARY_DIR"/Images/IconOverlay.png"];
				[self addSubview:over];
				[over release];
			}
			[tileImageView release];

			//name label
			UILabel* appDisplayLabel = [[UILabel alloc] initWithFrame:CGRectMake(6, 98, 105, 14)];
			appDisplayLabel.font = [UIFont boldSystemFontOfSize:13];
			appDisplayLabel.textColor = [UIColor whiteColor];
			appDisplayLabel.text = [app displayName];
			appDisplayLabel.backgroundColor = [UIColor clearColor];
			[self addSubview:appDisplayLabel];
			[appDisplayLabel release];
		}

		UIButton* launchButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		[launchButton addTarget:self action:@selector(launch) forControlEvents:UIControlEventTouchUpInside];
		if (frame.size.width==115) {
			[launchButton setImage:[UIImage imageWithContentsOfFile:@LIBRARY_DIR"/Images/TileOverlay.png"] forState:UIControlStateNormal];
		}
		self.tag = i;
		UILongPressGestureRecognizer* recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didHold:)];
		[launchButton addGestureRecognizer:recognizer];
		[recognizer release];
		[self addSubview:launchButton];
		[launchButton release];

		[self updateBadge];

		self.clipsToBounds = YES;
	}
	return self;
}

- (void)didHold:(UILongPressGestureRecognizer*)sender {
	if (sender.state == 1) {
		[[WOS7 sharedInstance] didHold:sender tile:self];
	}
}

- (void)dealloc {
	[leafIdentifier release];
	[super dealloc];
}

- (void)updateBadge {
	int num = (int)[(SBApplicationIcon*)[[[WOS7 sharedInstance] applications] objectAtIndex:appIndex] badgeValue];
	if (num == 0 && !badgeLabel) {
		return;
	}
	if (!badgeLabel) {
		NSDictionary* dict = [[NSDictionary alloc] initWithContentsOfFile:[NSString stringWithFormat:@LIBRARY_DIR"/Tiles/%@/Info.plist", leafIdentifier]];
		if (dict && [dict objectForKey:@"badgeX"]) {
			badgeLabel = [[UILabel alloc] initWithFrame:CGRectMake([[dict objectForKey:@"badgeX"] intValue], [[dict objectForKey:@"badgeY"] intValue], 110, [[dict valueForKey:@"badgeHeight"] intValue])];
			badgeLabel.font = [UIFont systemFontOfSize:[[dict objectForKey:@"badgeFontSize"] intValue]];
			badgeLabel.textAlignment = UITextAlignmentLeft;
		} else {
			badgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 110, 20)];
			badgeLabel.font = [UIFont boldSystemFontOfSize:20];
			badgeLabel.textAlignment = UITextAlignmentRight;
		}
		badgeLabel.textColor = [UIColor whiteColor];
		badgeLabel.text = [NSString stringWithFormat:@"%d", num];
		badgeLabel.backgroundColor = [UIColor clearColor];
		if (tileImageView && dict && [dict objectForKey:@"badgeX"]) {
			tileImageView.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@LIBRARY_DIR"/Tiles/%@/TileWithBadge.png", leafIdentifier]];
		}
		[self addSubview:badgeLabel];
		[dict release];
	} else if (num == 0) {
		[badgeLabel removeFromSuperview];
		[badgeLabel release];
		NSDictionary* dict = [[NSDictionary alloc] initWithContentsOfFile:[NSString stringWithFormat:@LIBRARY_DIR"/Tiles/%@/Info.plist", leafIdentifier]];
		if (tileImageView && dict && [dict objectForKey:@"badgeX"]) {
			tileImageView.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@LIBRARY_DIR"/Tiles/%@/Tile.png", leafIdentifier]];
		}
		badgeLabel = nil;
		[dict release];
	} else {
		badgeLabel.text = [NSString stringWithFormat:@"%d", num];
	}
}

- (void)launch {
	[(SBApplicationIcon*)[[[WOS7 sharedInstance] applications] objectAtIndex:appIndex] launch];
}

@end

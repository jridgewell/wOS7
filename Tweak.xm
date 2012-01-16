#import <SpringBoard/SpringBoard.h>
#import "Classes/DreamBoard.h"
#import "Classes/WOS7.h"

WOS7* wos7;

@interface SBApplicationIcon (warning)
	- (NSString*) leafIdentifier;
@end

%hook SBApplicationIcon
-(void)setBadge: (NSString*)badge {
	%orig(badge);
	//update badges
	if (wos7) {
		[wos7 updateBadge:[self leafIdentifier]];
	}
}
%end

%hook DreamBoard
-(void)loadTheme: (NSString*)theme {
	if ([theme isEqualToString:@"wOS7"] && wos7) {
		return;
	}


	//there are then two instances to check, switching to and from wOS7
	//check switching from wOS7
	if (wos7!=nil && ![theme isEqualToString:@"wOS7"]) {
		//get rid of wOS7
		[self unloadTheme];
		[self save:@"Default"];
		%orig(theme);
	} else if (wos7==nil && [theme isEqualToString:@"wOS7"]) {
		//check switching to wOS7
		if (![self.currentTheme isEqualToString:@"Default"]) {
			[self unloadTheme];
		}
		wos7 = [[WOS7 alloc] initWithWindow:[self window] array:[self appsArray]];
		[self save:@"wOS7"];
		[self showAllExcept:nil];
		[self window].userInteractionEnabled = YES;
	} else {
		//otherwise just do the original method
		%orig(theme);
	}
}

-(void)unloadTheme {
	//unload wOS7 if it's loaded
	if (wos7) {
		[wos7 release];
		wos7 = nil;
	} else {
		%orig;
	}
}

-(NSString*)currentTheme {
	if (wos7) {
		return @"wOS7";
	}
	return %orig;
}

- (void)toggleSwitcher {
	if (wos7) {
		//animate our mainview sliding up
		if (wos7.mainView.frame.origin.y==0) {
			[UIView animateWithDuration:.25 animations:^{
				wos7.mainView.frame = CGRectMake(wos7.mainView.frame.origin.x,
												 -93,
												 wos7.mainView.frame.size.width,
												 wos7.mainView.frame.size.height);
			}];
			[[objc_getClass("DreamBoard") sharedInstance] showAllExcept:nil];
		} else {
			//otherwise hide it
			[self hideSwitcher];
		}
	} else {
		%orig;
	}
}

-(void)hideSwitcher {
	if (wos7) {
		//animate our mainview sliding down
		[UIView animateWithDuration:.25 animations:^{
			wos7.mainView.frame = CGRectMake(wos7.mainView.frame.origin.x,
											 0,
											 wos7.mainView.frame.size.width,
											 wos7.mainView.frame.size.height);
		}];
		[[objc_getClass("DreamBoard") sharedInstance] hideAllExcept:wos7.mainView];
	} else {
		%orig;
	}
}

%end
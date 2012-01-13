#import <SpringBoard/SpringBoard.h>
#import "DreamBoard.h"
#import "WOS7.h"

WOS7* wos7;

%hook SBApplicationIcon
-(void)setBadge: (NSString*)badge{
	%orig(badge);
    //update badges
	if(wos7)[wos7 updateBadge:[self leafIdentifier]];
}
%end

%hook DreamBoard
-(void)loadTheme: (NSString*)theme{
    if([theme isEqualToString:@"wOS7"] && wos7)return;


    //there are then two instances to check, switching to and from wOS7
    //check switching from wOS7
    if(wos7!=nil && ![theme isEqualToString:@"wOS7"])
    {
        //get rid of wOS7
        [self unloadTheme];
        [self save:@"Default"];
        %orig(theme);
    }

    //check switching to wOS7
    else if(wos7==nil && [theme isEqualToString:@"wOS7"])
    {
        if(![self.currentTheme isEqualToString:@"Default"])[self unloadTheme];
		wos7 = [[WOS7 alloc] initWithWindow:[self window] array:[self appsArray]];
		[self save:@"wOS7"];
        [self showAllExcept:nil];
        [self window].userInteractionEnabled = YES;
	}

    //otherwise just do the original method
    else %orig(theme);
}

-(void)unloadTheme{
    //unload wOS7 if it's loaded
	if(wos7)
    {
		[wos7 release];
		wos7 = nil;
	}
    else %orig;
}

-(NSString*)currentTheme{
    if(wos7)return @"wOS7";
    return %orig;
}

- (void)toggleSwitcher{
    if(wos7)
    {
        CGRect frame = wos7.mainView.frame;

        //animate our mainview sliding up
        if(wos7.mainView.frame.origin.y==0)
        {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:.25];
            wos7.mainView.frame = CGRectMake(frame.origin.x,-93,frame.size.width,frame.size.height);
            [UIView commitAnimations];
            [[objc_getClass("DreamBoard") sharedInstance] showAllExcept:nil];
        }

        //otherwise hide it
        else [self hideSwitcher];
    }
    else %orig;
}

-(void)hideSwitcher{
    if(wos7)
    {
        CGRect frame = wos7.mainView.frame;

        //animate our mainview sliding down
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.25];
        wos7.mainView.frame = CGRectMake(frame.origin.x,0,frame.size.width,frame.size.height);
        [UIView commitAnimations];
        [[objc_getClass("DreamBoard") sharedInstance] hideAllExcept:wos7.mainView];
    }
    else %orig;
}

%end
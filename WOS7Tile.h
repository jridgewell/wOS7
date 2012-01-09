/*
 
 wOS7, Windows Phone 7 Theme
 
 Wyndwarrior, 2011. Designed for DreamBoard
 
 */

#import "WOS7.h"

@interface WOS7Tile : UIView
{
	NSString *leafIdentifier;
    int appIndex;
    
	UILabel *badgeLabel;
    UIImageView *tileImageView;
}

@property (nonatomic, retain) NSString *leafIdentifier;

-(id)initWithFrame:(CGRect)frame appIndex:(int)index;
-(void)updateBadge;
-(void)launch;

@end
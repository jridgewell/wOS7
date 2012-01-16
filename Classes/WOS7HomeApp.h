#import "WOS7.h"

@interface WOS7HomeApp : UIView
{
	NSString* leafIdentifier;
	int appIndex;

	UILabel* badgeLabel;
	UIImageView* tileImageView;
}

@property (nonatomic, retain)NSString* leafIdentifier;

- (id)initWithFrame:(CGRect)frame appIndex:(int)index;
- (void)didHold:(UILongPressGestureRecognizer*)sender;
- (void)updateBadge;
- (void)launch;

@end

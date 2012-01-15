#import <SpringBoard/SpringBoard.h>
#import "WOS7CustomActionSheet.h"
#import "WOS7ListApp.h"
#import "WOS7ScrollView.h"
#import "WOS7Tile.h"
#import "WOS7TouchView.h"
#import "DreamBoard.h"

#define LIBRARY_DIR "/var/mobile/Library/wOS7"

@interface WOS7 : NSObject <UIActionSheetDelegate, UIScrollViewDelegate>
{
	UIWindow* window;
	UIView* mainView;
	UIView* subView;
	WOS7ScrollView* tileScrollView;
	WOS7ScrollView* appList;

	UIButton* toggleInterface;

	NSMutableArray* applications;

	BOOL toggled;
	BOOL animatingBounce;
}

@property(nonatomic, readonly)NSMutableArray* applications;
@property(nonatomic, readonly)UIView* mainView;
@property(nonatomic, readonly)UIView* subView;

+(WOS7*)sharedInstance;
+(UIImage*)maskImage:(UIImage*)image withMask:(UIImage*)maskImage;

- (id)initWithWindow:(UIWindow*)_window array:(NSMutableArray*)_apps;
- (void)toggle;
- (void)toggleLeft:(double)t;
- (void)toggleRight:(double)t;
- (void)updateTiles;
- (void)updateBadge:(NSString*)leafId;
- (void)didPan:(UIPanGestureRecognizer*)recognizer;
- (void)didHold:(UILongPressGestureRecognizer*)gesture tile:(id)sender;
- (void)dismissActionSheet:(id)actionSheet withButtonIndex:(NSInteger)buttonIndex;
- (void)scrolledBeyondBottom:(UIScrollView*)scrollView;

@end

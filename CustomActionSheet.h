#import "WOS7.h"

@interface CustomActionSheet : UIView {
	float fadeAlpha;
	float width;
	NSInteger numberOfButtons;
	NSString* title;
	NSMutableArray* buttons;
	UIColor* backgroundColor;
	UIColor* fadeColor;
	UIColor* fontColor;
	UIFont* font;
}

@property(nonatomic) float fadeAlpha;
@property(nonatomic) float width;
@property(nonatomic, readonly) NSInteger numberOfButtons;
@property(nonatomic, retain) NSString* title;
@property(nonatomic, retain) UIColor* backgroundColor;
@property(nonatomic, retain) UIColor* fadeColor;
@property(nonatomic, retain) UIColor* fontColor;
@property(nonatomic, retain) UIFont* font;

- (NSInteger)addButtonWithTitle:(NSString*)titleString;
- (NSString*)buttonTitleAtIndex:(NSInteger)buttonIndex;
- (id)initWithTitle:(NSString*)titleString width:(float) viewWidth;
- (void)showInView:(UIView*)view;

@end

#import "WOS7.h"

@interface CustomActionSheet : UIView {
	UIColor* backgroundColor;
	NSMutableArray* buttons;
	float buttonPaddingX;
	float buttonPaddingy;
	id delegate;
	float fadeAlpha;
	UIColor* fadeColor;
	UIFont* font;
	UIColor* fontColor;
	NSInteger numberOfButtons;
	UIView* superView;
	NSString* title;
	UIFont* titleFont;
	UIColor* titleFontColor;
	float titlePaddingX;
	float titlePaddingy;
	float width;
}

@property(nonatomic, retain) UIColor* backgroundColor;
@property(nonatomic) float buttonPaddingX;
@property(nonatomic) float buttonPaddingY;
@property(nonatomic, retain) id delegate;
@property(nonatomic) float fadeAlpha;
@property(nonatomic, retain) UIColor* fadeColor;
@property(nonatomic, retain) UIFont* font;
@property(nonatomic, retain) UIColor* fontColor;
@property(nonatomic, readonly) NSInteger numberOfButtons;
@property(nonatomic, retain) UIView* superView;
@property(nonatomic, retain) NSString* title;
@property(nonatomic, retain) UIFont* titleFont;
@property(nonatomic, retain) UIColor* titleFontColor;
@property(nonatomic) float titlePaddingX;
@property(nonatomic) float titlePaddingY;
@property(nonatomic) float width;

- (NSInteger)addButtonWithTitle:(NSString*)titleString;
- (NSString*)buttonTitleAtIndex:(NSInteger)buttonIndex;
- (void)dismissWithButton:(id)sender;
- (id)initWithTitle:(NSString*)titleString delegate:(id)delegate width:(float)viewWidth;
- (void)showInView:(UIView*)view atPoint:(CGPoint)point;
@end

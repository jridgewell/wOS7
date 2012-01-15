#import "WOS7.h"

@interface CustomActionSheet : UIView {
	UIColor* backgroundColor;
	NSMutableArray* buttons;
	CGFloat buttonPaddingX;
	CGFloat buttonPaddingy;
	id delegate;
	CGFloat fadeAlpha;
	UIColor* fadeColor;
	UIFont* font;
	UIColor* fontColor;
	NSInteger numberOfButtons;
	UIView* superView;
	NSString* title;
	UIFont* titleFont;
	UIColor* titleFontColor;
	CGFloat titlePaddingX;
	CGFloat titlePaddingy;
	CGFloat width;
}

@property(nonatomic, retain) UIColor* backgroundColor;
@property(nonatomic) CGFloat buttonPaddingX;
@property(nonatomic) CGFloat buttonPaddingY;
@property(nonatomic, retain) id delegate;
@property(nonatomic) CGFloat fadeAlpha;
@property(nonatomic, retain) UIColor* fadeColor;
@property(nonatomic, retain) UIFont* font;
@property(nonatomic, retain) UIColor* fontColor;
@property(nonatomic, readonly) NSInteger numberOfButtons;
@property(nonatomic, retain) UIView* superView;
@property(nonatomic, retain) NSString* title;
@property(nonatomic, retain) UIFont* titleFont;
@property(nonatomic, retain) UIColor* titleFontColor;
@property(nonatomic) CGFloat titlePaddingX;
@property(nonatomic) CGFloat titlePaddingY;
@property(nonatomic) CGFloat width;

- (NSInteger)addButtonWithTitle:(NSString*)titleString;
- (NSString*)buttonTitleAtIndex:(NSInteger)buttonIndex;
- (void)dismissWithButton:(id)sender;
- (id)initWithTitle:(NSString*)titleString delegate:(id)delegate width:(float)viewWidth;
- (void)showInView:(UIView*)view atPoint:(CGPoint)point;
@end

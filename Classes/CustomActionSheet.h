#import "WOS7.h"

@interface CustomActionSheet : UIView {
	UIColor* backgroundColor;
	NSMutableArray* buttons;
	id delegate;
	float fadeAlpha;
	UIColor* fadeColor;
	UIFont* font;
	UIColor* fontColor;
	NSInteger numberOfButtons;
	NSString* title;
	float width;
}

@property(nonatomic, retain) UIColor* backgroundColor;
@property(nonatomic, retain) id delegate;
@property(nonatomic) float fadeAlpha;
@property(nonatomic, retain) UIColor* fadeColor;
@property(nonatomic, retain) UIFont* font;
@property(nonatomic, retain) UIColor* fontColor;
@property(nonatomic, readonly) NSInteger numberOfButtons;
@property(nonatomic, retain) NSString* title;
@property(nonatomic) float width;

- (NSInteger)addButtonWithTitle:(NSString*)titleString;
- (NSString*)buttonTitleAtIndex:(NSInteger)buttonIndex;
- (void)dismissWithButton:(id)sender;
- (id)initWithTitle:(NSString*)titleString delegate:(id)delegate width:(float)viewWidth;
- (void)showInView:(UIView*)view;
@end

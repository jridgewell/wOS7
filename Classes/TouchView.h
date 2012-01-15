#import "WOS7.h"

@interface TouchView : UIView {
	id delegate;
}
@property(nonatomic, retain) id delegate;

- (TouchView*)initWithFrame:(CGRect)rect delegate:(id)touchDelegate;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

@end
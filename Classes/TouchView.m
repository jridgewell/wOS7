#import "TouchView.h"

@implementation TouchView

@synthesize delegate;

- (TouchView*)initWithFrame:(CGRect)rect delegate:(id)touchDelegate {
	self = (TouchView*)[super initWithFrame:rect];
	if (self) {
		[self setDelegate:touchDelegate];
	}

	return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[[[self delegate] sharedInstance] touchesBegan:touches withEvent:event];
}

@end
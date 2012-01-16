#import "WOS7TouchView.h"

@implementation WOS7TouchView

@synthesize delegate;

- (WOS7TouchView*)initWithFrame:(CGRect)rect delegate:(id)touchDelegate {
	self = (WOS7TouchView*)[super initWithFrame:rect];
	if (self) {
		[self setDelegate:touchDelegate];
	}

	return self;
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
	[[self delegate] touchesBegan:touches withEvent:event];
}

@end
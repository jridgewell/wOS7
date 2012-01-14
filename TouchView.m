#import "TouchView.h"

@implementation TouchView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[[WOS7 sharedInstance] touchesBegan:touches withEvent:event];
}

@end
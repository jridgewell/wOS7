#import "WOS7ScrollView.h"

@implementation WOS7ScrollView

@synthesize parent;
@synthesize target;

- (WOS7ScrollView*)initWithFrame:(CGRect)rect target:(SEL)scrollTarget parent:(NSObject*)targetParent {
	self = (WOS7ScrollView*)[super initWithFrame:rect];
	if (self) {
		[self setParent:targetParent];
		[self setTarget:scrollTarget];
	}

	return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if(scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height) {
		NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[[self parent] methodSignatureForSelector:[self target]]];
		[inv setSelector:[self target]];
		[inv setTarget:[self parent]];
		[inv setArgument:scrollView atIndex:2];
		[inv invoke];
	}
}

@end

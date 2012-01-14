#import "CustomActionSheet.h"

@implementation CustomActionSheet

@synthesize fadeAlpha;
@synthesize width;
@synthesize numberOfButtons;
@synthesize title;
@synthesize backgroundColor;
@synthesize fadeColor;
@synthesize fontColor;
@synthesize font;

- (NSInteger)addButtonWithTitle:(NSString*)titleString {
	UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];

	CGSize contentSize = [titleString sizeWithFont:[self font]
								 constrainedToSize:CGSizeMake([self width], CGFLOAT_MAX)
									 lineBreakMode:UILineBreakModeTailTruncation];
	[button setFrame:CGRectMake(0, [self numberOfButtons] * contentSize.height, [self width], contentSize.height)];

	[button setTitle:titleString forState:UIControlStateNormal];
	[button setTitleColor:[self fontColor] forState:UIControlStateNormal];
	[button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
	[[button titleLabel] setFont:[self font]];
	[buttons addObject:button];
	numberOfButtons = [buttons count];

	return [self numberOfButtons] - 1;
}

- (NSString*)buttonTitleAtIndex:(NSInteger)buttonIndex {
	if ([self numberOfButtons] == 0 || buttonIndex >= [self numberOfButtons]) {
		return nil;
	}
	return [[buttons objectAtIndex:buttonIndex] currentTitle];
}

- (void)dealloc {
	[title release];
	[backgroundColor release];
	[buttons release];
	[fadeColor release];
	[fontColor release];
	[font release];
	[super dealloc];
}

- (id)initWithTitle:(NSString*)titleString width:(float) viewWidth {
	self = [super init];
    if (self) {
		[self setTitle:titleString];
		[self setWidth:viewWidth];
		buttons = [[NSMutableArray alloc] init];

		[self setBackgroundColor:[UIColor whiteColor]];
		[self setFadeAlpha:.60];
		[self setFadeColor:[UIColor blackColor]];
		[self setFont:[UIFont systemFontOfSize:20]];
		[self setFontColor:[UIColor blackColor]];
		[self setWidth:320];
    }

    return self;
}

- (void)showInView:(UIView*)view {
	CGSize contentSize = [[self title] sizeWithFont:[self font]
								 constrainedToSize:CGSizeMake([self width], CGFLOAT_MAX)
									 lineBreakMode:UILineBreakModeTailTruncation];
	UILabel* leafId = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [self width], contentSize.height)];

	[leafId setText:[self title]];
	[leafId setTextColor:[self fontColor]];
	[leafId setBackgroundColor:[self backgroundColor]];
	[leafId setFont:[self font]];

	float height = leafId.frame.size.height;
	for (UIButton* button in buttons) {
		height += [button frame].size.height;
	}

	UIView* actionSheet = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self width], height)];
	actionSheet.opaque = YES;
	actionSheet.backgroundColor = [self backgroundColor];

	[actionSheet addSubview:leafId];
	for (UIButton* button in buttons) {
		CGRect frame = [button frame];
		frame.origin.x += leafId.frame.size.height;
		[button setFrame:frame];
		[actionSheet addSubview:button];
	}
	[leafId release];


	[view addSubview:actionSheet];
	[actionSheet release];
}

@end

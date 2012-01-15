#import "CustomActionSheet.h"

#define OVERLAY_TAG 9782
#define ACTION_SHEET_TAG 9783

@interface CustomActionSheet (Private)
	UIView* superView;

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event;

@property(nonatomic, retain) UIView* superView;

@end

@implementation CustomActionSheet (Private)

- (UIView*)superView {
	return superView;
}

- (void)setSuperView:(UIView*)sView {
	[[self superView] release];
	superView = [sView retain];
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
	UITouch* touch = [touches anyObject];

	if ([touch view] == [[[touch view] superview] viewWithTag:OVERLAY_TAG]) {
		[[buttons objectAtIndex:[self numberOfButtons] - 1] sendActionsForControlEvents:UIControlEventTouchUpInside];
	}
}

@end

@implementation CustomActionSheet

@synthesize backgroundColor;
@synthesize delegate;
@synthesize fadeAlpha;
@synthesize fadeColor;
@synthesize font;
@synthesize fontColor;
@synthesize numberOfButtons;
@synthesize title;
@synthesize width;

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
	[button addTarget:self action:@selector(dismissWithButton:) forEvents:UIControlEventTouchUpInside];
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

- (void)dismissWithButton:(id)sender {
	[[[self superView] viewWithTag:ACTION_SHEET_TAG] removeFromSuperview];
	[[[self superView] viewWithTag:OVERLAY_TAG] removeFromSuperview];
	[[self delegate] dismissWithButton:sender];
}

- (id)initWithTitle:(NSString*)titleString delegate:(id)actionDelegate width:(float)viewWidth {
	self = [super init];
    if (self) {
		[self setTitle:titleString];
		[self setDelegate:actionDelegate];
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
	[self setSuperView:view];
	CGSize contentSize = [[self title] sizeWithFont:[self font]
								  constrainedToSize:CGSizeMake([self width], CGFLOAT_MAX)
									  lineBreakMode:UILineBreakModeTailTruncation];
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [self width], contentSize.height)];

	[label setText:[self title]];
	[label setTextColor:[self fontColor]];
	[label setBackgroundColor:[self backgroundColor]];
	[label setFont:[self font]];

	float height = [label frame].size.height;
	for (UIButton* button in buttons) {
		height += [button frame].size.height;
	}

	UIView* actionSheet = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self width], height)];
	[actionSheet setOpaque:YES];
	[actionSheet setBackgroundColor:[self backgroundColor]];
	[actionSheet setTag:ACTION_SHEET_TAG];

	[actionSheet addSubview:label];
	for (UIButton* button in buttons) {
		CGRect frame = [button frame];
		frame.origin.x += [label frame].size.height;
		[button setFrame:frame];
		[actionSheet addSubview:button];
	}
	[label release];

	TouchView* overlay = [[TouchView alloc] initWithFrame:[view frame] delegate:self];
	[overlay setOpaque:NO];
	[overlay setBackgroundColor:[self fadeColor]];
	[overlay setAlpha:[self fadeAlpha]];
	[overlay setUserInteractionEnabled:YES];
	[overlay setTag:OVERLAY_TAG];
	[view addSubview:overlay];

	[view addSubview:actionSheet];
	[actionSheet release];
}

@end

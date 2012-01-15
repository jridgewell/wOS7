#import "CustomActionSheet.h"

#define OVERLAY_TAG 9782
#define ACTION_SHEET_TAG 9783

@interface CustomActionSheet (Private)

- (void)animationDidStop:(NSString*)animationID finished:(NSNumber*)finished context:(void*)context;
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event;

@end

@implementation CustomActionSheet (Private)

- (void)animationDidStop:(NSString*)animationID finished:(NSNumber*)finished context:(void*)context {
	[[[self superView] viewWithTag:ACTION_SHEET_TAG] removeFromSuperview];
	[[[self superView] viewWithTag:OVERLAY_TAG] removeFromSuperview];
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
	UITouch* touch = [touches anyObject];

	if ([touch view] == [[self superView] viewWithTag:OVERLAY_TAG]) {
		[[buttons objectAtIndex:[self numberOfButtons] - 1] sendActionsForControlEvents:UIControlEventTouchUpInside];
	}
}

@end

@implementation CustomActionSheet

@synthesize backgroundColor;
@synthesize buttonPaddingX;
@synthesize buttonPaddingY;
@synthesize delegate;
@synthesize fadeAlpha;
@synthesize fadeColor;
@synthesize font;
@synthesize fontColor;
@synthesize numberOfButtons;
@synthesize superView;
@synthesize title;
@synthesize titleFont;
@synthesize titleFontColor;
@synthesize titlePaddingX;
@synthesize titlePaddingY;
@synthesize width;

- (NSInteger)addButtonWithTitle:(NSString*)titleString {
	UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];

	CGSize contentSize = [titleString sizeWithFont:[self font]
								 constrainedToSize:CGSizeMake([self width], CGFLOAT_MAX)
									 lineBreakMode:UILineBreakModeTailTruncation];
	[button setFrame:CGRectMake(0,
								0,
								[self width],
								(contentSize.height + ([self buttonPaddingY] * 2)))];
	[button setTitle:titleString forState:UIControlStateNormal];
	[button setTitleEdgeInsets:UIEdgeInsetsMake(0, [self buttonPaddingX], 0, 0)];
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
	[buttons release];
	[backgroundColor release];
	[delegate release];
	[fadeColor release];
	[font release];
	[fontColor release];
	[superView release];
	[title release];
	[titleFont release];
	[titleFontColor release];

	[super dealloc];
}

- (void)dismissWithButton:(id)sender {
	UIView* actionSheet = [[self superView] viewWithTag:ACTION_SHEET_TAG];
	UIView* overlay = [[self superView] viewWithTag:OVERLAY_TAG];

	MARK
	CMLog(@"%@", actionSheet);
	CMLog(@"%@", overlay);

	CGRect frame = actionSheet.frame;
	frame.size = CGSizeMake(frame.size.width, 0);

	[UIView beginAnimations:@"dismissActionSheet" context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	[actionSheet setFrame:frame];
	[overlay setAlpha:.00];
	[UIView commitAnimations];

	[[self delegate] dismissActionSheet:self withButtonIndex:[buttons indexOfObject:sender]];
}

- (id)initWithTitle:(NSString*)titleString delegate:(id)actionDelegate width:(float)viewWidth {
	self = [super init];
    if (self) {
		[self setTitle:titleString];
		[self setDelegate:actionDelegate];
		[self setWidth:viewWidth];
		buttons = [[NSMutableArray alloc] init];

		[self setBackgroundColor:[UIColor whiteColor]];
		[self setButtonPaddingX:15];
		[self setButtonPaddingY:7];
		[self setFadeAlpha:.60];
		[self setFadeColor:[UIColor blackColor]];
		[self setFont:[UIFont systemFontOfSize:18]];
		[self setFontColor:[UIColor blackColor]];
		[self setTitleFont:[UIFont systemFontOfSize:14]];
		[self setTitleFontColor:[UIColor grayColor]];
		[self setTitlePaddingX:5];
		[self setTitlePaddingY:5];
    }

    return self;
}

- (void)showInView:(UIView*)view atPoint:(CGPoint)point {
	[self setSuperView:view];
	CGSize contentSize = [[self title] sizeWithFont:[self font]
								  constrainedToSize:CGSizeMake([self width], CGFLOAT_MAX)
									  lineBreakMode:UILineBreakModeTailTruncation];
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake([self titlePaddingX],
															   [self titlePaddingY],
															   ([self width] - ([self titlePaddingX] * 2)),
															   (contentSize.height + [self titlePaddingY]))];
	[label setText:[self title]];
	[label setTextColor:[self titleFontColor]];
	[label setBackgroundColor:[UIColor clearColor]];
	[label setFont:[self titleFont]];

	float yLoc = point.y;
	UIView* actionSheet = [[UIView alloc] initWithFrame:CGRectMake(0, yLoc, [self width], 0)];
	[actionSheet setOpaque:YES];
	[actionSheet setBackgroundColor:[self backgroundColor]];
	[actionSheet setTag:ACTION_SHEET_TAG];
	[actionSheet setClipsToBounds:YES];

	[actionSheet addSubview:label];

	CGRect frame = [label frame];
	float y = (frame.origin.y + frame.size.height);
	for (UIButton* button in buttons) {
		frame = [button frame];
		frame.origin = CGPointMake(0, y);
		[button setFrame:frame];
		[actionSheet addSubview:button];
		y += frame.size.height;
	}
	[label release];

	TouchView* overlay = [[TouchView alloc] initWithFrame:[view frame] delegate:self];
	[overlay setOpaque:NO];
	[overlay setAlpha:.00];
	[overlay setBackgroundColor:[self fadeColor]];
	[overlay setUserInteractionEnabled:YES];
	[overlay setTag:OVERLAY_TAG];

	[view addSubview:overlay];
	[view addSubview:actionSheet];

	if (yLoc + y > [view frame].size.height) {
		yLoc -= y;
	}
	[UIView beginAnimations:@"showActionSheet" context:nil];
	[actionSheet setFrame:CGRectMake(0, yLoc, [self width], y)];
	[overlay setAlpha:[self fadeAlpha]];
	[UIView commitAnimations];


	[actionSheet release];
	[overlay release];
}

@end

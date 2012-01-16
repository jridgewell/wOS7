#import "WOS7CustomActionSheet.h"

@interface WOS7CustomActionSheet (Private)
- (void)animationDidStop:(NSString*)animationID finished:(NSNumber*)finished context:(void*)context;
- (void)dismissActionSheet:(id)actionSheet withButtonIndex:(NSInteger)buttonIndex;
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event;
@end

@implementation WOS7CustomActionSheet (Private)
- (void)animationDidStop:(NSString*)animationID finished:(NSNumber*)finished context:(void*)context {
	[actionSheet removeFromSuperview];
	[overlay removeFromSuperview];
}
- (void)dismissActionSheet:(id)actionSheet withButtonIndex:(NSInteger)buttonIndex {
}
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
	UITouch* touch = [touches anyObject];
	if ([touch view] == overlay) {
		[[buttons objectAtIndex:[self numberOfButtons] - 1] sendActionsForControlEvents:UIControlEventTouchUpInside];
	}
}
@end

@implementation WOS7CustomActionSheet

@synthesize actionSheet;
@synthesize backgroundColor;
@synthesize buttonPaddingX;
@synthesize buttonPaddingY;
@synthesize delegate;
@synthesize fadeAlpha;
@synthesize fadeColor;
@synthesize font;
@synthesize fontColor;
@synthesize numberOfButtons;
@synthesize overlay;
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
	[button addTarget:self action:@selector(dismissWithButton:) forControlEvents:UIControlEventTouchUpInside];
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

	[actionSheet release];
	[overlay release];

	[super dealloc];
}

- (void)dismissWithButton:(id)sender {
	CGRect frame = actionSheet.frame;
	frame.size = CGSizeMake(frame.size.width, 0);

	[UIView beginAnimations:@"dismissActionSheet" context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	[actionSheet setFrame:frame];
	[overlay setAlpha:0];
	[UIView commitAnimations];

	if ([[self delegate] respondsToSelector:@selector(dismissActionSheet:withButtonIndex:)]) {
		[[self delegate] dismissActionSheet:self withButtonIndex:[buttons indexOfObject:sender]];
	}
}

- (id)initWithTitle:(NSString*)titleString delegate:(id)actionDelegate width:(CGFloat)viewWidth {
	self = [super init];
    if (self) {
		[self setTitle:titleString];
		[self setDelegate:actionDelegate];
		[self setWidth:viewWidth];
		buttons = [[NSMutableArray alloc] init];

		[self setBackgroundColor:[UIColor whiteColor]];
		[self setButtonPaddingX:15];
		[self setButtonPaddingY:7];
		[self setFadeAlpha:(CGFloat).60];
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

	CGFloat yLoc = point.y;
	actionSheet = [[UIView alloc] initWithFrame:CGRectMake((([[self superView] frame].size.width - [self width]) / 2),
														   yLoc,
														   [self width],
														   0)];
	[actionSheet setOpaque:YES];
	[actionSheet setBackgroundColor:[self backgroundColor]];
	[actionSheet setClipsToBounds:YES];

	[actionSheet addSubview:label];

	CGRect frame = [label frame];
	CGFloat y = (frame.origin.y + frame.size.height);
	for (UIButton* button in buttons) {
		frame = [button frame];
		frame.origin = CGPointMake(0, y);
		[button setFrame:frame];
		[actionSheet addSubview:button];
		y += frame.size.height;
	}
	[label release];

	overlay = [[WOS7TouchView alloc] initWithFrame:[view frame] delegate:self];
	[overlay setOpaque:NO];
	[overlay setAlpha:0];
	[overlay setBackgroundColor:[self fadeColor]];
	[overlay setUserInteractionEnabled:YES];

	[view addSubview:overlay];
	[view addSubview:actionSheet];

	if (yLoc + y > [view frame].size.height) {
		yLoc -= y;
	}
	[UIView beginAnimations:@"showActionSheet" context:nil];
	[actionSheet setFrame:CGRectMake([actionSheet frame].origin.x, yLoc, [self width], y)];
	[overlay setAlpha:[self fadeAlpha]];
	[UIView commitAnimations];


	[actionSheet release];
	[overlay release];
}

@end

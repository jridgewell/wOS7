#import <UIKit/UIView.h>

@interface WOS7TouchView : UIView {
	id delegate;
}
@property(nonatomic, retain) id delegate;

- (WOS7TouchView*)initWithFrame:(CGRect)rect delegate:(id)touchDelegate;
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event;

@end
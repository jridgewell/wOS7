@interface WOS7ScrollView : UIScrollView <UIScrollViewDelegate> {
	NSObject* parent;
	SEL target;
}
@property(nonatomic, retain) NSObject* parent;
@property(nonatomic) SEL target;


- (WOS7ScrollView*)initWithFrame:(CGRect)rect target:(SEL)scrollTarget parent:(NSObject*)targetParent;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

@end

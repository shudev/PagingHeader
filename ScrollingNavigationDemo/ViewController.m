

#import "ViewController.h"
#define LABEL_SPACING 30.0f

@interface ViewController ()<UIScrollViewDelegate>{
    UIFont *labelFont;
    UIColor *selectedLabelColor;
    UIColor *unselectedLabelColor;
}

//---for swipeable navigation---
@property (nonatomic, retain) NSMutableArray *navigationTitles;
@property (nonatomic, retain) NSMutableArray *navigationLabels;
@property (nonatomic, retain) NSMutableArray *centerPoints;
@property (nonatomic) NSUInteger selectedLabelIndex;

@end

@implementation ViewController

- (void)viewDidLoad
{
    if(1){
        [self setupPagingView];
    } else {
        [self removePagingView];
    }
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - paging header view

- (IBAction)nextPage:(id)sender {
    if( _selectedLabelIndex < _navigationTitles.count - 1  ){
        [self switchToLabelWithNumber:_selectedLabelIndex+1];
    }
}

- (IBAction)previousPage:(id)sender {
    if( _selectedLabelIndex > 0 ){
        [self switchToLabelWithNumber:_selectedLabelIndex-1];
    }
}

-(void)didChangePage:(NSUInteger)index{
    
    NSLog(@"index:%d",index);
    _selectedLabel.text = [self.navigationTitles objectAtIndex:self.selectedLabelIndex];
    
    
}

-(void)setupPagingView{

    labelFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0f];
    selectedLabelColor = [UIColor whiteColor];
    unselectedLabelColor = [UIColor lightTextColor];
    self.navigationTitles = [[NSMutableArray alloc] initWithObjects:@"  1  ",@"  2  ",@"  3  ", @"  4  ", nil];
    _selectedLabel.text = [self.navigationTitles objectAtIndex:self.selectedLabelIndex];

    _navigationScrollView.delegate = self;
    _navigationScrollView.showsHorizontalScrollIndicator = NO;
    _navigationScrollView.showsVerticalScrollIndicator = NO;
    _navigationScrollView.decelerationRate=UIScrollViewDecelerationRateFast;
    [self.view addSubview:_navigationScrollView];
    
    _navigationScrollView.backgroundColor = [UIColor clearColor];
    _navigationScrollView.clipsToBounds = YES;
    
    NSLog(@"_navigationTitles count = %d",[_navigationTitles count]);
    [self setupNavigationWithTitles:_navigationTitles];
    _selectedLabelIndex = 0;
}

-(void)removePagingView{
    
}

-(void) setupNavigationWithTitles:(NSMutableArray*)titles{
    
    if (_navigationLabels == nil) {
        _navigationLabels = [[NSMutableArray alloc] init];
    } else {
        for (UILabel *label in _navigationLabels) {
            [label removeFromSuperview];
        }
        [_navigationLabels removeAllObjects];
    }
    
    //[_navigationScrollView setContentSize:CGSizeMake(320, 44)];
    
    int i = 0;
    
    for (NSString *accountName in titles) {
        UILabel *label = [self getLabelForNavigationScrollViewWithName:accountName];
        label.tag = i;
        UITapGestureRecognizer *tapGestureForLabel = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedOnLabel:)];
        
        [label addGestureRecognizer:tapGestureForLabel];
        [_navigationLabels addObject:label];
        i++;
    }
    
    UILabel *firstLabel = [_navigationLabels objectAtIndex:0];
    CGFloat firstLabelWidth = firstLabel.frame.size.width;
    CGFloat xPosition = _navigationScrollView.frame.size.width/2 - (firstLabelWidth/(2.0f));
    CGFloat previousLabelWidth = firstLabelWidth;
    
    if (_centerPoints == nil) {
        _centerPoints = [[NSMutableArray alloc] init];
    } else {
        [_centerPoints removeAllObjects];
    }
    
    for (UILabel *label in _navigationLabels) {
        
        [self.navigationScrollView setContentSize:CGSizeMake(xPosition+_navigationScrollView.frame.size.width/2+(label.frame.size.width/(2.0f)), 44)];
        label.frame = CGRectMake(xPosition, 10, label.frame.size.width, label.frame.size.height);
        NSNumber *centerPoint = [NSNumber numberWithDouble:xPosition+(label.frame.size.width/(2.0f))];
        previousLabelWidth = label.frame.size.width;
        xPosition = previousLabelWidth + LABEL_SPACING + xPosition;
        [_centerPoints addObject:centerPoint];
        [_navigationScrollView addSubview:label];
    }
    [self switchToLabelWithNumber:_selectedLabelIndex];
    
}

-(UILabel *) getLabelForNavigationScrollViewWithName:(NSString *)name{
    
    UILabel *label = [[UILabel alloc] init];
    [label setFont:labelFont];
    label.text = name;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = unselectedLabelColor;
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    
    CGFloat labelWidth = label.frame.size.width;
    CGFloat mod = fmodf(labelWidth, 2.0f);
    
    NSLog(@"label width and mod = %f & %f", labelWidth, mod);
    
    if (mod > 0.0f) {
        labelWidth = labelWidth + 1.0f;
        label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, labelWidth, label.frame.size.height);
    }
    [label setUserInteractionEnabled:YES];
    
    return label;
}


// ページングヘッダーを指定ページに移動
-(void) switchToLabelWithNumber:(int)activeLabelNo{
    NSLog(@"switchToAccountWithNumber");
    if (activeLabelNo != _selectedLabelIndex) {
        UILabel *oldCenterLabel = [_navigationLabels objectAtIndex:_selectedLabelIndex];
        oldCenterLabel.textColor = unselectedLabelColor;
    }
    UILabel *centerLabel = [_navigationLabels objectAtIndex:activeLabelNo];
    centerLabel.textColor = selectedLabelColor;
    
    CGFloat centerPoint = [[_centerPoints objectAtIndex:activeLabelNo] floatValue];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [_navigationScrollView setContentOffset:CGPointMake((centerPoint - _navigationScrollView.frame.size.width/2), _navigationScrollView.frame.origin.y) animated:NO];
    
    [UIView commitAnimations];
    _selectedLabelIndex = activeLabelNo;
    [self didChangePage:_selectedLabelIndex];
}


// ページングヘッダービューがスクロールされたときに位置を調整
-(void)autoPositionAdjustingTo:(UIScrollView *)scrollView{
    
    NSLog(@"autoPositionAdjustingTo");
    CGFloat positionOfX = _navigationScrollView.contentOffset.x;
    CGFloat centerPoint = positionOfX + _navigationScrollView.frame.size.width/2;
    
    CGFloat endPosition = [[_centerPoints lastObject] floatValue];
    
    if (centerPoint <= _navigationScrollView.frame.size.width/2) {
        [self switchToLabelWithNumber:0];
    } else if (centerPoint >= endPosition){
        [self switchToLabelWithNumber:([_navigationLabels count]-1)];
    } else{
        for (int i = 0; i < ([_centerPoints count]-1); i++) {
            CGFloat point = [[_centerPoints objectAtIndex:i] floatValue];
            CGFloat nextPoint = [[_centerPoints objectAtIndex:i+1] floatValue];
            
            if (point <= centerPoint && centerPoint <= nextPoint) {
                CGFloat l = centerPoint - point;
                CGFloat r = nextPoint - centerPoint;
                int centerAccount;
                
                if (l < r) {
                    centerAccount = i;
                } else {
                    centerAccount = i+1;
                }
                [self switchToLabelWithNumber:centerAccount];
                break;
            }
        }
    }
    
}

// 指定ページのラベルがタップされた
-(void)tappedOnLabel:(UITapGestureRecognizer *)tapGesture{
    
    UIView *labelView = tapGesture.view;
    int tag = labelView.tag;
    NSLog(@"tappedOnLabel tag = %d", tag);
    [self switchToLabelWithNumber:tag];
}


#pragma mark - UIScrollView delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"scrollViewWillBeginDragging:willDecelerate");
    if(scrollView == _navigationScrollView){
        UILabel *centerLabel = [_navigationLabels objectAtIndex:_selectedLabelIndex];
        centerLabel.textColor = unselectedLabelColor;
        
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSLog(@"scrollViewDidEndDragging:willDecelerate");
    if (scrollView == _navigationScrollView) {
        if (!decelerate) {
            [self autoPositionAdjustingTo:scrollView];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"scrollViewDidEndDecelerating");
    if (scrollView == _navigationScrollView) {
        [self autoPositionAdjustingTo:scrollView];
    }
}


- (void)viewDidUnload {
    [self setNavigationScrollView:nil];
    [super viewDidUnload];
}

@end
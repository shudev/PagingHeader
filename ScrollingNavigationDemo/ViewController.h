

#import <UIKit/UIKit.h>


@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *selectedLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *navigationScrollView;

- (IBAction)nextPage:(id)sender;
- (IBAction)previousPage:(id)sender;

@end

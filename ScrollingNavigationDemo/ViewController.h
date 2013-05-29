

#import <UIKit/UIKit.h>


@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *selectedLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *navigationScrollView;

- (IBAction)nextPage:(id)sender;
- (IBAction)previousPage:(id)sender;

@end

/*
 
 http://morishin127.tumblr.com/
 
 ボタンの画像変更などのViewの変更はメソッドが呼ばれると同時にされているわけじゃないみたい。
 メソッドが呼ばれて直ちに反映されてほしいときは
[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.05]];

を使うといいかも。例えば

 [button1 setImage:image1 forState:UIControlStateNormal];
 [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.05]];

 のように書けばすぐに変更が画面に反映されるようになる。
 詳しい仕組みはわからないけど。
 スマートじゃないかも。応急処置的な。
*/


/*
 
 setNeedsDisplay uiview
 
 */

/*
 
 UIViewをdrawRectが呼ばれない。
 なんで？
 ってしらべたら
 表示対象のUIViewがhiddennだったり表示エリアになかったり幅0pxだと動かないみたい。
 勉強になりました
 
 setNeedsDisplay
 メソッド
 で再レンダリングを予約できます
 
 参考サイト
 http://msmori.blogspot.jp/2011/01/drawrect.html
 
 参考サイト
 http://blog.f60k.com/uiview_drawrect_setneedsdisplay/
 
 */


/*
 
 http://blog.f60k.com/uiview_drawrect_setneedsdisplay/*/



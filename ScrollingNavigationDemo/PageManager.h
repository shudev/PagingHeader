#import <Foundation/Foundation.h>


@interface PageManager : NSObject

-(void)addObjectForCurrentPage:(NSString*)test;
-(void)changeCurrentPage:(NSInteger)index;
-(NSMutableDictionary*)pageDataForCurrentPage;
-(void)removeAllForCurrentPage;

@end
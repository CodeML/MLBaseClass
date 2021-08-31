

#import <UIKit/UIKit.h>
#import "MLBaseCellModel.h"
#import "MLBaseTableViewSectionModel.h"
#import "MLBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class MLBaseTableViewCell;
@interface MLBaseViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign) BOOL isSectionModel;
@property (nonatomic, assign) UIStatusBarStyle style;
@property (nonatomic, copy) void (^callBackBlock)(NSDictionary *parma);
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL hasFooter;
@property (nonatomic, strong) id parma;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) BOOL shadow;
@property (nonatomic, assign) BOOL backArrow;


- (void)loadData;
- (void)loadMore;
- (void)setupTableView:(UITableView *)tableView;
- (void)setupCell:(MLBaseTableViewCell *)cell;

//***********Nav************
- (void)push:(NSObject *)vc;
- (void)push:(NSObject *)vc parma:(id)parma;
- (void)push:(NSObject *)vc parma:(id)parma title:(NSString *)title;
- (void)pop;
- (void)popTo:(NSString *)classStr;
@end

NS_ASSUME_NONNULL_END



#import <UIKit/UIKit.h>
#import "SCCNavigationController.h"
#import "MLBaseClass.h"
#import "MLExtension.h"
#import <MJRefresh/MJRefresh.h>
#import "heads.h"
#import "SCCRequest.h"
#import "SCCCustomNavigationBar.h"
//#import "SCCRouterConst.h"
#import "SCCNoDataView.h"

NS_ASSUME_NONNULL_BEGIN

@class MLBaseTableViewCell;
@interface MLBaseViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

typedef void (^SCCCallBackBlock)(NSDictionary *parma);

@property (nonatomic, strong) SCCCustomNavigationBar *navigationBar;
@property (nonatomic, assign) BOOL isSectionModel;
@property (nonatomic, assign) UIStatusBarStyle style;
@property (nonatomic, copy) SCCCallBackBlock callBackBlock;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIColor *navBarColor;
@property (nonatomic, assign) BOOL hasFooter;
@property (nonatomic, strong) id parma;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger totalPage;
@property (nonatomic, assign) BOOL shadow;
@property (nonatomic, assign) BOOL backArrow;
@property (nonatomic, strong) UIView *noData;

- (void)loadData;
- (void)loadMore;
- (void)setupTableView:(UITableView *)tableView;
- (void)setupCell:(MLBaseTableViewCell *)cell;
- (void)showToast:(NSString *)msg;

//***********Nav************
- (void)push:(NSObject *)vc;
- (void)push:(NSObject *)vc parma:(id)parma;
- (void)push:(NSObject *)vc parma:(id)parma title:(NSString *)title;
- (void)pop;
- (void)popTo:(NSString *)classStr;

//***********request************
- (id)resultDeconstructor:(id)response;
- (NSMutableArray *)modelArrayFrom:(NSDictionary *)data modelName:(NSString *)modelName;
- (void)recordsParsing:(NSDictionary *)data modelName:(NSString *)modelName;
- (void)recordsParsing:(NSDictionary *)data modelName:(NSString *)modelName section:(void(^)(MLBaseTableViewSectionModel *section))setupSection;
@end

NS_ASSUME_NONNULL_END

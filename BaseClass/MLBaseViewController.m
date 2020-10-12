

#import "MLBaseViewController.h"
#import "MLBaseTableViewCell.h"
#import <Objc/Runtime.h>
#import "heads.h"
#import "MLExtension.h"
//#import <UMAnalytics/MobClick.h>

@interface MLBaseViewController ()
@property (nonatomic, strong) UIView *noData;
@property (nonatomic, assign) BOOL isFirstVC;
@end

@implementation MLBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.page = 1;
    self.backArrow = YES;
    [self backNoText];
    
    if (@available(iOS 11.0, *)) {
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationController.navigationBar.tintColor = UIColor.black3;
    [self loadData];
}

- (void)setBackArrow:(BOOL)backArrow {
    _backArrow = backArrow;
    
    if (_backArrow) {
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"header_back_icon" target:self action:@selector(pop)];
    }else{
        self.navigationItem.leftBarButtonItem = nil;
    }
}

- (void)setShadow:(BOOL)shadow {
    _shadow = shadow;
    [self.navigationController.navigationBar addShadow];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    IKNetworking.manager.tableView = _tableView;
    if (_shadow) {
        [self.navigationController.navigationBar addShadow];
    }
    // 页面统计
//    [MobClick beginLogPageView:NSStringFromClass(self.class)];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_shadow) {
        [self.navigationController.navigationBar deleteShadow];
    }
//    [MobClick endLogPageView:NSStringFromClass(self.class)];
}

#pragma mark - nav
- (void)backNoText {
    UIBarButtonItem *backBtn = [UIBarButtonItem new];
    backBtn.title = @"";
    self.navigationItem.backBarButtonItem = backBtn;
}

- (void)setStyle:(UIStatusBarStyle)style {
    objc_setAssociatedObject(self, @selector(style), @(style), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (style) {
        self.navigationController.navigationBar.hidden = YES;
//        [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    }else{
        self.navigationController.navigationBar.hidden = NO;
//        [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    }
}

- (void)setHasFooter:(BOOL)hasFooter {
    _hasFooter = hasFooter;
    
    if (hasFooter) {
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            self.page ++;
            [self loadMore];
        }];
        [footer setTitle:@"" forState:(MJRefreshStateIdle)];
        self.tableView.mj_footer = footer;
    }else{
        self.tableView.mj_footer = nil;
    }
}

- (UIStatusBarStyle)style {
    id objc = objc_getAssociatedObject(self, @selector(style));
    if (!objc) {
        objc = @(UIStatusBarStyleDefault);
    }
    return (UIStatusBarStyle)objc;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.style;
}

- (void)push:(NSObject *)vc {
    [self push:vc parma:@{}];
}

- (void)push:(NSObject *)vc parma:(id)parma title:(NSString *)title {
    MLBaseViewController *contro = nil;
    @try {
        if ([vc isKindOfClass:NSString.class]) {
            contro = [NSClassFromString((NSString *)vc) new];
            if (!contro) {
                @throw [NSException exceptionWithName:NSStringFromClass(self.class) reason:[NSString stringWithFormat:@"%@控制器不存在", vc] userInfo:nil];
            }
        }else if ([vc isKindOfClass:UIViewController.class]) {
            contro = (MLBaseViewController *)vc;
        }else{
            @throw [NSException exceptionWithName:@"错误" reason:@"push错误类型" userInfo:nil];
        }
    } @catch (NSException *exception) {
        NSLog(@"%@-->%@", exception.name, exception);
        // error page
        contro = MLBaseViewController.new;
    } @finally {
        if (parma && [contro isKindOfClass:MLBaseViewController.class]) {
            contro.parma = parma;
        }
        
        if (title.length) {
            contro.title = title;
        }
        
        self.navigationController.navigationBar.hidden = NO;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:contro animated:YES];
        if (self.isFirstVC) {
            self.hidesBottomBarWhenPushed = NO;
        }
    }
}

- (void)push:(NSObject *)vc parma:(id)parma {
    [self push:vc parma:parma title:@""];
}

- (void)popTo:(NSString *)classStr {
    for (MLBaseViewController *vc in self.navigationController.viewControllers) {
        if ([NSStringFromClass(vc.class) isEqualToString:classStr]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
}

- (void)pop {
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (BOOL)isFirstVC {
    return [self.navigationController.viewControllers.firstObject isEqual:self];
}

#pragma mark - UI
- (void)loadData {}
- (void)loadMore {
    if (self.tableView.mj_footer.state == MJRefreshStateNoMoreData && self.page > 1) {
        return;
    }
    [self loadData];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@ is dealloc", NSStringFromClass(self.class));
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count = self.dataArray.count;
    return _isSectionModel ? count : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *cells = _dataArray;
    if (_isSectionModel) {
        cells = [(MLBaseTableViewSectionModel *)self.dataArray[section] cellModels];
    }
    return cells.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!self.dataArray.count) {
        return UITableViewCell.new;
    }
    
    MLBaseCellModel *model = [self getModel:indexPath];

    MLBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:model.cellName];
    if (!cell) {
        cell = [[NSClassFromString(model.cellName) alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:model.cellName];
    }
    cell.indexPath = indexPath;
    cell.cellModel = model;
    [self setupCell:cell];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_isSectionModel) {
        return [(MLBaseTableViewSectionModel *)self.dataArray[section] headH];
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (_isSectionModel) {
        return [(MLBaseTableViewSectionModel *)self.dataArray[section] headView];
    }
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (_isSectionModel) {
        return [(MLBaseTableViewSectionModel *)self.dataArray[section] footH];
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (_isSectionModel) {
        return [(MLBaseTableViewSectionModel *)self.dataArray[section] footView];
    }
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!self.dataArray.count) {
        return CELLH;
    }
    
    MLBaseCellModel *model = [self getModel:indexPath];
    return model.cellHeight ? : CELLH;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    MLBaseCellModel *model = [self getModel:indexPath];
//    if (model.actionBlock) {
//        model.actionBlock(indexPath);
//    }
//}

- (MLBaseCellModel *)getModel:(NSIndexPath *)indexPath {
    MLBaseCellModel *model = nil;
    if (_isSectionModel) {
        model = [(MLBaseTableViewSectionModel *)self.dataArray[indexPath.section] cellModels][indexPath.row];
    }else{
        model = self.dataArray[indexPath.row];
    }
    return model;
}

#pragma mark - lazy
- (void)setupCell:(MLBaseTableViewCell *)cell {}

- (void)setupTableView:(UITableView *)tableView {}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, self.view.height_ml - NAV_BAR_H) style:(UITableViewStyleGrouped)];
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [_tableView registerClass:MLBaseTableViewCell.class forCellReuseIdentifier:@"BaseTableViewCell"];
        [self setupTableView:_tableView];
        [self.view addSubview:_tableView];
        
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self.page = 1;
            [self loadData];
        }];
    }
    return _tableView;
}

#pragma mark - data

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }else if (_dataArray.count) {
        if ([_dataArray.firstObject isKindOfClass:MLBaseTableViewSectionModel.class]) {
            _isSectionModel = YES;
//            for (MLBaseTableViewSectionModel *section in _dataArray) {
//                NSArray *arr = section.cellModels;
//                if ([arr.lastObject isKindOfClass:MLBaseCellModel.class]) {
//                    MLBaseCellModel *model = arr.lastObject;
//                    model.showLine = NO;
//                }
//            }
        }else{
            _isSectionModel = NO;
//            if ([_dataArray.lastObject isKindOfClass:MLBaseCellModel.class]) {
//                MLBaseCellModel *model = _dataArray.lastObject;
//                model.showLine = NO;
//            }
        }
    }
    return _dataArray;
}

@end

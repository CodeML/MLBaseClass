

#import "MLBaseViewController.h"
#import "MLBaseTableViewCell.h"
#import <Objc/Runtime.h>
#import <Toast/Toast.h>

//#import <UMAnalytics/MobClick.h>

@interface MLBaseViewController ()

@property (nonatomic, assign) BOOL isFirstVC;

@end

@implementation MLBaseViewController
@synthesize dataArray = _dataArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.page = 1;
    self.backArrow = YES;
    [self backNoText];
    
    self.view.backgroundColor = UIColor.whiteColor;
//    self.navigationController.navigationBar.tintColor = UIColor.black3;
    
    self.navigationController.navigationBarHidden = YES;
//    self.navigationBar.hidden = NO;
    
    [self loadData];
}

- (void)setNavBarColor:(UIColor *)navBarColor {
    _navBarColor = navBarColor;
    self.navigationBar.backgroundColor = navBarColor;
//    if (@available(iOS 15.0, *)) {
//        UINavigationBarAppearance *appearance = UINavigationBarAppearance.new;
//        appearance.backgroundColor = navBarColor;
//        appearance.shadowColor = UIColor.clearColor;
//        appearance.backgroundEffect = nil;
//        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
//        UIApplication.sharedApplication.keyWindow.backgroundColor = navBarColor;
//    }else{
//        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:navBarColor] forBarMetrics:UIBarMetricsDefault];
//    }
}

- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    
    self.navigationBar.titleLab.text = title;
}

- (void)setNoData:(UIView *)noData {
    _noData = noData;
    _noData.hidden = YES;
    if (_tableView) {
        _tableView.backgroundView = noData;
    }else{
        [self.view insertSubview:noData atIndex:0];
    }
}

- (void)setBackArrow:(BOOL)backArrow {
    _backArrow = backArrow;
    _navigationBar.backBtn.hidden = !_backArrow;
//    if (_backArrow) {
//        self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"header_back_icon" target:self action:@selector(pop)];
//    }else{
//        self.navigationItem.leftBarButtonItem = nil;
//    }
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
}

- (void)setHasFooter:(BOOL)hasFooter {
    _hasFooter = hasFooter;
    
    if (hasFooter) {
        weakify(self)
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            strongify(self)
            if (self.page == self.totalPage) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self loadMore];
            }
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
    if ([vc isKindOfClass:NSString.class] && [(NSString *)vc containsString:@"method://"]) {
        NSString *url = (NSString *)vc;
        if ([SCCModule canOpenURL:url]) {
            [SCCModule openURL:url];
        }
    }else{
        [self push:vc parma:@{}];
    }
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
        
//        if ([contro isKindOfClass:MLBaseViewController.class]) {
//            self.navigationController.navigationBarHidden = false;
//        }
        self.hidesBottomBarWhenPushed = true;
        [self.navigationController pushViewController:contro animated:true];
        if (self.isFirstVC) {
            self.hidesBottomBarWhenPushed = false;
        }
    }
}

- (void)push:(NSObject *)vc parma:(id)parma {
    [self push:vc parma:parma title:@""];
}

- (void)popTo:(NSString *)classStr {
    [self.navigationController.viewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(__kindof UIViewController * _Nonnull vc, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([NSStringFromClass(vc.class) isEqualToString:classStr]) {
            [self.navigationController popToViewController:vc animated:YES];
            *stop = YES;
        }
    }];
}

- (void)pop {
    if (self.presentingViewController && ![self.presentingViewController.presentedViewController isKindOfClass:UINavigationController.class]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (BOOL)isFirstVC {
    return [self.navigationController.viewControllers.firstObject isEqual:self];
}

#pragma mark - UI
/**
 主要用作tableview数据请求，footer loadMore会触发该网络请求
*/
- (void)loadData {}

- (void)loadMore {
    if (_totalPage) {
        self.page ++;
        [self loadData];
    }else{
        [self.tableView.mj_footer resetNoMoreData];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)showToast:(NSString *)msg
{
    [self.view makeToast:msg duration:1 position:CSToastPositionCenter];
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
    if (!self.dataArray.count) {
        return 0.01;
    }
    if (_isSectionModel) {
        return [(MLBaseTableViewSectionModel *)self.dataArray[section] headH];
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (!self.dataArray.count) {
        return UIView.new;
    }
    if (_isSectionModel) {
        return [(MLBaseTableViewSectionModel *)self.dataArray[section] headView];
    }
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (!self.dataArray.count) {
        return 0.01;
    }
    if (_isSectionModel) {
        return [(MLBaseTableViewSectionModel *)self.dataArray[section] footH];
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (!self.dataArray.count) {
        return UIView.new;
    }
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
    return model.cellHeight;
}

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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAV_BAR_H, SCREENW, self.view.height_ml - NAV_BAR_H) style:(UITableViewStyleGrouped)];
        _tableView.contentInsetAdjustmentBehavior = NO;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = false;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:MLBaseTableViewCell.class forCellReuseIdentifier:@"MLBaseTableViewCell"];
        
        weakify(self)
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            strongify(self)
            self.page = 1;
            [self loadData];
            if (self.hasFooter) {
                self.tableView.mj_footer.state = MJRefreshStateIdle;
            }
        }];
        
        [self setupTableView:_tableView];
        [self.view addSubview:self.noData];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (SCCCustomNavigationBar *)navigationBar {
    if (!_navigationBar) {
        _navigationBar = [SCCCustomNavigationBar new];
        _navigationBar.titleLab.text = @"";
        [self.view addSubview:_navigationBar];
        weakify(self)
        _navigationBar.handleBackBlock = ^(UIButton * _Nonnull button) {
            strongify(self)
            [self pop];
        };
        
        [_navigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.trailing.mas_equalTo(self.view);
            make.height.mas_equalTo(SCC_TopBar_Height);
        }];
    }
    return _navigationBar;
}

#pragma mark - data
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    } else if (_dataArray.count) {
        if ([_dataArray.firstObject isKindOfClass:MLBaseTableViewSectionModel.class]) {
            _isSectionModel = YES;
        } else {
            _isSectionModel = NO;
        }
    }
    
    return _dataArray;
}

- (void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    _noData.hidden = _dataArray.count;
}

- (id)resultDeconstructor:(id)response {
    NSDictionary *dict = response[@"result"] ?: @{};
    NSInteger code = [response[@"code"] ?: 0 integerValue];
    BOOL success = [response[@"success"] ?: false boolValue];
    NSString *message = response[@"message"] ?: @"";
    
    if (code != 200 || !success || dict.count == 0) {
        NSError *err = [NSError errorWithDomain:message code:code userInfo:dict];
        return err;
    }else{
        return dict;
    }
}

- (NSMutableArray *)modelArrayFrom:(NSDictionary *)data modelName:(NSString *)modelName {
    if (![data isKindOfClass:NSDictionary.class] || ![data.allKeys containsObject:@"records"]) {
        return NSMutableArray.array;
    }
    _totalPage = [(data[@"totalPage"] ?: @"1") integerValue];
    NSArray *array = data[@"records"] ?: @[];
    return [array toModelArr:modelName];
}

- (void)recordsParsing:(NSDictionary *)data modelName:(NSString *)modelName {
    _totalPage = [(data[@"totalPage"] ?: @"1") integerValue];
    NSArray *array = data[@"records"] ?: @[];
    
    NSMutableArray *arrM = [array toModelArr:modelName];
    if (self.page == 1) {
        self.dataArray = arrM;
    }else{
        [self.dataArray addObjectsFromArray:arrM];
    }
}

- (void)recordsParsing:(NSDictionary *)data modelName:(NSString *)modelName section:(void (^)(MLBaseTableViewSectionModel * _Nonnull))setupSection {
    _totalPage = [data[@"totalPage"] ?: @"1" integerValue];
    NSMutableArray *datas = [data[@"records"] toModelArr:modelName];
    
    NSMutableArray *arrM = NSMutableArray.array;
    for (MLBaseCellModel *model in datas) {
        MLBaseTableViewSectionModel *section = MLBaseTableViewSectionModel.new;
        section.cellModels = @[model].mutableCopy;
        if (setupSection) {
            setupSection(section);
        }
        [arrM addObject:section];
    }
    
    if (self.page == 1) {
        self.dataArray = arrM;
    }else{
        [self.dataArray addObjectsFromArray:arrM];
    }
}
@end

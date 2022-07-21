//
//  MLTableView.m
//  SpeedCarConnecting
//
//  Created by 魏明磊 on 2021/9/24.
//

#import "MLTableView.h"

@interface MLTableView ()
@property (nonatomic, assign) BOOL isSectionModel;
@end

@implementation MLTableView
- (void)reloadData {
    [self.tableView reloadData];
//    self.height_ml = _tableView.height_ml = MIN(_tableView.contentSize.height, SCREENH * 0.5);
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
        [cell addTarget:self action:@selector(cellClick:)];
    }
    cell.indexPath = indexPath;
    cell.cellModel = model;
    [self setupCell:cell];
    return cell;
}

- (void)cellClick:(UITapGestureRecognizer *)tap {
    MLBaseTableViewCell *cell = (MLBaseTableViewCell *)tap.view;
    if (self.callBackBlock) {
        self.callBackBlock(cell.indexPath);
    }
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

- (MLBaseCellModel *)getModel:(NSIndexPath *)indexPath {
    MLBaseCellModel *model = nil;
    if (_isSectionModel) {
        model = [(MLBaseTableViewSectionModel *)self.dataArray[indexPath.section] cellModels][indexPath.row];
    }else{
        model = self.dataArray[indexPath.row];
    }
    return model;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentSize"]) {
        CGSize contentSize = [change[NSKeyValueChangeNewKey] CGSizeValue];
        contentSize.height = MIN(contentSize.height, SCREENH * 0.5);
        self.tableView.size_ml = self.size_ml = contentSize;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_tableView removeObserver:self forKeyPath:@"contentSize"];
}

#pragma mark - lazy
- (void)setupCell:(MLBaseTableViewCell *)cell {}

- (void)setupTableView:(UITableView *)tableView {}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
        _tableView.contentInsetAdjustmentBehavior = NO;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = false;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:MLBaseTableViewCell.class forCellReuseIdentifier:@"BaseTableViewCell"];
        [_tableView addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
        [self setupTableView:_tableView];
        [self addSubview:_tableView];
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
        }else{
            _isSectionModel = NO;
        }
    }
    return _dataArray;
}
@end

//
//  MLTableView.h
//  SpeedCarConnecting
//
//  Created by 魏明磊 on 2021/9/24.
//

#import "MLBaseView.h"
#import "MLBaseCellModel.h"
#import "MLBaseTableViewCell.h"
#import "MLBaseTableViewSectionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MLTableView : MLBaseView<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

- (void)reloadData;
@end

NS_ASSUME_NONNULL_END



#import "MLBaseModel.h"

NS_ASSUME_NONNULL_BEGIN
@class MLBaseCellModel, MLBaseView;
@interface MLBaseTableViewSectionModel : MLBaseModel
@property (nonatomic, strong) NSDictionary *dict;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, assign) CGFloat headH;
@property (nonatomic, assign) CGFloat footH;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIView *footView;
@property (nonatomic, strong) NSMutableArray <MLBaseCellModel *> *cellModels;
@end

NS_ASSUME_NONNULL_END

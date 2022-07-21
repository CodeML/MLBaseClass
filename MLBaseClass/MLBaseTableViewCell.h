

#import <UIKit/UIKit.h>
#import "MLExtension.h"
#import "heads.h"
#import "MLBaseCellModel.h"
#import "UIImageView+WebCache.h"
#import "SccgWebSrv.h"

NS_ASSUME_NONNULL_BEGIN

@interface MLBaseTableViewCell : UITableViewCell
@property (nonatomic, strong) UIView *line_ml;

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) MLBaseCellModel *cellModel;
@property (nonatomic, copy) void (^callBackBlock)(id param);
- (void)setupUI;
- (void)setModel:(MLBaseCellModel *)cellModel;
@end

NS_ASSUME_NONNULL_END

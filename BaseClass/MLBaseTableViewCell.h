

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MLBaseCellModel;
@interface MLBaseTableViewCell : UITableViewCell
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) MLBaseCellModel *cellModel;
@property (nonatomic, copy) void (^callBackBlock)(id param);
- (void)setupUI;
- (void)setModel:(MLBaseCellModel *)cellModel;
@end

NS_ASSUME_NONNULL_END

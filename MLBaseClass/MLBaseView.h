

#import <UIKit/UIKit.h>
#import "heads.h"

NS_ASSUME_NONNULL_BEGIN
@class MLBaseModel;
@interface MLBaseView : UIView
@property (nonatomic, strong) MLBaseModel *viewModel;

- (void)setupUI;
- (void)setModel:(MLBaseModel *)viewModel;
@end

NS_ASSUME_NONNULL_END

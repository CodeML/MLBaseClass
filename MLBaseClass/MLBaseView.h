

#import <UIKit/UIKit.h>
#import "heads.h"
#import "MLExtension.h"
#import "SccgWebSrv.h"
#import <SDWebImage/UIImageView+WebCache.h>

NS_ASSUME_NONNULL_BEGIN
@class MLBaseModel;
@interface MLBaseView : UIView
@property (nonatomic, strong) MLBaseModel *viewModel;
@property (nonatomic, copy) void (^callBackBlock)(id param);

- (void)setupUI;
- (void)setModel:(MLBaseModel *)viewModel;
@end

NS_ASSUME_NONNULL_END

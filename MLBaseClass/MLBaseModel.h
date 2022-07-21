
#import <UIKit/UIkit.h>
#import "MLExtension.h"

NS_ASSUME_NONNULL_BEGIN

@interface MLBaseModel : NSObject <NSCopying, YYModel>
- (NSDictionary *)keyValue;
@end

NS_ASSUME_NONNULL_END

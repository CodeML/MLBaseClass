
#import "MLBaseModel.h"
#import <MJExtension/MJExtension.h>

@implementation MLBaseModel
- (id)copyWithZone:(nullable NSZone *)zone {
    NSDictionary *dict = self.keyValue;
    return [dict toModel:NSStringFromClass(self.class)];
}

- (NSDictionary *)keyValue {
    return (NSDictionary *)[self modelToJSONObject];
}
@end

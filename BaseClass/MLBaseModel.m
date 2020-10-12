
#import "MLBaseModel.h"
#import "MJExtension.h"
#import "MLExtension.h"

@implementation MLBaseModel
- (id)copyWithZone:(nullable NSZone *)zone {
    NSDictionary *dict = self.keyValue;
    return [dict toModel:NSStringFromClass(self.class)];
}

- (NSMutableDictionary *)keyValue {
    return [self mj_keyValues];
}
@end

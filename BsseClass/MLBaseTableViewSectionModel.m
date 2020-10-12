

#import "MLBaseTableViewSectionModel.h"
#import <MJExtension/MJExtension.h>
#import "MLBaseCellModel.h"

@implementation MLBaseTableViewSectionModel
- (void)setCellModels:(NSMutableArray<MLBaseCellModel *> *)cellModels {
    NSObject *obj = cellModels.firstObject;
    if ([obj isKindOfClass:NSDictionary.class]) {
        NSMutableArray *arrM = [NSMutableArray array];
        for (NSDictionary *dict in cellModels) {
            MLBaseCellModel *model = [MLBaseCellModel mj_objectWithKeyValues:dict];
            [arrM addObject:model];
        }
        _cellModels = arrM;
    }else if ([obj isKindOfClass:MLBaseCellModel.class]) {
        _cellModels = cellModels;
    }
}
@end

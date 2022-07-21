

#import "MLBaseTableViewSectionModel.h"
#import "MJExtension.h"
#import "MLBaseCellModel.h"

@implementation MLBaseTableViewSectionModel

@synthesize cellModels = _cellModels;

- (instancetype)init {
    if (self = [super init]) {
        self.footH = self.headH = 0.01;
        self.cellModels = NSMutableArray.array;
    }
    return self;
}

- (void)setCellModels:(NSMutableArray<MLBaseCellModel *> *)cellModels {
    NSObject *obj = cellModels.firstObject;
    if ([obj isKindOfClass:NSDictionary.class]) {
        NSMutableArray *arrM = [NSMutableArray array];
        for (NSDictionary *dict in cellModels) {
            MLBaseCellModel *model = [MLBaseCellModel mj_objectWithKeyValues:dict];
            [arrM addObject:model];
        }
        _cellModels = arrM;
    }else{
        _cellModels = cellModels;
    }
}

- (NSMutableArray<MLBaseCellModel *> *)cellModels
{
    if (!_cellModels) {
        _cellModels = [NSMutableArray array];
    }
    return _cellModels;
}

@end

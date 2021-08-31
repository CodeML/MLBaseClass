

#import "MLBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MLBaseCellModel : MLBaseModel
@property (nonatomic, copy) NSString *ID;

#pragma mark - UI
@property (nonatomic, copy) NSString *image;

@property (nonatomic, assign) CGFloat font;
@property (nonatomic, assign) CGFloat titleFont;
@property (nonatomic, assign) CGFloat valueFont;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *titleColor;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *valueColor;

@property (nonatomic, copy) NSString *cellName;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) UITableViewCellAccessoryType accType;
@property (nonatomic, copy) NSString *accImage;
@property (nonatomic, strong) UIView *accView;

@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, assign) BOOL showLine;

#pragma mark - action
@property (nonatomic, weak) id target;
@property (nonatomic, copy) NSString *action;
@property (nonatomic, assign) SEL sel;
@end

NS_ASSUME_NONNULL_END

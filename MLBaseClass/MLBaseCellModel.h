

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
@property (nonatomic, copy) NSString *titleLines;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *valueColor;
@property (nonatomic, copy) NSString *valueLines;

@property (nonatomic, copy) NSString *cellName;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) UITableViewCellAccessoryType accType;
@property (nonatomic, copy) NSString *accImage;
@property (nonatomic, strong) UIView *accView;
@property (nonatomic, strong) NSString *backColor;

@property (nonatomic, assign) CGFloat cellW;
@property (nonatomic, assign) CGFloat LRMargin;
@property (nonatomic, copy) NSString *imageSize;
@property (nonatomic, assign) UIEdgeInsets margin;
@property (nonatomic, assign) UIEdgeInsets contentMargin;
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, assign) BOOL showLine;

@property (nonatomic, assign) UIRectCorner corners;

#pragma mark - action
@property (nonatomic, weak) id target;
@property (nonatomic, copy) NSString *action;
@property (nonatomic, assign) SEL sel;
@end

NS_ASSUME_NONNULL_END

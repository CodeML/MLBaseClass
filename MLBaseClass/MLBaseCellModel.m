

#import "MLBaseCellModel.h"

@implementation MLBaseCellModel

- (instancetype)init {
    if (self = [super init]) {
        self.showLine = YES;
    }
    return self;
}

- (NSString *)titleColor {
    if (!_titleColor) {
        _titleColor = @"333333";
    }
    return _titleColor;
}

- (void)setFont:(CGFloat)font {
    _font = font;
    
    _titleFont = font;
    _valueFont = font;
}

- (CGFloat)titleFont {
    if (!_titleFont) {
        _titleFont = 16;
    }
    return _titleFont;
}

- (CGFloat)valueFont {
    if (!_valueFont) {
        _valueFont = 16;
    }
    return _valueFont;
}

- (NSString *)valueColor {
    if (!_valueColor) {
        _valueColor = @"999999";
    }
    return _valueColor;
}

- (NSString *)cellName {
    if (!_cellName) {
        _cellName = @"MLBaseTableViewCell";
    }
    return _cellName;
}

- (CGFloat)cellHeight {
    if (!_cellHeight) {
        _cellHeight = 44;
    }
    return _cellHeight;
}

@end

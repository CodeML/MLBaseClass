

#import "MLBaseTableViewCell.h"

@implementation MLBaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
        [self.contentView addSubview:self.line_ml];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self cornerRadius:_cellModel.corners radius:10];
    
    if (_cellModel.showLine) {
        _line_ml.left_ml = _cellModel.contentMargin.left?:MARGIN_B;
        _line_ml.width_ml = (_cellModel.cellW?:SCREENW) - (_cellModel.contentMargin.left?:MARGIN_B) - (_cellModel.contentMargin.right?:MARGIN_B);
    }
}

- (void)setupUI { }

- (void)setModel:(MLBaseCellModel *)model {
    if (model.backColor.length) {
        self.backgroundColor = [UIColor hex:model.backColor];
        self.contentView.backgroundColor = UIColor.clearColor;
    }else{
        self.backgroundColor = UIColor.clearColor;
        self.contentView.backgroundColor = UIColor.whiteColor;
    }
    if (model.titleColor.length) {
        self.textLabel.textColor = [UIColor hex:model.titleColor];
    }else{
        self.textLabel.textColor = UIColor.black3;
    }
    
    if (model.valueColor.length) {
        self.detailTextLabel.textColor = [UIColor hex:model.valueColor];
    }else{
        self.detailTextLabel.textColor = UIColor.black9;
    }

    if (model.titleFont) {
        self.textLabel.font = [UIFont systemFontOfSize:model.titleFont];
    }else if (model.font) {
        self.textLabel.font = [UIFont systemFontOfSize:model.font];
    }else{
        self.textLabel.font = [UIFont systemFontOfSize:14];
    }
    
    if (model.valueFont) {
        self.detailTextLabel.font = [UIFont systemFontOfSize:model.valueFont];
    }else if (model.font) {
        self.detailTextLabel.font = [UIFont systemFontOfSize:model.font];
    }else{
        self.detailTextLabel.font = [UIFont systemFontOfSize:14];
    }

    self.accessoryType = model.accType ? : UITableViewCellAccessoryNone;
    
    if (model.accView) {
        self.accessoryView = model.accView;
    }else{
        self.accessoryView = nil;
    }
    
    if (model.accImage) {
        UIImageView *imageView = [[UIImageView alloc] init];
        if ([model.accImage containsString:@"://"]) {
            imageView.size_ml = CGSizeMake(30, 30);
            imageView.layer.cornerRadius = imageView.height_ml * 0.5;
            imageView.layer.masksToBounds = YES;
            [imageView sd_setImageWithURL:[NSURL URLWithString:model.accImage] placeholderImage:[UIImage imageNamed:@"HolderImage"]];
        }else{
            imageView.image = [UIImage imageNamed:model.accImage];
            [imageView sizeToFit];
        }
        self.accessoryView = imageView;
    }
    
    if (model.image) {
        self.imageView.image = [UIImage imageNamed:model.image];
        if (!self.imageView.image) {
            [self.imageView sd_setImageWithURL:[SccgWebSrv get_img_url:model.image] placeholderImage:[UIImage imageNamed:@"HolderImage"]];
        }
        self.imageView.layer.cornerRadius = MARGIN_S;
        self.imageView.layer.masksToBounds = YES;
    }else{
        self.imageView.image = nil;
    }
    if (model.titleLines.length) {
        self.textLabel.numberOfLines = model.titleLines.integerValue;
    }
    self.textLabel.text = model.title;
    if (model.valueLines.length) {
        self.detailTextLabel.numberOfLines = model.valueLines.integerValue;
    }
    self.detailTextLabel.text = model.value;
    if ([model.value containsString:@"\n"]) {
        self.detailTextLabel.numberOfLines = 0;
    }
}

- (void)setCellModel:(MLBaseCellModel *)cellModel {
    _cellModel = cellModel;
    [self setModel:cellModel];
    self.line_ml.hidden = !cellModel.showLine || cellModel.corners > 3;
    self.line_ml.top_ml = cellModel.cellHeight - 1;
}

#pragma mark - lazy
- (UIView *)line_ml {
    if (!_line_ml) {
        _line_ml = [[UIView alloc] initWithFrame:CGRectMake(MARGIN_B, 0, SCREENW - MARGIN_B * 2, 0.5)];
        _line_ml.backgroundColor = UIColor.lineColor;
    }
    return _line_ml;
}

@end



#import "MLBaseTableViewCell.h"
#import "MLBaseCellModel.h"

@interface MLBaseTableViewCell ()
@property (nonatomic, strong) UIView *line_ml;
@end

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

- (void)setupUI { }

- (void)setModel:(MLBaseCellModel *)model {
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
    
    if (model.accView) {
        self.accessoryView = model.accView;
    }else{
        self.accessoryView = nil;
    }
    
    if (model.image) {
        if ([model.image containsString:@"://"]) {
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"HolderImage"]];
        }else{
            self.imageView.image = [UIImage imageNamed:model.image];
        }
        self.imageView.layer.cornerRadius = MARGIN_S;
        self.imageView.layer.masksToBounds = YES;
    }
    
    self.textLabel.text = model.title;
    self.detailTextLabel.text = model.value;
    if ([model.value containsString:@"\n"]) {
        self.detailTextLabel.numberOfLines = 0;
    }
}

- (void)setCellModel:(MLBaseCellModel *)cellModel {
    _cellModel = cellModel;
    [self setModel:cellModel];
    self.line_ml.hidden = !cellModel.showLine;
    self.line_ml.top_ml = cellModel.cellHeight - 1;
}

#pragma mark - lazy
- (UIView *)line_ml {
    if (!_line_ml) {
        _line_ml = [[UIView alloc] initWithFrame:CGRectMake(MARGIN_B, 0, SCREENW - MARGIN_B * 2, 1)];
        _line_ml.backgroundColor = UIColor.lineColor;
    }
    return _line_ml;
}

@end

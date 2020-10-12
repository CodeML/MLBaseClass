

#import "MLBaseView.h"

@implementation MLBaseView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setViewModel:(MLBaseModel *)viewModel {
    _viewModel = viewModel;
    [self setModel:viewModel];
}

- (void)setModel:(MLBaseModel *)viewModel {
    
}

- (void)setupUI {


}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end

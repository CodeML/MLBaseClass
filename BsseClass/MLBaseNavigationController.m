

#import "MLBaseNavigationController.h"
#import "MLBaseViewController.h"
//#import "KMLoginViewController.h"

@interface MLBaseNavigationController ()

@end

@implementation MLBaseNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    if (self = [super initWithRootViewController:rootViewController]) {
        self.rootVC = rootViewController;
    }
    return self;
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];

//    if (![self.rootVC isKindOfClass:[BaseViewController class]]) {
//        return;
//    }
    

//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"login" style:(UIBarButtonItemStyleDone) target:self action:@selector(login)];
}

//- (void)login {
//    [self presentViewController:[[KMLoginViewController alloc] init] animated:YES completion:^{
//        LogD(@"=======login did present=======");
//    }];
//}

//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    [super pushViewController:viewController animated:animated];
//
//}
@end

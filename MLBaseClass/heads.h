#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
#define SCREEN_BOUNDS [UIScreen mainScreen].bounds
#define STATUS_BAR_H ([UIApplication sharedApplication].statusBarFrame.size.height)
#define NAV_BAR_H (STATUS_BAR_H + CELLH)
#define BOTTOM_SAFE_H (NAV_BAR_H > 80 ? 34 : 0)
#define TAB_BAR_H (BOTTOM_SAFE_H + 49)
#define CELLH   44.0
#define CELLW   SCREENW - MARGIN_B * 2
#define MARGIN_B 15
#define MARGIN_M 10
#define MARGIN_S 5
#define SCALE_VALUE(x)      (ceilf((x) * (SCREENW / 375.0)))

#define weakify(var) __weak typeof(var) MLWeak_##var = var;
#define strongify(var) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
__strong typeof(var) var = MLWeak_##var; \
_Pragma("clang diagnostic pop")

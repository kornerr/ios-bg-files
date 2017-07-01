
#import "AppDelegate.h"

#import "MainVC.h"

@interface AppDelegate ()

@property (nonatomic, strong) MainVC *mainVC;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window =
        [[UIWindow alloc]
            initWithFrame:[[UIScreen mainScreen] bounds]];
    self.mainVC = [MainVC new];
    UINavigationController *nc =
        [[UINavigationController alloc]
            initWithRootViewController:self.mainVC];
    self.window.rootViewController = nc;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    return YES;
}

@end


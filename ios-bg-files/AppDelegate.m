
#import "AppDelegate.h"

#import "MainVC.h"

@interface AppDelegate ()

@property (nonatomic, strong) MainVC *mainVC;
@property (nonatomic, strong) Notification *notification;

@end

@implementation AppDelegate

#pragma mark - PUBLIC

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window =
        [[UIWindow alloc]
            initWithFrame:[[UIScreen mainScreen] bounds]];

    [self setupMainVC];
    [self setupNotification];
    self.mainVC.notification = self.notification;

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)application:(UIApplication *)app
    didRegisterUserNotificationSettings:(UIUserNotificationSettings *)uns {

    [self.notification
        application:app
        didRegisterUserNotificationSettings:uns];
}

- (void)applicationWillEnterForeground:(UIApplication *)app {
    [self.mainVC refreshUI];
}

#pragma mark - PRIVATE

- (void)setupNotification {
    self.notification = [Notification new];
}

- (void)setupMainVC {
    self.mainVC = [MainVC new];
    UINavigationController *nc =
        [[UINavigationController alloc]
            initWithRootViewController:self.mainVC];
    self.window.rootViewController = nc;
}

@end


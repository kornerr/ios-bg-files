
#import "Notification.h"

@interface Notification ()

@end

@implementation Notification

#pragma mark - PUBLIC

- (void)application:(UIApplication *)app
    didRegisterUserNotificationSettings:(UIUserNotificationSettings *)uns {

    NSLog(
        @"Notification. New permission status: '%@'",
        @(self.isAllowed));
    if (self.delegate &&
        [(NSObject *)self.delegate
            respondsToSelector:@selector(notification:didChangeAllowedStatus:)]) {

        [self.delegate
            notification:self
            didChangeAllowedStatus:self.isAllowed];
    }
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initNotification];
    }
    return self;
}

- (void)reportMessage:(NSString *)message {
    UILocalNotification *notification = [UILocalNotification new];
    notification.alertBody = message;
    notification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication]
        presentLocalNotificationNow:notification];
}

- (void)requestPermission {
    UIApplication *app = [UIApplication sharedApplication];
    if ([app respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        [app registerUserNotificationSettings:
            [UIUserNotificationSettings
                settingsForTypes:UIUserNotificationTypeAlert
                categories:nil]];
    }
}

#pragma mark - PROPERTIES

- (BOOL)isAllowed {
    UIUserNotificationSettings *uns =
        [[UIApplication sharedApplication]
            currentUserNotificationSettings];
    return (uns.types & UIUserNotificationTypeAlert);
}

#pragma mark - PRIVATE

- (void)initNotification {
}

@end


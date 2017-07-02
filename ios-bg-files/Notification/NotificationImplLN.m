
#import "NotificationImplLN.h"

@interface NotificationImplLN ()

@end

@implementation NotificationImplLN

#pragma mark - PUBLIC

- (void)application:(UIApplication *)app
    didRegisterUserNotificationSettings:(UIUserNotificationSettings *)uns {

    [self.delegate
        notificationImplDidChangeAllowedStatus:self.isAllowed];
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

@end


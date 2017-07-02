
#import "NotificationImplUNC.h"

#import "EXTScope.h"

@import UserNotifications;

@interface NotificationImplUNC ()

@end

@implementation NotificationImplUNC

#pragma mark - PUBLIC

- (void)reportMessage:(NSString *)message {
    UNMutableNotificationContent *content =
        [UNMutableNotificationContent new];
    content.body = message;
    // Deliver right away.
    UNTimeIntervalNotificationTrigger *trigger =
        [UNTimeIntervalNotificationTrigger
            triggerWithTimeInterval:0
            repeats:NO];
    UNNotificationRequest *req =
        [UNNotificationRequest
            requestWithIdentifier:@"Now"
            content:content
            trigger:trigger];
    // Schedule delivery.
    UNUserNotificationCenter *unc =
        [UNUserNotificationCenter currentNotificationCenter];
    [unc addNotificationRequest:req withCompletionHandler:nil];
}

- (void)requestPermission {
    UNUserNotificationCenter *unc =
        [UNUserNotificationCenter currentNotificationCenter];
    @weakify(self);
    [unc
        requestAuthorizationWithOptions:UNAuthorizationOptionAlert
        completionHandler:^(BOOL granted, NSError *error) {
            @strongify(self);
            [self.delegate
                notificationImplDidChangeAllowedStatus:granted];
        }];
}

#pragma mark - PROPERTIES

- (BOOL)isAllowed {
    return NO;

    // TODO async!

    /*
    UNUserNotificationCenter *unc =
        [UNUserNotificationCenter currentNotificationCenter];



    UIUserNotificationSettings *uns =
        [[UIApplication sharedApplication]
            currentUserNotificationSettings];
    return (uns.types & UIUserNotificationTypeAlert);
    */
}

@end


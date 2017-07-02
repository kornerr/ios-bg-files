
#import "Notification.h"

#import "NotificationImplLN.h"
//#import "NotificationUNC.h"

@interface Notification () <NotificationImplDelegate>

@property (nonatomic, strong) NotificationImplLN *implLN;

@property (nonatomic, weak) id<NotificationImpl> impl;

@end

@implementation Notification

#pragma mark - PUBLIC

- (void)application:(UIApplication *)app
    didRegisterUserNotificationSettings:(UIUserNotificationSettings *)uns {

    if (self.implLN) {
        [self.implLN
            application:app
            didRegisterUserNotificationSettings:uns];
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
    [self.impl reportMessage:message];
}

- (void)requestPermission {
    [self.impl requestPermission];
}

#pragma mark - PROPERTIES

- (BOOL)isAllowed {
    return self.impl.isAllowed;
}

#pragma mark - PRIVATE

- (void)initNotification {
        self.implLN = [NotificationImplLN new];
        self.implLN.delegate = self;
        self.impl = self.implLN;
    /*
    if (NSClassFromString(@"UNUserNotificationsCenter")) {

    }
    else {

    }
    */
}

#pragma mark - DELEGATE

- (void)notificationImplDidChangeAllowedStatus:(BOOL)status {
    if (self.delegate &&
        [(NSObject *)self.delegate
            respondsToSelector:@selector(notification:didChangeAllowedStatus:)]) {

        [self.delegate
            notification:self
            didChangeAllowedStatus:self.isAllowed];
    }
}

@end


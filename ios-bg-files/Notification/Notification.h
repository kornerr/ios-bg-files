
#import <UIKit/UIKit.h>

@class Notification;

@protocol NotificationDelegate

- (void)notification:(Notification *)notification
    didChangeAllowedStatus:(BOOL)status;

@end

@interface Notification : NSObject

@property (nonatomic, assign, readonly) BOOL isAllowed;

@property (nonatomic, weak) id<NotificationDelegate> delegate;

- (void)application:(UIApplication *)app
    didRegisterUserNotificationSettings:(UIUserNotificationSettings *)uns;
- (void)reportMessage:(NSString *)message;
- (void)requestPermission;

@end


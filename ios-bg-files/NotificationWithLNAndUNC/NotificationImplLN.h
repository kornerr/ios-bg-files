
#import "NotificationImpl.h"
#import "NotificationImplDelegate.h"

#import <UIKit/UIKit.h>

@interface NotificationImplLN : NSObject <NotificationImpl>

@property (nonatomic, weak) id<NotificationImplDelegate> delegate;

- (void)application:(UIApplication *)app
    didRegisterUserNotificationSettings:(UIUserNotificationSettings *)uns;

@end


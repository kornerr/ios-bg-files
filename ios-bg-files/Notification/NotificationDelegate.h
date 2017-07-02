
#import <Foundation/Foundation.h>

@class Notification;

@protocol NotificationDelegate

- (void)notificationDidChangeAllowedStatus:(BOOL)status;

@end


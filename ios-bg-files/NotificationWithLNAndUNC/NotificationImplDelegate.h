
#import <Foundation/Foundation.h>

@protocol NotificationImplDelegate

- (void)notificationImplDidChangeAllowedStatus:(BOOL)status;

@end


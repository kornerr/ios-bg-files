
#import <UIKit/UIKit.h>

@protocol NotificationImpl

@property (nonatomic, assign, readonly) BOOL isAllowed;

- (void)reportMessage:(NSString *)message;
- (void)requestPermission;

@end


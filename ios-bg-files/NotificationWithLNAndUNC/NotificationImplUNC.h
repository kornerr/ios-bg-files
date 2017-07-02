
#import "NotificationImpl.h"
#import "NotificationImplDelegate.h"

@interface NotificationImplUNC : NSObject <NotificationImpl>

@property (nonatomic, weak) id<NotificationImplDelegate> delegate;

@end


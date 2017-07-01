
#import <Foundation/Foundation.h>

@class Notification;

@protocol NotificationDelegate

- (void)location:(Location *)location
    didChangeBackgroundExecutionStatus:(BOOL)backgroundExecutionIsAllowed;

@end

@interface Location : NSObject

@property (nonatomic, assign, readonly) BOOL isBackgroundExecutionAllowed;

@property (nonatomic, weak) id<LocationDelegate> delegate;

- (void)requestBackgroundExecution;
- (void)startUpdates;

@end


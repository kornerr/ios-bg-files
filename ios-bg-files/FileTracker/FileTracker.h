
#import <Foundation/Foundation.h>

@class FileTracker;

@protocol FileTrackerDelegate

- (void)fileTracker:(FileTracker *)tracker
    didNoticeChangeWithDirectory:(NSString *)dir;

@end

@interface FileTracker : NSObject

- (void)startTrackingDirectory:(NSString *)dir;
- (void)stopTracking;

@end


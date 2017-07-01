
#import <Foundation/Foundation.h>

@class Tracker;

@protocol TrackerDelegate

- (void)tracker:(Tracker *)tracker
    didNoticeChangeInDirectory:(NSString *)dir;

@end

@interface Tracker : NSObject

@property (nonatomic, weak) id<TrackerDelegate> delegate;

- (void)startTrackingDirectory:(NSString *)dir;
- (void)stopTracking;

@end


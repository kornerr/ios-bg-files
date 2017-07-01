
#import "FileTracker.h"

@interface FileTracker ()

@property (nonatomic, assign) int descriptor;
@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, strong) dispatch_source_t source;
@property (nonatomic, strong) NSString *directory;

@end

@implementation FileTracker

#pragma mark - PUBLIC

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initFileTracker];
    }
    return self;
}

- (void)startTrackingDirectory:(NSString *)dir {
    // Stop tracking old source.
    if (self.source) {
        [self stopTracking];
    }
    self.directory = dir;
    // Get directory descriptor.
    self.descriptor = open([dir fileSystemRepresentation], O_EVTONLY);
    // Create GCD dispatch source to track changes.
    self.source =
        dispatch_source_create(
            DISPATCH_SOURCE_TYPE_VNODE,
            self.descriptor,
            DISPATCH_VNODE_WRITE,
            self.queue);
    // Process changes.
    dispatch_source_set_event_handler(
        self.source,
        ^{
            [self directoryDidChange];
        });
    // Close descriptor upon cancellation.
    dispatch_source_set_cancel_handler(
        self.source,
        ^{
            close(self.descriptor);
        });
    // Start tracking.
    dispatch_resume(self.source);
}

- (void)stopTracking {
    if (self.source) {
        dispatch_source_cancel(self.source);
        self.source = nil;
    }
}

#pragma mark - PRIVATE

- (void)directoryDidChange {
    NSLog(@"FileTracker. directoryDidChange '%@'", self.directory);
}

- (void)initFileTracker {
    self.queue = dispatch_queue_create("FileTrackerQueue", 0);
    self.source = nil;
}

#pragma mark - DELEGATE

/*
- (void)locationManager:(CLLocationManager *)locationManager
    didChangeAuthorizationStatus:(CLAuthorizationStatus)status {

    NSLog(@"Location. New auth status: '%@'", @(status));
    if (self.delegate &&
        [(NSObject *)self.delegate
            respondsToSelector:@selector(location:didChangeBackgroundExecutionStatus:)]) {

        [self.delegate
            location:self
            didChangeBackgroundExecutionStatus:self.isBackgroundExecutionAllowed];
    }
}

- (void)locationManager:(CLLocationManager *)locationManager
    didUpdateLocations:(NSArray *)locations {

    printf("Location. Update\n");
    NSLog(@"Location.Update");
}
*/

@end


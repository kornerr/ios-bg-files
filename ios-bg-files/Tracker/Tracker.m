
#import "Tracker.h"

#import "EXTScope.h"

@interface Tracker ()

@property (nonatomic, assign) int descriptor;
@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, strong) dispatch_source_t source;
@property (nonatomic, strong) NSString *directory;

@end

@implementation Tracker

#pragma mark - PUBLIC

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initTracker];
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

    @weakify(self);

    // Process changes.
    dispatch_source_set_event_handler(
        self.source,
        ^{
            @strongify(self);
            [self directoryDidChange];
        });
    // Close descriptor upon cancellation.
    dispatch_source_set_cancel_handler(
        self.source,
        ^{
            @strongify(self);
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
    // TODO This does not take long file uploads into consideration,
    // because big files take time. However, that's easy to support
    // if so desired.
    NSLog(@"Tracker. directoryDidChange '%@'", self.directory);
    if (self.delegate &&
        [(NSObject *)self.delegate
            respondsToSelector:@selector(tracker:didNoticeChangeInDirectory:)]) {

        [self.delegate
            tracker:self
            didNoticeChangeInDirectory:self.directory];
    }
}

- (void)initTracker {
    self.queue = dispatch_queue_create("TrackerQueue", 0);
    self.source = nil;
}

@end


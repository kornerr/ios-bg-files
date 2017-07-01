
#import "Location.h"

@interface Location () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation Location

#pragma mark - PUBLIC

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initLocation];
    }
    return self;
}

- (void)requestBackgroundExecution {
    [self.locationManager requestAlwaysAuthorization];
}

- (void)startUpdates {
    [self.locationManager startUpdatingLocation];
}

#pragma mark - PROPERTIES

- (BOOL)isBackgroundExecutionAllowed {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    return (status == kCLAuthorizationStatusAuthorizedAlways);
}

#pragma mark - PRIVATE

- (void)initLocation {
    [self setupLocationManager];
}

- (void)setupLocationManager {
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    self.locationManager.pausesLocationUpdatesAutomatically = NO;
    self.locationManager.allowsBackgroundLocationUpdates = YES;
}

#pragma mark - DELEGATE

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
    // Prevent flood.
    static int i = 0;
    if (!(++i % 30)) {
        NSLog(@"Location. Still updating");
    }
}

@end


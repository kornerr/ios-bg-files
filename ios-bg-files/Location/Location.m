
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


@end


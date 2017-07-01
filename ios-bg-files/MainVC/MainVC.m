
#import "MainVC.h"

#import "FileSystemVC.h"
#import "Location.h"
#import "Tracker.h"

@interface MainVC ()
    <FileSystemVCDelegate,
    LocationDelegate,
    NotificationDelegate,
    TrackerDelegate>

@property (nonatomic, strong) IBOutlet UIButton *locationButton;
@property (nonatomic, strong) IBOutlet UIButton *notificationButton;
@property (nonatomic, strong) IBOutlet UILabel *noteLabel;

@property (nonatomic, strong) Location *location;
@property (nonatomic, strong) Tracker *tracker;

@property (nonatomic, strong) NSString *selectedDir;

@end

@implementation MainVC

#pragma mark - PUBLIC

- (void)refreshUI {
    NSLog(@"MainVC. refreshUI");
    // Buttons.
    BOOL bgIsOn = self.location.isBackgroundExecutionAllowed;
    self.locationButton.enabled = !bgIsOn;

    BOOL notificationsAreOn = NO;
    if (self.notification) {
        notificationsAreOn = self.notification.isAllowed;
        NSLog(
            @"MainVC. refreshUI. notificationsAreOn: '%@'",
            @(notificationsAreOn));
        self.notificationButton.enabled = !notificationsAreOn;
    }
    // Note.
    NSString *note =
        [NSString
            stringWithFormat:NSLocalizedString(@"Note.OK", nil),
            self.selectedDir];
    if (!bgIsOn) {
        note = NSLocalizedString(@"Note.BG", nil);
    }
    else if (!notificationsAreOn) {
        note = NSLocalizedString(@"Note.Notifications", nil);
    }
    else if (![self.selectedDir length]) {
        note = NSLocalizedString(@"Note.Dir", nil);
    }
    self.noteLabel.text = note;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMainVC];
}

#pragma mark - PRIVATE

- (void)setupMainVC {
    // File tracker.
    self.tracker = [Tracker new];
    self.tracker.delegate = self;
    // Location.
    self.location = [Location new];
    self.location.delegate = self;
    [self.location startUpdates];
    [self.location requestBackgroundExecution];
}

- (void)setupNotification {
    self.notification.delegate = self;
    [self.notification requestPermission];
}

#pragma mark - PROPERTIES

- (void)setNotification:(Notification *)notification {
    _notification = notification;
    [self setupNotification];
}

#pragma mark - BUTTONS

- (IBAction)openSettings:(id)sender {
    NSURL *settingsURL =
        [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    [[UIApplication sharedApplication] openURL:settingsURL];
}

- (IBAction)selectDirectory:(id)sender {
    NSURL *url = [NSURL fileURLWithPath:NSHomeDirectory()];
    FileSystemVC *vc = [[FileSystemVC alloc] initWithURL:url];
    vc.delegate = self;
    UINavigationController *nc =
        [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nc animated:YES completion:nil];
}

#pragma mark - DELEGATE

- (void)fileSystemVC:(FileSystemVC *)fsvc didSelectDirectory:(NSURL *)url {
    self.selectedDir = url.path;
    [self.tracker startTrackingDirectory:url.path];
    [self refreshUI];
}

- (void)location:(Location *)location
    didChangeBackgroundExecutionStatus:(BOOL)status {

    [self refreshUI];
}

- (void)notification:(Notification *)notification
    didChangeAllowedStatus:(BOOL)status {

    [self refreshUI];
}

- (void)tracker:(Tracker *)tracker
    didNoticeChangeInDirectory:(NSString *)dir {

    [self.notification reportMessage:@"Directory changed"];
}

@end


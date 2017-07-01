
#import "MainVC.h"

#import "FileSystemVC.h"
#import "Location.h"
#import "Tracker.h"

@interface MainVC ()
    <FileSystemVCDelegate,
    LocationDelegate,
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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMainVC];

    // TODO: remove. Register local notification support.
    UIApplication *app = [UIApplication sharedApplication];
    if ([app respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        [app registerUserNotificationSettings:
            [UIUserNotificationSettings
                settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound
                categories:nil]];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateUI];
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

- (void)updateUI {
    BOOL bgIsOn = self.location.isBackgroundExecutionAllowed;
    // Buttons.
    self.locationButton.enabled = !bgIsOn;
    // Note.
    NSString *note =
        [NSString
            stringWithFormat:NSLocalizedString(@"Note.OK", nil),
            self.selectedDir];
    if (!bgIsOn) {
        note = NSLocalizedString(@"Note.BG", nil);
    }
    else if (![self.selectedDir length]) {
        note = NSLocalizedString(@"Note.Dir", nil);
    }
    self.noteLabel.text = note;
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
    [self updateUI];
}

- (void)location:(Location *)location
    didChangeBackgroundExecutionStatus:(BOOL)status {

    [self updateUI];
}

- (void)tracker:(Tracker *)tracker
    didNoticeChangeInDirectory:(NSString *)dir {

    NSLog(@"VC. Directory change: '%@'", dir);

    // TODO: remove.
    UILocalNotification *notification = [UILocalNotification new];
    notification.alertBody = @"Directory changed";
    notification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication]
        presentLocalNotificationNow:notification];
}

@end


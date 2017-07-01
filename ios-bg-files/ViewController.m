
#import "ViewController.h"

#import "FileTracker.h"
#import "FileSystemVC.h"
#import "Location.h"

@interface ViewController () <FileSystemVCDelegate, LocationDelegate>

@property (nonatomic, strong) FileTracker *tracker;
@property (nonatomic, strong) Location *location;

@property (nonatomic, strong) IBOutlet UIButton *bgLocationUpdatesButton;
@property (nonatomic, strong) IBOutlet UILabel *noteLabel;

@property (nonatomic, strong) NSString *selectedDir;

@end

@implementation ViewController

#pragma mark - PUBLIC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViewController];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateButtonsAndNote];
}

#pragma mark - PRIVATE

- (void)setupViewController {
    // File tracker.
    self.tracker = [FileTracker new];
    // Location.
    self.location = [Location new];
    self.location.delegate = self;
    [self.location startUpdates];
    [self.location requestBackgroundExecution];
}

- (void)updateButtonsAndNote {
    BOOL bgIsOn = self.location.isBackgroundExecutionAllowed;
    // Buttons.
    self.bgLocationUpdatesButton.enabled = !bgIsOn;
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

#pragma mark - DELEGATE

- (void)location:(Location *)location
    didChangeBackgroundExecutionStatus:(BOOL)status {

    [self updateButtonsAndNote];
}

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

- (void)fileSystemVC:(FileSystemVC *)fsvc didSelectDirectory:(NSURL *)url {
    self.selectedDir = url.path;
    [self.tracker startTrackingDirectory:url.path];
    [self updateButtonsAndNote];
}

@end


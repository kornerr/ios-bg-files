
#import "ViewController.h"

#import "FileSystemVC.h"
#import "Location.h"

@interface ViewController () <FileSystemVCDelegate>

@property (nonatomic, strong) Location *location;

@end

@implementation ViewController

#pragma mark - PUBLIC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViewController];
}

#pragma mark - PRIVATE

- (void)setupViewController {
    self.location = [Location new];
    [self.location startUpdates];
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
    NSLog(@"ViewController. Selected dir: '%@'", url.path);
}

@end


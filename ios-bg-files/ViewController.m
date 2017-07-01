
#import "ViewController.h"

#import "FileSystemVC.h"

@interface ViewController () <FileSystemVCDelegate>

@end

@implementation ViewController

#pragma mark - PUBLIC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViewController];
}

#pragma mark - PRIVATE

- (void)setupViewController {
    
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


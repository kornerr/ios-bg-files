
#import <UIKit/UIKit.h>

@class FileSystemVC;

@protocol FileSystemVCDelegate

- (void)fileSystemVC:(FileSystemVC *)fileSystemVC
    didSelectDirectory:(NSURL *)url;

@end

@interface FileSystemVC : UIViewController

@property (nonatomic, weak) id<FileSystemVCDelegate> delegate;

- (instancetype)initWithURL:(NSURL *)url;

@end


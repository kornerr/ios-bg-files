
#import "FileSystemItem+Parser.h"

@implementation FileSystemItem (Parser)

- (void)parseURL:(NSURL *)url {
    // Defaults.
    self.url = url;
    self.size = @"Unknown";
    self.isDir = NO;

    // Get real values.
    NSError *err = nil;
    NSDictionary *attrs =
        [[NSFileManager defaultManager]
            attributesOfItemAtPath:url.path
            error:&err];

    if (!err) {
        self.isDir = [attrs.fileType isEqualToString:NSFileTypeDirectory];
        self.size =
            [NSByteCountFormatter
                stringFromByteCount:attrs.fileSize
                countStyle:NSByteCountFormatterCountStyleFile];
    }
    else {
        NSLog(
        @"FileSystemItem+Parser. Could not get path '%@' attributes. Error: '%@'",
        self.url.path,
        err);
    }
}

@end


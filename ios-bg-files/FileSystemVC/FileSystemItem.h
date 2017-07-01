
#import <Foundation/Foundation.h>

@interface FileSystemItem : NSObject

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, copy) NSString *size;
@property (nonatomic, assign) BOOL isDir;

@end


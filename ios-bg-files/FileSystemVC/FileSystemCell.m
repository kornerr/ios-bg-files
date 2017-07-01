
#import "FileSystemCell.h"

@interface FileSystemCell ()

@property (nonatomic, strong) IBOutlet UILabel *pathLabel;
@property (nonatomic, strong) IBOutlet UILabel *descLabel;

@end

@implementation FileSystemCell

#pragma mark - PUBLIC

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupFileSystemCell];
}

#pragma mark - SETTERS

- (void)setItem:(FileSystemItem *)item {
    _item = item;
    [self updateItem];
}

#pragma mark - PRIVATE

- (void)setupFileSystemCell {
    [self updateItem];
}

- (void)updateItem {
    if (self.pathLabel && self.item) {
        self.pathLabel.text = self.item.url.path.lastPathComponent;
        self.descLabel.text =
            [NSString
                stringWithFormat:@"%@, %@",
                (self.item.isDir ? @"Dir" : @"File"),
                self.item.size];
    }
}

@end



#import "FileSystemVC.h"

#import "FileSystemCell.h"
#import "FileSystemItem.h"
#import "FileSystemItem+Parser.h"

static NSString * const kFileSystemVCCell = @"FileSystemCell";
static CGFloat const kFileSystemVCCellHeight = 60;

@interface FileSystemVC () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSURL *url;

@property (nonatomic, strong) NSArray<FileSystemItem *> *items;

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionViewLayout;

@end

@implementation FileSystemVC

#pragma mark - PUBLIC

- (instancetype)initWithURL:(NSURL *)url {
    self = [super init];
    if (self) {
        _url = url;
        [self initFileSystemVC];
    }
    return self;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.collectionViewLayout.itemSize =
        CGSizeMake(
            self.collectionView.frame.size.width,
            kFileSystemVCCellHeight);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupFileSystemVC];
}

#pragma mark - PRIVATE

- (void)initFileSystemVC {
    [self setupItems];
}

- (void)setupCollectionView {
    // Configure collection view layout.
    self.collectionViewLayout = [UICollectionViewFlowLayout new];
    self.collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionViewLayout.minimumInteritemSpacing = 0;
    self.collectionViewLayout.minimumLineSpacing = 0;
    // Configure collection view.
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.collectionViewLayout = self.collectionViewLayout;
    // Register cells.
    [self.collectionView
        registerNib:[UINib nibWithNibName:kFileSystemVCCell bundle:[NSBundle mainBundle]]
        forCellWithReuseIdentifier:kFileSystemVCCell];
}

- (void)setupFileSystemVC {
    // Title.
    self.navigationItem.title = self.url.path.lastPathComponent;
    // Cancel.
    self.navigationItem.rightBarButtonItem =
        [[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemDone
            target:self
            action:@selector(cancel:)];

    [self setupCollectionView];
}

- (void)setupItems {
    // Get directory contents.
    NSError *err = nil;
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *urlItems =
        [fm contentsOfDirectoryAtURL:self.url
            includingPropertiesForKeys:nil
            options:0
            error:&err];
    NSLog(@"FileSystemVC. URL items: '%@'", urlItems);
    // Parse items.
    if (!err) {
        NSMutableArray *items = [NSMutableArray array];
        for (NSURL *url in urlItems) {
            FileSystemItem *item = [FileSystemItem new];
            [item parseURL:url];
            [items addObject:item];
        }
        self.items = items;
    }
    // Reset and report error.
    else {
        self.items = [NSArray array];
        NSLog(
            @"FileSystemVC. Could not get directory '%@' contents. Error: '%@'",
            self.url.path,
            err);
    }
}

#pragma mark - NAVIGATION

- (void)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)selectDir:(id)sender {
    // Navigate.
    [self dismissViewControllerAnimated:YES completion:nil];
    // Report.
    if (self.delegate &&
        [(NSObject *)self.delegate respondsToSelector:@selector(fileSystemVC:didSelectDirectory:)]) {

        [self.delegate fileSystemVC:self didSelectDirectory:self.url];
    }
}

#pragma mark - DELEGATE

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv
    cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    FileSystemCell *cell =
        [cv dequeueReusableCellWithReuseIdentifier:kFileSystemVCCell
            forIndexPath:indexPath];
    FileSystemItem *item = self.items[indexPath.row];
    cell.item = item;
    return cell;
}

- (void)collectionView:(UICollectionView *)cv
    didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    FileSystemItem *item = self.items[indexPath.row];
    // Go to another dir.
    if (item.isDir) {
        FileSystemVC *vc = [[FileSystemVC alloc] initWithURL:item.url];
        vc.delegate = self.delegate;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (NSInteger)collectionView:(UICollectionView *)cv
    numberOfItemsInSection:(NSInteger)section {

    return self.items.count;
}

@end


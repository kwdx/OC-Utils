//
//  PageViewController.m
//  Demo
//
//  Created by warden on 2019/4/26.
//  Copyright © 2019 warden. All rights reserved.
//

#import "PageViewController.h"
#import "WDCollectionViewPageFlowLayout.h"

@interface PageViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation PageViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.titleLabel];
        self.contentView.backgroundColor = [UIColor colorWithRed:0.898 green:0.149 blue:0.086 alpha:1.00];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _titleLabel.frame = self.contentView.bounds;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end

@interface PageViewController () <UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *horizontalCV;
@property (nonatomic, strong) UICollectionView *verticalCV;

@end

@implementation PageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (@available(iOS 11.0, *)) {
        self.horizontalCV.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.verticalCV.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:self.horizontalCV];
    [self.view addSubview:self.verticalCV];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.horizontalCV.frame = CGRectMake(0, 50, self.view.frame.size.width, 150);
    self.verticalCV.frame = CGRectMake(0, 250, self.view.frame.size.width, 200);
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return (section == 0) ? 8 : 11;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(PageViewCell.class) forIndexPath:indexPath];
    cell.titleLabel.text = [NSString stringWithFormat:@"%ld - %ld", indexPath.section, indexPath.row];
    return cell;
}

#pragma mark - Getter

- (UICollectionView *)horizontalCV {
    if (!_horizontalCV) {
        WDCollectionViewPageFlowLayout *flowLayout = [WDCollectionViewPageFlowLayout new];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 2;
        flowLayout.minimumInteritemSpacing = 2;
        flowLayout.pageInset = UIEdgeInsetsMake(5, 10, 5, 20);

        _horizontalCV = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _horizontalCV.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        _horizontalCV.dataSource = self;
        _horizontalCV.pagingEnabled = YES;
        _horizontalCV.showsHorizontalScrollIndicator = NO;
        [_horizontalCV registerClass:PageViewCell.class forCellWithReuseIdentifier:NSStringFromClass(PageViewCell.class)];
    }
    return _horizontalCV;
}

- (UICollectionView *)verticalCV {
    if (!_verticalCV) {
        WDCollectionViewPageFlowLayout *flowLayout = [WDCollectionViewPageFlowLayout new];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.minimumLineSpacing = 2;
        flowLayout.minimumInteritemSpacing = 2;
        flowLayout.pageInset = UIEdgeInsetsMake(5, 5, 25, 5);

        _verticalCV = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _verticalCV.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        _verticalCV.dataSource = self;
        _verticalCV.pagingEnabled = YES;
        _verticalCV.showsHorizontalScrollIndicator = NO;
        [_verticalCV registerClass:PageViewCell.class forCellWithReuseIdentifier:NSStringFromClass(PageViewCell.class)];
    }
    return _verticalCV;
}

@end

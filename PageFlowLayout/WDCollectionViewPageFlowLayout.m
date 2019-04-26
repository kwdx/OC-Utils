//
//  WDCollectionViewPageFlowLayout.m
//  Aipai
//
//  Created by warden on 2019/4/26.
//  Copyright © 2019 warden. All rights reserved.
//

#import "WDCollectionViewPageFlowLayout.h"

@interface WDCollectionViewPageFlowLayout ()

@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *allAttributes;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *sectionPages;

@property (nonatomic, assign) NSInteger itemsPerPage;
@property (nonatomic, assign) CGSize pageSize;

@end

@implementation WDCollectionViewPageFlowLayout

- (instancetype)init {
    if (self = [super init]) {
        _itemCountPerRow = 4;
        _rowCount = 2;
        _itemsPerPage = _itemCountPerRow * _rowCount;
        _pageInset = UIEdgeInsetsZero;
    }
    return self;
}

#pragma mark - Override

- (CGSize)collectionViewContentSize {
//    NSInteger sections = [self.collectionView numberOfSections];
//    NSInteger pages = 0;
//    for (int i = 0; i < sections; i++) {
//        NSInteger items = [self.collectionView numberOfItemsInSection:sections];
//        NSInteger pageNumber = items / self.itemsPerPage;
//        if (items % self.itemsPerPage != 0) {
//            // 有余数，不满一页，算一页
//            pageNumber += 1;
//        }
//        pages += pageNumber;
//    }
//
//    CGSize size = self.collectionView.frame.size;
//    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
//        size.width = size.width * pages;
//    } else {
//        size.height = size.height * pages;
//    }
    NSInteger pages = 0;
    for (NSNumber *sectionPage in self.sectionPages) {
        pages += sectionPage.integerValue;
    }
    CGSize size = self.collectionView.frame.size;
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        size.width = size.width * pages;
    } else {
        size.height = size.height * pages;
    }
    return size;
}

- (void)prepareLayout {
    [super prepareLayout];
    
    NSInteger sections = self.collectionView.numberOfSections;
    self.allAttributes = nil;
    self.sectionPages = nil;;
    for (NSInteger section = 0; section < sections; section++) {
        NSInteger items = [self.collectionView numberOfItemsInSection:section];
        for (NSInteger item = 0; item < items; item++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            [self.allAttributes addObject:attributes];
        }
        NSInteger pages = items / self.itemsPerPage;
        if (items % self.itemsPerPage != 0) {
            // 有余数，不满一页，算一页
            pages += 1;
        }
        [self.sectionPages addObject:@(pages)];
    }
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat pageWidth = self.collectionView.frame.size.width - self.pageInset.left - self.pageInset.right;
    CGFloat pageHeight = self.collectionView.frame.size.height - self.pageInset.top - self.pageInset.bottom;
    
    CGFloat itemWidth = (pageWidth - (self.itemCountPerRow - 1) * self.minimumInteritemSpacing) / self.itemCountPerRow;
    CGFloat itemHeight = (pageHeight - (self.rowCount - 1) * self.minimumLineSpacing) / self.rowCount;
    
    NSInteger item = indexPath.item;
    NSInteger pageNumber = item / self.itemsPerPage;
    item -= pageNumber * self.itemsPerPage;
    for (int i = 0; i < indexPath.section; i++) {
        pageNumber += self.sectionPages[i].integerValue;
    }
    /// 计算在当前页的位置
    NSInteger x = item % self.itemCountPerRow;
    NSInteger y = item / self.itemCountPerRow;
    CGFloat itemX = self.pageInset.left + x * (itemWidth + self.minimumInteritemSpacing);
    CGFloat itemY = self.pageInset.top + y * (itemHeight + self.minimumLineSpacing);
    
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        itemX += pageNumber * self.pageSize.width;
    } else {
        itemY += pageNumber * self.pageSize.height;
    }
    
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    attributes.frame = CGRectMake(itemX, itemY, itemWidth, itemHeight);
    return attributes;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.allAttributes;
}

#pragma mark - Setter

- (void)setItemCountPerRow:(NSInteger)itemCountPerRow {
    if (itemCountPerRow <= 0) {
        itemCountPerRow = 1;
    }
    _itemCountPerRow = itemCountPerRow;
    self.itemsPerPage = _itemCountPerRow * _rowCount;
}

- (void)setRowCount:(NSInteger)rowCount {
    if (rowCount <= 0) {
        rowCount = 1;
    }
    _rowCount = rowCount;
    self.itemsPerPage = _itemCountPerRow * _rowCount;
}

#pragma mark - Getter

- (NSMutableArray<UICollectionViewLayoutAttributes *> *)allAttributes {
    if (!_allAttributes) {
        _allAttributes = [NSMutableArray array];
    }
    return _allAttributes;
}

- (NSMutableArray<NSNumber *> *)sectionPages {
    if (!_sectionPages) {
        _sectionPages = [NSMutableArray array];
    }
    return _sectionPages;
}

- (CGSize)pageSize {
    return self.collectionView.frame.size;
}

@end

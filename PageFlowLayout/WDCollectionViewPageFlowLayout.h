//
//  WDCollectionViewPageFlowLayout.h
//  Aipai
//
//  Created by warden on 2019/4/26.
//  Copyright © 2019 warden. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WDCollectionViewPageFlowLayout : UICollectionViewFlowLayout

/// 一行显示多少个，默认为4个
@property (nonatomic, assign) NSInteger itemCountPerRow;
/// 一页显示多少行，默认为2行
@property (nonatomic, assign) NSInteger rowCount;

/// 页内边距
@property (nonatomic, assign) UIEdgeInsets pageInset;

@end

NS_ASSUME_NONNULL_END

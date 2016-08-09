//
//  ZGBarrageLayout.h
//  ZGBarrage
//
//  Created by Zong on 16/8/8.
//  Copyright © 2016年 Zong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZGBarrageItemModel;

@class ZGBarrageView;

@interface ZGBarrageLayout : NSObject

@property (nonatomic, weak) ZGBarrageView *barrageView;
@property (nonatomic) NSInteger maxRows;

- (void)prepareLayout;
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath;
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath model:(nullable ZGBarrageItemModel *)model;

@end

//
//  ZGBarrageLayout.h
//  ZGBarrage
//
//  Created by Zong on 16/8/8.
//  Copyright © 2016年 Zong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZGBarrageItemModel;

@interface ZGBarrageLayout : NSObject

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndex:(NSInteger)index;
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndex:(NSInteger)index model:(nullable ZGBarrageItemModel *)model;

@end

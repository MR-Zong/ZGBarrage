//
//  ZGBarrageFlowLayout.h
//  ZGBarrage
//
//  Created by Zong on 16/8/9.
//  Copyright © 2016年 Zong. All rights reserved.
//

#import "ZGBarrageLayout.h"

@class ZGBarrageItemModel;

@interface ZGBarrageFlowLayout : ZGBarrageLayout

@property (nonatomic) CGFloat minimumLineSpacing;
@property (nonatomic) CGFloat minimumInteritemSpacing;
@property (nonatomic) UIEdgeInsets edgeInsets;
@property (nonatomic) CGSize itemSize;


@end

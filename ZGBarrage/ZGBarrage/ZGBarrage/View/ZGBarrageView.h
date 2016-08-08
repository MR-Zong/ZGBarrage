//
//  ZGBarrageContainView.h
//  ZGBarrage
//
//  Created by Zong on 16/8/8.
//  Copyright © 2016年 Zong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZGBarrageDataSource.h"

@class ZGBarrageCell;

@class ZGBarrageLayout;

@interface ZGBarrageView : UIView

/**
 * 初始化方法
 */
- (instancetype)initWithFrame:(CGRect)frame barrageLayout:(ZGBarrageLayout *)layout;

/**
 * 给弹幕上弹匣
 * magazine:中文意思 -- 弹匣
 */
- (void)addMagazine:(NSArray *)magazine;


/***
 * 从缓存池获取cell
 */
- (__kindof ZGBarrageCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;


@property (nonatomic, weak) id <ZGBarrageDataSource> dataSource;

@end

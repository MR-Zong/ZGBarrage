//
//  ZGBarrageContainView.h
//  ZGBarrage
//
//  Created by Zong on 16/8/8.
//  Copyright © 2016年 Zong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZGBarrageDataSource.h"

@class ZGMagazine;

@class ZGBarrageCell;

@class ZGBarrageLayout;

@class ZGEmitter;

@interface ZGBarrageView : UIView


@property (nonatomic, strong) ZGEmitter *emitter;


@property (nonatomic, assign) NSInteger currentIndex;

/**
 * reload
 */
- (void)reloadDataWithMagazine:(ZGMagazine *)magazine;

/**
 * 初始化方法
 */
- (instancetype)initWithFrame:(CGRect)frame barrageLayout:(ZGBarrageLayout *)layout;


/***
 * 从缓存池获取cell
 */
- (__kindof ZGBarrageCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;


@property (nonatomic, strong) id <ZGBarrageViewDataSource> dataSource;

@end

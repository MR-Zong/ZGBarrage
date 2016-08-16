//
//  ZGBarrageContainView.h
//  ZGBarrage
//
//  Created by Zong on 16/8/8.
//  Copyright © 2016年 Zong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZGBarrageViewDataSourceImplement.h"
#import "ZGBarrageFlowLayout.h"
#import "ZGBarrageItemModel.h"
#import "ZGEmitter.h"
#import "ZGBarrageViewDelegate.h"

@class ZGMagazine;

@class ZGBarrageCell;

@class ZGEmitter;

@interface ZGBarrageView : UIView

@property (nonatomic, weak) id <ZGBarrageViewDelegate> delegate;

@property (nonatomic, strong) ZGEmitter *emitter;


@property (nonatomic, strong) ZGBarrageLayout *layout;

/**
 * 设置，并显示弹幕模型数组，注意数组元素类型一定要ZGBarrageItemModel
 * 注意，此方法用于添加--自己发的弹幕
 */
- (void)addMineItemModel:(ZGBarrageItemModel *)mineItemModel;

/**
 * 设置，并显示弹幕模型数组，注意数组元素类型一定要ZGBarrageItemModel
 * 注意，此方法用于添加--别人发的弹幕
 */
- (void)addDataArray:(NSArray *)dataArray;

/**
 * reload
 */
- (void)reloadDataWithMagazine:(ZGMagazine *)magazine;

/**
 * 强制重置
 * 1,重置整个barrageView
 * 2,将会清空所有缓存数据
 * 3,所有的标志位都会设置回初始状态
 * 4，已经在飘的弹幕，也会被移除
 */
- (void)destroy;

/**
 * 重置整个barrageView
 * 1,将会清空所有缓存数据
 * 2,所有的标志位都会设置回初始状态
 * 3，已经在飘的弹幕，不会受到影响
 */
- (void)reset;

/**
 * 发射自己发的弹幕
 */
- (void)sendMineItemModelsArray:(NSMutableArray *)mineItemModelsArray;

/**
 * 初始化方法
 */
- (instancetype)initWithFrame:(CGRect)frame barrageLayout:(ZGBarrageLayout *)layout;


/**
 * 获取缓存数据总数
 */
- (NSInteger)totalCountOfItemModels;

/***
 * 从缓存池获取cell
 */
- (__kindof ZGBarrageCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;


/**
 * 获取最大显示行数
 */
- (NSInteger)getMaxRows;

@end

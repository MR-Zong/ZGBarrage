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

@class ZGMagazine;

@class ZGBarrageCell;

@class ZGEmitter;

@interface ZGBarrageView : UIView


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
 * 发射自己发的弹幕
 */
- (void)sendMineItemModelsArray:(NSMutableArray *)mineItemModelsArray;

/**
 * 初始化方法
 */
- (instancetype)initWithFrame:(CGRect)frame barrageLayout:(ZGBarrageLayout *)layout;


/***
 * 从缓存池获取cell
 */
- (__kindof ZGBarrageCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;


/**
 * 获取最大显示行数
 */
- (NSInteger)getMaxRows;

@end

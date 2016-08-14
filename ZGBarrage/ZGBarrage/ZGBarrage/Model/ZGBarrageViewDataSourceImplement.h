//
//  ZGBarrageViewDataSource.h
//  ZGBarrage
//
//  Created by Zong on 16/8/9.
//  Copyright © 2016年 Zong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZGBarrageDataSource.h"

@class  ZGBarrageView;

@interface ZGBarrageViewDataSourceImplement : NSObject <ZGBarrageViewDataSource>

@property (nonatomic, assign,readonly) NSInteger currentIndex;

@property (nonatomic, assign,readonly) NSInteger maxCount;

@property (nonatomic, assign,readonly) NSInteger totalCount;

// 用于缓存，我自己发的弹幕
@property(nonatomic, strong) NSMutableArray *mineItemModelsArray;


/**
 * 构造器
 */
+ (instancetype)barrageViewDataSourceImplementWithBarrageView:(ZGBarrageView *)barrageView;

@property (nonatomic, weak) ZGBarrageView *barrageView;

/**
 * 设置，并显示弹幕模型数组，注意数组元素类型一定要ZGBarrageItemModel
 * 注意，此方法用于添加--自己发的弹幕
 */
- (void)addMineItemModel:(ZGBarrageItemModel *)mineItemModel;

/**
 * 给弹幕上弹匣
 * magazine:中文意思 -- 弹匣
 */
- (void)addMagazine:(NSArray *)magazine;

/**
 * 重置dsI
 * 1,将会清空所有缓存数据
 * 2,所有的标志位都会设置回初始状态
 * 3，已经在飘的弹幕，不会受到影响
 */
- (void)reset;

- (void)emitCompleteWithMagazine:(ZGMagazine *)magazine;

@end

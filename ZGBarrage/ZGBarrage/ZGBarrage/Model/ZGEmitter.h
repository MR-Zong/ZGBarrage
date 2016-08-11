//
//  ZGEmitter.h
//  ZGBarrage
//
//  Created by Zong on 16/8/9.
//  Copyright © 2016年 Zong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZGBarrageCell.h"

@class ZGEmitter;

@class ZGMagazine;

@class ZGBarrageViewDataSourceImplement;

@protocol ZGEmitterDataSource <NSObject>

- (ZGBarrageCell *)emitter:(ZGEmitter *)emitter cellForItemAtIndexPath:(NSIndexPath *)indexPath itemModel:(ZGBarrageItemModel *)itemModel;
- (ZGMagazine *)getMagazineWithIndex:(NSInteger)index;
- (NSInteger)getMaxRows;

@end

@interface ZGEmitter : NSObject <ZGBarrageCellAnimateDelegate2>

/**
 * 注意，一定要先调用prepare
 */
- (void)prepare;

/**
 * 启动发射
 */
- (void)start;

/**
 * 发射一个barrageCell
 */
- (void)emitWithBarrageCell:(ZGBarrageCell *)cell;


@property (nonatomic, weak) ZGBarrageViewDataSourceImplement *barrageViewDataSource;
@property (nonatomic, weak) id <ZGEmitterDataSource> dataSource;

@end

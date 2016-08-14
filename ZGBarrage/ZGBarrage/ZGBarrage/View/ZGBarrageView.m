//
//  ZGBarrageContainView.m
//  ZGBarrage
//
//  Created by Zong on 16/8/8.
//  Copyright © 2016年 Zong. All rights reserved.
//

#import "ZGBarrageView.h"
#import "ZGBarrageCell.h"
#import "ZGMagazine.h"
#import "ZGEmitter.h"

@interface ZGBarrageView () <ZGBarrageCellAnimateDelegate,ZGEmitterDataSource>

@property (nonatomic, strong) ZGBarrageViewDataSourceImplement *dataSource;

// 循环重用cell池
@property (nonatomic,strong) NSMutableSet* reusableCachePool;

@end

@implementation ZGBarrageView

- (instancetype)initWithFrame:(CGRect)frame barrageLayout:(ZGBarrageLayout *)layout
{
    if (self = [super initWithFrame:frame]) {
        _layout = layout;
        _layout.barrageView = self;
        [_layout prepareLayout];
        
        _dataSource = [[ZGBarrageViewDataSourceImplement alloc] init];
        _dataSource.barrageView = self;
        
        _emitter = [[ZGEmitter alloc] init];
        _emitter.dataSource = self;
        _emitter.barrageViewDataSource = _dataSource;
        [_emitter prepare];
    }
    return self;
}

- (void)addMineItemModel:(ZGBarrageItemModel *)mineItemModel
{
    
    [self.dataSource addMineItemModel:mineItemModel];
}

- (void)addDataArray:(NSArray *)dataArray
{
    [self.dataSource addMagazine:dataArray];
}

- (ZGBarrageCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath
{
    __block ZGBarrageCell* anyObject = nil;
    [self.reusableCachePool enumerateObjectsUsingBlock:^(ZGBarrageCell* cell, BOOL *stop) {
        if ([cell.identifier isEqualToString:identifier]) {
            *stop = YES;
            anyObject = cell;
        }
    }];
    
    if (anyObject != nil) {
        [self.reusableCachePool removeObject:anyObject];
    }
    return anyObject;

}


- (NSInteger)getMaxRows
{
    return self.layout.maxRows;
}

- (void)sendMineItemModelsArray:(NSMutableArray *)mineItemModelsArray
{
    // 立即发射，自己发的弹幕
    [self.emitter sendMineItemModelsArray:mineItemModelsArray];
    
}


- (void)reloadDataWithMagazine:(ZGMagazine *)magazine
{
//    // 判断emitter里面是不是正在发射
//    if (self.emitter.magazine.firstStageOfLeaveCount > 0) {
//        // 正在发射就不用启动发射器了
//        return;
//    }

    // 发射器开始发射
    [_emitter startWithMagazine:magazine];
  
}

#pragma mark - ZGBarrageCellAnimateDelegate
- (void)animationDidStopWithCell:(ZGBarrageCell *)cell
{
    // 随着动画结束，该cell已经离开屏幕!!
    // 加入cell缓存池
    [self.reusableCachePool setValue:cell forKey:ZGBarrageCellReusableIdentifier];
    
    // dataSource 操作
    [self.dataSource manageMagazinesArrayWithItemModel:cell.itemModel];
    
    
}

#pragma mark - ZGEmitterDataSource
- (NSInteger)emitterGetMaxRows
{
    return self.layout.maxRows;
}

- (ZGMagazine *)getMagazineWithIndex:(NSInteger)index
{
    return [self.dataSource getMagazineWithIndex:index];
}

- (ZGBarrageCell *)emitter:(ZGEmitter *)emitter cellForItemAtIndexPath:(NSIndexPath *)indexPath itemModel:(ZGBarrageItemModel *)itemModel
{
    
//    NSLog(@"item %zd - section %zd",indexPath.item,indexPath.section);
    // 1,先拿到布局信息
    UICollectionViewLayoutAttributes *layoutAttribute = [self.layout layoutAttributesForItemAtIndexPath:indexPath itemModel:itemModel];
    
    // 2,拿到cell视图
    ZGBarrageCell *cell = [self.dataSource barrageView:self cellForItemAtIndexPath:indexPath];
    cell.frame = layoutAttribute.frame;
    
    cell.imageView.frame = CGRectMake(0, 0, 45, 45);
    cell.textLabel.frame = CGRectMake(45, 0, cell.bounds.size.width - 45, cell.bounds.size.height);
    cell.animateDelegate = self;
    cell.animateDelegate2 = self.emitter;
    cell.minimumInteritemSpacing = ((ZGBarrageFlowLayout *)self.layout).minimumInteritemSpacing;
    cell.itemModel = itemModel;
    cell.textLabel.text = itemModel.text;
    
    // 3,addSubview,并设置布局信息
    [self addSubview:cell];
    
    return cell;
    
}


@end

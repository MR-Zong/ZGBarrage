//
//  ZGBarrageContainView.m
//  ZGBarrage
//
//  Created by Zong on 16/8/8.
//  Copyright © 2016年 Zong. All rights reserved.
//

#import "ZGBarrageView.h"
#import "ZGBarrageLayout.h"
#import "ZGBarrageItemModel.h"
#import "ZGBarrageCell.h"
#import "ZGMagazine.h"
#import "ZGEmitter.h"

@interface ZGBarrageView () <ZGBarrageCellAnimateDelegate,ZGEmitterDataSource>

@property (nonatomic, strong) ZGBarrageLayout *layout;

@property (nonatomic, strong) NSSet *cellCachePool;

@end

@implementation ZGBarrageView

- (instancetype)initWithFrame:(CGRect)frame barrageLayout:(ZGBarrageLayout *)layout
{
    if (self = [super initWithFrame:frame]) {
        _layout = layout;
        _layout.barrageView = self;
        [_layout prepareLayout];
        
        _emitter = [[ZGEmitter alloc] init];
        _emitter.dataSource = self;
    }
    return self;
}



- (ZGBarrageCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}


- (void)reloadDataWithMagazine:(ZGMagazine *)magazine
{

    // 把数据交给发射器发射
    [_emitter start];
  
}

#pragma mark - ZGBarrageCellAnimateDelegate
- (void)animationDidStopWithCell:(ZGBarrageCell *)cell
{
    // 加入cell缓存池
    [self.cellCachePool setValue:cell forKey:@""];
    
    // dataSource 操作
    [self.dataSource manageMagazinesArrayWithItemModel:cell.itemModel];
    
    
}

#pragma mark - ZGEmitterDataSource
- (NSInteger)getMaxRows
{
    return self.layout.maxRows;
}

- (ZGMagazine *)getMagazineWithEmitter:(ZGEmitter *)emitter
{
    return [self.dataSource getMagazine];
}

- (ZGBarrageCell *)emitter:(ZGEmitter *)emitter cellForItemAtIndexPath:(NSIndexPath *)indexPath itemModel:(ZGBarrageItemModel *)itemModel
{
    
    // 1,先拿到布局信息
    UICollectionViewLayoutAttributes *layoutAttribute = [self.layout layoutAttributesForItemAtIndexPath:indexPath model:itemModel];
    
    // 2,拿到cell视图
    ZGBarrageCell *cell = [self.dataSource barrageView:self cellForItemAtIndexPath:indexPath];
    cell.frame = layoutAttribute.frame;
    cell.animateDelegate = self;
    cell.animateDelegate2 = self.emitter;
    
    // 3,addSubview,并设置布局信息
    [self addSubview:cell];
    
    return cell;
    
}


@end

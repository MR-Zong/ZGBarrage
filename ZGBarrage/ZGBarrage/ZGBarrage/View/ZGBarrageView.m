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
        
        [self observNotifications];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    [self destroy];
}

- (void)removeFromSuperview
{
    [self destroy];
    
    [super removeFromSuperview];
}

- (void)observNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didAppWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didAppEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
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
    [self.emitter sendMineItemModelsArray:mineItemModelsArray];
}


- (void)reloadDataWithMagazine:(ZGMagazine *)magazine
{
    [_emitter startWithMagazine:magazine];
}

- (void)destroy
{
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    [self.dataSource reset];
    [self.emitter destroy];
}

- (void)reset
{
    [self.dataSource reset];
    [self.emitter reset];
}

- (NSInteger)totalCountOfItemModels
{
    return self.dataSource.totalCount;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *tmpView = [super hitTest:point withEvent:event];
    if ( tmpView == self) {
        return nil;
    }else {
        return tmpView;
    }
}

#pragma mark - ZGBarrageCellAnimateDelegate
- (void)animationDidStopWithCell:(ZGBarrageCell *)cell
{
    [self.reusableCachePool setValue:cell forKey:ZGBarrageCellReusableIdentifier];
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
    UICollectionViewLayoutAttributes *layoutAttribute = [self.layout layoutAttributesForItemAtIndexPath:indexPath itemModel:itemModel];
    ZGBarrageCell *cell = [self.dataSource barrageView:self cellForItemAtIndexPath:indexPath];
    cell.frame = layoutAttribute.frame;
    cell.imageView.frame = CGRectMake(0, 0, 45, 45);
    cell.textLabel.frame = CGRectMake(45, 0, cell.bounds.size.width - 45, cell.bounds.size.height);
    cell.animateDelegate = self;
    cell.animateDelegate2 = self.emitter;
    cell.minimumInteritemSpacing = ((ZGBarrageFlowLayout *)self.layout).minimumInteritemSpacing;
    cell.itemModel = itemModel;
    
    [self addSubview:cell];
    
    return cell;
    
}

#pragma mark - observe notification
- (void)didAppWillEnterForeground:(NSNotification *)note
{
    [self destroy];
}

- (void)didAppEnterBackground:(NSNotification *)note
{
    [self destroy];
}

@end

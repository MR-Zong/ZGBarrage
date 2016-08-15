//
//  ZGBarrageViewDataSource.m
//  ZGBarrage
//
//  Created by Zong on 16/8/9.
//  Copyright © 2016年 Zong. All rights reserved.
//

#import "ZGBarrageViewDataSourceImplement.h"
#import "ZGMagazine.h"
#import "ZGBarrageItemModel.h"
#import "ZGBarrageView.h"
#import "ZGEmitter.h"
#import "ZGBarrageCell.h"

@interface ZGBarrageViewDataSourceImplement ()

@property (nonatomic, strong) NSMutableArray *magazinesArray;

@end

@implementation ZGBarrageViewDataSourceImplement

+ (instancetype)barrageViewDataSourceImplementWithBarrageView:(ZGBarrageView *)barrageView
{
    ZGBarrageViewDataSourceImplement *dsI = [[ZGBarrageViewDataSourceImplement alloc] init];
    dsI.barrageView = barrageView;
    return dsI;
}

- (instancetype)init
{
    if (self = [super init]) {
          _magazinesArray = [NSMutableArray array];
        _mineItemModelsArray = [NSMutableArray array];
    }
    return self;
}

- (void)addMineItemModel:(ZGBarrageItemModel *)mineItemModel
{
    // 上锁
    [self.mineItemModelsArray addObject:mineItemModel];
    
    // 添加完数据，通知barrageView将数据显示到屏幕
    [self.barrageView sendMineItemModelsArray:self.mineItemModelsArray];
    
}


- (void)addMagazine:(NSArray *)magazine
{
    // 必须上锁
    ZGMagazine *tmpMagazine = [[ZGMagazine alloc] init];
    tmpMagazine.startIndex = self.currentIndex; // 切记
    tmpMagazine.dataArray = magazine;
    tmpMagazine.leaveCount = magazine.count;
    tmpMagazine.firstStageOfLeaveCount = tmpMagazine.leaveCount;
    [self.magazinesArray addObject:tmpMagazine];
    tmpMagazine.indexInContainer = [self.magazinesArray indexOfObject:tmpMagazine];
    
    _maxCount += tmpMagazine.dataArray.count;
    _totalCount += tmpMagazine.dataArray.count;
    if (self.magazinesArray.count > 0) {
        _currentIndex += tmpMagazine.dataArray.count;
    }

    // 添加完数据，通知barrageView将数据显示到屏幕
    [self.barrageView reloadDataWithMagazine:tmpMagazine];
}

- (void)removeMagazineWithIndex:(NSInteger)index
{
    if (index < self.magazinesArray.count) {
        // 必须上锁
        _totalCount -= ((ZGMagazine *)self.magazinesArray[index]).dataArray.count;
        
        [self.magazinesArray removeObjectAtIndex:index];
        if (self.magazinesArray.count == 0) {
            _currentIndex = 0;
            [self.barrageView.emitter resetSectionLastedIndexPathDic];
            [self.barrageView.emitter resetCanEmitFlagDic];
        }
    }
}


- (void)reset
{
    self.magazinesArray = nil;
    self.magazinesArray = [NSMutableArray array];
    _currentIndex = 0;
}

- (ZGMagazine *)getMagazineWithIndex:(NSInteger)index
{
    if (index < self.magazinesArray.count) {
        return self.magazinesArray[index];
    }
    return nil;
}

- (ZGBarrageItemModel *)getItemModelWithIndexPath:(NSIndexPath *)indexPath
{
    NSInteger maxRows = [self.barrageView getMaxRows];
    NSInteger normalIndex = indexPath.item * maxRows + indexPath.section;
    if (normalIndex >= 0 && normalIndex < self.maxCount) {
        
        NSInteger indexOfMagazine = 0;
        NSInteger indexInMagazine = 0;
        while ((int)indexOfMagazine < (int)self.magazinesArray.count) {
            ZGMagazine *tmpMagazine = self.magazinesArray[indexOfMagazine];
            NSInteger startIndex = tmpMagazine.startIndex;
            NSInteger magazineLength = tmpMagazine.dataArray.count;
            if ( normalIndex >= startIndex && normalIndex < startIndex + magazineLength) {
                indexInMagazine = normalIndex - startIndex;
                break;
            }
            
            indexOfMagazine++;
        }
        
        if (indexOfMagazine >= self.magazinesArray.count) {
            return nil;
        }
        
        ZGMagazine *magazine = self.magazinesArray[indexOfMagazine];
        ZGBarrageItemModel *itemModel = magazine.dataArray[indexInMagazine];
        return itemModel;
        
    }else {
        return nil;
    }
}

/**
 * 第二阶段动画完成的回调
 */
- (void)manageMagazinesArrayWithItemModel:(ZGBarrageItemModel *)itemModel
{
    if (self.magazinesArray.count > 0) {
        NSIndexPath *indexPath = itemModel.indexPath;
        NSInteger maxRows = [self.barrageView getMaxRows];
        NSInteger normalIndex = indexPath.item * maxRows + indexPath.section;
        
        if (normalIndex >= 0 && normalIndex < self.maxCount) {
            NSInteger indexOfMagazine = 0;
            NSInteger indexInMagazine = 0;
            while ((int)indexOfMagazine < (int)self.magazinesArray.count) {
                ZGMagazine *tmpMagazine = self.magazinesArray[indexOfMagazine];
                NSInteger startIndex = tmpMagazine.startIndex;
                NSInteger magazineLength = tmpMagazine.dataArray.count;
                if ( normalIndex >= startIndex && normalIndex < startIndex + magazineLength) {
                    indexInMagazine = normalIndex - startIndex;
                    break;
                }
                
                indexOfMagazine++;
            }
            
            if (indexOfMagazine >= self.magazinesArray.count) {
                return ;
            }
            
            ZGMagazine *magazine = self.magazinesArray[indexOfMagazine];
            magazine.leaveCount--;
            if ( magazine && magazine.leaveCount <= 0) {
                [self removeMagazineWithIndex:indexOfMagazine];
            }
        }
    }
}

- (NSInteger)numberOfItemsWithBarrageView:(ZGBarrageView *)barrageView
{
    return 19;
}


- (ZGBarrageCell *)barrageView:(ZGBarrageView *)barrageView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZGBarrageCell *cell = [barrageView dequeueReusableCellWithIdentifier:ZGBarrageCellReusableIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[ZGBarrageCell alloc] initWithReusableIdentifier:ZGBarrageCellReusableIdentifier];
    }
    
    cell.backgroundColor = [UIColor orangeColor];
    return cell;
}

#pragma mark - emitter 发射完一个magazine
- (void)emitCompleteWithMagazine:(ZGMagazine *)magazine
{
    // 这个方法就提供一下，以后有需要拓展
}

@end

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
    NSLog(@"tmpMagazine.startIndex %zd",tmpMagazine.startIndex);
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
        // 移除就要减去totalCount
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
    // 1,将会清空所有缓存数据
    self.magazinesArray = nil;
    self.magazinesArray = [NSMutableArray array];
    
    // 2,所有的标志位都会设置回初始状态
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
    // 根据indexPath，来获取
    
    //    NSInteger section = 0;
    //    NSInteger item = 0;
    //    for (int i=0; i<self.magazine.count; i++) {
    //        item = i / self.maxRows;
    //        section = i % self.maxRows;
    //    }

    // 1，把indexPath 转换 一维index
    NSInteger maxRows = [self.barrageView getMaxRows];
    NSInteger normalIndex = indexPath.item * maxRows + indexPath.section;
    
    // 2,必须注意indexPath必须是有效的
    if (normalIndex >= 0 && normalIndex < self.maxCount) { // 有效
        
        //3,一维index 转换成 在哪个magazine的第几个index
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
            // 说明这个indexPath的itemModel所在的magazine已经由于全部发射完成，而被移除
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
    // 检查是否是这个magazine已经显示完
    if (self.magazinesArray.count > 0) {
        // 根据itemModel.indexPath 算出该itemModel属于哪个magazine
        // 1，把indexPath 转换 一维index
        NSIndexPath *indexPath = itemModel.indexPath;
        NSInteger maxRows = [self.barrageView getMaxRows];
        NSInteger normalIndex = indexPath.item * maxRows + indexPath.section;
        
        // 2,必须注意indexPath必须是有效的
        if (normalIndex >= 0 && normalIndex < self.maxCount) { // 有效
            
            //3,一维index 转换成 在哪个magazine的第几个index
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
                // 说明这个indexPath的itemModel所在的magazine已经由于全部发射完成，而被移除
                return ;
            }
            
            ZGMagazine *magazine = self.magazinesArray[indexOfMagazine];
            // 对magazine.leaveCount 减一
            magazine.leaveCount--;
            if ( magazine && magazine.leaveCount <= 0) { // 如果显示完，就要移除这个magazine
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
    // 不能移除，因为这里才第一阶段的完成而已
    // 要第二阶段动画全部完成才能移除magazine
    // 所以这个方法就提供一下，以后有需要拓展
    // 移除发射完的magazine
//    [self removeMagazineWithIndex:magazine.indexInContainer];
}

@end

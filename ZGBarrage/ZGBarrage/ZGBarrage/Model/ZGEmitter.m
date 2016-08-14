//
//  ZGEmitter.m
//  ZGBarrage
//
//  Created by Zong on 16/8/9.
//  Copyright © 2016年 Zong. All rights reserved.
//

#import "ZGEmitter.h"
#import "ZGBarrageItemModel.h"
#import "ZGBarrageCell.h"
#import "ZGMagazine.h"
#import "ZGBarrageViewDataSourceImplement.h"

@interface ZGEmitter ()

/**能否发射标志*/
@property (nonatomic, strong) NSMutableDictionary *canEmitFlagDic;

/**该section是否有弹幕在飘*/
@property (nonatomic, strong) NSMutableDictionary *hasItemInSectionFlagDic;

/**弹道当前indexPath*/
@property (nonatomic, strong) NSMutableDictionary *sectionLastedEmitIndexPathDic;


@property (nonatomic, assign) NSInteger maxRows;


@end

@implementation ZGEmitter

- (void)prepare
{
    // 发射前，要知道最大行数
    self.maxRows = [self.dataSource emitterGetMaxRows];
    
    // 初始化每行是否可以发射的标志
    self.canEmitFlagDic = [NSMutableDictionary dictionary];
    for (int i=0; i<self.maxRows; i++) {
        [self.canEmitFlagDic setObject:@(YES) forKey:[NSString stringWithFormat:@"%zd",i]];
    }
    
    // 初始化弹道当前indexPath
    self.sectionLastedEmitIndexPathDic = [NSMutableDictionary dictionary];
    for (int i=0; i<self.maxRows; i++) {
        [self.sectionLastedEmitIndexPathDic setObject:[NSIndexPath indexPathForItem:-1 inSection:i] forKey:[NSString stringWithFormat:@"%zd",i]];
    }

    
    // 初始化每行是否已经有item的标志
    self.hasItemInSectionFlagDic = [NSMutableDictionary dictionary];
    for (int i=0; i<self.maxRows; i++) {
        [self.hasItemInSectionFlagDic setObject:@(NO) forKey:[NSString stringWithFormat:@"%zd",i]];
    }

    

}


- (void)sendMineItemModelsArray:(NSMutableArray *)mineItemModelsArray
{
    // 扫描全部弹道
    for (int i=0; i<self.maxRows; i++) {
        NSInteger section = i;
        // 每次扫描操作
        // 1,判断该弹道的标志是否为yes
        if ([[self.canEmitFlagDic valueForKey:[NSString stringWithFormat:@"%zd",i]] boolValue] == YES) {
            
            // 自己的弹幕用的就是当前弹道的lastedIndexPath
            NSIndexPath *lastedIndexPath = self.sectionLastedEmitIndexPathDic[[NSString stringWithFormat:@"%zd",section]];
            
            // 获取mineItemModelsArray.firstObject
            ZGBarrageItemModel *mineItemModel = mineItemModelsArray.firstObject;
            if (!mineItemModel) { // 为空，说明已经发射完自己的弹幕
                return;
            }
            
            // 修改mineItemModel的indexPath 为 lastedIndexPath
            mineItemModel.indexPath = lastedIndexPath;
            
            // 根据LastedIndexPath 获取cell
            ZGBarrageCell *cell = [self.dataSource emitter:self cellForItemAtIndexPath:lastedIndexPath itemModel:mineItemModel];
            cell.itemModel.indexPath = lastedIndexPath;
            [cell startAnimation];
            cell.itemModel.isEmit = YES;
            // 发射后，设置标志位
            [self.canEmitFlagDic setValue:@(NO) forKey:[NSString stringWithFormat:@"%zd",section]];
            [self.sectionLastedEmitIndexPathDic setObject:lastedIndexPath forKey:[NSString stringWithFormat:@"%zd",section]];
            
            // 发射完自己的弹幕，要移除mineItemModel
            [self.barrageViewDataSource.mineItemModelsArray removeObjectAtIndex:0];
            
        }else { // 判断该弹道的标志为no
            NSLog(@"NO,不用管，emitter自己会发射");
        }
    }

}


- (void)startWithMagazine:(ZGMagazine *)magazine
{
    // 每次addMagazine都要扫描全部弹道
    for (int i=0; i<self.maxRows; i++) {
        // 每次扫描操作
        // 1,判断该弹道标志是否为yes
        if ([[self.canEmitFlagDic valueForKey:[NSString stringWithFormat:@"%zd",i]] boolValue] == YES) {
            
            // 2,取当前弹道sectionLastedEmitIndexPathDic ,并由它算出nextIndexPath
            NSInteger item = 0;
            NSInteger section = i;
            NSIndexPath *lastedIndexPath = self.sectionLastedEmitIndexPathDic[[NSString stringWithFormat:@"%zd",section]];
            if (lastedIndexPath.item == -1) { // 该弹道从未发射过item
                item = 0;
            }else {
                item = lastedIndexPath.item + 1;
            }
            NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
            NSLog(@"nextIndexPath,item = %zd,section = %zd",nextIndexPath.item,nextIndexPath.section);
            
            
            
            // 3,根据nextIndexPath,获取itemModel
            ZGBarrageItemModel *nextItemModel = [self.barrageViewDataSource getItemModelWithIndexPath:nextIndexPath];
            
            if (!nextItemModel) { // 为空，说明没有此itemModel
                ;
            }else {
                
                // 有，根据itemModel，获取cell,然后，立即发射
                ZGBarrageCell *cell = [self.dataSource emitter:self cellForItemAtIndexPath:nextIndexPath itemModel:nextItemModel];
                cell.itemModel.indexPath = nextIndexPath;
                [cell startAnimation];
                cell.itemModel.isEmit = YES;
                // 发射后，设置标志位
                [self.canEmitFlagDic setValue:@(NO) forKey:[NSString stringWithFormat:@"%zd",section]];
                [self.sectionLastedEmitIndexPathDic setObject:nextIndexPath forKey:[NSString stringWithFormat:@"%zd",section]];
            }
            
        }else { // 判断该弹道标志是否为NO
             NSLog(@"还不能发,什么都不做，因为emitter会自己接着来获取它，并发射");
        }
    }
    
    
    
    return;
    // 第一种方案
    // 判断是不是正在发射
    if (!self.magazine && self.magazine.firstStageOfLeaveCount<= 0) { // 没有在发射
        self.magazine = magazine;
        [self emitStart];
        
    }else { // 正在发射中

        NSInteger Count = self.maxRows < magazine.dataArray.count ? self.maxRows : magazine.dataArray.count;
        NSInteger endIndex = magazine.startIndex + Count;
        for (int i=(int)magazine.startIndex; i<endIndex; i++) {
            NSInteger item = i / self.maxRows;
            NSInteger section = i % self.maxRows;
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            NSLog(@"item %zd - section %zd",indexPath.item,indexPath.section);
            
            // 必须判断前一排ItemModel有没有发射过,否则会漏数据
            NSIndexPath *previousIndexPath = [NSIndexPath indexPathForItem:item - 1 inSection:section];
            ZGBarrageItemModel *previousItemModel = [self.barrageViewDataSource getItemModelWithIndexPath:previousIndexPath];
            if ( previousItemModel == nil || previousItemModel.isEmit == YES) { // 前面的数据已经发射掉了,这样再发射就不会漏掉前面的数据
                
                // 判断该section能否发射
                if ([[self.canEmitFlagDic valueForKey:[NSString stringWithFormat:@"%zd",section]] boolValue] == YES) {
                    // 可以发射
                    NSInteger index = i - magazine.startIndex;
                    ZGBarrageItemModel *itemModel = magazine.dataArray[index];
                    // 一定要记得赋值
                    itemModel.indexPath = indexPath;
                    itemModel.magazineIndexInContainer = magazine.indexInContainer;
                    ZGBarrageCell *cell = [self.dataSource emitter:self cellForItemAtIndexPath:indexPath itemModel:itemModel];
                    [cell startAnimation];
                    cell.itemModel.isEmit = YES;
                    // 发射后，设置标志位
                    [self.canEmitFlagDic setValue:@(NO) forKey:[NSString stringWithFormat:@"%zd",section]];
                }else {
                    NSLog(@"还不能发,什么都不做，因为emitter会自己接着来获取它，并发射");
                }
            }
            
        }

    }
    
}


// 第一种方案
- (void)emitStart
{
    // 一开始发射的时候，要算出该magazine的起始indexPath
    // 起始就是通过self.barrage.currenIndex来算
    
    NSLog(@"emitStart--startIndex %zd",self.magazine.startIndex);
    NSInteger Count = self.maxRows < self.magazine.dataArray.count ? self.maxRows : self.magazine.dataArray.count;
    NSInteger endIndex = self.magazine.startIndex + Count;
    for (int i=(int)self.magazine.startIndex; i<endIndex; i++) {
        NSInteger item = i / self.maxRows;
        NSInteger section = i % self.maxRows;
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
        NSLog(@"item %zd - section %zd",indexPath.item,indexPath.section);
        // 判断该section能否发射
        if ([[self.canEmitFlagDic valueForKey:[NSString stringWithFormat:@"%zd",section]] boolValue] == YES) {
             // 可以发射
            NSInteger index = i - self.magazine.startIndex;
            ZGBarrageItemModel *itemModel = self.magazine.dataArray[index];
            // 一定要记得赋值
            itemModel.indexPath = indexPath;
            itemModel.magazineIndexInContainer = self.magazine.indexInContainer;
            ZGBarrageCell *cell = [self.dataSource emitter:self cellForItemAtIndexPath:indexPath itemModel:itemModel];
            [cell startAnimation];
            cell.itemModel.isEmit = YES;
            // 发射后，设置标志位
            [self.canEmitFlagDic setValue:@(NO) forKey:[NSString stringWithFormat:@"%zd",section]];
        }else {
            NSLog(@"还不能发");
        }
    }
    

    
}


- (void)emitWithBarrageCell:(ZGBarrageCell *)cell
{
    // 找下一个itemModel,之前，要先检查是否有自己发的弹幕
    if (self.barrageViewDataSource.mineItemModelsArray.count > 0) { // 有自己的弹幕未发，就要优先发
        NSInteger section = cell.itemModel.indexPath.section;
        // 发射自己的弹幕
        // 自己的弹幕用的就是当前弹道的lastedIndexPath
        NSIndexPath *lastedIndexPath = self.sectionLastedEmitIndexPathDic[[NSString stringWithFormat:@"%zd",section]];
        
        // 获取mineItemModelsArray.firstObject
        ZGBarrageItemModel *mineItemModel = self.barrageViewDataSource.mineItemModelsArray.firstObject;
        
        // 修改mineItemModel的indexPath 为 lastedIndexPath
        mineItemModel.indexPath = lastedIndexPath;
        
        // 根据LastedIndexPath 获取cell
        ZGBarrageCell *cell = [self.dataSource emitter:self cellForItemAtIndexPath:lastedIndexPath itemModel:mineItemModel];
        cell.itemModel.indexPath = lastedIndexPath;
        [cell startAnimation];
        cell.itemModel.isEmit = YES;
        // 发射后，设置标志位
        [self.canEmitFlagDic setValue:@(NO) forKey:[NSString stringWithFormat:@"%zd",section]];
        [self.sectionLastedEmitIndexPathDic setObject:lastedIndexPath forKey:[NSString stringWithFormat:@"%zd",section]];

        // 发射完自己的弹幕，要移除mineItemModel
        [self.barrageViewDataSource.mineItemModelsArray removeObjectAtIndex:0];
        
        // 返回，不用再去发射别人发的弹幕
        return;
        
    }
    
    
    // 这里查找同section 下一个cell 有个问题,如果下一个cell不在这个magazine要怎么处理
    // 2,取当前弹道sectionLastedEmitIndexPathDic ,并由它算出nextIndexPath
    NSInteger item = 0;
    NSInteger section = cell.itemModel.indexPath.section;
    NSIndexPath *lastedIndexPath = self.sectionLastedEmitIndexPathDic[[NSString stringWithFormat:@"%zd",section]];
    if (lastedIndexPath.item == -1) { // 该弹道从未发射过item
        item = 0;
    }else {
        item = lastedIndexPath.item + 1;
    }
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
    
    // 根据nextIndexPath，获取nextItemModel
    ZGBarrageItemModel *nextItemModel = [self.barrageViewDataSource getItemModelWithIndexPath:nextIndexPath];
    
    if (!nextItemModel) { // 为空，说明没有此itemModel
        ;
    }else {
        
        // 有，根据itemModel，获取cell,然后，立即发射
        ZGBarrageCell *cell = [self.dataSource emitter:self cellForItemAtIndexPath:nextIndexPath itemModel:nextItemModel];
        cell.itemModel.indexPath = nextIndexPath;
        [cell startAnimation];
        cell.itemModel.isEmit = YES;
        // 发射后，设置标志位
        [self.canEmitFlagDic setValue:@(NO) forKey:[NSString stringWithFormat:@"%zd",section]];
        [self.sectionLastedEmitIndexPathDic setObject:nextIndexPath forKey:[NSString stringWithFormat:@"%zd",section]];
    }

    
    
    
    
    return;
    
    // 第一种方案
    //    NSInteger section = 0;
    //    NSInteger item = 0;
    //    for (int i=0; i<self.magazine.count; i++) {
    //        item = i / self.maxRows;
    //        section = i % self.maxRows;
    //    }
    
    // 判断，同行（section）的下一个，有没有超出magazine
    //    NSInteger item = cell.itemModel.indexPath.item;
    //    NSInteger section = cell.itemModel.indexPath.section;
    
    // 这里查找同section 下一个cell 有个问题,如果下一个cell不在这个magazine要怎么处理
    if ( ((item + 1) * self.maxRows + section) >= self.magazine.startIndex  && ( (item + 1) * self.maxRows + section) <  (self.magazine.startIndex + self.magazine.dataArray.count) ) {
        
        
        
        // 没有超出magazine
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:(item+1) inSection:section];
        ZGBarrageItemModel *itemModel = self.magazine.dataArray[( (item + 1) * self.maxRows + section) -  self.magazine.startIndex];
        itemModel.indexPath = indexPath;
         NSLog(@"item %zd - section %zd",itemModel.indexPath.item,itemModel.indexPath.section);
        // 其实可以不用赋值的，因为永远都是第一个magazine
        itemModel.magazineIndexInContainer = self.magazine.indexInContainer;
        ZGBarrageCell *cell = [self.dataSource emitter:self cellForItemAtIndexPath:indexPath itemModel:itemModel];
        [cell startAnimation];
        cell.itemModel.isEmit = YES;
        [self.canEmitFlagDic setValue:@(NO) forKey:[NSString stringWithFormat:@"%zd",section]];
    }else {
        // 判断是否magazine全部发射完成
        if (self.magazine.firstStageOfLeaveCount <=0 )
        {
            // 通知dataSource，本次magazine已经发射完成，要更换magazine了
            [self.barrageViewDataSource emitCompleteWithMagazine:self.magazine];
            
            // emitter 立马要获取一个新的magazine来发射
            self.magazine = [self.dataSource getMagazineWithIndex:(self.magazine.indexInContainer + 1)];
            
            NSLog(@"self.magazine.startIndex %zd",self.magazine.startIndex);
            if (self.magazine == nil) { // 获取新的magazine是Nil说明magazinesArray全部发射完
                return;
            }
            // 对新的magazine，重新一轮发射
            [self emitStart];
        }
    }
}


- (void)resetSectionLastedIndexPathDic
{
    for (int i=0; i<self.maxRows; i++) {
        [self.sectionLastedEmitIndexPathDic setObject:[NSIndexPath indexPathForItem:-1 inSection:i] forKey:[NSString stringWithFormat:@"%zd",i]];
    }
}

#pragma mark - ZGBarrageCellAnimateDelegate2
- (void)animation2DidStopWithCell:(ZGBarrageCell *)cell
{
    [self.canEmitFlagDic setValue:@(YES) forKey:[NSString stringWithFormat:@"%zd",cell.itemModel.indexPath.section]];
    
    // 此时，第一阶段发射完一个cell了
    // 发射一个，magezine.firstStageOfLeaveCount 要减一
    self.magazine.firstStageOfLeaveCount--;
    
    [self emitWithBarrageCell:cell];
}

@end

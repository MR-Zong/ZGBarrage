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

/**弹道当前indexPath*/
@property (nonatomic, strong) NSMutableDictionary *sectionLastedEmitIndexPathDic;


@property (nonatomic, assign) NSInteger maxRows;


@end

@implementation ZGEmitter

- (void)prepare
{
    self.maxRows = [self.dataSource emitterGetMaxRows];
    
    self.canEmitFlagDic = [NSMutableDictionary dictionary];
    for (int i=0; i<self.maxRows; i++) {
        [self.canEmitFlagDic setObject:@(YES) forKey:[NSString stringWithFormat:@"%zd",i]];
    }

    self.sectionLastedEmitIndexPathDic = [NSMutableDictionary dictionary];
    for (int i=0; i<self.maxRows; i++) {
        [self.sectionLastedEmitIndexPathDic setObject:[NSIndexPath indexPathForItem:-1 inSection:i] forKey:[NSString stringWithFormat:@"%zd",i]];
    }

}


- (void)sendMineItemModelsArray:(NSMutableArray *)mineItemModelsArray
{
    for (int i=0; i<self.maxRows; i++) {
        NSInteger section = i;
        if ([[self.canEmitFlagDic valueForKey:[NSString stringWithFormat:@"%zd",i]] boolValue] == YES) {
            
            NSIndexPath *lastedIndexPath = self.sectionLastedEmitIndexPathDic[[NSString stringWithFormat:@"%zd",section]];
            
            ZGBarrageItemModel *mineItemModel = mineItemModelsArray.firstObject;
            if (!mineItemModel) {
                return;
            }
            
            mineItemModel.indexPath = lastedIndexPath;
            
            ZGBarrageCell *cell = [self.dataSource emitter:self cellForItemAtIndexPath:lastedIndexPath itemModel:mineItemModel];
            cell.itemModel.indexPath = lastedIndexPath;
            [cell startAnimation];
            cell.itemModel.isEmit = YES;
            // 发射后，设置标志位
            [self.canEmitFlagDic setValue:@(NO) forKey:[NSString stringWithFormat:@"%zd",section]];
            [self.sectionLastedEmitIndexPathDic setObject:lastedIndexPath forKey:[NSString stringWithFormat:@"%zd",section]];
            
            [self.barrageViewDataSource.mineItemModelsArray removeObjectAtIndex:0];
            
        }else {
//            NSLog(@"NO,不用管，emitter自己会发射");
        }
    }

}


- (void)startWithMagazine:(ZGMagazine *)magazine
{
    for (int i=0; i<self.maxRows; i++) {

        if ([[self.canEmitFlagDic valueForKey:[NSString stringWithFormat:@"%zd",i]] boolValue] == YES) {
            
            NSInteger item = 0;
            NSInteger section = i;
            NSIndexPath *lastedIndexPath = self.sectionLastedEmitIndexPathDic[[NSString stringWithFormat:@"%zd",section]];
            if (lastedIndexPath.item == -1) {
                item = 0;
            }else {
                item = lastedIndexPath.item + 1;
            }
            NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:item inSection:section];            
            ZGBarrageItemModel *nextItemModel = [self.barrageViewDataSource getItemModelWithIndexPath:nextIndexPath];
            
            if (!nextItemModel) {
                ;
            }else {
                ZGBarrageCell *cell = [self.dataSource emitter:self cellForItemAtIndexPath:nextIndexPath itemModel:nextItemModel];
                cell.itemModel.indexPath = nextIndexPath;
                [cell startAnimation];
                cell.itemModel.isEmit = YES;
                // 发射后，设置标志位
                [self.canEmitFlagDic setValue:@(NO) forKey:[NSString stringWithFormat:@"%zd",section]];
                [self.sectionLastedEmitIndexPathDic setObject:nextIndexPath forKey:[NSString stringWithFormat:@"%zd",section]];
            }
            
        }else {
            //             NSLog(@"还不能发,什么都不做，因为emitter会自己接着来获取它，并发射");
        }
    }
    
}



- (void)emitWithBarrageCell:(ZGBarrageCell *)cell
{
    if (self.barrageViewDataSource.mineItemModelsArray.count > 0) {
        NSInteger section = cell.itemModel.indexPath.section;
        NSIndexPath *lastedIndexPath = self.sectionLastedEmitIndexPathDic[[NSString stringWithFormat:@"%zd",section]];
 
        ZGBarrageItemModel *mineItemModel = self.barrageViewDataSource.mineItemModelsArray.firstObject;
        mineItemModel.indexPath = lastedIndexPath;
        
        ZGBarrageCell *cell = [self.dataSource emitter:self cellForItemAtIndexPath:lastedIndexPath itemModel:mineItemModel];
        cell.itemModel.indexPath = lastedIndexPath;
        [cell startAnimation];
        cell.itemModel.isEmit = YES;
        // 发射后，设置标志位
        [self.canEmitFlagDic setValue:@(NO) forKey:[NSString stringWithFormat:@"%zd",section]];
        [self.sectionLastedEmitIndexPathDic setObject:lastedIndexPath forKey:[NSString stringWithFormat:@"%zd",section]];

        [self.barrageViewDataSource.mineItemModelsArray removeObjectAtIndex:0];
        
        return;
        
    }
    
    
    NSInteger item = 0;
    NSInteger section = cell.itemModel.indexPath.section;
    NSIndexPath *lastedIndexPath = self.sectionLastedEmitIndexPathDic[[NSString stringWithFormat:@"%zd",section]];
    if (lastedIndexPath.item == -1) {
        item = 0;
    }else {
        item = lastedIndexPath.item + 1;
    }
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
    ZGBarrageItemModel *nextItemModel = [self.barrageViewDataSource getItemModelWithIndexPath:nextIndexPath];
    
    if (!nextItemModel) {
        ;
    }else {
        ZGBarrageCell *cell = [self.dataSource emitter:self cellForItemAtIndexPath:nextIndexPath itemModel:nextItemModel];
        cell.itemModel.indexPath = nextIndexPath;
        [cell startAnimation];
        cell.itemModel.isEmit = YES;
        // 发射后，设置标志位
        [self.canEmitFlagDic setValue:@(NO) forKey:[NSString stringWithFormat:@"%zd",section]];
        [self.sectionLastedEmitIndexPathDic setObject:nextIndexPath forKey:[NSString stringWithFormat:@"%zd",section]];
    }

}



- (void)resetSectionLastedIndexPathDic
{
    for (int i=0; i<self.maxRows; i++) {
        [self.sectionLastedEmitIndexPathDic setObject:[NSIndexPath indexPathForItem:-1 inSection:i] forKey:[NSString stringWithFormat:@"%zd",i]];
    }
}

- (void)resetCanEmitFlagDic
{
    for (int i=0; i<self.maxRows; i++) {
        [self.canEmitFlagDic setObject:@(YES) forKey:[NSString stringWithFormat:@"%zd",i]];
    }
}

- (void)reset
{
    [self resetSectionLastedIndexPathDic];
}

- (void)destroy
{
    [self resetSectionLastedIndexPathDic];
    [self resetCanEmitFlagDic];
}

#pragma mark - ZGBarrageCellAnimateDelegate2
- (void)animation2DidStopWithCell:(ZGBarrageCell *)cell
{
    [self.canEmitFlagDic setValue:@(YES) forKey:[NSString stringWithFormat:@"%zd",cell.itemModel.indexPath.section]];
    self.magazine.firstStageOfLeaveCount--;
    [self emitWithBarrageCell:cell];
}

@end

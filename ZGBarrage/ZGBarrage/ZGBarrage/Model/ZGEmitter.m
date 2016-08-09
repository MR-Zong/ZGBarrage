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

@interface ZGEmitter ()

@property (nonatomic, strong) ZGMagazine *magazine;

@property (nonatomic, strong) NSMutableDictionary *flagDic;


@property (nonatomic, assign) NSInteger maxRows;


@end

@implementation ZGEmitter

- (void)start
{
    // 判断是不是第一次发射
    if (!self.magazine) {
        
        // 发射前，要知道最大行数
        self.maxRows = [self.dataSource getMaxRows];
        
        // 初始化每行是否可以发射的标志
        self.flagDic = [NSMutableDictionary dictionary];
        for (int i=0; i<self.maxRows; i++) {
            [self.flagDic setObject:@(YES) forKey:[NSString stringWithFormat:@"%zd",i]];
        }
        
        
        self.magazine = [self.dataSource getMagazineWithEmitter:self];
        
        // 开始发射
        [self emitStart];
    }
    
}

- (void)emitStart
{
    NSInteger Count = self.maxRows < self.magazine.count ? self.maxRows : self.magazine.count;
    for (int i=0; i<Count; i++) {
        NSInteger item = 0;
        NSInteger section = i;
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
        ZGBarrageCell *cell = [self.dataSource emitter:self cellForItemAtIndexPath:indexPath itemModel:self.magazine[item]];
        
        // 判断该section是否可以发射
        if ([[self.flagDic valueForKey:[NSString stringWithFormat:@"%zd",section]] boolValue] == YES) {
            [cell startAnimation];
            [self.flagDic setValue:@(NO) forKey:[NSString stringWithFormat:@"%zd",section]];
        }
    }
}

- (void)emitWithBarrageCell:(ZGBarrageCell *)cell
{
    
//    NSInteger section = 0;
//    NSInteger item = 0;
//    for (int i=0; i<self.magazine.count; i++) {
//        item = i / self.maxRows;
//        section = i % self.maxRows;
//    }
    
    // 判断，同行（section）的下一个，有没有超出magazine
    NSInteger item = cell.itemModel.indexPath.item;
    NSInteger section = cell.itemModel.indexPath.section;
    if ( ( (item + 1) * self.maxRows + section) < self.magazine.count ) {
        // 没有超出magazine
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:(item+1) inSection:section];
        ZGBarrageCell *cell = [self.dataSource emitter:self cellForItemAtIndexPath:indexPath itemModel:self.magazine[item]];
        [cell startAnimation];
        [self.flagDic setValue:@(NO) forKey:[NSString stringWithFormat:@"%zd",section]];
    }else {
        // 判断是否magazine全部发射完成
        if (self.magazine.leaveCount <=0 )
        {
            // 通知dataSource，本次magazine已经发射完成，要更换magazine了
        }
    }
}

#pragma mark - ZGBarrageCellAnimateDelegate2
- (void)animation2DidStopWithCell:(ZGBarrageCell *)cell
{
    [self.flagDic setValue:@(YES) forKey:[NSString stringWithFormat:@"%zd",cell.itemModel.indexPath.section]];
    [self emitWithBarrageCell:cell];
}

@end

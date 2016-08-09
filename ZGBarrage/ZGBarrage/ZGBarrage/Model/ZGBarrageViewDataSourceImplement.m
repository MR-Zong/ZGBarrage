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
    }
    return self;
}

- (void)addMagazine:(NSArray *)magazine
{
    // 必须上锁
    ZGMagazine *tmpMagazine = (ZGMagazine *)magazine;
    tmpMagazine.leaveCount = magazine.count;
    [self.magazinesArray addObject:tmpMagazine];
    
    // 添加完数据，通知barrageView将数据显示到屏幕
    [self.barrageView reloadDataWithMagazine:tmpMagazine];
    
    // 添加完magazine 通知emitter
//    [self.barrageView.emitter start];
    
}

- (void)removeMagazineWithIndex:(NSInteger)index
{
    // 必须上锁
    [self.magazinesArray removeObjectAtIndex:index];
    
    if (self.magazinesArray.count == 0) {
        self.barrageView.currentIndex = 0;
    }
}


- (ZGMagazine *)getMagazine
{
    return self.magazinesArray.firstObject;
}

- (void)manageMagazinesArrayWithItemModel:(ZGBarrageItemModel *)itemModel
{
    // 对magazine.leaveCount 减一
    ZGMagazine *magazine = self.magazinesArray[itemModel.containerIndex];
    magazine.leaveCount--;
    
    // 检查是否是这个magazine已经显示完
    if (magazine.leaveCount <= 0) { // 如果显示完，就要移除这个magazine
        [self removeMagazineWithIndex:itemModel.containerIndex];
    }
}

- (NSInteger)numberOfItemsWithBarrageView:(ZGBarrageView *)barrageView
{
    return 19;
}

- (ZGBarrageCell *)barrageView:(ZGBarrageView *)barrageView cellForItemAtIndex:(NSInteger)index
{
    return nil;
}

@end

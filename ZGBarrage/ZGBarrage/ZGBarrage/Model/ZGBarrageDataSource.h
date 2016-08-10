//
//  ZGBarrageDataSource.h
//  ZGBarrage
//
//  Created by Zong on 16/8/8.
//  Copyright © 2016年 Zong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZGBarrageView;

@class ZGBarrageCell;

@class ZGBarrageItemModel;

@class ZGMagazine;

@protocol ZGBarrageViewDataSource <NSObject>

@required

- (NSInteger)numberOfItemsWithBarrageView:(ZGBarrageView *)barrageView;


- (ZGBarrageCell *)barrageView:(ZGBarrageView *)barrageView cellForItemAtIndexPath:(NSIndexPath *)indexPath;

- (void)manageMagazinesArrayWithItemModel:(ZGBarrageItemModel *)itemModel;


- (ZGMagazine *)getMagazineWithIndex:(NSInteger)index;

@end

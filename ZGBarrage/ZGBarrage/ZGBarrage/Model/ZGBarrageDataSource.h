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

@protocol ZGBarrageDataSource <NSObject>

@required

- (NSInteger)numberOfItemsWithBarrageView:(ZGBarrageView *)barrageView;


- (ZGBarrageCell *)barrageView:(ZGBarrageView *)barrageView cellForItemAtIndex:(NSInteger)index;


@end

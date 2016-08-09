//
//  ZGBarrageViewDataSource.h
//  ZGBarrage
//
//  Created by Zong on 16/8/9.
//  Copyright © 2016年 Zong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZGBarrageDataSource.h"

@class  ZGBarrageView;

@interface ZGBarrageViewDataSourceImplement : NSObject <ZGBarrageViewDataSource>

/**
 * 构造器
 */
+ (instancetype)barrageViewDataSourceImplementWithBarrageView:(ZGBarrageView *)barrageView;

@property (nonatomic, weak) ZGBarrageView *barrageView;

/**
 * 给弹幕上弹匣
 * magazine:中文意思 -- 弹匣
 */
- (void)addMagazine:(NSArray *)magazine;

@end

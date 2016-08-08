//
//  ZGBarrageContainView.m
//  ZGBarrage
//
//  Created by Zong on 16/8/8.
//  Copyright © 2016年 Zong. All rights reserved.
//

#import "ZGBarrageView.h"
#import "ZGBarrageLayout.h"
#import "ZGBarrageItemModel.h"
#import "ZGBarrageCell.h"

@interface ZGBarrageView ()

@property (nonatomic, strong) NSMutableArray *magazinesArray;

@property (nonatomic, strong) ZGBarrageLayout *layout;

@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation ZGBarrageView

- (instancetype)initWithFrame:(CGRect)frame barrageLayout:(ZGBarrageLayout *)layout
{
    if (self = [super initWithFrame:frame]) {
        _magazinesArray = [NSMutableArray array];
        _layout = layout;
    }
    return self;
}


- (void)addMagazine:(NSArray *)magazine
{
    // 必须上锁
    [self.magazinesArray addObject:magazine];
    
    // 添加完数据，接着就是显示到屏幕
    [self reloadDataWithMagazine:magazine];
}

- (void)removeMagazineWithIndex:(NSInteger)index
{
    // 必须上锁
    [self.magazinesArray removeObjectAtIndex:index];
    
    if (self.magazinesArray.count == 0) {
        self.currentIndex = 0;
    }
}

- (ZGBarrageCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}


- (void)reloadDataWithMagazine:(NSArray *)magazine
{
    for (int i=0; i<magazine.count; i++) {
        
        // 1,先拿到布局信息
        ZGBarrageItemModel *model = magazine[i];
        UICollectionViewLayoutAttributes *layoutAttribute = [self.layout layoutAttributesForItemAtIndex:0 model:model];
        
        // 2,拿到cell视图
        ZGBarrageCell *cell = [self.dataSource barrageView:self cellForItemAtIndex:i];
        cell.frame = layoutAttribute.frame;
        
        // 3,addSubview,并设置布局信息
        [self addSubview:cell];
        
        // 4,开始动画
        [cell startAnimation];
        
    }
  
}


@end

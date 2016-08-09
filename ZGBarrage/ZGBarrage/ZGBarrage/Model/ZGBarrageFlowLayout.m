//
//  ZGBarrageFlowLayout.m
//  ZGBarrage
//
//  Created by Zong on 16/8/9.
//  Copyright © 2016年 Zong. All rights reserved.
//

#import "ZGBarrageFlowLayout.h"
#import "ZGBarrageView.h"

@interface ZGBarrageFlowLayout ()



@end

@implementation ZGBarrageFlowLayout

- (instancetype)init
{
    if (self = [super init]) {
        self.itemSize = CGSizeMake(120, 44);
    }
    return self;
}

- (void)prepareLayout
{
    [self caculateMaxRows];
}

- (void)caculateMaxRows
{
    // 先算出barrageView能容纳几行
    CGFloat validHeight = self.barrageView.bounds.size.height - self.edgeInsets.top - self.edgeInsets.bottom;
    CGFloat sum = 0.0;
    NSInteger row = 0;
    BOOL isLineSpace = YES;
    while ( sum < validHeight) {
        if (row == 0) {
            sum += self.itemSize.height;
            row++;
        }else {
            if (isLineSpace == YES) {
                sum += self.minimumLineSpacing;
                isLineSpace = NO;
            }else {
                sum += self.itemSize.height;
                isLineSpace = YES;
                row++;
            }
        }
        
    }
    
    if (row != 1) {
        row--;
    }
    
    self.maxRows = row;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 根据indexPath，设置cell的frame
    UICollectionViewLayoutAttributes * attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGFloat attrY = self.edgeInsets.top + indexPath.section * (self.itemSize.height + self.minimumLineSpacing);
    attr.frame = CGRectMake(self.barrageView.bounds.size.width, attrY, self.itemSize.width, self.itemSize.height);
    
    return attr;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath model:(ZGBarrageItemModel *)model
{
    return [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
}



- (CGSize)itemSizeWithModel:(ZGBarrageItemModel *)itemModel
{
    return CGSizeZero;
}

@end

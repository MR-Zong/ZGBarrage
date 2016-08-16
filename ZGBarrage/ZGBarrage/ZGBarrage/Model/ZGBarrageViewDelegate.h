//
//  ZGBarrageViewDelegate.h
//  ZGBarrage
//
//  Created by Zong on 16/8/16.
//  Copyright © 2016年 Zong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZGBarrageView;
@class ZGBarrageItemModel;

@protocol ZGBarrageViewDelegate <NSObject>

- (void)barrageView:(ZGBarrageView *)barrageView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)barrageView:(ZGBarrageView *)barrageView didSelectItemAtIndexPath:(NSIndexPath *)indexPath itemModel:(ZGBarrageItemModel *)itemModel;
- (void)barrageView:(ZGBarrageView *)barrageView didSelectItemImageViewWithItemModel:(ZGBarrageItemModel *)itemModel;
- (void)barrageView:(ZGBarrageView *)barrageView didSelectItemTextLabelWithItemModel:(ZGBarrageItemModel *)itemModel;

@end

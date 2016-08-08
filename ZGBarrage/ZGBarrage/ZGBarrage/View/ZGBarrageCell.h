//
//  ZGBarrageCell.h
//  ZGBarrage
//
//  Created by Zong on 16/8/8.
//  Copyright © 2016年 Zong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZGBarrageCell;

@protocol ZGBarrageCellAnimateDelegate <NSObject>

- (void)animationDidStopWithCell:(ZGBarrageCell *)cell;

@end

@interface ZGBarrageCell : UIView

- (void)startAnimation;

@property (nonatomic, weak) id<ZGBarrageCellAnimateDelegate> animateDelegate;

@end

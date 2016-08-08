//
//  ZGBarrageCell.m
//  ZGBarrage
//
//  Created by Zong on 16/8/8.
//  Copyright © 2016年 Zong. All rights reserved.
//

#import "ZGBarrageCell.h"

@implementation ZGBarrageCell

- (void)startAnimation
{
    CABasicAnimation *baseAnimation = [CABasicAnimation animationWithKeyPath:@"center"];

    baseAnimation.toValue = @(-self.bounds.size.width);
    baseAnimation.duration = 5.0;

    
    [self.layer addAnimation:baseAnimation forKey:@"barrage"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag == YES) {
         // 通知barrageView
          // 加入cell缓存池
        // 检查是否是这个magazine已经显示完
        // 如果显示完，就要移除这个magazine
        if (self.animateDelegate && [self.animateDelegate respondsToSelector:@selector(animationDidStopWithCell:)]) {
            [self.animateDelegate animationDidStopWithCell:self];
        }
        
        // removeFromSuperview
        [self removeFromSuperview];
        
      
    }
}

@end

//
//  ZGBarrageCell.m
//  ZGBarrage
//
//  Created by Zong on 16/8/8.
//  Copyright © 2016年 Zong. All rights reserved.
//

#import "ZGBarrageCell.h"

#define Velocity 50

@implementation ZGBarrageCell

- (void)startAnimation
{
    CABasicAnimation *baseAnimation = [CABasicAnimation animationWithKeyPath:@"center.x"];

    CGFloat targetValue = self.superview.bounds.size.width - 8 - self.bounds.size.width / 2;
    baseAnimation.toValue = @(targetValue);
    baseAnimation.duration = (targetValue - self.center.x) / Velocity;

    
    [self.layer addAnimation:baseAnimation forKey:@"firstAnimation"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag == YES) {
        
        CABasicAnimation *baseAnimationFirst = (CABasicAnimation *)anim;
        NSLog(@"toValue %@",baseAnimationFirst.toValue);
        
        if (((NSNumber *)baseAnimationFirst.toValue).doubleValue > 0) { // 第一阶段动画结束
            
            // 通知代理
            if (self.animateDelegate2 && [self.animateDelegate2 respondsToSelector:@selector(animation2DidStopWithCell:)]) {
                [self.animateDelegate2 animation2DidStopWithCell:self];
            }
            
            // 可以开始第二阶段动画
            CABasicAnimation *baseAnimationSecond = [CABasicAnimation animationWithKeyPath:@"center.x"];
            
            CGFloat targetValue = -self.bounds.size.width / 2;
            baseAnimationSecond.toValue = @(targetValue);
            baseAnimationSecond.duration = (targetValue - ((NSNumber *)baseAnimationFirst.toValue).doubleValue) / Velocity;
            
            
            [self.layer addAnimation:baseAnimationSecond forKey:@"secondAnimation"];
            
        }else { // 第二阶段动画结束
            
            // 通知barrageView
            if (self.animateDelegate && [self.animateDelegate respondsToSelector:@selector(animationDidStopWithCell:)]) {
                [self.animateDelegate animationDidStopWithCell:self];
                
                // removeFromSuperview
                [self removeFromSuperview];
            }
        }
        
      
    }
}

@end

//
//  ZGBarrageCell.m
//  ZGBarrage
//
//  Created by Zong on 16/8/8.
//  Copyright © 2016年 Zong. All rights reserved.
//

#import "ZGBarrageCell.h"

#define Velocity 30.0

NSString * const ZGBarrageCellReusableIdentifier = @"ZGBarrageCellReusableIdentifier";

@implementation ZGBarrageCell

- (instancetype)initWithReusableIdentifier:(NSString *)identifer{
    if (self = [super init]) {
        _identifier = identifer;
        [self setupViews];
    }
    return self;
}

- (void)setupViews
{
    self.textLabel = [[UILabel alloc] init];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.font = [UIFont systemFontOfSize:18];
    
    [self addSubview:self.textLabel];
}

- (void)startAnimation
{
    CABasicAnimation *baseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];

    CGFloat relativeValue =  -(8 + self.bounds.size.width);
    baseAnimation.toValue =  @(relativeValue);
    baseAnimation.duration = fabs(relativeValue) / Velocity;
    baseAnimation.delegate = self;
    NSLog(@"targetValue %f",relativeValue);
    NSLog(@"duration %f",baseAnimation.duration);
    
    [self.layer addAnimation:baseAnimation forKey:@"firstAnimation"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag == YES) {
        
        CABasicAnimation *baseAnimationFirst = (CABasicAnimation *)anim;
        NSLog(@"toValue %@",baseAnimationFirst.toValue);
        
        CGFloat fromValue = -(8 + self.bounds.size.width);
        if (((NSNumber *)baseAnimationFirst.toValue).doubleValue >=  fromValue ) { // 第一阶段动画结束
            
            // 通知代理
            if (self.animateDelegate2 && [self.animateDelegate2 respondsToSelector:@selector(animation2DidStopWithCell:)]) {
                [self.animateDelegate2 animation2DidStopWithCell:self];
            }
            
            // 可以开始第二阶段动画
            CABasicAnimation *baseAnimationSecond = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
            
            CGFloat relativeValue = -self.superview.bounds.size.width;
            baseAnimationSecond.fromValue = @(fromValue);
            baseAnimationSecond.toValue = @(relativeValue);
            baseAnimationSecond.duration = fabs(relativeValue) / Velocity;
            
            
            [self.layer addAnimation:baseAnimationSecond forKey:@"secondAnimation"];
            
        }else { // 第二阶段动画结束
            
            // 随着第二阶段动画结束，该cell已经离开屏幕!!
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

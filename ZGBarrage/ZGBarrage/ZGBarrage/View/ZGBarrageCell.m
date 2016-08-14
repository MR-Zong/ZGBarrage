//
//  ZGBarrageCell.m
//  ZGBarrage
//
//  Created by Zong on 16/8/8.
//  Copyright © 2016年 Zong. All rights reserved.
//

#import "ZGBarrageCell.h"
#import "ZGBarrageView.h"

#define Velocity 30.0

NSString * const ZGBarrageCellReusableIdentifier = @"ZGBarrageCellReusableIdentifier";

@interface ZGBarrageCell ()

//@property (nonatomic, assign) NSInteger clickCount;

@end

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
    self.imageView = [[UIImageView alloc] init];
    self.imageView.image = [UIImage imageNamed:@"Zong.jpg"];
    self.imageView.backgroundColor = [UIColor greenColor];
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didPressImageView:)]];
    [self addSubview:self.imageView];
    
    self.textLabel = [[UILabel alloc] init];
    self.textLabel.userInteractionEnabled = YES;
    [self.textLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didPressTextLabel:)]];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.textLabel];
    
}

- (void)startAnimation
{
    // 动画第一种实现方案--可惜有一点缺点，闪烁
//    CABasicAnimation *baseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
//
//    CGFloat relativeValue =  -(self.minimumInteritemSpacing + self.bounds.size.width);
//    baseAnimation.toValue =  @(relativeValue);
//    baseAnimation.duration = fabs(relativeValue) / Velocity;
//    baseAnimation.delegate = self;
    
    /**
     * 第二种方法 也一样有闪烁
     */
//    CABasicAnimation *baseAnimation = [CABasicAnimation animationWithKeyPath:@"position.x"];
//    
//    CGFloat relativeValue =  self.superview.bounds.size.width - self.minimumInteritemSpacing - self.bounds.size.width;
//    baseAnimation.toValue =  @(relativeValue);
//    baseAnimation.duration = fabs(self.minimumInteritemSpacing + self.bounds.size.width) / Velocity;
//    baseAnimation.delegate = self;
    
    
    //动画结束时候状态，我动画结束在哪里就停在哪里
    //    baseAnimation.removedOnCompletion = NO;
    //    baseAnimation.fillMode=kCAFillModeForwards;
    //    baseAnimation.additive = YES;
    //    NSLog(@"targetValue %f",relativeValue);
    //    NSLog(@"duration %f",baseAnimation.duration);
    
    //    [self.layer addAnimation:baseAnimation forKey:@"firstAnimation"];

    
    /**
     * 第三种方法 简直完美
     */
    CGFloat toX =  self.superview.bounds.size.width - self.minimumInteritemSpacing - self.bounds.size.width;
    [UIView animateWithDuration:(fabs(self.minimumInteritemSpacing + self.bounds.size.width) / Velocity) delay:0 options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionAllowUserInteraction animations:^{
        self.frame = CGRectMake(toX, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        
        if (finished == YES) { // 第一阶段动画结束
            
            // 通知代理
            if (self.animateDelegate2 && [self.animateDelegate2 respondsToSelector:@selector(animation2DidStopWithCell:)]) {
                [self.animateDelegate2 animation2DidStopWithCell:self];
            }
            
            // 开始第二阶段动画
            [UIView animateWithDuration:((self.superview.bounds.size.width - self.minimumInteritemSpacing) / Velocity ) delay:0 options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionAllowUserInteraction animations:^{
                self.frame = CGRectMake(-self.bounds.size.width, self.frame.origin.y, self.bounds.size.width, self.bounds.size.height);
                
            } completion:^(BOOL finished) { // 第二阶段动画结束
                if (finished == YES) {
                    // 随着第二阶段动画结束，该cell已经离开屏幕!!
                    // 通知barrageView
                    if (self.animateDelegate && [self.animateDelegate respondsToSelector:@selector(animationDidStopWithCell:)]) {
                        [self.animateDelegate animationDidStopWithCell:self];
                        
                        // removeFromSuperview
                        [self removeFromSuperview];
                    }
                }
                
            }];
        }
    }];

    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag == YES) {
        
        CABasicAnimation *baseAnimationFirst = (CABasicAnimation *)anim;
        
        CGFloat fromValue = -(self.minimumInteritemSpacing + self.bounds.size.width);
//        CGFloat fromValue = self.superview.bounds.size.width - self.minimumInteritemSpacing - self.bounds.size.width;

        if (((NSNumber *)baseAnimationFirst.toValue).doubleValue >=  fromValue ) { // 第一阶段动画结束
//        if (((NSNumber *)baseAnimationFirst.toValue).doubleValue >  0 ) { // 第一阶段动画结束
        
            // 通知代理
            if (self.animateDelegate2 && [self.animateDelegate2 respondsToSelector:@selector(animation2DidStopWithCell:)]) {
                [self.animateDelegate2 animation2DidStopWithCell:self];
            }
            
//            self.layer.transform = CATransform3DMakeTranslation(fromValue, 0, 0);
            // 可以开始第二阶段动画
            CABasicAnimation *baseAnimationSecond = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
            
            CGFloat relativeValue = -(self.superview.bounds.size.width + self.bounds.size.width);
            baseAnimationSecond.fromValue = @(fromValue);
            baseAnimationSecond.toValue = @(relativeValue);
            baseAnimationSecond.duration = fabs(relativeValue) / (Velocity + 10);
            baseAnimationSecond.delegate = self;
            

//            CABasicAnimation *baseAnimationSecond = [CABasicAnimation animationWithKeyPath:@"position.x"];
//            
//            CGFloat relativeValue = -(self.bounds.size.width);
//            baseAnimationSecond.fromValue = @(fromValue);
//            baseAnimationSecond.toValue = @(relativeValue);
//            baseAnimationSecond.duration = fabs(fromValue - relativeValue) / (Velocity );
//            baseAnimationSecond.delegate = self;

            
//            baseAnimationSecond.removedOnCompletion = NO;
//            baseAnimationSecond.fillMode=kCAFillModeForwards;
//            baseAnimationSecond.additive = YES;
            
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



#pragma mark - 
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
//    NSLog(@"hitTest");
//    NSLog(@"event %@",event);
    
//    NSLog(@"self %@",self);
    CALayer *layer =  self.layer.presentationLayer;
//    NSLog(@"layer.frame %@",NSStringFromCGRect(layer.frame));
    
    CGPoint superViewPoint = [self convertPoint:point toView:self.superview];
//    NSLog(@"superViewPoint %@",NSStringFromCGPoint(superViewPoint));
    
    CGPoint selfPoint = [self convertPoint:superViewPoint toFrame:layer.frame];
//    NSLog(@"selfPoint %@",NSStringFromCGPoint(selfPoint));
//        if ([self pointInside:selfPoint frame:layer.frame] == YES ) {
//            self.clickCount++;
//            if (self.clickCount % 2 != 0) { // 解决double clike问题
//                return nil;
//            }
//
////            NSLog(@"你点到我啦！哼~");
//            NSLog(@"text %@",self.itemModel.text);
//        }
    
    
//    NSLog(@"hitTest %@",[super hitTest:selfPoint withEvent:event]);
   return [super hitTest:selfPoint withEvent:event];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesBegan");
    return [super touchesBegan:touches withEvent:event];
}

- (void)didPressImageView:(UITapGestureRecognizer *)tap
{
    NSLog(@"didPressImageView");
}

- (void)didPressTextLabel:(UITapGestureRecognizer *)tap
{
    NSLog(@"didPressTextLabel");
}

- (BOOL)pointInside:(CGPoint)point frame:(CGRect)frame
{
    if (point.x >= 0 && point.x <= frame.size.width) {
        if (point.y >= 0 && point.y <= frame.size.height) {
            return YES;
        }
    }
    
    return NO;
}

- (CGPoint)convertPoint:(CGPoint)point toFrame:(CGRect)frame
{
    CGFloat newX =  point.x - frame.origin.x;
    CGFloat newY =  point.y - frame.origin.y;
    return CGPointMake(newX, newY);
}



@end

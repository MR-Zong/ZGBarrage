//
//  ZGBarrageCell.m
//  ZGBarrage
//
//  Created by Zong on 16/8/8.
//  Copyright © 2016年 Zong. All rights reserved.
//

#import "ZGBarrageCell.h"
#import "ZGBarrageView.h"
#import "ZGBarrageView.h"

#define Velocity 30.0

NSString * const ZGBarrageCellReusableIdentifier = @"ZGBarrageCellReusableIdentifier";

@interface ZGBarrageCell ()

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
    CGFloat toX =  self.superview.bounds.size.width - self.minimumInteritemSpacing - self.bounds.size.width;
    [UIView animateWithDuration:(fabs(self.minimumInteritemSpacing + self.bounds.size.width) / Velocity) delay:0 options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionAllowUserInteraction animations:^{
        self.frame = CGRectMake(toX, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        
        if (finished == YES) {
            
            if (self.animateDelegate2 && [self.animateDelegate2 respondsToSelector:@selector(animation2DidStopWithCell:)]) {
                [self.animateDelegate2 animation2DidStopWithCell:self];
            }
            [UIView animateWithDuration:((self.superview.bounds.size.width - self.minimumInteritemSpacing) / Velocity ) delay:0 options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionAllowUserInteraction animations:^{
                self.frame = CGRectMake(-self.bounds.size.width, self.frame.origin.y, self.bounds.size.width, self.bounds.size.height);
                
            } completion:^(BOOL finished) {
                if (finished == YES) {
                    if (self.animateDelegate && [self.animateDelegate respondsToSelector:@selector(animationDidStopWithCell:)]) {
                        [self.animateDelegate animationDidStopWithCell:self];
                        
                        [self removeFromSuperview];
                    }
                }
                
            }];
        }
    }];

    
}



- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    CALayer *layer =  self.layer.presentationLayer;
    CGPoint superViewPoint = [self convertPoint:point toView:self.superview];
    CGPoint selfPoint = [self convertPoint:superViewPoint toFrame:layer.frame];
   return [super hitTest:selfPoint withEvent:event];
}


- (void)didPressImageView:(UITapGestureRecognizer *)tap
{
    NSLog(@"didPressImageView");
    if (self.barrageView.delegate && [self.barrageView.delegate respondsToSelector:@selector(barrageView:didSelectItemAtIndexPath:itemModel:)]) {
        [self.barrageView.delegate barrageView:self.barrageView didSelectItemAtIndexPath:self.itemModel.indexPath itemModel:self.itemModel];
    }
    
    if (self.barrageView.delegate && [self.barrageView.delegate respondsToSelector:@selector(barrageView:didSelectItemImageViewWithItemModel:)]) {
        [self.barrageView.delegate barrageView:self.barrageView didSelectItemImageViewWithItemModel:self.itemModel];
    }
}

- (void)didPressTextLabel:(UITapGestureRecognizer *)tap
{
    NSLog(@"didPressTextLabel");
    if (self.barrageView.delegate && [self.barrageView.delegate respondsToSelector:@selector(barrageView:didSelectItemAtIndexPath:itemModel:)]) {
        [self.barrageView.delegate barrageView:self.barrageView didSelectItemAtIndexPath:self.itemModel.indexPath itemModel:self.itemModel];
    }
    
    if (self.barrageView.delegate && [self.barrageView.delegate respondsToSelector:@selector(barrageView:didSelectItemTextLabelWithItemModel:)]) {
        [self.barrageView.delegate barrageView:self.barrageView didSelectItemTextLabelWithItemModel:self.itemModel];
    }
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

#pragma mark - setter
- (void)setItemModel:(ZGBarrageItemModel *)itemModel
{
    _itemModel = itemModel;
    
    self.imageView.image = [UIImage imageNamed:@"Zong.jpg"];
    self.textLabel.text = itemModel.text;
}

@end

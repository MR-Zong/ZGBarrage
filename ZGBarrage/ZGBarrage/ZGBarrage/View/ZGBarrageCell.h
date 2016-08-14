//
//  ZGBarrageCell.h
//  ZGBarrage
//
//  Created by Zong on 16/8/8.
//  Copyright © 2016年 Zong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZGBarrageCell;

@class ZGBarrageItemModel;

@protocol ZGBarrageCellAnimateDelegate <NSObject>

- (void)animationDidStopWithCell:(ZGBarrageCell *)cell;

@end

@protocol ZGBarrageCellAnimateDelegate2 <NSObject>

- (void)animation2DidStopWithCell:(ZGBarrageCell *)cell;

@end


extern NSString * const ZGBarrageCellReusableIdentifier;

@interface ZGBarrageCell : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic) CGFloat minimumInteritemSpacing;
@property (nonatomic, strong) ZGBarrageItemModel *itemModel;
@property (nonatomic, readonly, copy) NSString* identifier;

- (instancetype)initWithReusableIdentifier:(NSString*)identifer;

- (void)startAnimation;

@property (nonatomic, weak) id<ZGBarrageCellAnimateDelegate> animateDelegate;

@property (nonatomic, weak) id<ZGBarrageCellAnimateDelegate2> animateDelegate2;

@end

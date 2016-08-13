//
//  ZGBarrageItemModel.h
//  ZGBarrage
//
//  Created by Zong on 16/8/8.
//  Copyright © 2016年 Zong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZGMagazine.h"

@interface ZGBarrageItemModel : NSObject

@property (nonatomic, assign) NSInteger magazineIndexInContainer;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, copy) NSString *text;

@property (nonatomic, copy) NSString *imageUrlString;

@property (nonatomic, assign) BOOL isEmit;

@end

//
//  ViewController.m
//  ZGBarrage
//
//  Created by Zong on 16/8/8.
//  Copyright © 2016年 Zong. All rights reserved.
//

#import "ViewController.h"
#import "ZGBarrageView.h"

@interface ZGTestModel : ZGBarrageItemModel

@property (nonatomic, copy) NSString *text;

@end

@implementation ZGTestModel


@end





#pragma mark -

@interface ViewController ()

@property (nonatomic, strong) ZGBarrageView *barrageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ZGBarrageFlowLayout *flowLayout = [[ZGBarrageFlowLayout alloc] init];
    self.barrageView = [[ZGBarrageView alloc] initWithFrame:self.view.bounds barrageLayout:flowLayout];
    
    // 制作模拟数据
    NSMutableArray *mDataArray = [NSMutableArray array];
    for (int i=0; i<9; i++) {
        ZGTestModel *model = [[ZGTestModel alloc] init];
        if (i%3 == 0) {
            model.text = @"奥运加油！";
        }else if (i%3 == 1){
            model.text = @"中国健儿好厉害~";
        }else if(i%3 == 2){
            model.text = @"傅园慧，天生带笑感的段子手~";
        }
        
        [mDataArray addObject:model];
    }
    
    [self.barrageView addDataArray:mDataArray.copy];
    
    self.barrageView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.barrageView];
}


- (void)test
{
//    UICollectionViewLayout *aa;
//    UICollectionViewFlowLayout *b;
//    UICollectionView *dd;

}


@end

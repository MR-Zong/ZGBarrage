//
//  ViewController.m
//  ZGBarrage
//
//  Created by Zong on 16/8/8.
//  Copyright © 2016年 Zong. All rights reserved.
//

#import "ViewController.h"
#import "ZGBarrageView.h"


@interface ViewController ()

@property (nonatomic, strong) ZGBarrageView *barrageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 宣传口号~
    UILabel *titleLable = [[UILabel alloc] init];
    titleLable.text = @"可以点击的弹幕！";
    titleLable.backgroundColor = [UIColor blackColor];
    titleLable.textColor = [UIColor yellowColor];
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.font = [UIFont systemFontOfSize:20];
    titleLable.frame = CGRectMake((self.view.bounds.size.width- 200) / 2.0, 50, 200, 40);
    [self.view addSubview:titleLable];
    
    
    
    
    // 使用样例
    // 注意,barrageView跟collectionView一样要有个布局Layout
    ZGBarrageFlowLayout *flowLayout = [[ZGBarrageFlowLayout alloc] init];
    self.barrageView = [[ZGBarrageView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 300) barrageLayout:flowLayout];
    
    // 模拟数据
//    [self barrageViewAddDataArrayWithSize:3];
//    [self barrageViewAddDataArrayWithSize:7];
//    [self barrageViewAddDataArrayWithSize:4];
    
    self.barrageView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.barrageView];
    
    
    
    // 测试用例
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn1 setTitle:@"1" forState:UIControlStateNormal];
    btn1.backgroundColor = [UIColor redColor];
    btn1.tag = 1;
    btn1.frame = CGRectMake(20, CGRectGetMaxY(self.barrageView.frame) +50, 80, 40);
    [btn1 addTarget:self action:@selector(didBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn2 setTitle:@"2" forState:UIControlStateNormal];
    btn2.backgroundColor = [UIColor orangeColor];
    btn2.tag = 2;
    btn2.frame = CGRectMake(CGRectGetMaxX(btn1.frame) + 20, btn1.frame.origin.y, 80, 40);
    [btn2 addTarget:self action:@selector(didBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];

    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn3.backgroundColor = [UIColor greenColor];
    [btn3 setTitle:@"3" forState:UIControlStateNormal];
    btn3.tag = 3;
    btn3.frame = CGRectMake(CGRectGetMaxX(btn2.frame) + 20, btn1.frame.origin.y, 80, 40);
    [btn3 addTarget:self action:@selector(didBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];

    
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn4.backgroundColor = [UIColor lightGrayColor];
    [btn4 setTitle:@"发自己弹幕" forState:UIControlStateNormal];
    btn4.tag = 4;
    btn4.frame = CGRectMake(btn1.frame.origin.x, CGRectGetMaxY(btn1.frame) + 20, 80, 40);
    [btn4 addTarget:self action:@selector(didBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn4];

    UIButton *btn5 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn5.backgroundColor = [UIColor orangeColor];
    [btn5 setTitle:@"reset" forState:UIControlStateNormal];
    btn5.tag = 5;
    btn5.frame = CGRectMake(CGRectGetMaxX(btn4.frame) + 20, btn4.frame.origin.y, 80, 40);
    [btn5 addTarget:self action:@selector(didBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn5];

    UIButton *btn6 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn6.backgroundColor = [UIColor redColor];
    [btn6 setTitle:@"destroy" forState:UIControlStateNormal];
    btn6.tag = 6;
    btn6.frame = CGRectMake(CGRectGetMaxX(btn5.frame) + 20, btn4.frame.origin.y, 80, 40);
    [btn6 addTarget:self action:@selector(didBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn6];

}


- (void)didBtnPress:(UIButton *)btn
{
    if (btn.tag == 4) { // 添加自己的弹幕
        [self barrageViewAddMineItemModel];
        
    }else if(btn.tag == 5) {
        [self.barrageView reset];
    
    }else if(btn.tag == 6) {
        [self.barrageView destroy];
        
    }else{ // 添加别人的弹幕
        
        [self barrageViewAddDataArrayWithSize:btn.tag];
    }
    
}


- (void)barrageViewAddMineItemModel
{
    ZGBarrageItemModel *mineItemModel = [[ZGBarrageItemModel alloc] init];
    mineItemModel.text = @"宗根的弹幕";
    [self.barrageView addMineItemModel:mineItemModel];
}

- (void)barrageViewAddDataArrayWithSize:(NSInteger)size
{
    NSMutableArray *mDataArray = [NSMutableArray array];
    for (int i=0; i<size; i++) {
        ZGBarrageItemModel *model = [[ZGBarrageItemModel alloc] init];
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
}

@end

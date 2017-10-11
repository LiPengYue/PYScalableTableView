//
//  ViewController.m
//  PYScalableTableView
//
//  Created by 李鹏跃 on 2017/9/26.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

#import "ViewController.h"
#import "ScalableTableView.h"
#import "PYTestBaseModel1.h"
#import "PushViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUP];
}
- (void)setUP {
    ScalableTableView *tableview = [[ScalableTableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    NSMutableArray *modelArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < 10; i++ ) {
        [modelArray addObject:[PYTestBaseModel1 new]];
    }
    tableview.modelArray = modelArray;

    __weak typeof (self)weakSelf = self;
    [tableview registerClickCellFunc:^(id  _Nullable model, NSString * _Nonnull clickSelectorKey) {
        PushViewController *vc = [[PushViewController alloc]init];
        [weakSelf presentViewController:vc animated:true completion:nil];
    }];
    [self.view addSubview:tableview];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

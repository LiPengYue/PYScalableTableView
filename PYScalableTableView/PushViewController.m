//
//  PushViewController.m
//  PYScalableTableView
//
//  Created by 李鹏跃 on 2017/10/10.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

#import "PushViewController.h"
#import "Masonry.h"
@interface PushViewController ()
@property (nonatomic,strong) UILabel *labelV;
@property (nonatomic,strong) UILabel *eventV;
@property (nonatomic,strong) UIImageView *imageV;
@end

@implementation PushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
   
    self.labelV = [[UILabel alloc]init];
    self.labelV.textAlignment = NSTextAlignmentCenter;
    self.labelV.textColor = [UIColor colorWithRed:0.5 green:0.8 blue:0.1 alpha:1];
    [self.view addSubview:self.labelV];
    
    self.eventV = [[UILabel alloc]init];
    self.eventV.textAlignment = NSTextAlignmentCenter;
    self.eventV.textColor = [UIColor colorWithRed:0.5 green:0.8 blue:0.1 alpha:1];
    [self.view addSubview:self.eventV];
 
    self.imageV.backgroundColor = [UIColor colorWithRed:0.8 green:0.7 blue:0.3 alpha:1];
    self.imageV = [[UIImageView alloc]init];
    self.imageV.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.imageV];
    
    
    self.imageV.image = [UIImage imageNamed:self.imageName];
    self.labelV.text = self.text;
    self.eventV.text = self.eventName;
    
    self.labelV.font = [UIFont systemFontOfSize:30];
    self.eventV.font = [UIFont systemFontOfSize:20];
    
    self.labelV.textColor = [UIColor colorWithRed:0.5 green:0.8 blue:0.1 alpha:1];
    self.eventV.textColor = [UIColor colorWithRed:0.5 green:0.8 blue:0.1 alpha:1];
    
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
      make.center.equalTo(self.view);
        make.height.width.equalTo(@(300));
    }];
    [self.eventV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.imageV.mas_top).offset(-20);
    }];
    [self.labelV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.eventV.mas_top).offset(-10);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:true completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

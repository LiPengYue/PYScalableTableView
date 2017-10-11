//
//  PYTestCell2.m
//  PYScalableTableView
//
//  Created by 李鹏跃 on 2017/9/29.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

#import "PYTestCell2.h"
#import "UITableViewCell+ScalableTableViewCell_Extension.h"
#import "Masonry.h"
@interface PYTestCell2 ()
@property (nonatomic,strong) UILabel *labelV;
@property (nonatomic,strong) UIImageView *imageV;
@property (nonatomic,strong) UIButton *button1;
@property (nonatomic,strong) UIButton *button2;
@end

@implementation PYTestCell2
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUP];
    }
    return self;
}

- (void)setUP {
    __weak typeof(self)weakSelf = self;
    
    ///设置数据
    [self cellSetDataFunc:^(NSObject *model) {
        weakSelf.labelV.text = NSStringFromClass(model.class);
        NSString *imageName = [model valueForKey:@"imageName"];
        weakSelf.imageV.image = [UIImage imageNamed:imageName];
    }];
    ///设置自视图
    [self setUPViews];
}


- (void) setUPViews {
    
    self.contentView.backgroundColor = [UIColor colorWithWhite:0.90 alpha:1];
    
    self.labelV = [[UILabel alloc]init];
    self.labelV.textAlignment = NSTextAlignmentCenter;
    self.labelV.textColor = [UIColor colorWithRed:0.7 green:0.5 blue:0.5 alpha:1];
    [self.contentView addSubview:self.labelV];
    
    self.imageV.backgroundColor = [UIColor colorWithRed:0.8 green:0.7 blue:0.3 alpha:1];
    self.imageV = [[UIImageView alloc]init];
    self.imageV.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.imageV];
    
    self.button1 = [[UIButton alloc]init];
    [self.button1 setTitle:@"点击事件1" forState: UIControlStateNormal];
    [self.button1 addTarget:self action:@selector(clickButton1:) forControlEvents:UIControlEventTouchUpInside];
    self.button1.backgroundColor = [UIColor colorWithRed:.5 green:.9 blue:.6 alpha:0.7];
    [self.contentView addSubview:self.button1];
    
    self.button2 = [[UIButton alloc]init];
    [self.button2 setTitle:@"点击事件2" forState: UIControlStateNormal];
    [self.button2 addTarget:self action:@selector(clickButton2:) forControlEvents:UIControlEventTouchUpInside];
    self.button2.backgroundColor = [UIColor colorWithRed:.5 green:.9 blue:.6 alpha:0.7];
    [self.contentView addSubview:self.button2];
    
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(8);
        make.bottom.equalTo(self.contentView).offset(-8);
        make.height.width.equalTo(@(100));
    }];
    
    [self.labelV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.equalTo(self.contentView);
        make.left.equalTo(self.imageV.mas_right);
    }];
    
    [self.button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.labelV.mas_right).offset(10);
        make.height.equalTo(@20);
        make.width.equalTo(@90);
    }];
    
    [self.button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.button1.mas_right).offset(5);
        make.height.width.equalTo(self.button1);
    }];
    
}


- (void) clickButton1: (UIButton *)button {
    NSLog(@"|||cell中打印: 点击Button1");
    [self cellClickEventBlockWithSelectorKey:@"clickButton1"];
}


- (void)clickButton2: (UIButton *)button {
    [self cellClickEventBlockWithSelectorKey:@"clickButton2"];
}
@end

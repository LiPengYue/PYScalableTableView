
//
//  PYTestCell1.m
//  PYScalableTableView
//
//  Created by 李鹏跃 on 2017/9/29.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

#import "PYTestCell1.h"
#import "UITableViewCell+ScalableTableViewCell_Extension.h"
#import "Masonry.h"
@interface PYTestCell1 ()
@property (nonatomic,strong) UILabel *labelV;
@property (nonatomic,strong) UIImageView *imageV;
@end

@implementation PYTestCell1
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
    
        self.contentView.backgroundColor = [UIColor colorWithWhite:0.99 alpha:1];
    self.labelV = [[UILabel alloc]init];
    self.labelV.textAlignment = NSTextAlignmentCenter;
    self.labelV.textColor = [UIColor colorWithRed:0.5 green:0.8 blue:0.1 alpha:1];
    
    [self.contentView addSubview:self.labelV];
    self.imageV.backgroundColor = [UIColor colorWithRed:0.8 green:0.7 blue:0.3 alpha:1];
    self.imageV = [[UIImageView alloc]init];
    self.imageV.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.imageV];
    
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(8);
        make.bottom.equalTo(self.contentView).offset(-8);
        make.height.width.equalTo(@(50));
    }];
    
    [self.labelV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.contentView);
    }];
}
@end


//
//  PYTestCell1.m
//  PYScalableTableView
//
//  Created by 李鹏跃 on 2017/9/29.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

#import "PYTestCell1.h"
#import "UITableViewCell+ScalableTableViewCell_Extension.h"
@interface PYTestCell1 ()
@property (nonatomic,strong) UILabel *label;
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
    [self cellSetDataFunc:^(NSObject *model) {
        weakSelf.label.text = NSStringFromClass(model.class);
    }];
    self.contentView.backgroundColor = [UIColor redColor];
    self.label = [[UILabel alloc]init];
    self.label.frame = self.contentView.bounds;
    self.label.textAlignment = NSTextAlignmentRight;
    self.label.textColor = [UIColor whiteColor];
    self.label.text = @"PYTestCell_1";
    [self.contentView addSubview:self.label];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

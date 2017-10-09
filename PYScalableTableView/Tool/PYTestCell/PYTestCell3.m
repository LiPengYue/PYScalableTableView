//
//  PYTestCell3.m
//  PYScalableTableView
//
//  Created by 李鹏跃 on 2017/9/29.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

#import "PYTestCell3.h"
#import "UITableViewCell+ScalableTableViewCell_Extension.h"


@interface PYTestCell3 ()
@property (nonatomic,strong) UILabel *label;
@end

@implementation PYTestCell3

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUP];
    }
    return self;
}

- (void)setUP {
    self.contentView.backgroundColor = [UIColor blueColor];
    __weak typeof (self)weakSelf;
    [self cellSetDataFunc:^(NSObject *model) {
        weakSelf.label.text = NSStringFromClass(model.class);
    }];
    UILabel *label = [[UILabel alloc]init];
    label.frame = self.contentView.bounds;
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = [UIColor whiteColor];
    label.text = @"PYTestCell_3";
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

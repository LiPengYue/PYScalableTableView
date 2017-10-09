//
//  PYTestBaseModel2.m
//  PYScalableTableView
//
//  Created by 李鹏跃 on 2017/9/29.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

#import "PYTestBaseModel2.h"
#import "PYTestModel3.h"
@implementation PYTestBaseModel2
///返回 model对应 的 cell的class 的方法
- (NSString *) cellClass{
    return @"PYTestCell2";
}

///存储的model array的
- (NSString *) modelArrayPropertyName {
    return @"modelArray";
}

///存储的model array的
- (NSArray *)modelArray {
    if (!_modelArray) {
        NSMutableArray *modelArrayM = [[NSMutableArray alloc]init];
        for (int i = 0; i < 5; i ++) {
            PYTestModel3 *model = [PYTestModel3 new];
            [modelArrayM addObject: model];
        }
        _modelArray = modelArrayM;
    }
    return _modelArray;
}
@end

//
//  PYTestModel3.m
//  PYScalableTableView
//
//  Created by 李鹏跃 on 2017/9/29.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

#import "PYTestModel3.h"
#import "PYTestBaseModel2.h"
@implementation PYTestModel3
///返回 model对应 的 cell的class 的方法
- (NSString *) cellClass{
    return @"PYTestCell3";
}

///存储的model array的
- (NSString *) modelArrayPropertyName {
    return nil;
}
@end

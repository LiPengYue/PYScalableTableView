//
//  ScalableTableView.h
//  PYScalableTableView
//
//  Created by 李鹏跃 on 2017/9/28.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScalableTableView : UITableView
/**
 * 数据源
 * 里面的model 必须实现以下方法：

 * 返回 model对应 的 cell的class 的方法
 - (NSString *) cellClass{
     return @"PYTestCell1";
 }

 * 存储的model array的属性名
  - (NSString *) modelArrayPropertyName {
     return @"modelArray";
 }
 */
@property (nonatomic,strong) NSArray *modelArray;
@end

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
 * 通过这个方法返回了model绑定的cell 的类型，在内部进行了cell的注册
 - (NSString *) cellClass{
     return @"PYTestCell1";
 }

 * 存储的model array的属性名
 * 组件内部通过这个方法，进行数据的查找
  - (NSString *) modelArrayPropertyName {
     return @"modelArray";
 }
 */
@property (nonatomic,strong) NSArray * _Nullable modelArray;

/**
 * cell点击的方法
 */
- (void) registerClickCellFunc: (void(^_Nullable)(id _Nullable model, NSString * _Nonnull clickSelectorKey))registerClickCellBlock;
@end

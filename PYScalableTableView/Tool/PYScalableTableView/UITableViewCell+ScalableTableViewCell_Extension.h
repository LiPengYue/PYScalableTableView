//
//  UITableViewCell+ScalableTableViewCell_Extension.h
//  PYScalableTableView
//
//  Created by 李鹏跃 on 2017/9/29.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (ScalableTableViewCell_Extension)

///tableview 给cell 传递数据
- (void) tableviewAssignedTheValueToCell: (id)model;
///设置数据
- (void) cellSetDataFunc: (void(^)(NSObject *model)) setDataCallBack;

///数据 的 model
@property (nonatomic, readonly, strong) id model;


#pragma mark - cell 点击事件的传递
typedef void (^Type_cellClickEventBlock)(id model, NSString *selectorKey);
/**
 cell向外界发送点击事件
 
 @param selectorKey 区分事件的key
 */
- (void) cellClickEventBlockWithSelectorKey: (NSString *)selectorKey;

/**
 注册点击事件 的传递 cell至tableview
 
 @param cellClickEventBlock 在cell点击事件发生后，会走这个回调
 */
- (void) registerClickEventFunc: (Type_cellClickEventBlock)cellClickEventBlock;
@end

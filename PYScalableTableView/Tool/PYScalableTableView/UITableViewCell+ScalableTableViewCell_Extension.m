//
//  UITableViewCell+ScalableTableViewCell_Extension.m
//  PYScalableTableView
//
//  Created by 李鹏跃 on 2017/9/29.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//

#import "UITableViewCell+ScalableTableViewCell_Extension.h"
#import <objc/runtime.h>

@implementation UITableViewCell (ScalableTableViewCell_Extension)
static NSString *const setModel = @"setModel_ScalableTableViewCell_Extension";
static NSString *const setDataCallBackKey = @"setDataCallBackKey_ScalableTableViewCell_Extension";
static NSString *const setDictionryKey = @"setDictionryKey_ScalableTableViewCell_Extension";
static NSString *const setClickCellCallBackKey = @"setClickCellCallBackKey_ScalableTableViewCell_Extension";


- (void) tableviewAssignedTheValueToCell:(id)model {
    if (![self getSetDataBlock]) {
           NSLog(@"🔥%@,objc_getAssociatedObject(self, &setDataCallBackKey); 获取不到值",self);
        return;
    }
    void (^setDataCallBack)(id) = [self getSetDataBlock];
    [self setModel:model];
    setDataCallBack(model);
}

- (void)cellSetDataFunc:(void (^)(NSObject *model))setDataCallBack {
    [self setDataBlock:setDataCallBack];
}


- (void(^)(id)) getSetDataBlock {
    return objc_getAssociatedObject(self, &setDataCallBackKey);
}

- (void) setDataBlock: (void(^)(id)) block {
    objc_setAssociatedObject(self, &setDataCallBackKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

///储存数据的model
- (void) setModel:(id)model {
    objc_setAssociatedObject(self, &setModel, model, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id) model {
    return objc_getAssociatedObject(self, &setModel);
}





///向外界发出点击事件
- (void) cellClickEventBlockWithSelectorKey: (NSString *)selectorKey {
    Type_cellClickEventBlock block = objc_getAssociatedObject(self, &setClickCellCallBackKey);
    if (block) {    
        block(self.model,selectorKey);
    }
}

- (void)setCellClickEventBlock:(Type_cellClickEventBlock)cellClickEventBlock {
    objc_setAssociatedObject(self, &setClickCellCallBackKey, cellClickEventBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

///外部tableview 调用
- (void) registerClickEventFunc:(Type_cellClickEventBlock)cellClickEventBlock {
    ///储存block
    [self setCellClickEventBlock:cellClickEventBlock];
}

@end

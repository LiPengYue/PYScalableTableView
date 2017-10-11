//
//  ScalableTableView.m
//  PYScalableTableView
//
//  Created by 李鹏跃 on 2017/9/28.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//


#import "ScalableTableView.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "UITableViewCell+ScalableTableViewCell_Extension.h"
///抽屉效果的TableView

@interface ScalableTableView ()
<
UITableViewDelegate,
UITableViewDataSource
>
/**
 tableview 需要的cell 的类型的集合
 */
@property (nonatomic,strong) NSArray <Class>*cellClassArray;
/**
 cell 的 ID array
 记录了已注册Cell 的 ID
 */
@property (nonatomic,strong) NSMutableArray <NSString *>*cellIDArray;
/**
 cell 回调的集合  set
 key : cell的class的string类型
 value : cell
 */
@property (nonatomic,strong) NSCache *cellCache;

/**
 * UI显示 数据源
 * modle 里面包必须要包含几个方法
 * ·。1，
 */
@property (nonatomic,strong) NSMutableArray *dataSourceArray;

/**
 * cell点击的方法
 */
@property (nonatomic,copy) void(^ _Nonnull registerClickCellBlock)(id _Nullable model, NSString * _Nonnull clickSelectorKey);
@end


@implementation ScalableTableView
@synthesize dataSourceArray = _dataSourceArray;
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        [self setUP];
    }
    return self;
}

- (void)setUP {
    self.delegate = self;
    self.dataSource = self;
    self.estimatedRowHeight = 100;
    self.rowHeight = UITableViewAutomaticDimension;
    

    //声明tableView的位置 添加下面代码
//    if (@available(iOS 11.0, *)) {
//        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
////        self.contentInset = UIEdgeInsetsMake(64, 0, 49, 0);
//        self.scrollIndicatorInsets = self.contentInset;
//    }
}


#pragma mark - 代理 与数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.dataSourceArray[indexPath.row];
    NSString *cellID = [self getModelCellClassName:model];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellID forIndexPath:indexPath];
    ///数据传递
    __weak typeof(self) weakSelf = self;
    [cell registerClickEventFunc:^(id model, NSString *selectorKey) {
        NSLog(@"%@, -> %@",model,selectorKey);
        if (weakSelf.registerClickCellBlock) {
            weakSelf.registerClickCellBlock(model, selectorKey);
        }
    }];
    
    [cell tableviewAssignedTheValueToCell:model];
    return cell;
}

- (void) didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
    
    ///显示数据源的处理
    NSObject *model = cell.model;
    NSInteger modelX = indexPath.row;
    NSInteger modelLength = [self getModelRange:model].length;

    NSArray *subModelArray = [self getModelSubModelArray:model];
    BOOL isCurrentScalable = [self getModelIsScalable:model];
    [self setModelIsScalable:model andIsScalable:!isCurrentScalable];
    
    if (subModelArray.count == 0 || !subModelArray) {
        NSLog(@"%@ -> %@,内部没有子数组集合",self,model);
        return;
    }
    
    //如果有值 那么就对数据进行操作
    if (!isCurrentScalable) {
        //当前需要展开
        NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndexesInRange: NSMakeRange(modelX + 1, modelLength)];
        [self.dataSourceArray insertObjects:subModelArray atIndexes:indexSet];
    }else{
        //当前应该收起
        [self deleteDataSourceArrayContainsWithModel:model];
    }
    //修改数据
    for (NSInteger i = modelX; i < self.dataSourceArray.count; i++) {
        id model = self.dataSourceArray[i];
        //注册
        [self registerClassWithCell:model];
        //对index 进行计算
        [self addPropertyWithModel:model andIdx:i];
        NSInteger subModelLen = [self getModelRange:model].length;
        NSRange range = NSMakeRange(i, subModelLen);
        [self setModelRange:model andRange:range];
    }
    [self reloadData];
}



#pragma mark - setter

//MARK: 数据源
//在这里 一定是全都没有展开的情况
- (void) setModelArray:(NSArray *)modelArray {
    
    //1. 遍历添加属性
    [modelArray enumerateObjectsUsingBlock:^(id  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        
        //动态给model 添加属性，
        [self addPropertyWithModel:model andIdx:idx];
        //注册cell
        [self registerClassWithCell:model];
        [self.dataSourceArray addObject:model];
    }];
    self.dataSourceArray = self.dataSourceArray;
}

//MARK: 内部 真正的 数据源
- (void) setDataSourceArray:(NSMutableArray *)dataSourceArray {
    _dataSourceArray = dataSourceArray;
    [self reloadData];
}

//MARK: - get 数据源 里面是处理好model
- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [[NSMutableArray alloc]init];
    }
    return _dataSourceArray;
}


//MARK: 计算 range
- (void) addPropertyWithModel: (id) model andIdx: (NSInteger)idx{
    
    //.。1，是否第已经添加过属性了
    if(![self getModelISAddProperty:model]) {
    
        //.。2，添加（X，Y） x: 在NSArray的位置，Y其子model的多少
        NSArray *array = [self getModelSubModelArray:model];
        NSInteger X = idx;
        NSInteger Y = array.count;
        NSRange range = NSMakeRange(X, Y);
        [self setModelRange:model andRange:range];
        
        //.。3，添加 是否展开属性
        BOOL isCurrentScalable = [self getModelIsScalable:model];
        [self setModelIsScalable:model andIsScalable:isCurrentScalable];
    }
}

//MARK: 注册 cell
- (void) registerClassWithCell: (NSObject *)model {
    NSString *cellClassName = [self getModelCellClassName:model];
    
    if (![self.cellIDArray containsObject:cellClassName]) {
        Class cellClass = [self getModelCellClass:model];
        
        [self registerClass:cellClass forCellReuseIdentifier: cellClassName];
        [self.cellIDArray addObject:cellClassName];
    }
}


//MARK: 动态添加属性 --@"SCALABLETABLEVIEW"
static NSString *const isAddPropertyKey = @"PY_isAddProperty_SCALABLETABLEVIEW";
static NSString *const rangeKey = @"PY_range_SCALABLETABLEVIEW";
static NSString *const isScalableKey = @"PY_isScalable_SCALABLETABLEVIEW";

//是否已经添加过属性了
- (void) setModelISAddProperty: (id)model andISAddProperty: (BOOL)isAnddProperty{
    if (!model) {
        return NSLog(@"是否已经添加过属性了。model没有值");
    }
      objc_setAssociatedObject(model, &isAddPropertyKey, @(isAnddProperty), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL) getModelISAddProperty: (id)model {
    NSNumber *isAddPropretyNum = objc_getAssociatedObject(model, &isAddPropertyKey);
    return isAddPropretyNum.boolValue;
}

//range
- (void) setModelRange: (id)model andRange: (NSRange)range{
    if (!model) {
        return NSLog(@"设置model range 属性的时候。model没有值");
    }
    NSValue *rangeValue = [NSValue valueWithRange:range];
    objc_setAssociatedObject(model, &rangeKey, rangeValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSRange) getModelRange: (id)model{
    NSValue *range = (objc_getAssociatedObject(model, &rangeKey));
    return range.rangeValue;
}

//当前是否已经展开了
- (void) setModelIsScalable: (id)model andIsScalable: (BOOL) isScalable {
    if (!model) {
        return NSLog(@"设置model 当前是否已经展开了 属性的时候。model没有值,--- 注意，查看是否在 model对应的cell中 实现了“ - (void)cellSetDataFunc:(void (^)(NSObject *model))setDataCallBack“方法，想要有折叠效果必须要用这个方法对cell传值");
    }
    objc_setAssociatedObject(model, &isScalableKey, @(isScalable), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL) getModelIsScalable: (id)model {
    NSNumber *isScalable = objc_getAssociatedObject(model, &isScalableKey);
    return isScalable.boolValue;
}

//MARK: 关于数据 处理
//获取model的子model数据数组
- (NSArray *) getModelSubModelArray: (id)model{
    NSObject *modelObj = model;
    SEL modelArraySEL = NSSelectorFromString(@"modelArrayPropertyName");
    IMP imp = [modelObj methodForSelector:modelArraySEL];
    NSObject *(*func)(id,SEL) = (void*)imp;
    
    if ([model respondsToSelector:modelArraySEL]) {
        NSObject *modelSubArrayName = func(model,modelArraySEL);
        if ([modelSubArrayName.class isSubclassOfClass: NSClassFromString(@"NSString")]) {
            NSString *modelSubArrayNameStr = (NSString *)modelSubArrayName;
            NSObject *modelSubArrayObj = [modelObj valueForKey:modelSubArrayNameStr];
            if ([modelSubArrayObj.class isSubclassOfClass:NSClassFromString(@"NSArray")]) {
                return (NSArray *)modelSubArrayObj;
            }
        }
    }
    NSLog(@"🐯||->，%@，没有子数据集合",model);
    return [NSArray new];
}

// 获取model 中 cell 的Classa
- (Class) getModelCellClass: (NSObject *) model {
    return NSClassFromString([self getModelCellClassName: (model)]);
}
- (NSString *) getModelCellClassName: (NSObject *)model {
    SEL bindCellClassNameSEL = NSSelectorFromString(@"cellClass");
    IMP imp = [model methodForSelector:bindCellClassNameSEL];
    
    NSObject *(*func)(id,SEL) = (void*)imp;
    NSObject *bindCellClassNameObj = func(model,bindCellClassNameSEL);
    if ([bindCellClassNameObj.class isSubclassOfClass:NSClassFromString(@"NSString")]) {
        return (NSString *)bindCellClassNameObj;
    }
    NSLog(@"🔥%@||-> 没有获取到model绑定的cell",self);
    return @"UITableViewCell";
}

///cell的idArray
- (NSArray<NSString *> *)cellIDArray {
    if (!_cellIDArray) {
        _cellIDArray = [[NSMutableArray alloc]init];
    }
    return _cellIDArray;
}

///获取给定model下的所有subModel
- (NSArray *) getModelSubModelArrayWithModel: (id)model andModelArray: (NSMutableArray *)modelArray{

    ///如果modelArray为空 那么创建一个
    if (!modelArray) modelArray = [[NSMutableArray alloc]init];
    
    /// 获取model 的子model
    NSArray *subModelArray = [self getModelSubModelArray:model];
    
    ///表示model中已经没有其他子数组了，返回传入的modelArray
    if (subModelArray.count <= 0) return modelArray;
    
    /// 表示model中还有子数组，那么遍历
    [subModelArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![modelArray containsObject:obj]) [modelArray addObject:obj];
        
        /// 递归
        [self getModelSubModelArrayWithModel:obj andModelArray:modelArray];
    }];
    ///返回modelArray
    return modelArray;
}

///删除 显示数据源dataSourceArray 中取消展示的model
///(点击model1,则删除dataSourceArray中包含的model1的子model)
- (void) deleteDataSourceArrayContainsWithModel: (id) model {
    /// 获取model 的子model
    NSArray *subModelArray = [self getModelSubModelArray:model];
    
    ///表示model中已经没有其他子数组了，返回传入的modelArray
    if (subModelArray.count <= 0) return;
   
    /// 表示model中还有子数组，那么遍历
    [subModelArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        ///判断DataSourceArray中是否包含obj
        if ([self.dataSourceArray containsObject: obj]) {
            
            ///设置成收起状态
            [self setModelIsScalable:obj andIsScalable:false];
            
            ///删除
            [self.dataSourceArray removeObject:obj];
        
            /// 递归
            [self deleteDataSourceArrayContainsWithModel:obj];
        }
    }];
}

- (void)registerClickCellFunc:(void (^)(id _Nullable, NSString * _Nonnull))registerClickCellBlock {
    self.registerClickCellBlock = registerClickCellBlock;
}

@end

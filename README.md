![ScalableTablView.gif](http://upload-images.jianshu.io/upload_images/4185621-cf09588806387d45.gif?imageMogr2/auto-orient/strip)

#前言：
经常遇到多层cell折叠展开的需求，于是写了一个工具组件。
其中有几个特点：
>1. cell的高度自适应，或者统一设置cell高度。
>2.  使用简单，注册cell，和cell数据传递不用手动管理。
>3. 不需要告诉组件内部有model中多少层数据。
>4. 降低耦合，高聚合，并且性能较优。

---
#注意：
**1. 适用Model的数据结构**
>如下图：model中有个属性，是一个model数组，而model数组中的model又有包含了一个model数组属性，以此类推。。。

![适用的数据结构](http://upload-images.jianshu.io/upload_images/4185621-7f246530a5a12651.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


**2. Model中需要实现的方法**
model在定义时，需要实现两个方法：
```
///1. 返回 model对应 的 cell的class 的方法，通过这个方法返回了model绑定的cell 的类型，在内部进行了cell的注册
- (NSString *) cellClass{
    return @"PYTestCell1";
}
```
```
///2. 存储的model array的属性名， 组件内部通过这个方法，进行数据的查找。
- (NSString *) modelArrayPropertyName {
    return @"modelArray";
}
```

----
#核心思路
**1、根数据源**
> ScalableTableView工具中，要求传入一个数据源（以下统称`根数据源`）`@property (nonatomic,strong) NSArray *modelArray;`

**2、显示数据源**
>根据根数据源，生成另外一个数据源（以下统称`显示数据源`）`@property (nonatomic,strong) NSMutableArray *dataSourceArray;`所有的UI展示，获取数据都是从这个数据源中做调整。

**3、cell的注册**
>1. 在model中，获取cell 的Class，并注册。在第次传入根数据源的时候，先进行注册对应的cell。而并没有把所有的子model绑定的cell都注册完成。
>2. 在展开子cell的时候，注册展开cell中未注册的cell类型。
> 3. 不用担心会重复注册，因为有一个全局变量对已经注册的cell的类型进行了记录。

**4、model的扩展**
>1. 记录cell的展开状态，
>2. 还需要记录model在整个`显示数据源`的位置，以便数据的插入。

是否已经添加过属性了
```
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
```
当前是否已经展开了
```
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

```
range
```
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
```

---
#核心代码
>注释很清楚了，不再赘述。

**1. 展开的核心代码**
```
 UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
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
    }
```
**2. 收起的核心代码**
```
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
```

**3.获取model的子model数据数组**
```
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
```
**4. 获取model 中 cell 的Classa**
```
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
```
**5. cell传递数据的扩展**
````

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

````
---
内容扩展更新 ---
#cell 与tableview之间的数据传递通道
**1、cell内部点击事件的传递调用**
```
[self cellClickEventBlockWithSelectorKey:@"clickButton1"];
```
**2、tableView中注册cell的点击事件调用**
```
[self.tableview registerClickCellFunc:^(id  _Nullable model, NSString * _Nonnull clickSelectorKey) {
//代码处理
}];
```
#实现一行代码实现收缩效果
给tableView设置一个代理，并实现下列代码；
```
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableview didSelectRowAtIndexPath:indexPath];
}
```
---
[如果不太明白，运行一波代码就都懂喽！](https://github.com/LiPengYue/PYScalableTableView)
如果感觉提供了一个不一样的思路，请来一波红心，是对我最大的鼓励。

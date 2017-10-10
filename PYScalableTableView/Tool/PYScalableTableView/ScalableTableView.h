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
@property (nonatomic,strong) NSArray *modelArray;
- (void)encodeWithCoder:(nonnull NSCoder *)aCoder;

- (nullable NSIndexPath *)dataSourceIndexPathForPresentationIndexPath:(nullable NSIndexPath *)presentationIndexPath;

- (NSInteger)dataSourceSectionIndexForPresentationSectionIndex:(NSInteger)presentationSectionIndex;

- (void)performUsingPresentationValues:(nonnull void (^)(void))actionsToTranslate;

- (nullable NSIndexPath *)presentationIndexPathForDataSourceIndexPath:(nullable NSIndexPath *)dataSourceIndexPath;

- (NSInteger)presentationSectionIndexForDataSourceSectionIndex:(NSInteger)dataSourceSectionIndex;

+ (nonnull instancetype)appearance;

+ (nonnull instancetype)appearanceForTraitCollection:(nonnull UITraitCollection *)trait;

+ (nonnull instancetype)appearanceForTraitCollection:(nonnull UITraitCollection *)trait whenContainedIn:(nullable Class<UIAppearanceContainer>)ContainerClass, ...;

+ (nonnull instancetype)appearanceForTraitCollection:(nonnull UITraitCollection *)trait whenContainedInInstancesOfClasses:(nonnull NSArray<Class<UIAppearanceContainer>> *)containerTypes;

+ (nonnull instancetype)appearanceWhenContainedIn:(nullable Class<UIAppearanceContainer>)ContainerClass, ...;

+ (nonnull instancetype)appearanceWhenContainedInInstancesOfClasses:(nonnull NSArray<Class<UIAppearanceContainer>> *)containerTypes;

- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection;

- (CGPoint)convertPoint:(CGPoint)point fromCoordinateSpace:(nonnull id<UICoordinateSpace>)coordinateSpace;

- (CGPoint)convertPoint:(CGPoint)point toCoordinateSpace:(nonnull id<UICoordinateSpace>)coordinateSpace;

- (CGRect)convertRect:(CGRect)rect fromCoordinateSpace:(nonnull id<UICoordinateSpace>)coordinateSpace;

- (CGRect)convertRect:(CGRect)rect toCoordinateSpace:(nonnull id<UICoordinateSpace>)coordinateSpace;

- (void)didUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context withAnimationCoordinator:(nonnull UIFocusAnimationCoordinator *)coordinator;

- (void)setNeedsFocusUpdate;

- (BOOL)shouldUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context;

- (void)updateFocusIfNeeded;

@end

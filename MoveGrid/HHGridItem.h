//
//  HHGridItem.h
//  MoveGrid
//
//  Created by 胡晓桥 on 15/3/26.
//  Copyright (c) 2015年 51app. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HHGridItemDelegate;
@interface HHGridItem : UIButton

//格子的X坐标
@property (nonatomic, assign) CGFloat pointX;
//格子的Y坐标
@property (nonatomic, assign) CGFloat pointY;
//格子的ID
@property (nonatomic, assign) NSInteger gridId;
//格子索引
@property (nonatomic, assign) NSInteger gridIndex;
//格子的中心点
@property (nonatomic, assign) CGPoint gridCenterPoint;

//格子的选中状态
@property(nonatomic, assign) BOOL isChecked;
//格子的移动状态
@property(nonatomic, assign) BOOL isMove;


//代理对象
@property (nonatomic, weak) id<HHGridItemDelegate> delegate;

/**
 *  创建格子
 *  @param gridId         格子的ID
 *  @param isAddBadgeIcon 是否添加角标
 */
- (id)initWithFrame:(CGRect)frame
             gridId:(NSInteger)gridId
          gridIndex:(NSInteger)index
              image:(UIImage *)image
              title:(NSString *)title
      normalBgImage:(UIImage *)normalImage
     highlightImage:(UIImage *)highlightImage
     isAddBadgeIcon:(BOOL)isAddBadgeIcon
          badgeIcon:(UIImage *)badgeImage;


//根据格子的坐标计算格子的索引位置
+ (NSInteger)indexOfPoint:(CGPoint)point
               withButton:(UIButton *)btn
                gridArray:(NSMutableArray *)gridListArray;



@end


@protocol HHGridItemDelegate <NSObject>

//响应格子的点击事件
- (void)gridItemDidCliked:(HHGridItem *)clickItem;
//响应格子的删除事件
- (void)gridItemDidDeleleClicked:(UIButton *)deleteButton;
//响应格子的长按手势事件
- (void)pressGestureStateBegan:(UILongPressGestureRecognizer *)longPressGesture withGridItem:(HHGridItem *)gridItem;

- (void)pressGestureStateChangedWithPoint:(CGPoint)gridPoint gridItem:(HHGridItem *)gridItem;

- (void)pressGestureStateEnded:(HHGridItem *)gridItem;

@end
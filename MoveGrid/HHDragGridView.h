//
//  HHDragGridView.h
//  MoveGrid
//
//  Created by 胡晓桥 on 15/3/26.
//  Copyright (c) 2015年 51app. All rights reserved.
//

#import <UIKit/UIKit.h>

//状态
NS_ENUM(NSUInteger, HHDragGridViewState)
{
    HHDragGridViewStateNormal = 1,//首页状态
    HHDragGridViewStateMore = 2 //更多状态
};


@interface HHDragGridView : UIView
//格子总数
@property (nonatomic, assign) NSInteger totolCount;
//每行个数(列数)
@property (nonatomic, assign) NSInteger rowCount;

//图片数组
@property (nonatomic, strong) NSArray *images;
//标题数组
@property (nonatomic, strong) NSArray *titles;

//是否添加更多
@property (nonatomic, assign) enum HHDragGridViewState state;



//格子对应进入的目标控制器数组
@property (nonatomic, strong) NSArray *destinationControllers;


/**
 *  创建格子容器
 *
 *  @param totolCount  格子总数
 *  @param rowCount    每行个数
 *  @param images      图片
 *  @param titles      标题
 *  @param badageImage 角标图片（删除/添加）
 *  @param state
 *
 */
- (id)initWithFrame:(CGRect)frame
         totolCount:(NSInteger)totolCount
           rowCount:(NSInteger)rowCount
             images:(NSArray *)images
             titles:(NSArray *)titles
              state:(enum HHDragGridViewState)  state;


@end

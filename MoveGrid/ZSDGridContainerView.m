//
//  ZSDGridContainerView.m
//  MoveGrid
//
//  Created by 胡晓桥 on 15/3/19.
//  Copyright (c) 2015年 51app. All rights reserved.
//

#import "ZSDGridContainerView.h"
#import "CustomGrid.h"



@interface ZSDGridContainerView()<CustomGridDelegate>

@end

@implementation ZSDGridContainerView

- (id)initWithFrame:(CGRect)frame
{
    
    
    return self;
}


#pragma mark - CustomGridDelegate

//响应格子的点击事件
- (void)gridItemDidClicked:(CustomGrid *)clickItem
{
    
}

//响应格子删除事件
- (void)gridItemDidDeleteClicked:(UIButton *)deleteButton
{
    
}

//响应格子的长按手势事件
- (void)pressGestureStateBegan:(UILongPressGestureRecognizer *)longPressGesture withGridItem:(CustomGrid *) grid
{
    
}

- (void)pressGestureStateChangedWithPoint:(CGPoint) gridPoint gridItem:(CustomGrid *) gridItem
{
    
}

- (void)pressGestureStateEnded:(CustomGrid *) gridItem
{
    
}


@end

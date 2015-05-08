//
//  HHGridItem.m
//  MoveGrid
//
//  Created by 胡晓桥 on 15/3/26.
//  Copyright (c) 2015年 51app. All rights reserved.
//

#import "HHGridItem.h"

#define  ImageWidth 27
#define  ImageHeight 27
#define  TopMargin 20
#define  TitleHight 21
#define  BadageWidth 16
#define  BadageMargin 5

@implementation HHGridItem

- (id)initWithFrame:(CGRect)frame
             gridId:(NSInteger)gridId
          gridIndex:(NSInteger)index
              image:(UIImage *)image
              title:(NSString *)title
      normalBgImage:(UIImage *)normalImage
     highlightImage:(UIImage *)highlightImage
     isAddBadgeIcon:(BOOL)isAddBadgeIcon
          badgeIcon:(UIImage *)badgeImage
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //设置背景图片
        
        
        [self setBackgroundImage:normalImage forState:UIControlStateNormal];
        [self setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
        
        //添加imageView
        UIImageView *imageView = [UIImageView new];
        imageView.image = image;
    
        imageView.bounds = CGRectMake(0, 0, ImageWidth, ImageHeight);
        imageView.center = CGPointMake(frame.size.width / 2, TopMargin + ImageHeight / 2);
        [self addSubview:imageView];
        
        //添加titleLabel
        UILabel *titleLabel = [UILabel new];
        titleLabel.text = title;
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.bounds = CGRectMake(0, 0, frame.size.width, TitleHight);
        titleLabel.center = CGPointMake(frame.size.width / 2, TopMargin+ImageHeight+10);
        [self addSubview:titleLabel];
        
        [self addTarget:self action:@selector(gridClick:) forControlEvents:UIControlEventTouchUpInside];
        
        _gridIndex = index;
        _gridId = gridId;
        _gridCenterPoint = self.center;
        
        //判断是否要添加删除或者添加图标
        if (isAddBadgeIcon) {
            //当长按时添加删除按钮图标
            UIButton *badgeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            badgeButton.frame = CGRectMake(frame.size.width - (BadageWidth+BadageMargin), BadageMargin, BadageWidth, BadageWidth);
            [badgeButton setBackgroundImage:badgeImage forState:UIControlStateNormal];
            [badgeButton addTarget:self action:@selector(deleteGrid:) forControlEvents:UIControlEventTouchUpInside];
            badgeButton.hidden = YES;
            
            badgeButton.tag = gridId;
            
            [self addSubview:badgeButton];
            
            //添加长按手势
            UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(gridLongPress:)];
            [self addGestureRecognizer:longPressGesture];
        }
        
    }
    return self;
}

//响应格子的点击事件
- (void)gridClick:(HHGridItem *)clickItem
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(gridItemDidCliked:)]) {
        [self.delegate gridItemDidCliked:clickItem];
    }
}

//响应格子的删除事件
- (void)deleteGrid:(UIButton *)badgeButton
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(gridItemDidDeleleClicked:)]) {
        [self.delegate gridItemDidDeleleClicked:badgeButton];
    }
}

//响应格子的长按手势事件
- (void)gridLongPress:(UILongPressGestureRecognizer *)gesture
{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            if (self.delegate && [self.delegate respondsToSelector:@selector(pressGestureStateBegan:withGridItem:)]) {
                [self.delegate pressGestureStateBegan:gesture withGridItem:self];
            }
            break;
            case UIGestureRecognizerStateChanged:
            if (self.delegate && [self.delegate respondsToSelector:@selector(pressGestureStateChangedWithPoint:gridItem:)]) {
                
                //长按移动后的新坐标
                CGPoint newPoint = [gesture locationInView:gesture.view];
                [self.delegate pressGestureStateChangedWithPoint:newPoint gridItem:self];
            }
            break;
            case UIGestureRecognizerStateEnded:
            if (self.delegate && [self.delegate respondsToSelector:@selector(pressGestureStateEnded:)]) {
                [self.delegate pressGestureStateEnded:self];
            }
            break;
        default:
            break;
    }
}

//根据格子的坐标计算格子的索引位置
+ (NSInteger)indexOfPoint:(CGPoint)point
               withButton:(UIButton *)btn
                gridArray:(NSMutableArray *)gridListArray
{
    for (NSInteger i = 0; i < gridListArray.count; i++) {
        UIButton *appButton = gridListArray[i];
        if (appButton != btn) {
            if (CGRectContainsPoint(appButton.frame, point)) {
                return i;
            }
        }
    }
    return -1;
}



@end

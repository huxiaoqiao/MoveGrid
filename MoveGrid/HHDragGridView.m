//
//  HHDragGridView.m
//  MoveGrid
//
//  Created by 胡晓桥 on 15/3/26.
//  Copyright (c) 2015年 51app. All rights reserved.
//

#import "HHDragGridView.h"
#import "UIView+GetViewController.h"
#import "HHGridItem.h"

@interface HHDragGridView()<HHGridItemDelegate>
//每列个数(行数)
@property (nonatomic, assign) NSInteger columnCount;
//格子的宽度
@property (nonatomic, assign) CGFloat width;
//格子的高度
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, strong) NSMutableArray *showGridArray;//正在显示的格子数组
@property (nonatomic, strong) NSMutableArray *deletedGridArray;//删掉的格子数组

//选中格子的起始中心点位置
@property (nonatomic, assign) CGPoint originPoint;

//选中格子的起始位置
@property (nonatomic, assign) CGPoint startPoint;

@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, strong) UIImage *normalImage;
@property (nonatomic, strong) UIImage *highlightImage;

@property (nonatomic, assign) BOOL isContain;

@end

@implementation HHDragGridView

//画分隔线
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (int i = 0; i <= _columnCount - 1; i++) {
        CGContextMoveToPoint(context, 0, _height*i);
        CGContextAddLineToPoint(context, self.frame.size.width, _height *i);
    }
    CGContextMoveToPoint(context, 0, self.frame.size.height - 1);
    CGContextAddLineToPoint(context, self.frame.size.width, self.frame.size.height - 1);
    
    for (int i = 1; i <= _rowCount - 1; i++) {
        CGContextMoveToPoint(context, _width*i, 0);
        CGContextAddLineToPoint(context, _width*i, self.frame.size.height);
    }
    
    CGContextSetLineWidth(context, 1);
    
    [[UIColor groupTableViewBackgroundColor] set];
    
    CGContextDrawPath(context, kCGPathStroke);
}


- (id)initWithFrame:(CGRect)frame
         totolCount:(NSInteger)totolCount
           rowCount:(NSInteger)rowCount
             images:(NSArray *)images
             titles:(NSArray *)titles
              state:(enum HHDragGridViewState) state
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _totolCount = totolCount;
        _rowCount = rowCount;
        //计算每列个数
        if (_totolCount % _rowCount == 0) {
            _columnCount = _totolCount / _rowCount;
        }else
        {
            _columnCount = _totolCount / _rowCount + 1;
        }
        
        //计算格子的宽度和高度
        
        //格子的宽度
        _width = self.frame.size.width  / _rowCount;
        //格子的高度
        _height = self.frame.size.height / _columnCount;
        
        _images = [NSMutableArray arrayWithArray:images];
        _titles = [NSMutableArray arrayWithArray:titles];
        _state = state;
        
        _showGridArray = [NSMutableArray array];
        _deletedGridArray = [NSMutableArray array];
        
        _normalImage = [UIImage imageNamed:@""];
        _highlightImage = [UIImage imageNamed:@"btn_highlight"];
        
        [self setupGridItems];
        [self setNeedsDisplay];
    }
    return self;
}


- (void)setupGridItems
{
    
    for (int i = 0; i < _rowCount; i ++)
    {
        
        for (int j = 0; j < _columnCount; j++) {
            //每个格子的x坐标
            CGFloat pointX = _width  * j;
            //每个格子的y坐标
            CGFloat pointY = _height  * i;
            
            
            CGRect itemFrame = CGRectMake(pointX, pointY, _width , _height);
            
            NSLog(@"%@",NSStringFromCGRect(itemFrame));
            
            BOOL isAddBadage;
            
            UIImage *badgeImage;
            if (_state == HHDragGridViewStateNormal) {
                if (i*_rowCount + j == _totolCount - 1) {
                    isAddBadage = NO;
                }else
                {
                    isAddBadage = YES;
                }
                badgeImage = [UIImage imageNamed:@"app_item_plus"];
            }else
            {
                isAddBadage = YES;
                badgeImage = [UIImage imageNamed:@"app_item_add"];
            }
            
           
            
            HHGridItem *item = [[HHGridItem alloc] initWithFrame:itemFrame gridId:i*_rowCount + j gridIndex:i*_rowCount + j image:_images[i*_rowCount + j] title:_titles[i*_rowCount + j] normalBgImage:_normalImage highlightImage:_highlightImage isAddBadgeIcon:isAddBadage badgeIcon:badgeImage];
            item.tag = i*_rowCount + j;
            item.delegate = self;
            
            [self addSubview:item];
            [_showGridArray addObject:item];
            
        }
        
        
        
       
       
        
}
    
}



- (void)showViewController:(UIViewController *)controller
{
    [self.viewController presentViewController:controller animated:YES completion:nil];
}


#pragma mark - HHGridItemDelegate

//响应格子的点击事件
- (void)gridItemDidCliked:(HHGridItem *)clickItem
{
    NSLog(@"你点击的格子的ID是:%ld",(long)clickItem.gridId);
    
}
//响应格子的删除事件
- (void)gridItemDidDeleleClicked:(UIButton *)deleteButton
{
    NSLog(@"你删除的格子的ID是:%ld",deleteButton.tag);
    
    for (NSInteger i = 0; i < _totolCount; i++) {
        HHGridItem *removeItem = _showGridArray[i];
        if (removeItem.gridId == deleteButton.tag) {
            [removeItem removeFromSuperview];
            
            NSInteger count = _showGridArray.count -1;
            for (NSInteger index = removeItem.gridIndex; index < count; index ++) {
                HHGridItem *preGrid = _showGridArray[index];
                HHGridItem *nextGrid = _showGridArray[index + 1];
                
                //从删除的Item开始，后面依次补位
                [UIView animateWithDuration:0.5 animations:^{
                    nextGrid.center = preGrid.gridCenterPoint;
                }];
                nextGrid.gridIndex = index;
            }
            [_showGridArray removeObjectAtIndex:removeItem.gridIndex];
            
            //删除的Item添加到更多格子数组
            [_deletedGridArray addObject:removeItem];
        }
    }
    
    //ToDo ---- 添加删除的动画路径
    
}
//响应格子的长按手势事件
- (void)pressGestureStateBegan:(UILongPressGestureRecognizer *)longPressGesture withGridItem:(HHGridItem *)gridItem
{
    
    //判断格子是否已经被选中并且是都可移动状态，如果选中就加一个放大的特效
    if (_isSelected && gridItem.isChecked) {
        gridItem.transform = CGAffineTransformMakeScale(1.2, 1.2);
    }
    
    //没有一个格子选中的时候
    if (!_isSelected) {
        _isSelected = YES;
        gridItem.isMove = YES;
        gridItem.isChecked = YES;
        //选中格子的时候显示删除图标
        UIButton *removeBtn = (UIButton *)[longPressGesture.view viewWithTag:gridItem.gridId];
        removeBtn.hidden = NO;
        
        //获取移动格子的起始位置
        _startPoint = [longPressGesture locationInView:self.superview];
        
        //获取移动格子起始位置中心点
        _originPoint = gridItem.center;
        
        //给选中的格子添加放大特效
        [UIView animateWithDuration:0.5 animations:^{
            gridItem.transform = CGAffineTransformMakeScale(1.2, 1.2);
            gridItem.alpha = 0.8;
            
            [gridItem setBackgroundImage:_highlightImage forState:UIControlStateNormal];
        }];
        
        
    }
    
    
}

- (void)pressGestureStateChangedWithPoint:(CGPoint)gridPoint gridItem:(HHGridItem *)gridItem
{
    if(_isSelected && gridItem.isChecked)
    {
        [self.superview bringSubviewToFront:gridItem];
        //格子移动后的X坐标
        CGFloat deltaX = gridPoint.x - _startPoint.x;
        //格子移动后的Y坐标
        CGFloat deltaY = gridPoint.y - _startPoint.y;
        //拖动的Item跟随手势移动
        gridItem.center = CGPointMake(gridItem.center.x+deltaX, gridItem.center.y+deltaY);
        
        //移动的格子的索引下标
        NSInteger fromIndex = gridItem.gridIndex;
        //移动到目标格子的索引下标
        NSInteger toIndex = [HHGridItem indexOfPoint:gridItem.center withButton:gridItem gridArray:_showGridArray];
        
        NSInteger borderIndex = _showGridArray.count - 1;
        
        if (toIndex < 0 || toIndex >= borderIndex) {
            _isContain = NO;
        }else
        {
            //获取移动到目标格子
            HHGridItem *targetGrid = _showGridArray[toIndex];
            gridItem.center = targetGrid.gridCenterPoint;
            _originPoint = targetGrid.gridCenterPoint;
            gridItem.gridIndex = toIndex;
            
            //判断格子的移动方向，是从后往前还是从前往后拖动
            if ((fromIndex - toIndex) > 0) {
                NSLog(@"从后往前拖动格子。。。。");
                //从移动格子的位置开始，始终获取最后一个格子的索引位置
                NSInteger lastGridIndex = fromIndex;
                for (NSInteger i = toIndex; i < fromIndex; i ++) {
                    HHGridItem *lastGrid = _showGridArray[lastGridIndex];
                    HHGridItem *preGrid = _showGridArray[lastGridIndex -1];
                    
                    [UIView animateWithDuration:0.5 animations:^{
                        preGrid.center = lastGrid.gridCenterPoint;
                    }];
                    
                    //实时更新格子的索引下标
                    preGrid.gridIndex = lastGridIndex;
                    lastGridIndex--;
                    
                    [self sortGridList];
                }
                
            }else if((fromIndex - toIndex) < 0){
                //从前往后拖动格子
                NSLog(@"从前往后拖动格子。。。。");
                //从移动格子到目标格子之间的所有格子向前移动一格
                for (NSInteger i = fromIndex; i < toIndex; i++) {
                    HHGridItem *topOneGrid = _showGridArray[i];
                    HHGridItem *nextGrid = _showGridArray[i+1];
                    
                    [UIView animateWithDuration:0.5 animations:^{
                        nextGrid.center = topOneGrid.gridCenterPoint;
                    }];
                    
                    //实时更新格子的索引下标
                    nextGrid.gridIndex = i;
                    
                }
                //排列格子顺序和更新格子坐标信息
                [self sortGridList];
            }
        }
        
    }

}

- (void)pressGestureStateEnded:(HHGridItem *)gridItem
{
    if (_isSelected && gridItem.isChecked) {
        //撤销格子的放大效果
        
        [UIView animateWithDuration:0.5 animations:^{
            gridItem.transform = CGAffineTransformIdentity;
            gridItem.alpha = 1.0;
            if (!_isContain) {
                gridItem.center = _originPoint;
            }
        }];
        
        //排列格子顺序和更新格子坐标信息
        [self sortGridList];
    }
}

- (void)sortGridList
{
    //重新排列数组中存放的格子顺序
    [_showGridArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        HHGridItem *tempGrid1 = (HHGridItem *)obj1;
        HHGridItem *tempGrid2 = (HHGridItem *)obj2;
        return tempGrid1.gridIndex > tempGrid2.gridIndex;
    }];
    
    //更新所有格子的中心点坐标信息
    for (NSInteger i = 0; i < _showGridArray.count; i++) {
        HHGridItem *gridItem = _showGridArray[i];
        gridItem.gridCenterPoint = gridItem.center;
        
        //for test print
        //NSLog(@"移动后所有格子的位置信息{gridIndex: %d, gridCenterPoint: %@, gridID: %d}",
        //gridItem.gridIndex, NSStringFromCGPoint(gridItem.gridCenterPoint), gridItem.gridId);
    }
}



@end

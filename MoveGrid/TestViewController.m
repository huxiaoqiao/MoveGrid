//
//  TestViewController.m
//  MoveGrid
//
//  Created by 胡晓桥 on 15/3/19.
//  Copyright (c) 2015年 51app. All rights reserved.
//

#import "TestViewController.h"
#import "CustomGrid.h"
#import "HHDragGridView.h"

@interface TestViewController ()
@property (weak, nonatomic) IBOutlet UIView *gridView;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSMutableArray *imageArr = [NSMutableArray array];
    NSMutableArray *titleArr = [NSMutableArray array];
    
    for (int i = 0; i < 9; i ++) {
        UIImage *image = [UIImage imageNamed:@"testimage"];
        [imageArr addObject:image];
        [titleArr addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    HHDragGridView *dragGridView = [[HHDragGridView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width) totolCount:9 rowCount:3 images:imageArr titles:titleArr state:HHDragGridViewStateNormal];
    
    [self.view addSubview:dragGridView];
    

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  instruction.m
//  Detectnum
//
//  Created by Harley Wang on 2018/7/29.
//  Copyright © 2018年 Steven. All rights reserved.
//

#import "instruction.h"

@interface instruction ()

@end

@implementation instruction

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addimageview:@"1.jpg"];
   
}
-(void)addimageview:(NSString *)imagename{
    
    
    UIImageView* imageview1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
    
    UIImage * image=[UIImage imageNamed:imagename];
    
    [imageview1 setImage:image];
    
    [self.view addSubview:imageview1];
    
    UIButton *btn = [[UIButton alloc]init];
    btn.frame = CGRectMake(LineX(10), LineY(20), LineX(50), LineY(50));
//    btn.layer.cornerRadius=50/2.0;  //设置圆形按钮
//    btn.layer.masksToBounds=50/2.0;
   // btn.backgroundColor=[UIColor blackColor];
    //  [btn setTitle:@"返回" forState:UIControlStateNormal]; // 标题
    [btn setBackgroundImage:[UIImage imageNamed:@"left.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];//设置事件
    [self.view addSubview:btn];
    
    
}
-(void)clickBtn{
    [self.navigationController popViewControllerAnimated:YES];
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

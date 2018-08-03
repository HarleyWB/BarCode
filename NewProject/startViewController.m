//
//  startViewController.m
//  Detectnum
//
//  Created by li li on 2017/7/21.
//  Copyright © 2017年 Steven. All rights reserved.
//

#import "startViewController.h"
#import "RootViewController.h"
#import "WebViewController.h"
#import "QRViewController.h"
#import "instruction.h"
#import "CJScanQRCodeViewController.h"

@interface startViewController ()

@end

@implementation startViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addimageview:@"start.jpg"];
    NSLog(@"sa");
   
    UIButton *but3 =[UIButton buttonWithType:UIButtonTypeCustom];
    but3.frame=CGRectMake (LineX(20), LineY(450), LineX(130), LineY(50));
  // but3.backgroundColor=[UIColor grayColor];
    //NSString *but3s = NSLocalizedString(@"contact",@"");
    //but3.layer.cornerRadius = 20.0;//2.0是圆角的弧度，根据需求自己更改
   // but3.layer.borderColor = [UIColor blackColor].CGColor;//设置边框颜色
   //but3.layer.borderWidth = 1.0f;
    [but3 setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    //[but3 setBackgroundImage:[UIImage imageNamed:@"right.png"] forState:UIControlStateSelected];
    [but3 setTitle: @"說明" forState: UIControlStateNormal];
    [but3 setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    [but3 addTarget:self action:@selector(but3clik) forControlEvents:UIControlEventTouchUpInside];
     but3.titleLabel.font = [UIFont systemFontOfSize:25.0];
    [self.view addSubview:but3];
    
    
    
    UIButton *but1 =[UIButton buttonWithType:UIButtonTypeCustom];
    but1.frame=CGRectMake(LineX(170), LineY(450), LineX(130), LineY(50));
   // but1.backgroundColor=[UIColor grayColor];
   //NSString *but1s = NSLocalizedString(@"contact",@"");
    but1.layer.cornerRadius = 10.0;//2.0是圆角的弧度，根据需求自己更改
   // but1.layer.borderColor = [UIColor blackColor].CGColor;//设置边框颜色
   // but1.layer.borderWidth = 1.0f;
  
    [but1 setTitle: @"公司網站" forState: UIControlStateNormal];
     [but1 setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    [but1 addTarget:self action:@selector(but1clik) forControlEvents:UIControlEventTouchUpInside];
     but1.titleLabel.font = [UIFont systemFontOfSize:25.0];
    [but1 setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    [self.view addSubview:but1];
    
    UIButton *but2 =[UIButton buttonWithType:UIButtonTypeCustom];
  // but2.backgroundColor=[UIColor grayColor];
    but2.frame=CGRectMake(LineX(20), LineY(360), LineX(130), LineY(50));
    but2.layer.cornerRadius = 10.0;//2.0是圆角的弧度，根据需求自己更改

   
    [but2 setTitle:@"執行解碼" forState:UIButtonTypeCustom];
     [but2 setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    but2.titleLabel.font = [UIFont systemFontOfSize:25.0];
    [but2 addTarget:self action:@selector(but2clik) forControlEvents:UIControlEventTouchUpInside];
    [but2 setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
   // but2.backgroundColor=[UIColor blackColor];
    [self.view addSubview:but2];
    
    UIButton *butqr =[UIButton buttonWithType:UIButtonTypeCustom];
    // but2.backgroundColor=[UIColor grayColor];
    butqr.frame=CGRectMake(LineX(170), LineY(360), LineX(130), LineY(50));
    butqr.layer.cornerRadius = 10.0;//2.0是圆角的弧度，根据需求自己更改
    // but2.layer.borderColor = [UIColor blackColor].CGColor;//设置边框颜色
    //  but2.layer.borderWidth = 1.0f;
    // but2.backgroundColor=[UIColor greenColor];
    [butqr setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    
    [butqr setTitle:@"掃描條碼" forState:UIButtonTypeCustom];
    [butqr setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    butqr.titleLabel.font = [UIFont systemFontOfSize:25.0];
    [butqr addTarget:self action:@selector(butqrclik) forControlEvents:UIControlEventTouchUpInside];
    // but2.backgroundColor=[UIColor blackColor];
    [self.view addSubview:butqr];
   
    
}
-(void)but1clik{
    WebViewController* web=[[WebViewController alloc]init];
web.weburl=@"http://www.allbests.com.tw/";
   // web.weburl=@"http://www.hdu.edu.cn/";
   // RootViewController * web=[[RootViewController alloc]init];
    [self.navigationController pushViewController:web animated:YES];
}
-(void) but2clik{
    RootViewController *r=[[RootViewController alloc]init];
    [self.navigationController pushViewController: r animated:YES];
}
-(void) but3clik{
     instruction *r=[[instruction alloc]init];
    [self.navigationController pushViewController: r animated:YES];
}
-(void)butqrclik{
    CJScanQRCodeViewController *r=[[CJScanQRCodeViewController alloc]init];
    [self.navigationController pushViewController: r animated:YES];
}
-(void)addimageview:(NSString *)imagename{
    
    
    UIImageView* imageview1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
   
    UIImage * image=[UIImage imageNamed:imagename];
    
    [imageview1 setImage:image];
    
    [self.view addSubview:imageview1];
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

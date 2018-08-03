//
//  ViewController.m
//  Detectnum
//
//  Created by Harley Wang on 2017/12/5.
//  Copyright © 2017年 Steven. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()<WKNavigationDelegate,WKUIDelegate>



// 设置加载进度条

@property(nonatomic,strong) UIProgressView *  ProgressView;
@end

@implementation WebViewController
WKWebView* webView ;
-(void)viewWillAppear:(BOOL)animated
{
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    // Do any additional setup after loading the view.

        
    
        
        
        
    
    //在app里面加载页面
    CGRect bounds = CGRectMake(0 , LineY(50), Main_Screen_Width, Main_Screen_Height);
     webView = [[WKWebView alloc]initWithFrame:bounds];
   NSURL *url = [NSURL URLWithString:self.weburl];//创建URL
   // NSURL *url = [NSURL URLWithString:@"https://www.baidu.com/"];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建
    [webView loadRequest:request];//加载
   // [webView setAllowsBackForwardNavigationGestures:true];
    
 // [self.view addSubview:self.ProgressView];
    [self.view addSubview:webView];
   UIButton *btn = [[UIButton alloc]init];
  btn.frame = CGRectMake(LineX(100), LineY(510), LineX(50), LineY(50));

//btn.backgroundColor=[UIColor blackColor];
  //  [btn setTitle:@"返回" forState:UIControlStateNormal]; // 标题
    [btn setBackgroundImage:[UIImage imageNamed:@"left.png"] forState:UIControlStateNormal];
   [btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];//设置事件
    [self.view addSubview:btn];
    
    
    
    UIButton *btn2 = [[UIButton alloc]init];
    btn2.frame = CGRectMake(LineX(170), LineY(511), LineX(50), LineY(50));
 
  // btn2.backgroundColor=[UIColor blackColor];
    //[btn2 setTitle:@"qianjin" forState:UIControlStateNormal]; // 标题
    [btn2 setBackgroundImage:[UIImage imageNamed:@"right.png"] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(clickBtn2) forControlEvents:UIControlEventTouchUpInside];//设置事件
    [self.view addSubview:btn2];
    
    UIButton *btn4 = [[UIButton alloc]init];
    btn4.frame = CGRectMake(LineX(0), LineY(20), LineX(80), LineY(30));
 
   //btn4.backgroundColor=[UIColor blackColor];
    //  [btn setTitle:@"返回" forState:UIControlStateNormal]; // 标题
    [btn4 setBackgroundImage:[UIImage imageNamed:@"left2.png"] forState:UIControlStateNormal];
    [btn4 addTarget:self action:@selector(clickBtn4) forControlEvents:UIControlEventTouchUpInside];//设置事件
    [self.view addSubview:btn4];
    
}
//添加响应函数
-(void)clickBtn4{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)clickBtn{
   if (webView.canGoBack)
  
    webView.goBack;
}
-(void)clickBtn2{
    if (webView.canGoForward)
    
    webView.goForward;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
    //开始加载的时候，让加载进度条显示
    
    self.ProgressView.hidden = NO;
    
    NSLog(@"开始加载的时候调用。。");
    
 
    
    
}
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    
    
    /*
     
     主意：这个方法是当网页的内容全部显示（网页内的所有图片必须都正常显示）的时候调用（不是出现的时候就调用），，否则不显示，或则部分显示时这个方法就不调用。
     
     */
    
    NSLog(@"加载完成调用");
    
    // 获取加载网页的标题
    
   // NSLog(@"加载的标题：%@",self.ZSJ_WkwebView.title);
    
    
    
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    // 首先，判断是哪个路径
    

        
        // 判断是哪个对象
    
            
    
            
            if (webView.estimatedProgress == 1.0) {
                
                //隐藏
                
                self.ProgressView.hidden = YES;
                
            }else{
                
                // 添加进度数值
                
                self.ProgressView.progress = webView.estimatedProgress;
                
            }
            
   
    
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

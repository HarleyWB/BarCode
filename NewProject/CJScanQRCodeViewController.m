//
//  CJScanQRCodeViewController.m
//  Detectnum
//
//  Created by Harley Wang on 2018/8/2.
//  Copyright © 2018年 Steven. All rights reserved.
//

#import "CJScanQRCodeViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "WebViewController.h"
@interface CJScanQRCodeViewController ()

@property (strong,nonatomic) UILabel* labResult;
@property (strong,nonatomic) NSString *url;
@property (strong,nonatomic) NSTimer *timer;
@property (strong,nonatomic) UIButton *overlayButton ;
@end

@implementation CJScanQRCodeViewController
@synthesize labResult;
- (void)viewDidLoad {
    [super viewDidLoad];
    //页面标题
    self.title = @"扫一扫";
    //配置定位信息
    //[self configLocation];
    //配置二维码扫描
    [self configBasicDevice];
    //配置缩放手势
   // [self configPinchGes];
    //开始启动
    [self.session startRunning];
    UIButton *btn4 = [[UIButton alloc]init];
    btn4.frame = CGRectMake(LineX(20), LineY(20), LineX(35), LineY(35));
    // btn4.backgroundColor=[UIColor blackColor];
    
    //btn.backgroundColor=[UIColor blackColor];
    //  [btn setTitle:@"返回" forState:UIControlStateNormal]; // 标题
    [btn4 setBackgroundImage:[UIImage imageNamed:@"left.png"] forState:UIControlStateNormal];
    [btn4 addTarget:self action:@selector(clickBtn4) forControlEvents:UIControlEventTouchUpInside];//设置事件
    
    
    self.view.backgroundColor = [UIColor blackColor];
    UIImageView * imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(LineX(15), LineY(20), LineX(290), LineY(50))];
    imageView1.image = [UIImage imageNamed:@"協進公司標題副本.jpg"];
    [self.view addSubview:imageView1];
//    UILabel * labIntroudction= [[UILabel alloc] initWithFrame:CGRectMake(LineX(15), LineY(70), LineX(290), LineY(100))] ;
//    labIntroudction.backgroundColor = [UIColor clearColor];
//    labIntroudction.numberOfLines=4;
//    labIntroudction.textColor=[UIColor whiteColor];
//    labIntroudction.text=@"此APP只能掃描我們的專屬編碼，手機請距離掃描目標7-15公分，不同手機鏡頭掃描距離不同，掃到時，下方會顯示結果";
//
//    [self.view addSubview:labIntroudction];
    [self.view addSubview:btn4];
    labResult= [[UILabel alloc] initWithFrame:CGRectMake(LineX(30), LineY(430), LineX(85), LineY(40))];
    labResult.backgroundColor = [UIColor clearColor];
    labResult.numberOfLines=2;
    labResult.textColor=[UIColor blackColor];
    labResult.text=@"Result：";
    [labResult sizeToFit];
    [self.view addSubview:labResult];
}
-(void)clickBtn4{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)configBasicDevice{
    int ZYAppWidth=Main_Screen_Width;
    int ZYAppHeight=Main_Screen_Height;
    //默认使用后置摄像头进行扫描,使用AVMediaTypeVideo表示视频
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //设备输入 初始化
    self.input = [[AVCaptureDeviceInput alloc]initWithDevice:self.device error:nil];
    //设备输出 初始化，并设置代理和回调，当设备扫描到数据时通过该代理输出队列，一般输出队列都设置为主队列，也是设置了回调方法执行所在的队列环境
    self.output = [[AVCaptureMetadataOutput alloc]init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //会话 初始化，通过 会话 连接设备的 输入 输出，并设置采样质量为 高
    self.session = [[AVCaptureSession alloc]init];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    //会话添加设备的 输入 输出，建立连接
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.output]) {
        [self.session addOutput:self.output];
    }
    //指定设备的识别类型 这里只指定二维码识别这一种类型 AVMetadataObjectTypeQRCode
    //指定识别类型这一步一定要在输出添加到会话之后，否则设备的课识别类型会为空，程序会出现崩溃
    [self.output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeUPCECode,AVMetadataObjectTypeAztecCode,AVMetadataObjectTypePDF417Code,AVMetadataObjectTypeDataMatrixCode,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeITF14Code,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode39Mod43Code,AVMetadataObjectTypeCode93Code,AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeInterleaved2of5Code]];
    //设置扫描信息的识别区域，本文设置正中央的一块正方形区域，该区域宽度是scanRegion_W
    //这里考虑了导航栏的高度，所以计算有点麻烦，识别区域越小识别效率越高，所以不设置整个屏幕
    CGFloat navH = self.navigationController.navigationBar.bounds.size.height;

    
    
    [self.output setRectOfInterest:CGRectMake(0,0, Main_Screen_Width, Main_Screen_Height)];
 
    //预览层 初始化，self.session负责驱动input进行信息的采集，layer负责把图像渲染显示
    //预览层的区域设置为整个屏幕，这样可以方便我们进行移动二维码到扫描区域,在上面我们已经对我们的扫描区域进行了相应的设置
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
    self.previewLayer.frame = CGRectMake(0, 0, ZYAppWidth, ZYAppHeight);
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:self.previewLayer];
    //扫描框 和扫描线的布局和设置，模拟正在扫描的过程，这一块加不加不影响我们的效果，只是起一个直观的作用
   // TNWCameraScanView *clearView = [[TNWCameraScanView alloc]initWithFrame:self.view.frame navH:navH];
  //  [self.view addSubview:clearView];
    int M=230;
 
    int x=(320-M)/2;
    int y=(568-M)/2;
   UIImageView * imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(LineX(x), LineY(y), LineX(M), LineY(M))];
   imageView1.image = [UIImage imageNamed:@"pick_bg.png"];
//    [self.view addSubview:imageView1];//绿色扫描框
    _overlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //   overlayButton.backgroundColor=[UIColor greenColor];
    // [overlayButton setTitle:@"返回" forState:UIControlStateNormal];
    // [overlayButton setImage:[UIImage imageNamed:@"right.png"] forState:UIControlStateNormal];
    [_overlayButton setFrame:CGRectMake(LineX( 85), LineY(430), LineX(290), LineY(60))];
    [_overlayButton addTarget:self action:@selector(backButtonPressed1) forControlEvents:UIControlEventTouchUpInside];
    _overlayButton.hidden=YES;
    [self.view addSubview:_overlayButton];
    
}
-(void) backButtonPressed1{
    WebViewController *r=[[WebViewController alloc]init];
    r.weburl=_url;
    
    [self.navigationController pushViewController: r animated:YES];
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:_url]];
    _overlayButton.hidden=YES;
    
}
- (void)configPinchGes{
    self.pinchGes = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchDetected:)];
    [self.view addGestureRecognizer:self.pinchGes];
}

- (void)pinchDetected:(UIPinchGestureRecognizer*)recogniser{
    if (!_device){
        return;
    }
    //对手势的状态进行判断
    if (recogniser.state == UIGestureRecognizerStateBegan){
        self.initScale = _device.videoZoomFactor;
        
    }
    //相机设备在改变某些参数前必须先锁定，直到改变结束才能解锁
    NSError *error = nil;
    [_device lockForConfiguration:&error]; //锁定相机设备
    if (!error) {
        CGFloat zoomFactor; //缩放因子
        CGFloat scale = recogniser.scale;
        if (scale < 1.0f) {
            zoomFactor = self.initScale - pow(self.device.activeFormat.videoMaxZoomFactor, 1.0f - recogniser.scale);
        } else {
            zoomFactor = self.initScale + pow(self.device.activeFormat.videoMaxZoomFactor, (recogniser.scale - 1.0f) / 2.0f);
        }
        zoomFactor = MIN(15.0f, zoomFactor);
        zoomFactor = MAX(1.0f, zoomFactor);
        _device.videoZoomFactor = zoomFactor;
        [_device unlockForConfiguration];
    }
}
#pragma mark - AVCaptureMetadataOutputObjectsDelegate
//后置摄像头扫描到二维码的信息
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
   // [self.session stopRunning];   //停止扫描
    if ([metadataObjects count] >= 1) {
        //数组中包含的都是AVMetadataMachineReadableCodeObject 类型的对象，该对象中包含解码后的数据
        AVMetadataMachineReadableCodeObject *qrObject = [metadataObjects lastObject];
        //拿到扫描内容在这里进行个性化处理
        NSString *QRcode = qrObject.stringValue;
        NSString *result = QRcode;
        //解析数据进行处理并实现相应的逻辑
        //代码省略
        //QRcode部分
        if(![QRcode isEqualToString:@""]){
            [self playSound];
            NSRange rangeUrl = [ QRcode rangeOfString:@"www"];
            NSRange rangeUrl0 = [ QRcode rangeOfString:@"http"];
            if( rangeUrl.location !=NSNotFound||rangeUrl0.location !=NSNotFound){
                //QRcode内容为网址
                //主线程  刷新viewcontroller显示
                //////////////以下内容用于在主界面显示检测结果
                NSRange rangeUrl2 = [ QRcode rangeOfString:@"http"];
                NSString *qrUrl=QRcode;
                if(rangeUrl2.location==NSNotFound){
                    qrUrl=[@"http://" stringByAppendingString:QRcode];
                }
                dispatch_queue_t main_que = dispatch_get_main_queue();
                dispatch_async(main_que, ^{
                    // Do some work
                    dispatch_async(main_que, ^{
                        
                        // Update the
                        UILabel* labResult1= [[UILabel alloc] initWithFrame:CGRectMake(LineX( 85), LineY(430), LineX(290), LineY(100))];
                        labResult1.backgroundColor = [UIColor blackColor];
                        labResult1.numberOfLines=0;
                        labResult1.textColor=[UIColor whiteColor];
                        labResult1.text=result;
                       [labResult1 sizeToFit];
                        [self.view addSubview:labResult1];
                        self.url=qrUrl;
                        _overlayButton.hidden=false;
                        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(timerac) userInfo:nil repeats:NO];
                        [UIView animateWithDuration:2 animations:^{labResult1.alpha = 0.0;} completion:^(BOOL finished)  {
                            [labResult1 removeFromSuperview];
                            
                        }];
                        // [NSThread sleepForTimeInterval:3.5];
                        //overlayButton.hidden=YES;
                        
                    });
                });
            }else{
                
                //QRcode内容为普通文本
                //主线程  刷新viewcontroller显示
                //////////////以下内容用于在主界面显示检测结果
                dispatch_queue_t main_que = dispatch_get_main_queue();
                dispatch_async(main_que, ^{
                    // Do some work
                    dispatch_async(main_que, ^{
                        
                        // Update the
                        UILabel* labResult1= [[UILabel alloc] initWithFrame:CGRectMake(LineX(80), LineY(430), LineX(240), LineY(120))];
                       labResult1.backgroundColor = [UIColor blackColor];
                        labResult1.numberOfLines=0;
                        labResult1.textColor=[UIColor whiteColor];
                        labResult1.text=QRcode;
                     [labResult1 sizeToFit];
                        [self.view addSubview:labResult1];
                        
                        
                        
                        [UIView animateWithDuration:2 animations:^{labResult1.alpha = 0.0;} completion:^(BOOL finished)  {
                            [labResult1 removeFromSuperview];
                            
                        }];
                        
                        
                    });
                });
            }
            
            
            
        }
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)timerac{
    _overlayButton.hidden=YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)playSound
{
    static SystemSoundID shake_sound_male_id = 0;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"183" ofType:@"wav"];
    if (path) {
        //注册声音到系统
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&shake_sound_male_id);
        AudioServicesPlaySystemSound(shake_sound_male_id);
    }
    
    AudioServicesPlaySystemSound(shake_sound_male_id);   //播放注册的声音，（此句代码，可以在本类中的任意位置调用，不限于本方法中）
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);   //让手机震动
}
@end

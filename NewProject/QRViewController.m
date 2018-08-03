
//
//  RootViewController.m
//  NewProject
//
//  Created by LU jianfeng
//  Copyright (c) 2015. All rights reserved.
//

#import "QRViewController.h"

#import "FftOpencvFun.h"
#import <AudioToolbox/AudioToolbox.h>
#import "WebViewController.h"

#define DETECT_WM_IMAGE_256

#define SUCCESS_URL_1   @"http://www.allbests.com.tw/"
#define VIDEO_WIDTH     1280
#define VIDEO_HEIGHT    720

@interface QRViewController ()

{
    char outBuf[50];  //watermark detection buffer
    
    int G_prev_width;
    int G_prev_height;
    
    float G_scale;
}

@property (strong,nonatomic) UILabel* labResult;
@property (strong,nonatomic) NSString *url;
@property (strong,nonatomic) NSTimer *timer;
@property (strong,nonatomic) UIButton *overlayButton ;
@end




@implementation QRViewController
@synthesize labResult;

#if 0
@synthesize captureManager;
#endif

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupCamera];
    
    
    UIButton *btn4 = [[UIButton alloc]init];
    btn4.frame = CGRectMake(LineX(20), LineY(20), LineX(35), LineY(35));
    // btn4.backgroundColor=[UIColor blackColor];

    //btn.backgroundColor=[UIColor blackColor];
    //  [btn setTitle:@"返回" forState:UIControlStateNormal]; // 标题
    [btn4 setBackgroundImage:[UIImage imageNamed:@"left.png"] forState:UIControlStateNormal];
    [btn4 addTarget:self action:@selector(clickBtn4) forControlEvents:UIControlEventTouchUpInside];//设置事件
    
    
    self.view.backgroundColor = [UIColor blackColor];
    UIImageView * imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(LineX(15), LineY(20), LineX(290), LineY(50))];
    imageView1.image = [UIImage imageNamed:@"協進公司標題.png"];
    [self.view addSubview:imageView1];
    UILabel * labIntroudction= [[UILabel alloc] initWithFrame:CGRectMake(LineX(15), LineY(70), LineX(290), LineY(100))] ;
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.numberOfLines=4;
    labIntroudction.textColor=[UIColor whiteColor];
    labIntroudction.text=@"此APP只能掃描我們的專屬編碼，手機請距離掃描目標7-15公分，不同手機鏡頭掃描距離不同，掃到時，下方會顯示結果";
    
    [self.view addSubview:labIntroudction];
    [self.view addSubview:btn4];
    labResult= [[UILabel alloc] initWithFrame:CGRectMake(LineX(30), LineY(430), LineX(85), LineY(40))];
    labResult.backgroundColor = [UIColor clearColor];
    labResult.numberOfLines=2;
    labResult.textColor=[UIColor blackColor];
    labResult.text=@"Result：";
    [labResult sizeToFit];
    [self.view addSubview:labResult];
    
    float xs = Main_Screen_Width  / VIDEO_HEIGHT;
    float ys = Main_Screen_Height / VIDEO_WIDTH;
    
    if (xs < ys)
        G_scale = ys;
    else
        G_scale = xs;
    
    G_prev_width  = G_IMAGE_WIDTH  * G_scale;
    G_prev_height = G_IMAGE_HEIGHT * G_scale;
    
    int left = (Main_Screen_Width  - G_prev_width) / 2;
    int top  = (Main_Screen_Height - G_prev_height) / 2;
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(left-5, top-5, G_prev_width+10, G_prev_height+10)];
    imageView.image = [UIImage imageNamed:@"pick_bg.png"];
    [self.view addSubview:imageView];
    
    //    UIButton * scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [scanButton setTitle:@"返回" forState:UIControlStateNormal];
    //    scanButton.frame = CGRectMake(100, 480, 120, 40);
    //    scanButton.backgroundColor = [UIColor lightGrayColor];
    //    [scanButton setBackgroundImage:[UIImage imageNamed:@"scanbutton.png"]
    //                          forState:UIControlStateNormal];
    
    _overlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //   overlayButton.backgroundColor=[UIColor greenColor];
    // [overlayButton setTitle:@"返回" forState:UIControlStateNormal];
    // [overlayButton setImage:[UIImage imageNamed:@"right.png"] forState:UIControlStateNormal];
    [_overlayButton setFrame:CGRectMake(LineX( 85), LineY(430), LineX(290), LineY(60))];
    [_overlayButton addTarget:self action:@selector(backButtonPressed1) forControlEvents:UIControlEventTouchUpInside];
    _overlayButton.hidden=YES;
    [self.view addSubview:_overlayButton];
    
    
    //
    //    [scanButton addTarget:self action:@selector(backButtonPressed)
    //         forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:scanButton];
    
    upOrdown = NO;
    num =0;
    
#if 0
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(50, 110, 220, 2)];
    _line.image = [UIImage imageNamed:@"line.png"];
    [self.view addSubview:_line];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    
#endif
    
    
}
-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(50, 110+2*num, 220, 2);
        if (2*num == 280) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(50, 110+2*num, 220, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
    
}

-(void)backButtonPressed
{
    
    if(self.preview) {
        [self.preview removeFromSuperlayer];
        self.preview = nil;
    }
    
    if(self.session) {
        [self.session stopRunning];
        self.session = nil;
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
#if 0
        [timer invalidate];
#endif
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    
    
    // [NSThread sleepForTimeInterval:0.5f];
}

- (void)setupCamera
{
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    //_output = [[AVCaptureMetadataOutput alloc]init];
    //[_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    _output_raw = [[AVCaptureVideoDataOutput alloc]init];
    [_output_raw setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    //[_session setSessionPreset:AVCaptureSessionPresetHigh];
    [_session setSessionPreset:AVCaptureSessionPreset1280x720];
    
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output_raw])
    {
        [_session addOutput:self.output_raw];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    //_output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
    
    //new
    // We're only interested in faces
    //[_output setMetadataObjectTypes:@[AVMetadataObjectTypeFace]];
    
    _output_raw.videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithInt:kCVPixelFormatType_32BGRA], kCVPixelBufferPixelFormatTypeKey,
                                 [NSNumber numberWithInt: 320], (id)kCVPixelBufferWidthKey,
                                 [NSNumber numberWithInt: 240], (id)kCVPixelBufferHeightKey,
                                 nil];
    
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    //_preview.frame =CGRectMake(left, top, G_IMAGE_WIDTH, G_IMAGE_HEIGHT);
    _preview.frame =CGRectMake(0,0,Main_Screen_Width,Main_Screen_Height);
    
    [self.view.layer insertSublayer:self.preview atIndex:0];
    //[self.view.layer addSublayer:self.preview];
    
    //_output_raw.minFrameDuration = CMTimeMake(1, 15);
    dispatch_queue_t queue = dispatch_queue_create("ScanQueue", NULL);
    [_output_raw setSampleBufferDelegate:self queue:queue];
    //dispatch_release(queue);
    
    // Start
    [_session startRunning];
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
/*
 - (void)captureOutput:(AVCaptureOutput *)captureOutput
 didOutputMetadataObjects:(NSArray *)metadataObjects
 fromConnection:(AVCaptureConnection *)connection
 {
 
 NSString *stringValue;
 
 if ([metadataObjects count] >0)
 {
 AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
 stringValue = metadataObject.stringValue;
 }
 
 [_session stopRunning];
 [self dismissViewControllerAnimated:YES completion:^
 {
 [timer invalidate];
 NSLog(@"%@",stringValue);
 }];
 }
 */

/*
 - (void)captureOutput:(AVCaptureOutput *)captureOutput
 didOutputMetadataObjects:(NSArray *)metadataObjects
 fromConnection:(AVCaptureConnection *)connection
 {
 for (AVMetadataObject *metadataObject in metadataObjects)
 {
 if ([metadataObject.type isEqualToString:AVMetadataObjectTypeFace])
 {
 // Take an image of the face and pass to CoreImage for detection
 AVCaptureConnection *stillConnection = [_stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
 [_stillImageOutput captureStillImageSaynchronouslyFromConnection:stillConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
 if (error) {
 NSLog(@"There was a problem");
 return;
 }
 
 NSData *jpegData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
 
 UIImage *smileImage = [UIImage imageWithData:jpegData];
 _previewLayer.hidden = YES;
 [_session stopRunning];
 self.imageView.hidden = NO;
 self.imageView.image = smileyImage;
 self.activityView.hidden = NO;
 self.statusLabel.text = @"Processing";
 self.statusLabel.hidden = NO;
 
 CIImage *image = [CIImage imageWithData:jpegData];
 [self imageContainsSmiles:image callback:^(BOOL happyFace) {
 if (happyFace) {
 self.statusLabel.text = @"Happy Face Found!";
 }else {
 self.statusLabel.text = @"Not a good photo...";
 }
 self.activityView.hidden = YES;
 self.retakeButton.hidden = NO;
 }];
 }];
 }
 }
 }
 */

// Create a UIImage from sample buffer data
- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    // Get a CMSampleBuffer's Core Video image buffer for the media data
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // Get the number of bytes per row for the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // Create a bitmap graphics context with the sample buffer data
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    // Create a Quartz image from the pixel data in the bitmap graphics context
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    // Free up the context and color space
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // Create an image object from the Quartz image
    //UIImage *image = [UIImage imageWithCGImage:quartzImage];
    UIImage *image = [UIImage imageWithCGImage:quartzImage scale:1.0f orientation:UIImageOrientationRight];
    //cameraImg_Buffer = [UIImage imageWithCGImage:quartzImage scale:1.0f orientation:UIImageOrientationRight];
    //cameraImg_Buffer = [UIUtils rotateImage:image];
    //image = nil;
    
    // Release the Quartz image
    CGImageRelease(quartzImage);
    //quartzImage = nil;
    //image = nil;
    
    //CGImageRefRelease();
    return (image);
    //return NULL;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    
    
    IplImage *_image = NULL;
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // get information of the image in the buffer
    uint8_t *bufferBaseAddress = (uint8_t *)CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0);
    size_t bufferWidth  = CVPixelBufferGetWidth(imageBuffer);
    size_t bufferHeight = CVPixelBufferGetHeight(imageBuffer);
    
    // create IplImage
    if (bufferBaseAddress)
    {
        _image = cvCreateImage(cvSize(bufferWidth, bufferHeight), IPL_DEPTH_8U, 4);
        _image->imageData = (char*)bufferBaseAddress;
    }
    // release memory
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    
    
    
    IplImage* img    = cvCreateImage(cvSize(bufferWidth, bufferHeight), IPL_DEPTH_8U, 3);
    IplImage* img512 = cvCreateImage(cvSize(G_IMAGE_WIDTH, G_IMAGE_WIDTH), IPL_DEPTH_8U, 3);
    
    //  IplImage* imgQR = cvCreateImage(cvSize(G_IMAGE_WIDTH, G_IMAGE_WIDTH), IPL_DEPTH_8U, 3);
    cvCvtColor(_image, img, CV_RGBA2BGR);
    cvReleaseImage(&_image);
    
#if 0
    UIImage* dstImg = [UIUtils UIImageFromIplImage:img];
    UIImageWriteToSavedPhotosAlbum(dstImg, nil, nil, nil);
#endif
    
#if 0
    int top   = (img->height - G_IMAGE_WIDTH/2) / 2;
    int left  = (img->width  - G_IMAGE_WIDTH/2) / 2;
#endif
    //由于采集过来的图是侧的，所以调整了height和width，如下
    //jflu,2015-4-25
    
    int top  =  VIDEO_HEIGHT / 2 - G_IMAGE_WIDTH  / 2;   //Video Width : 1280
    int left =  VIDEO_WIDTH  / 2 - G_IMAGE_HEIGHT / 2;   //Video height : 720
    
    //NSLog(@"top,left : %d %d",top,left);
    
    cvSetImageROI(img, cvRect(left,top, G_IMAGE_WIDTH, G_IMAGE_WIDTH));
    
    cvCopy(img, img512);
    //cvCopy(img, imgQR);
    //  cvTranspose(imgQR, imgQR);
    cvTranspose(img512, img512);
    cvFlip(img512, img512, 1);
    //  cvFlip(imgQR,imgQR,1);
    
#if 0
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if ([[UIScreen mainScreen] respondsToSelector: @selector(scale)])
        {
            CGSize result = [[UIScreen mainScreen] bounds].size;
            result = CGSizeMake(result.width * [UIScreen mainScreen].scale,
                                result.height * [UIScreen mainScreen].scale);
            return (result.height == 960 ? UIDevice_iPhoneHiRes : UIDevice_iPhoneTallerHiRes);
        } else
            return UIDevice_iPhoneStandardRes;
    } else
        return (([[UIScreen mainScreen] respondsToSelector: @selector(scale)]) ? UIDevice_iPadHiRes : UIDevice_iPadStandardRes);
#endif
    
    memset(outBuf, '0', 50);
    //[NSThread sleepForTimeInterval:0.2f];
    bool ret=false;
    UIImage *QRimg=[self convertToUIImage:img512];
    NSString*QRcode= [self scanqrcode:QRimg];
    // NSLog(@"%@", QRcode);
    if(![QRcode isEqualToString:@""]){
        NSLog(@"%@", QRcode);
    }
    
   
    
    //QRcode部分
    if(![QRcode isEqualToString:@""]){
        [self playSound];
        NSRange rangeUrl = [ QRcode rangeOfString:@"http"];
        if( rangeUrl.location !=NSNotFound){
            //QRcode内容为网址
            //主线程  刷新viewcontroller显示
            //////////////以下内容用于在主界面显示检测结果
            dispatch_queue_t main_que = dispatch_get_main_queue();
            dispatch_async(main_que, ^{
                // Do some work
                dispatch_async(main_que, ^{
                    
                    // Update the
                    UILabel* labResult1= [[UILabel alloc] initWithFrame:CGRectMake(LineX( 85), LineY(430), LineX(290), LineY(50))];
                    labResult1.backgroundColor = [UIColor blackColor];
                    labResult1.numberOfLines=2;
                    labResult1.textColor=[UIColor whiteColor];
                    labResult1.text=QRcode;
                    [labResult1 sizeToFit];
                    [self.view addSubview:labResult1];
                    self.url=QRcode;
                    _overlayButton.hidden=false;
                    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(timerac) userInfo:nil repeats:NO];
                    [UIView animateWithDuration:5 animations:^{labResult1.alpha = 0.0;} completion:^(BOOL finished)  {
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
                    UILabel* labResult1= [[UILabel alloc] initWithFrame:CGRectMake(LineX( 85), LineY(430), LineX(290), LineY(50))];
                    labResult1.backgroundColor = [UIColor blackColor];
                    labResult1.numberOfLines=2;
                    labResult1.textColor=[UIColor whiteColor];
                    labResult1.text=QRcode;
                    [labResult1 sizeToFit];
                    [self.view addSubview:labResult1];
                    
                    
                    
                    [UIView animateWithDuration:3 animations:^{labResult1.alpha = 0.0;} completion:^(BOOL finished)  {
                        [labResult1 removeFromSuperview];
                        
                    }];
                    
                    
                });
            });
        }
        
        
        
    }
    
  
    
#if 0
    UIImage* dstImg = [UIUtils UIImageFromIplImage:img512];
    UIImageWriteToSavedPhotosAlbum(dstImg, nil, nil, nil);
    dstImg = nil;
#endif
    
    
    cvReleaseImage(&img);
    img    = NULL;
    //cvReleaseImage(&img512);
    img512 = NULL;
    
    
}
-(void) backButtonPressed1{
    WebViewController *r=[[WebViewController alloc]init];
    r.weburl=_url;
    
    [self.navigationController pushViewController: r animated:YES];
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:_url]];
    _overlayButton.hidden=YES;
    
}
- (void)timerac{
    _overlayButton.hidden=YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)playSound
{
    static SystemSoundID shake_sound_male_id = 0;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"connected" ofType:@"mp3"];
    if (path) {
        //注册声音到系统
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&shake_sound_male_id);
        AudioServicesPlaySystemSound(shake_sound_male_id);
    }
    
    AudioServicesPlaySystemSound(shake_sound_male_id);   //播放注册的声音，（此句代码，可以在本类中的任意位置调用，不限于本方法中）
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);   //让手机震动
}


-(NSString *)getdatafromlist:(NSString*)key{
    NSString *plistpath=[[NSBundle mainBundle]pathForResource:@"ResultList" ofType:@"plist"];
    
    NSMutableDictionary *dataDic=[[NSMutableDictionary alloc]initWithContentsOfFile:plistpath];
    NSString *str=[dataDic objectForKey:key];
    return str;
    
}
-(void)clickBtn4{
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSString*)scanqrcode:(UIImage *)image{
    
    // CIDetector(CIDetector可用于人脸识别)进行图片解析，从而使我们可以便捷的从相册中获取到二维码
    // 声明一个 CIDetector，并设定识别类型 CIDetectorTypeQRCode
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy: CIDetectorAccuracyHigh}];
  
    // 取得识别结果
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    NSString *resultStr=@"";
    for (int index = 0; index < [features count]; index ++) {
        CIQRCodeFeature *feature = [features objectAtIndex:index];
        resultStr = feature.messageString;
        
        // NSLog(@"%@",resultStr);
    }
    
    return resultStr;
}
-(UIImage*)convertToUIImage:(IplImage*)image
{
    cvCvtColor(image, image, CV_BGR2RGB);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSData *data = [NSData dataWithBytes:image->imageData length:image->imageSize];
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)data);
    CGImageRef imageRef = CGImageCreate(image->width, image->height, image->depth, image->depth * image->nChannels, image->widthStep, colorSpace, kCGImageAlphaNone | kCGBitmapByteOrderDefault, provider, NULL, false, kCGRenderingIntentDefault);
    UIImage *ret = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    cvReleaseImage(&image);
    image=NULL;
    return ret;
}

@end



//
//  AppDelegate.m
//  NewProject
//


#import "AppDelegate.h"
#import "RootViewController.h"

#import"startViewController.h"
#import"CJScanQRCodeViewController.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
 
        
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        // Override point for customization after application launch.
        
        startViewController  * rt = [[ startViewController alloc]init];
        UINavigationController *navigation=[[UINavigationController alloc]initWithRootViewController:rt];
        self.window.rootViewController=navigation;
        navigation.navigationBarHidden=YES;
        [self.window makeKeyAndVisible];
        
        // [self setup3DTouch:application];
        
    
    return YES;
}
- (void)setup3DTouch:(UIApplication *)application
{
    /**
     type 该item 唯一标识符
     localizedTitle ：标题
     localizedSubtitle：副标题
     icon：icon图标 可以使用系统类型 也可以使用自定义的图片
     userInfo：用户信息字典 自定义参数，完成具体功能需求
     */
    //    UIApplicationShortcutIcon *icon1 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"标签.png"];
    UIApplicationShortcutIcon *icon1 = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeSearch];
    // UIApplicationShortcutIcon *icon1 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"pic"];
    
    
    NSString *nslabtmp = NSLocalizedString(@"detectwa",@"");
    
    
    UIApplicationShortcutItem *cameraItem = [[UIApplicationShortcutItem alloc] initWithType:@"ONE" localizedTitle:nslabtmp localizedSubtitle:@"" icon:icon1 userInfo:nil];
    
    UIApplicationShortcutIcon *icon2 = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeContact];
    // UIApplicationShortcutIcon *icon1 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"pic"];
    
    
    NSString *nslabtmp2 = NSLocalizedString(@"contact",@"");
    
    
    UIApplicationShortcutItem *cameraItem2 = [[UIApplicationShortcutItem alloc] initWithType:@"TWO" localizedTitle:nslabtmp2 localizedSubtitle:@"" icon:icon2 userInfo:nil];
    
    /** 将items 添加到app图标 */
    application.shortcutItems = @[cameraItem,cameraItem2];
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end


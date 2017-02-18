//
//  NGAppDelegate.m
//  OilWearCounter
//
//  Created by Tony Zhao on 5/3/15.
//  Copyright (c) 2015 Tony Zhao. All rights reserved.
//

#import "NGAppDelegate.h"
#import "NGViewController.h"
#import "SMS_SDK/SMS_SDK.h"
#import "RZTransitionsNavigationController.h"

@implementation NGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NGViewController * ngViewController = [[NGViewController alloc] init];
    RZTransitionsNavigationController * navigationController= [[RZTransitionsNavigationController alloc] initWithRootViewController:ngViewController];
    
    self.window.rootViewController = navigationController;
    

    [SMS_SDK registerApp:@"6941d7e2854c" withSecret:@"63319b569756bf92411cdad492fdc665"];
    
    //Baidu Map
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8) {
        //由于IOS8中定位的授权机制改变 需要进行手动授权
        CLLocationManager  *locationManager = [[CLLocationManager alloc] init];
        //获取授权认证
        [locationManager requestAlwaysAuthorization];
        [locationManager requestWhenInUseAuthorization];
    }
    
    self.mapManager = [[BMKMapManager alloc] init];
    BOOL ret = [_mapManager start:@"orAEPonN1Fi6hH4W7m1cZYAS" generalDelegate:self];
    
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    //数据库操作
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *databasePath = [documentsPath stringByAppendingPathComponent:@"counter.db"];
    if (![fileManager fileExistsAtPath:databasePath])
    {
        NSString *bundleDatabasePath = [[NSBundle mainBundle] pathForResource:@"counter" ofType:@"db"];
        NSLog(@"%@",bundleDatabasePath);
        [fileManager copyItemAtPath:bundleDatabasePath toPath:databasePath error:nil];
    }
    
    return YES;
}

- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
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

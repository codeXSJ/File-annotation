//
//  AppDelegate.m
//  Annotation
//
//  Created by 许公子 on 2020/7/23.
//  Copyright © 2020 ppt. All rights reserved.
//

#import "AppDelegate.h"
#import "StartViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    UINavigationController *nvc =[[UINavigationController alloc]initWithRootViewController:[[StartViewController alloc] init]];
    self.window.rootViewController = nvc;
    return YES;
}




@end

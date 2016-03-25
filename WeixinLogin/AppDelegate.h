//
//  AppDelegate.h
//  WeixinLogin
//
//  Created by huanghy on 16/3/24.
//  Copyright © 2016年 huanghy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, copy)void (^getCodeBlock )(NSString *WXCode);

@end


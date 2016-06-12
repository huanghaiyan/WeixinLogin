//
//  ViewController.m
//  WeixinLogin
//
//  Created by huanghy on 16/3/24.
//  Copyright © 2016年 huanghy. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "WXApi.h"

#define kWXAPP_ID       @"wx5fd7bd08928b91a8"
#define kWXAPP_SECRET   @"87378fa8e806f3ea8706e812cf773b70"
@interface ViewController ()
{
    NSDictionary *dic;
}

@end

@implementation ViewController

static NSString *kLinkURL = @"http://tech.qq.com/zt2012/tmtdecode/252.htm";
static NSString *kLinkTagName = @"WECHAT_TAG_JUMP_SHOWRANK";
static NSString *kLinkTitle = @"专访张小龙：产品之上的世界观";
static NSString *kLinkDescription = @"微信的平台化发展方向是否真的会让这个原本简洁的产品变得臃肿？在国际化发展方向上，微信面临的问题真的是文化差异壁垒吗？腾讯高级副总裁、微信产品负责人张小龙给出了自己的回复。";





- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)loginWeixin:(id)sender {
    
    if ([WXApi isWXAppInstalled]) {//检查微信是否已被用户安装微信,已安装返回YES,未安装返回NO
        //构造SendAuthReq结构体
        
        SendAuthReq *req = [[SendAuthReq alloc] init];
        
        req.scope = @"snsapi_userinfo,snsapi_base";
        
        req.state = @"123";
        
        //第三方向微信终端发送一个SendAuthReq消息结构
        
        [WXApi sendReq:req];
        
        AppDelegate* delegate = (AppDelegate* )[UIApplication sharedApplication].delegate;
        delegate.getCodeBlock = ^(NSString *WXCode){
            [self getAccess_token:WXCode];
        };
    }else{
        NSLog(@"没有安装微信");
    }
}
#pragma mark - 获取access_token授权
-(void)getAccess_token:(NSString *)wxCode

{
    
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",kWXAPP_ID,kWXAPP_SECRET,wxCode];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSURL *zoneUrl = [NSURL URLWithString:url];
        
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (data) {
                
                dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"%@",dic);
                /*
                 
                 {
                 
                 "access_token" = "OezXcEiiBSKSxW0eoylIeJDUKD6z6dmr42JANLPjNN7Kaf3e4GZ2OncrCfiKnGWiusJMZwzQU8kXcnT1hNs_ykAFDfDEuNp6waj-bDdepEzooL_k1vb7EQzhP8plTbD0AgR8zCRi1It3eNS7yRyd5A";
                 
                 "expires_in" = 7200;
                 
                 openid = oyAaTjsDx7pl4Q42O3sDzDtA7gZs;
                 
                 "refresh_token" = "OezXcEiiBSKSxW0eoylIeJDUKD6z6dmr42JANLPjNN7Kaf3e4GZ2OncrCfiKnGWi2ZzH_XfVVxZbmha9oSFnKAhFsS0iyARkXCa7zPu4MqVRdwyb8J16V8cWw7oNIff0l-5F-4-GJwD8MopmjHXKiA";
                 
                 scope = "snsapi_userinfo,snsapi_base";
                 
                 }
                 
                 */
                
                // self.access_token.text = [dic objectForKey:@"access_token"];
                
                //self.openid.text = [dic objectForKey:@"openid"];
                [self getUserInfo];
            }
            
        });
        
    });
    
}
#pragma mark - 获取微信用户信息
-(void)getUserInfo

{
    
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",[dic objectForKey:@"access_token"],[dic objectForKey:@"openid"]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSURL *zoneUrl = [NSURL URLWithString:url];
        
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (data) {
                
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"%@",dict);
                /*
                 {
                 city = East;
                 country = CN;
                 headimgurl = "http://wx.qlogo.cn/mmopen/ZoB5P44qP04JsANhILvsMaaRwArQCyCM8gSNKiayKpMHOEJUrEiauhBed9Noicr171UvM0DlI5lyaA2TyyX48pnbOOH1Hcy0pjI/0";
                 language = "zh_CN";
                 nickname = "\U9ec4\U6d77\U71d5";
                 openid = "on93ejp57V17O9asjN8zXWcuo2_g";
                 privilege =     (
                 );
                 province = Beijing;
                 sex = 2;
                 unionid = oZ824s15eXTor1o2MTTgZD6SFjPk;
                 }

                 */
                
                [self postWXLogin:dict];//根据服务器接口，把获得的微信用户的信息，看服务器需要什么参数就传什么参数
                
            }
            
        });
        
    });
    
}

-(void)postWXLogin:(NSDictionary *)dictionary
{
    NSLog(@"%@",dictionary);

}
- (IBAction)wxShare:(id)sender {
    //创建发送对象实例
    SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
    sendReq.bText = NO;//不使用文本信息
    sendReq.scene = 1;//0 = 好友列表 1 = 朋友圈 2 = 收藏
    
    //创建分享内容对象
    WXMediaMessage *urlMessage = [WXMediaMessage message];
    urlMessage.title = kLinkTitle;//分享标题
    urlMessage.description = kLinkDescription;//分享描述
    [urlMessage setThumbImage:[UIImage imageNamed:@"testImg"]];//分享图片,使用SDK的setThumbImage方法可压缩图片大小
    
    //创建多媒体对象
    WXWebpageObject *webObj = [WXWebpageObject object];
    webObj.webpageUrl = kLinkURL;//分享链接
    
    //完成发送对象实例
    urlMessage.mediaObject = webObj;
    sendReq.message = urlMessage;
    
    //发送分享信息
    [WXApi sendReq:sendReq];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

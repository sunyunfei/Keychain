//
//  ViewController.m
//  Keychain存储数据
//
//  Created by 孙云 on 16/8/2.
//  Copyright © 2016年 haidai. All rights reserved.
//

#import "ViewController.h"
#import "WQUserDataManager.h"
#import "WQKeyChain.h"
#import "SYFKeyChain.h"
#import "SYFManagerKeyChain.h"
static NSString * const KEY_IN_KEYCHAIN = @"com.wuqian.app.allinfo";
static NSString * const KEY_PASSWORD = @"com.wuqian.app.password";
@interface ViewController ()
- (IBAction)clickBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *filed;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    [userDefault setObject:@"123456@qq.com" forKey:@"Account"];
//    [userDefault setObject:@"123456" forKey:@"Password"];
//    [userDefault synchronize];
//    NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents"];
//    NSLog(@"APP_Path = %@", path);
    //判断是否已有这个密码
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0];

}

- (void)loadData{

    NSString *str = [SYFManagerKeyChain queryDataToKeyChain:KEY_PASSWORD];
    NSLog(@"%@",str);
    if([SYFManagerKeyChain queryDataToKeyChain:KEY_PASSWORD]){
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"已有这个app帐号，是否直接显示" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okact = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            self.label.text = [SYFManagerKeyChain queryDataToKeyChain:KEY_PASSWORD];
        }];
        
        [alert addAction:okact];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
- (IBAction)clickBtn:(id)sender {
    
    [SYFManagerKeyChain addDataToKeyChain:KEY_PASSWORD dataString:self.filed.text];
    
    self.label.text = [SYFManagerKeyChain queryDataToKeyChain:KEY_PASSWORD];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.view endEditing:YES];
}
@end

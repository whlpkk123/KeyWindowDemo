//
//  YZKViewController.m
//  UIDemo
//
//  Created by YZK on 2023/1/11.
//

#import "YZKViewController.h"

@interface YZKViewController ()

@end

@implementation YZKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor cyanColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 30, 100, 30);
    [button setTitle:@"button2" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
}

- (void)btnClick {
    // 在YZKWindow中，重写canBecomeKeyWindow为NO，可以看到不会影响window上的触摸事件
    NSLog(@"4 %@", [UIApplication sharedApplication].keyWindow);
    NSLog(@"5 %@", [UIApplication sharedApplication].windows);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"6 %@", [UIApplication sharedApplication].keyWindow);
    });
    
    YZKViewController *vc = [[YZKViewController alloc] init];
    // 使用keyWindow.rootViewController是有问题的
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:YES completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [vc dismissViewControllerAnimated:YES completion:nil];
        });
    }];
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

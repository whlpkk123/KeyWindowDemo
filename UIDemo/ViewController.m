//
//  ViewController.m
//  UIDemo
//
//  Created by bytedance on 2022/7/19.
//

#import "ViewController.h"
#import "YZKWindow.h"

@interface ViewController ()
@property (nonatomic, strong) UIWindow *window2;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
}

- (IBAction)dsfsdf:(id)sender {
    NSLog(@"1 %@", [UIApplication sharedApplication].windows);
    UIWindow *window = [[YZKWindow alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    NSLog(@"2 %@", [UIApplication sharedApplication].windows);
    window.backgroundColor = [UIColor brownColor];
    window.windowLevel = 100;
    window.hidden = NO;
    self.window2 = window;
    NSLog(@"3 %@", [UIApplication sharedApplication].keyWindow);

    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, 100, 30);
    [button setTitle:@"button" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [window addSubview:button];
}

- (void)btnClick {
    NSLog(@"4 %@", [UIApplication sharedApplication].keyWindow);
    NSLog(@"5 %@", [UIApplication sharedApplication].windows);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"6 %@", [UIApplication sharedApplication].keyWindow);
    });
}

@end

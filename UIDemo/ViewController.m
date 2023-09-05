//
//  ViewController.m
//  UIDemo
//
//  Created by YZK on 2022/7/19.
//

#import "ViewController.h"
#import "YZKWindow.h"
#import "YZKViewController.h"

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
    
    window.rootViewController = [YZKViewController new];
}

@end

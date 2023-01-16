# iOS KeyWindow详解

### 概述

iOS 中的 KeyWindow，很多做iOS开发的小伙伴一定都知道这个属性，但是能彻底讲清楚它的，却是凤毛麟角，今天笔者带大家一起解开这层面纱。

附上下文所用的[Demo Github链接](https://github.com/whlpkk/KeyWindowDemo)

### KeyWindow是什么？

[苹果官方文档《Multiple Display Programming Guide for iOS》](https://developer.apple.com/library/archive/documentation/WindowsViews/Conceptual/WindowAndScreenGuide/WindowScreenRolesinApp/WindowScreenRolesinApp.html)中是这样解释的

> A window is considered the key window when it is currently receiving keyboard and non touch-related events. Whereas touch events are delivered to the window in which the touch occurred, events that don’t have an associated coordinate value are delivered to the key window. Only one window at a time can be key.
>
> Most of the time, the app window becomes the key window. Because iOS uses separate windows to display alert views and input accessory views, these windows can also become key. For example, when an alert or input accessory view has a text field in which the user is currently typing, the window that contains the input view is key.

翻译过来如下：

当一个窗口目前正在接收键盘和非触摸相关的事件时，它被认为是`KeyWindow`。触摸事件被传递到发生触摸的窗口，而没有相关坐标值的事件被传递到`KeyWindow`。一次只能有一个窗口是`KeyWindow`。

大多数情况下，应用程序窗口会成为关键窗口。因为iOS使用单独的窗口来显示警报视图和输入附件视图，这些窗口也可以成为关键。例如，当警报或输入附件视图有一个用户目前正在输入的文本字段时，包含输入视图的窗口就是关键。

### KeyWindow 和 普通Window的区别

普通Window也是可以正常响应触摸事件的，但是不可以响应非触摸事件。这里的非触摸事件，包含：摇晃等运动传感器产生的事件、远程控制（AirPlay投射，耳机线控，车载系统显示）等事件。

我们可以简单的写几行代码，测试一下摇一摇功能。

```objective-c
@interface YZKWindow : UIWindow
@end

@implementation YZKWindow
  
// 新建一个Window类,重写UIResponder的方法，接收摇晃事件
- (void)motionBegan:(UIEventSubtype)motion withEvent:(nullable UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake)
    {
        NSLog(@"摇一摇");
    }
}
@end
  
// 另一个controller的一个点击事件
- (void)btnclick {
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
    [button addTarget:self action:@selector(btn2Click) forControlEvents:UIControlEventTouchUpInside];
    [window addSubview:button];
}
```

如上述代码所示，我们创建了一个YZKWindow的实例，并且没有 `makeKeyAndVisible`。但是我们依然可以在界面上看到我们的Window显示，此时我们摇一摇手机，我们可以看到，并没有打印“摇一摇”的log。

这是因为此时的KeyWindow是我们应用的主Window，即appdelegate.window（iOS13往后sceneDelegate.window类似）。此时的摇晃事件，会从Application传递给当前的KeyWindow。由于UIWindow也继承自UIResponder，这个事件会根据事件的传递链以及响应链去查找对应的响应者。显然我们的YZKWindow不在链条中，所以不会触发事件。

这里我们在YZKWindow上，放置了一个Button，我们测试发现，Button是可以被正常点击响应的。即非KeyWindow是可以响应触摸事件的。

### KeyWindow 是哪个？

上文的Demo，如果我们在YZKWindow的Button点击事件中，打印当前的KeyWindow，可以发现，当前的YZKWindow变成了KeyWindow。

这说明了系统会在Button点击时自动帮我们切换KeyWindow。

同理，当我们使用UIAlertController（带TextField）或弹出键盘（带AccessoryView）的时候，系统都有可能会切换KeyWindow。

### Normal Window的展示

很多开发的小伙伴，在创建完Window后，会认为只有调用 `makeKeyAndVisible` 才能展示出Window，这其实是错误的。

事实上，当我们创建完成一个Window后，通过 `[UIApplication sharedApplication].windows` 方法，我们可以看到，其实已经添加到我们的Application上了。这里我们仅需简单的设置 `window.hidden = NO`，就可以让Window展示。

需要注意， `[UIApplication sharedApplication].windows` 数组并不会强引用Window，如果不将Window的实例强引用保存起来，它会很快释放，导致页面不能展示对应的window实例。

`makeKeyAndVisible` 实际上做的事情，也就是调用了 `makeKeyWindow` 和 `window.hidden = NO` 两件事。 

综上所述，如果小伙伴需要做一个显示在页面最上方的Window（eg:悬浮球，直播小窗），推荐直接设置 `hidden` 即可，没必要修改KeyWindow，可能会导致应用主Window相关非触摸事件不响应。

Window展示的逻辑，与是否是KeyWindow无关，与 `hidden` 及 `windowLevel` 有关。

iOS13往后sceneDelegate.window类似，这里就不细讲。

### PresentViewController

项目在开发过程中，经常会遇到需要PresentViewController的情况。如果是在一个UI组件中，可以快速便捷的直接在UI组件所在的Controller上Present。如果是在一段业务逻辑代码中，这个时候，我们一般有如下两种方式获取Controller（iOS13sceneDelegate类似）。

1. `[UIApplication sharedApplication].delegate.window`

2. `[UIApplication sharedApplication].keyWindow`

上文我们已经讲过，KeyWindow是会被系统修改的，所以不一定是应用的主Window，所以使用第二种方式去present，可能会导致UI异常，推荐使用第一种方式去获取Window。
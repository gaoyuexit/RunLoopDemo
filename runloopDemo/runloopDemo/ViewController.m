//
//  ViewController.m
//  runloopDemo
//
//  Created by 郜宇 on 16/6/19.
//  Copyright © 2016年 郜宇. All rights reserved.
//

#import "ViewController.h"
#import "GYThread.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    /**
     *  应用场景:
     *  1. imageView
     *  2. 常驻线程(一直在内存中的子线程): 例如:想创建一个子线程,一直在后台监控用户的一些行为,所以我们需要创建的这个线程一直不能死
     *  3. 给子线程添加NSTimer
     */
    
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(threadAddTimer) object:nil];
    [thread start];
    
    [self performSelector:@selector(run) onThread:thread withObject:nil waitUntilDone:NO];
    
}

// 给子线程添加NSTimer
- (void)threadAddTimer
{
    @autoreleasepool {
        // 方法一:
        
        NSTimer *timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(addTimer) userInfo:nil repeats:YES];
        // 添加到当前线程中(子线程)
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        
        // 当前的runloop中有timer了, 所以这个子线程的runloop可以常驻了,不会退出了
        [[NSRunLoop currentRunLoop] run];
        
        
        // 方法二:
        // 这个方法说明NSTimer加入到当前的runloop中的NSDefaultRunLoopMode的模式中,所以再加上一句runloop启动就和上面的方法一样了
        //    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(addTimer) userInfo:nil repeats:YES];
        //    [[NSRunLoop currentRunLoop] run];
    }
    
}

- (void)addTimer
{
    NSLog(@"----这是子线程的定时器----");
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [self showImgView];
    
    GYThread *thread = [[GYThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    
    [thread start];
    
}

- (void)run
{
    
    /***************************************************/
    /*                 正确的常驻方式                    */
    /***************************************************/

    NSLog(@"----执行任务run----");
    
    // 创建RunLoop,并让runloop常驻
    // 给runloop添加source或timer,才可以让线程常驻
    // 添加port就相当于添加source,事件
    
    [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
    
    [[NSRunLoop currentRunLoop] run];
    
    // 这句打印就不会执行了
    NSLog(@"----任务结束run----");
    
    /* 应用场景:
     一直在后台检测用户的行为,扫描用户的操作,检查操作,更新操作,检查联网状态
    */
    
    // 如果想退出runloop, 只要关闭这条线程,或者让runloop中没有port,source
    // 方式一:
    [NSThread exit];
    // 方式二:
    [[NSRunLoop currentRunLoop] removePort:[NSPort port] forMode:NSDefaultRunLoopMode];
    
    
    /***************************************************/
    /*          奇葩的常驻方式(不推荐)                    */
    /***************************************************/
    
    int flag = 1;
    while (flag) {
        [[NSRunLoop currentRunLoop] run];
    }
    /**
    缺点: 上面的代码会一直打印----runloop退出----,说明子线程的runloop一直进入,然后退出,再进入再退出, 因为这个runloop中没有timer,source,observe的其中任何一个, 只有点击了给他下达了任务,才会给它一个事件(source),这时候, 就不会一直打印----runloop退出----了, 这时候相当于给这个runloop,添加了source,所以这个runloop会进入循环, 就不会停止了,不会退出了
     */
    
    
}









- (void)showInfo
{
    // 如果不传模式,不传时间,默认为NSDefaultRunLoopMode,过期时间为distantFuture(遥远的未来,不过期)
    // 这样runloop跑起来会立刻退出,因为runloop中没有source,timer,observe
    [[NSRunLoop currentRunLoop] run];
    
    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantFuture]];
}



- (void)showImgView
{
    // 只在NSDefaultRunLoopMode模式下显示图片
    [self.imgView performSelector:@selector(setImage:) withObject:[UIImage imageNamed:@"123"] afterDelay:2.0 inModes:@[NSDefaultRunLoopMode]];

    // 回到主线程也可以选择mode
//    [self performSelector:<#(nonnull SEL)#> onThread:<#(nonnull NSThread *)#> withObject:<#(nullable id)#> waitUntilDone:<#(BOOL)#> modes:<#(nullable NSArray<NSString *> *)#>
}


@end

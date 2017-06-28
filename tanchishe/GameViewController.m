//
//  GameViewController.m
//  tanchishe
//
//  Created by zhaoml on 2017/6/23.
//  Copyright © 2017年 赵明亮. All rights reserved.
//

#define EWidth  20
#define Color   [UIColor colorWithRed:(arc4random()%255)/255.0 green:(arc4random()%255)/255.0 blue:(arc4random()%255)/255.0 alpha:1]

typedef enum {
    left = 0,
    up = 1,
    under = 2,
    right = 3,
}direction;

#import "GameViewController.h"
#import "StopView.h"
@interface GameViewController ()<StopViewDelegate>

@property (nonatomic,assign)direction fangxiang;

@property (nonatomic,strong)NSMutableArray *bodyArr;
@property (nonatomic,strong)NSMutableArray *positionArr;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic,assign) int  HNumber;
@property (nonatomic,assign) int  SNumber;

@property (nonatomic, strong) UIView *circleView;

@property (nonatomic,strong)UIView  *groundView;

@property (nonatomic,strong)UITapGestureRecognizer *tap;

@property (nonatomic, strong) StopView *stopV;
@end

@interface GameViewController ()

@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    _fangxiang = right;
    [self loadData];
    // Do any additional setup after loading the view.
}

- (StopView *)stopV {
    if (!_stopV) {
        _stopV = [[StopView alloc] initWithFrame:CGRectZero];
        _stopV.delegate = self;
    }
    return _stopV;
}

- (NSTimer *)timer {
    
    if (!_timer) {
        CGFloat time = 0;
        switch (_nadu) {
            case 1:
            {
                time = 0.09;
            }
                break;
            case 2:
            {
                time = 0.2;
            }
                break;

            case 3:
            {
                time = 0.5;
            }
                break;

                
            default:
                break;
        }

        _timer = [NSTimer timerWithTimeInterval:time target:self selector:@selector(timeFire) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
        [_timer fire];
    }
    return _timer;
}
- (void)loadData {
    
    int width = SCREEN_WIDTH;
    int height = SCREEN_HEIGHT - 60;
    
    _HNumber = width/EWidth;
    _SNumber = height/EWidth;
    
    [self creatUI];
}

- (UITapGestureRecognizer *)tap {
    if (!_tap) {
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [self.view addGestureRecognizer:_tap];
    }
    return _tap;
}
- (void)refreshStart {
    _fangxiang = right;
    _bodyArr = [NSMutableArray array];
    _positionArr = [NSMutableArray array];
    
    for(int i=0;i<2;i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(EWidth * (1-i), 0, EWidth, EWidth)];
        view.frame = CGRectMake(EWidth * i, 0, EWidth, EWidth);
        view.backgroundColor = Color;
        [_groundView addSubview:view];
        
        NSDictionary *dict = @{@"x":[NSString stringWithFormat:@"%f",view.frame.origin.x],@"y":[NSString stringWithFormat:@"%f",view.frame.origin.y]};
        [_positionArr addObject:dict];
        [_bodyArr addObject:view];
    }
    
    int startX = arc4random()%_HNumber *EWidth;
    int startY = arc4random()%_HNumber *EWidth;
    _circleView = [[UIView alloc] initWithFrame:CGRectMake(startX, startY, EWidth, EWidth)];
    _circleView.backgroundColor = Color;
    [_groundView addSubview:_circleView];
    [self turnCircleFrame:self.circleView.frame.origin];
    
    
    [self.timer setFireDate:[NSDate date]];

}

- (void)creatButton {
    NSArray *arr = @[@"上",@"左",@"右",@"下"];
    CGFloat buttonHeight = (SCREEN_HEIGHT - _SNumber * EWidth - 20 -40)/3;
    CGFloat buttonWidth = SCREEN_WIDTH/3;
    for (int i=0; i<4; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:arr[i] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.layer.cornerRadius = buttonHeight/2;
        button.layer.masksToBounds = YES;
        button.tag = 3000+i;
        if (i==0) {
            button.frame = CGRectMake(buttonWidth, 20+ _SNumber * EWidth, buttonWidth, buttonHeight);
        }else if (i==1) {
            button.frame = CGRectMake(0, 20+ _SNumber * EWidth + buttonHeight, buttonWidth, buttonHeight);
        }else if (i==2) {
            button.frame = CGRectMake(buttonWidth*2, 20+ _SNumber * EWidth + buttonHeight, buttonWidth, buttonHeight);
        }else if (i==3) {
            button.frame = CGRectMake(buttonWidth, 20+ _SNumber * EWidth+buttonHeight *2, buttonWidth, buttonHeight);
        }
        [button addTarget:self action:@selector(turnBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
}

- (void)creatUI {
    if (self.type == 0) {
        [self.view addGestureRecognizer:self.tap];
    }else{
        _SNumber = _HNumber;
        [self creatButton];
        
    }
    
    NSArray *array = @[@"返回",@"暂停",@"开始"];
    for (int i=0; i<array.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:array[i] forState:UIControlStateNormal];
        button.frame = CGRectMake(SCREEN_WIDTH/3 * i, SCREEN_HEIGHT - 40, SCREEN_WIDTH/3, 40);
        button.backgroundColor = [UIColor blackColor];
        button.tag = 4000+i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
    
    _groundView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, _HNumber * EWidth, _SNumber * EWidth)];
    _groundView.layer.borderColor = [UIColor blackColor].CGColor;
    _groundView.backgroundColor = [UIColor whiteColor];
    _groundView.clipsToBounds = YES;
    _groundView.center = CGPointMake(SCREEN_WIDTH/2,20 + _groundView.frame.size.height/2);
    _groundView.layer.borderWidth = 0.5;
    [self.view addSubview:_groundView];
    
    [self refreshStart];
}


- (void)timeFire {
    
    for (int i=(int)_bodyArr.count-1; i>=0; i--) {
        UIView *view = _bodyArr[i];
        if (i==0) {
            switch (_fangxiang) {
                case left:
                {
                    view.frame = CGRectMake(view.frame.origin.x - EWidth, view.frame.origin.y, EWidth, EWidth);
                }
                    break;
                case right:
                {
                    view.frame = CGRectMake(view.frame.origin.x+ EWidth, view.frame.origin.y, EWidth, EWidth);
                }
                    break;
                case up:
                {
                    view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y-EWidth, EWidth, EWidth);
                }
                    break;
                case under:
                {
                    view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y+EWidth, EWidth, EWidth);
                }
                    break;
                    
                default:
                    break;
            }
        }else{
            UIView *view1 = _bodyArr[i-1];
            view.frame = view1.frame;
        }
        NSDictionary *dict = @{@"x":[NSString stringWithFormat:@"%f",view.frame.origin.x],@"y":[NSString stringWithFormat:@"%f",view.frame.origin.y]};
        [_positionArr replaceObjectAtIndex:i withObject:dict];
    }
    if ([self adjustZhuangshang]) {
         [_timer setFireDate:[NSDate distantFuture]];
        NSString *str = [NSString stringWithFormat:@"你被撞死了\n得分：%lu",(unsigned long)_bodyArr.count-2];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒通知" message:str preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            self.stopV.title = @"重新开始吧!!!";
            self.stopV.ifStart = YES;
            [self.stopV show];
        }];
        [alert addAction:cancelAction];
        
        
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"在来一次" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            for (UIView *view in _groundView.subviews) {
                [view removeFromSuperview];
            }
            [self refreshStart];
        }];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else{
        [self adjustChi];
    }
}

- (BOOL)adjustZhuangshang{
    for (int i=0; i<_positionArr.count; i++) {
        NSDictionary *dict = _positionArr[i];
        UIView *view = _bodyArr[i];
        for (int j=i; j<_positionArr.count; j++) {
            NSDictionary *dict1 = _positionArr[j];
            UIView *view1 = _bodyArr[j];
            if ([dict1[@"x"] floatValue]< 0 || [dict1[@"x"] floatValue]+EWidth>_groundView.frame.size.width || [dict1[@"y"] floatValue]< 0 || [dict1[@"y"] floatValue]+EWidth>_groundView.frame.size.height) {
                return YES;
            }
            if ([dict isEqual:dict1] && ![view isEqual:view1]) {
                return YES;
            }
        }
    }
    return NO;
}

- (void)adjustChi{
    for (int i=0; i<_positionArr.count; i++) {
        NSDictionary *dict = _positionArr[i];
        NSDictionary *dict1 = @{@"x":[NSString stringWithFormat:@"%f",_circleView.frame.origin.x],@"y":[NSString stringWithFormat:@"%f",_circleView.frame.origin.y]};
        if ([dict isEqual:dict1]) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
            view.backgroundColor = Color;
            [_groundView addSubview:view];
            
            NSDictionary *dict = @{@"x":[NSString stringWithFormat:@"%f",view.frame.origin.x],@"y":[NSString stringWithFormat:@"%f",view.frame.origin.y]};
            [_positionArr addObject:dict];
            [_bodyArr addObject:view];
            
            int startX = arc4random()%_HNumber *EWidth;
            int startY = arc4random()%_HNumber *EWidth;
            _circleView.frame = CGRectMake(startX, startY, EWidth, EWidth);
            _circleView.backgroundColor = Color;
            [self turnCircleFrame:_circleView.frame.origin];
            return;
        }
    }
}

- (void)turnCircleFrame:(CGPoint)point {
    for (int i=0; i<_bodyArr.count ; i++) {
        UIView *view = [_bodyArr objectAtIndex:i];
        CGPoint point1 = view.frame.origin;
        if (point.x == point1.x && point.y == point1.y) {
            int startX = arc4random()%_HNumber *EWidth;
            int startY = arc4random()%_HNumber *EWidth;
            _circleView.frame = CGRectMake(startX, startY, EWidth, EWidth);
            [self turnCircleFrame:_circleView.frame.origin];
            return;
        }
    }
}

- (void)tapClick:(UITapGestureRecognizer *)ges {
    CGPoint point = [ges locationInView:self.view];
    CGFloat x = point.x;
    CGFloat y =SCREEN_HEIGHT - point.y;
    CGFloat canshu1 = SCREEN_HEIGHT/SCREEN_WIDTH;
    CGFloat canshu2 = SCREEN_HEIGHT/SCREEN_WIDTH * -1;
    CGFloat newY1 = x * canshu1;
    CGFloat newY2 = x * canshu2 + SCREEN_HEIGHT;
    
    if (y>newY1 && y>newY2) {
        if (_fangxiang!=under) {
            _fangxiang = up;
        }
    }else if (y>newY1 && y<newY2) {
        if (_fangxiang!=right) {
            _fangxiang = left;
        }
    }else if (y<newY1 && y>newY2) {
        if (_fangxiang!=left) {
            _fangxiang = right;
        }
    }else if (y<newY1 && y<newY2) {
        if (_fangxiang!=up) {
            _fangxiang = under;
        }
    }
}

- (void)turnBtnClick:(UIButton *)btn {
    switch (btn.tag) {
        case 3000:
        {
            if (_fangxiang!=under) {
                _fangxiang = up;
            }
        }
            break;
        case 3001:
        {
            if (_fangxiang!=right) {
                _fangxiang = left;
            }
        }
            break;
        case 3002:
        {
            if (_fangxiang!=left) {
                _fangxiang = right;
            }
        }
            break;
        case 3003:
        {
            if (_fangxiang!=up) {
                _fangxiang = under;
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)buttonClick:(UIButton *)btn {
    switch (btn.tag) {
        case 4000:
        {
            [_timer invalidate];
             [self.stopV hide];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
            break;
        case 4001:
        {
            [_timer setFireDate:[NSDate distantFuture]];
            self.stopV.ifStart = NO;
            self.stopV.title = @"(就当有茶杯)\nTea!";
            [self.stopV show];
        }
            break;
        case 4002:
        {
            [self.timer setFireDate:[NSDate date]];
            [self.stopV hide];
        }
            break;
        default:
            break;
    }
}

- (void)start {
    for (UIView *view in _groundView.subviews) {
        [view removeFromSuperview];
    }
    [self refreshStart];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

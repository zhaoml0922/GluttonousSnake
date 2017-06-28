//
//  StopView.m
//  tanchishe
//
//  Created by zhaoml on 2017/6/26.
//  Copyright © 2017年 赵明亮. All rights reserved.
//

#import "StopView.h"

@interface StopView ()
{
    UIView *alpView;
    UILabel *titleLabel;
    UIButton *startButton;
}
@end
@implementation StopView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI {
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 40);
    
    
    alpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, SCREEN_WIDTH/2)];
    alpView.alpha = 0.3;
    alpView.backgroundColor = [UIColor blackColor];
    alpView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    [self addSubview:alpView];
    
    titleLabel = [[UILabel alloc] initWithFrame:alpView.frame];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.numberOfLines = 0;
    titleLabel.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    [self addSubview:titleLabel];
    
    startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [startButton setTitle:@"重新开始" forState:UIControlStateNormal];
    [startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    startButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [startButton addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    startButton.hidden = YES;
    [self addSubview:startButton];
    
    
}

- (void)setIfStart:(BOOL)ifStart {
    _ifStart = ifStart;
    if (ifStart) {
        titleLabel.frame = CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y, titleLabel.frame.size.width, alpView.frame.size.height - 40);
        startButton.frame = CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y+alpView.frame.size.height - 40, titleLabel.frame.size.width, 40);
        startButton.hidden = NO;
    }else{
        titleLabel.frame = CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y, titleLabel.frame.size.width, alpView.frame.size.height);
        startButton.hidden = YES;
    }
}

- (void)btnClick {
    [self hide];
    [self.delegate start];
}

- (void)show {
    self.alpha = 1;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)hide {
    self.alpha = 0;
}


- (void)setTitle:(NSString *)title {
    _title = title;
    titleLabel.text = title;
}
@end

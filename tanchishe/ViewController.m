//
//  ViewController.m
//  tanchishe
//
//  Created by zhaoml on 2017/6/23.
//  Copyright © 2017年 赵明亮. All rights reserved.
//

#import "ViewController.h"
#import "GameViewController.h"
@interface ViewController ()
{
    NSInteger type;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *arr = @[@"高级",@"中等",@"初级"];
    
    for (int i=0; i<3; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 1000+i;
        [button setTitle:arr[i] forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 100+ 100 *i, SCREEN_WIDTH, 80);
        button.backgroundColor = [UIColor blackColor];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }

    NSArray *array = @[@"点击屏幕",@"点击按钮"];
    for (int i= 0; i<array.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 2000+i;
        [button setTitle:array[i] forState:UIControlStateNormal];
        button.frame = CGRectMake(SCREEN_WIDTH/2 * i, 100+ 300, SCREEN_WIDTH/2, 80);
        [button addTarget:self action:@selector(typeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
    UIButton *btn = [self.view viewWithTag:2000];
    [self typeButtonClick:btn];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)buttonClick:(UIButton *)button {
    GameViewController *game = [[GameViewController alloc] init];
    game.nadu = (int) button.tag - 999;
    game.type = type;
    [self presentViewController:game animated:YES completion:nil];
}

- (void)typeButtonClick:(UIButton *)button {
    button.backgroundColor = [UIColor blackColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    type = button.tag - 2000;
    if (button.tag == 2000) {
        UIButton *btn = [self.view viewWithTag:2001];
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    }else{
        UIButton *btn = [self.view viewWithTag:2000];
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

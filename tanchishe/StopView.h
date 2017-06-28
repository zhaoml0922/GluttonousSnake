//
//  StopView.h
//  tanchishe
//
//  Created by zhaoml on 2017/6/26.
//  Copyright © 2017年 赵明亮. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StopViewDelegate <NSObject>

- (void)start;

@end

@interface StopView : UIView

@property (nonatomic, assign) BOOL ifStart;///是否有开始按钮

- (void)show;


- (void)hide;

@property (nonatomic, weak) id<StopViewDelegate> delegate;

@property (nonatomic, strong) NSString *title;

@end

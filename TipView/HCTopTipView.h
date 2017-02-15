//
//  HCTopTipView.h
//  Post
//
//  Created by chuang Hao on 2016/12/8.
//  Copyright © 2016年 BML. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCTopTipView : UIView

@property (nonatomic, readonly) UILabel *detailLabel;
@property (nonatomic, readonly) UIView *lineView;
@property (nonatomic, assign) float viewHeight;
@property (nonatomic, assign) BOOL isStatusBarHidden;

- (void)showTopSuccessWithDetail:(NSString *)detailString addView:(UIView *)addView;

@end

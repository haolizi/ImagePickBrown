//
//  HCTopTipView.m
//  Post
//
//  Created by chuang Hao on 2016/12/8.
//  Copyright © 2016年 BML. All rights reserved.
//

#import "HCTopTipView.h"
@implementation HCTopTipView
@synthesize detailLabel;
@synthesize lineView;
@synthesize viewHeight;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(0, -86, SCREEN_WIDTH, 86);
        
        detailLabel = [[UILabel alloc] init];
        [self addSubview:detailLabel];
    
        lineView = [[UIView alloc] init];
        lineView.backgroundColor = RGB_COLOR(222, 222, 222, 1.0);
        [self addSubview:lineView];
    }
    return self;
}

//成功标识,添加到view上
- (void)showTopSuccessWithDetail:(NSString *)detailString addView:(UIView *)addView {
    [addView addSubview:self];
    detailLabel.frame = CGRectMake(14, 31, SCREEN_WIDTH - 28, 0);
    detailLabel.textAlignment = NSTextAlignmentCenter;
    
    //自适应label高和行间距
    [self addLabel:detailLabel labelFont:16 numOfLine:0 lineSpace:2 textWidth:SCREEN_WIDTH - 28 labelString:detailString];
    viewHeight = CGRectGetMaxY(detailLabel.frame) + 11;
    [self showAnimation];
}

- (void)showAnimation {
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, viewHeight);
        lineView.frame = CGRectMake(0, viewHeight - 1, SCREEN_WIDTH, 1);
        //如果所在控制器状态栏本来就是隐藏的，那么就不在隐藏和显示
        if ([UIApplication sharedApplication].statusBarHidden) {
            _isStatusBarHidden = YES;
        }
        else {
            [[UIApplication sharedApplication] setStatusBarHidden:TRUE];
        }
    } completion:^(BOOL finished) {
        [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.5];
    }];
}

- (void)delayMethod {
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(0, -viewHeight, SCREEN_WIDTH, viewHeight);
    } completion:^(BOOL finished) {
        if (!_isStatusBarHidden) {
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
        }
        [self removeFromSuperview];
    }];
}

#pragma mark -自适应label高和行间距
- (void) addLabel:(UILabel *)label
        labelFont:(int)sizeFont
        numOfLine:(int)numOfLine
        lineSpace:(int)lineSpace
        textWidth:(NSInteger)textWidth
      labelString:(NSString *)string
{
    label.numberOfLines = numOfLine;
    label.font = [UIFont systemFontOfSize:sizeFont];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize labelSize = [label sizeThatFits:CGSizeMake(textWidth, 1000)];
    CGRect frame = label.frame;
    frame.size.height = labelSize.height;
    label.frame = frame;
    // 设置label的行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
    [label setAttributedText:attributedString];
    [label sizeToFit];
}

@end

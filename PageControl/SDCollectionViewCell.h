//
//  SDCollectionViewCell.h
//  SDCycleScrollView
//
//  Created by aier on 15-3-22.
//  Copyright (c) 2015年 GSD. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface SDCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) UIImageView *imageView;
@property (copy, nonatomic) NSString *title;

@property (nonatomic, strong) UIColor *titleLabelTextColor;
@property (nonatomic, strong) UIFont *titleLabelTextFont;
@property (nonatomic, strong) UIColor *titleLabelBackgroundColor;
@property (nonatomic, assign) CGFloat titleLabelHeight;
@property (nonatomic, assign) BOOL hasConfigured;
@property (nonatomic, assign) BOOL isTradeBanner;
@property (nonatomic, assign) BOOL isTeamBanner;
@property (nonatomic, assign) BOOL isFullScreenWidth;

@end

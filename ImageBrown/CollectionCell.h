//
//  CollectionCell.h
//  PhotoBrownDemo
//
//  Created by chuang Hao on 2016/12/12.
//  Copyright © 2016年 Mr.Hao. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface CollectionCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *coverLabel;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) id asset;

@end

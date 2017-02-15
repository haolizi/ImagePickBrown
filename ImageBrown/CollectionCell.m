//
//  CollectionCell.m
//  PhotoBrownDemo
//
//  Created by chuang Hao on 2016/12/12.
//  Copyright © 2016年 Mr.Hao. All rights reserved.
//

#import "CollectionCell.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIImageView+WebCache.h"
@implementation CollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.userInteractionEnabled = YES;
        _imageView.clipsToBounds = YES;
        [self addSubview:_imageView];
        
        //封面标识
        _coverLabel = [[UILabel alloc] init];
        _coverLabel.frame = CGRectMake(0, self.bounds.size.height - 24, self.bounds.size.width, 24);
        _coverLabel.backgroundColor = [UIColor colorWithRed:221/225.0 green:50/255.0 blue:50/255.0 alpha:0.5];
        _coverLabel.text = @"封面";
        _coverLabel.font = [UIFont systemFontOfSize:14];
        _coverLabel.textAlignment = NSTextAlignmentCenter;
        _coverLabel.hidden = YES;
        [_imageView addSubview:_coverLabel];
        
        //删除按钮
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.frame = CGRectMake(self.bounds.size.width - 40, 0, 40, 40);
        _deleteBtn.imageEdgeInsets = UIEdgeInsetsMake(-20, 0, 0, -20);
        [_deleteBtn setImage:[UIImage imageNamed:@"photo_delete"] forState:UIControlStateNormal];
        [_imageView addSubview:_deleteBtn];
    }
    return self;
}

- (void)setAsset:(id)asset {
    _asset = asset;
    if (_asset) {
        //网络图片
        if ([_asset isKindOfClass:[NSString class]]){
            if ([_asset hasPrefix:@"http"]) {
                 [_imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_asset]] placeholderImage:[UIImage imageNamed:@"zwtu"]];
            }
            else {
                //本地图片
                UIImage *image = [UIImage imageNamed:_asset];
                if (!image) {
                    [UIImage imageWithContentsOfFile:_asset];
                }
                _imageView.image = image;
            }
        }
        //本地相册图片
        else {
            _imageView.image = _asset;
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _imageView.frame = self.bounds;
}

@end

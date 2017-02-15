//
//  SecondViewController.m
//  ImageBrown
//
//  Created by chuang Hao on 2017/2/15.
//  Copyright © 2017年 Mr.Hao. All rights reserved.
//

#import "SecondViewController.h"
#import "CollectionCell.h"
#import "TZImagePickerController.h"
#import "XLPhotoBrowser.h"

@interface SecondViewController ()
<XLPhotoBrowserDelegate,
UICollectionViewDelegate,
UICollectionViewDataSource,
TZImagePickerControllerDelegate>
{
    int coverIndex;//第几张图片为封面
    CGFloat _itemWH;
    CGFloat _margin;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *selectedPhotos;//本地图片数组
@property (nonatomic, strong) NSMutableArray *selectedAssets;//assets数组，用于记录选中的本地图片
@property (nonatomic, strong) NSMutableArray *allImageUrls;//上传成功后的所有图片
@property (nonatomic, strong) NSMutableArray *selectedAllPhotos;//所有图片数组
@property (nonatomic, copy) NSString *coverImageUrl;//上传后的封面图片

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择图片（最多7张）";//默认封面是第一张
    self.view.backgroundColor = [UIColor whiteColor];
    
    coverIndex = 0;
    _selectedPhotos    = [NSMutableArray array];
    _selectedAssets    = [NSMutableArray array];
    _allImageUrls      = [NSMutableArray array];
    _selectedAllPhotos = [NSMutableArray array];
    
    [_selectedAllPhotos addObjectsFromArray:_netImageUrlArray];
    
    [self initCollectionView];
    [self initCommitButton];
}

- (void)initCollectionView {
    _margin = 5;
    _itemWH = (SCREEN_WIDTH - 12*2 - 5*3)/4;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = _margin;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(12, 10, SCREEN_WIDTH - 24, 300) collectionViewLayout:layout];
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.scrollEnabled = NO;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:[CollectionCell class] forCellWithReuseIdentifier:@"CollectionCell"];
}

- (void)initCommitButton {
    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commitBtn.frame = CGRectMake((SCREEN_WIDTH - 150)/2, SCREEN_HEIGHT - 100, 150, 30);
    commitBtn.backgroundColor = [UIColor redColor];
    [commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [commitBtn addTarget:self action:@selector(commitImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commitBtn];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _selectedAllPhotos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    if (indexPath.row == _selectedAllPhotos.count) {
        cell.asset = @"tjtp-icon";
        cell.deleteBtn.hidden = YES;
    }
    else {
        cell.asset = _selectedAllPhotos[indexPath.row];
        cell.deleteBtn.hidden = NO;
    }
    
    //设置封面
    if (_selectedAllPhotos.count > 0) {
        if (coverIndex == indexPath.row) {
            cell.coverLabel.hidden = NO;
        }
        else {
            cell.coverLabel.hidden = YES;
        }
    }
    else {
        cell.coverLabel.hidden = YES;
    }
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_selectedAllPhotos.count > 0) {
        //添加图片
        if (indexPath.row == _selectedAllPhotos.count) {
            [self pushImagePickerController];
        }
        else {//浏览大图
            XLPhotoBrowser *browser = [XLPhotoBrowser showPhotoBrowserWithImages:_selectedAllPhotos currentImageIndex:indexPath.row];
            browser.delegate = self;
            browser.currentPageDotColor = [UIColor greenColor];
            browser.pageControlStyle = XLPhotoBrowserPageControlStyleAnimated;//pagecontrol的样式为弹性动画的样式
        }
    }
    //添加图片
    else {
        [self pushImagePickerController];
    }
}

//选择本地照片
- (void)pushImagePickerController {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:7 - _netImageUrlArray.count columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    imagePickerVc.isSelectOriginalPhoto = NO;//是否允许选择高清图
    imagePickerVc.selectedAssets = _selectedAssets;//目前已经选中的图片数组
    imagePickerVc.allowTakePicture = YES;//在内部显示拍照按钮
    
    //设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    
    //照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
    imagePickerVc.alwaysEnableDoneBtn = YES;//无图片时完成按钮依然可点
    imagePickerVc.showSelectBtn = YES;
    imagePickerVc.circleCropRadius = 100;
    imagePickerVc.allowPreview = YES;
    
    //回调选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        _selectedAssets = [NSMutableArray arrayWithArray:assets];
        _selectedPhotos = [NSMutableArray arrayWithArray:photos];
        [_selectedAllPhotos removeAllObjects];
        [_selectedAllPhotos addObjectsFromArray:_netImageUrlArray];
        [_selectedAllPhotos addObjectsFromArray:_selectedPhotos];
        [_collectionView reloadData];
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

//删除按钮点击事件
- (void)deleteBtnAction:(UIButton *)button{
    //有网络图片时
    if (_netImageUrlArray.count > 0) {
        //删除的是网络图片
        if (button.tag <= _netImageUrlArray.count - 1) {
            [_netImageUrlArray removeObjectAtIndex:button.tag];
        }
        //删除的是本地图片
        else {
            [_selectedPhotos removeObjectAtIndex:button.tag - _netImageUrlArray.count];
            [_selectedAssets removeObjectAtIndex:button.tag - _netImageUrlArray.count];
        }
    }
    //没有网络图片，删除的任何一个都是本地图片
    else {
        [_selectedPhotos removeObjectAtIndex:button.tag];
        [_selectedAssets removeObjectAtIndex:button.tag];
    }
    //如果删除的是封面图片，第一张图片变为封面
    if (button.tag == coverIndex) {
        coverIndex = 0;
    }
    else {
        if (button.tag < coverIndex) {
            -- coverIndex;
        }
    }
    [_selectedAllPhotos removeAllObjects];
    [_selectedAllPhotos addObjectsFromArray:_netImageUrlArray];
    [_selectedAllPhotos addObjectsFromArray:_selectedPhotos];
    [_collectionView reloadData];
}

//用作封面代理
- (void)UsageCoverWithCurrentImageIndex:(NSInteger)currentImageIndex{
    coverIndex = (int)currentImageIndex;
    [_collectionView reloadData];
}

//提交所有图片到服务器（上传部分就不写了，此处介绍如何得到我们想要的上传结果）
- (void)commitImage {
    //1.封面图片
    if (_netImageUrlArray > 0) {
        if (coverIndex < _netImageUrlArray.count - 1) {
            _coverImageUrl = _netImageUrlArray[coverIndex];
        }
        else {
            //_coverImageUrl 等于 _selectedAllPhotos[coverIndex]上传后的图片
        }
    }
    else {
        //_coverImageUrl 等于 _selectedAllPhotos[coverIndex]上传后的图片
    }
    
    //2.所有网络图片
    [_allImageUrls addObjectsFromArray:_netImageUrlArray];
    //然后将_selectedPhotos中图片上传成功后获取的url添加到_allImageUrls数组中
    //此时_allImageUrls就是我们最终上传成功后的所有图片url
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

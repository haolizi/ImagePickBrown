# ImageBrown

图片选择器，浏览图片支持网络图片与本地图片共存

## 前言


首先我要声明的是：这个demo是本人把[TZImagePickerController](https://github.com/banchichen/TZImagePickerController)（选择本地图片）与 [XLPhotoBrowser](http://www.jianshu.com/p/7ddeb1521d44)（图片浏览）这两个强大的神器简单修改、结合而成，感谢两位大神的无私贡献。

<br>这两个demo的具体用法和详细介绍，还请大家自己前去查看，这里就不一一讲解了，另TZImagePickerController支持选择原图和本地视频，这里给屏蔽掉了，你可根据自己项目需求自己进行修改。</br>

<br>本人才疏学浅，本demo只是简单展示，望能者勿喷。</br>


/**********一、初始化CollectinView**********/
```
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

/**********二、处理CollectinView代理、数据源及图片点击事件**********/
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

/**********三、删除图片**********/
```
效果图：



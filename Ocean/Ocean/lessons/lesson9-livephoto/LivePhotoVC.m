//
//  LivePhotoVC.m
//  oceanAppV3
//
//  Created by 方德翔 on 2024/6/26.
//

#import "LivePhotoVC.h"
#import <PhotosUI/PhotosUI.h>
#import <Photos/Photos.h>

// https://cloud.tencent.com/developer/article/2367673
// https://blog.csdn.net/chennai1101/article/details/129992076

// 本质是一张 HEIC 格式的封面图片 + 一段 MOV 格式的视频

@interface LivePhotoVC () <PHLivePhotoViewDelegate>
//@property(readwrite, nonatomic, strong) PHLivePhoto *livePhoto;
//@property(readonly, nonatomic, strong) UIGestureRecognizer *playbackGestureRecognizer;
//@property(readwrite, nonatomic, assign, getter=isMuted) BOOL muted;
@property (nonatomic, strong) PHLivePhotoView *livePhotoView;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation LivePhotoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    PHLivePhotoView *livePhotoView = [[PHLivePhotoView alloc] initWithFrame:CGRectMake(100, 100, 80, 80)];
    [self.view addSubview:livePhotoView];
    livePhotoView.contentMode = UIViewContentModeScaleAspectFit;
//    livePhotoView.isMuted = false;
//    PHLivePhoto* someLivePhoto = [PHLivePhoto init];
////    someLivePhoto.
//    livePhotoView.livePhoto = someLivePhoto; // someLivePhoto 是你的 PHLivePhoto 实例
    livePhotoView.delegate = self;
    self.livePhotoView = livePhotoView;
    [self.view addSubview:livePhotoView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"获取相册1" forState:UIControlStateNormal];
    button.frame = CGRectMake(20, 300, 80, 80);
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(selectImageFromPhotoLibrary:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button2 setTitle:@"获取相册2" forState:UIControlStateNormal];
    button2.frame = CGRectMake(120, 300, 80, 80);
    button2.backgroundColor = [UIColor redColor];
    [button2 addTarget:self action:@selector(fetchAllAlbums:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button3 setTitle:@"播放" forState:UIControlStateNormal];
    button3.frame = CGRectMake(300, 300, 80, 80);
    button3.backgroundColor = [UIColor redColor];
    [button3 addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];
    
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 400, 200, 200)];
    self.imageView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.imageView];
}

/*
typedef NS_ENUM(NSInteger, PHLivePhotoViewPlaybackStyle) {
    PHLivePhotoViewPlaybackStyleUndefined = 0, // 这个值对用户无效
    PHLivePhotoViewPlaybackStyleFull, // 播放Live Photo的整个动作和声音内容，包括开始和结束的过渡效果。
    PHLivePhotoViewPlaybackStyleHint, // 只播放Live Photo的一段简短的动作内容，没有声音。
} PHOTOS_ENUM_AVAILABLE_IOS_TVOS(9_1, 10_0);
 */
- (void)play:(UIButton *)sender{
    [self.livePhotoView startPlaybackWithStyle:PHLivePhotoViewPlaybackStyleFull];
}

- (void)pause:(UIButton *)sender{
    [self.livePhotoView stopPlayback];
}

- (void)livePhotoView:(PHLivePhotoView *)livePhotoView willBeginPlaybackWithStyle:(PHLivePhotoViewPlaybackStyle)playbackStyle {
    // 播放即将开始
    NSLog(@"播放即将开始");
}

- (void)livePhotoView:(PHLivePhotoView *)livePhotoView didEndPlaybackWithStyle:(PHLivePhotoViewPlaybackStyle)playbackStyle {
    // 播放已结束
    NSLog(@"播放已结束");
}

- (void)selectImageFromPhotoLibrary:(UIButton *)sender {
    // 检查是否支持访问相册
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.delegate = self;
        // 展示图片选择器
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerControllerDelegate

// 用户选择了图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *selectedImage = info[UIImagePickerControllerOriginalImage];
    // 使用选中的图片 && 关闭图片选择器
    [self.imageView setImage:selectedImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

// 用户取消选择
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
/*
 使用Photos框架时，确保在请求访问相册数据前获取用户的授权。
 此外，Photos框架提供的功能远不止这些，你可以根据需要使用更多的API来实现复杂的功能。
 */
- (void)fetchAllAlbums:(UIButton *)sender {
    // 请求访问权限
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            dispatch_async(dispatch_get_main_queue(), ^{
                // 获取所有相册
                PHFetchResult<PHAssetCollection *> *albums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
                [albums enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull collection, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSLog(@"相册名: %@", collection.localizedTitle);
                    // 这里可以进一步获取相册内的图片和视频
                }];
            });
        }
    }];
}
@end

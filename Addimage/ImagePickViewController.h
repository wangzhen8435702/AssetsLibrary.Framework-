//
//  ImagePickViewController.h
//  Addimage
//
//  Created by wangzhen on 15-3-13.
//  Copyright (c) 2015年 wangzhen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

typedef void(^PickViewBlock)(NSArray* dataList);

@interface ImagePickViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSMutableArray * _dataList;
    UICollectionView* _collectionView;
    PickViewBlock _block;
}

@property(nonatomic,strong)ALAssetsLibrary* library;

@property(nonatomic,strong)NSMutableArray * selectArr;

-(void)getDataListBlock:(PickViewBlock)block;


@end

//
//  PickView.h
//  Addimage
//
//  Created by wangzhen on 15-3-11.
//  Copyright (c) 2015年 wangzhen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickViewItem.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface PickView : UIView{
    NSMutableArray * _frameArr;
    NSInteger _currentIndex;
    BOOL _isINOtherFram;
    UIButton * addBtn;
    ALAssetsLibrary * library;
}

@property(nonatomic,strong)NSMutableArray* dataList;

@end

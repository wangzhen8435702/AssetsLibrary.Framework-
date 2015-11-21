//
//  PickView.m
//  Addimage
//
//  Created by wangzhen on 15-3-11.
//  Copyright (c) 2015年 wangzhen. All rights reserved.
//

#import "PickView.h"
#import "UIView+UIViewController.h"
#import "ImagePickViewController.h"
#define kSpaceWH 10
#define kImageViewWH (self.frame.size.width-2*kSpaceWH)/3


@implementation PickView

-(void)setDataList:(NSMutableArray *)dataList{
    _dataList=dataList;
    
     library = [[ALAssetsLibrary alloc]init];
    
    int i =0;
    
    for (UIImageView * image in self.subviews) {
        [image removeFromSuperview];
    }

    
    for(NSURL* url in dataList){
        
        UIImageView* imageV = [[UIImageView alloc]initWithFrame:[self getFrame:i]];

        imageV.userInteractionEnabled=YES;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(kImageViewWH-32, -8, 40, 40)];
        
        
        [btn setImage:[UIImage imageNamed:@"button_icon_close"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(removeAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [imageV addSubview:btn];

        [library assetForURL:url resultBlock:^(ALAsset *asset) {
            
            ALAssetRepresentation *rep = [asset defaultRepresentation];
            Byte *buffer = (Byte*)malloc((unsigned long)rep.size);
            NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:((unsigned long)rep.size) error:nil];
            NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
            
            [imageV setImage:[UIImage imageWithData:data]];
            
        } failureBlock:nil];
        
//        [_frameArr addObject: [NSValue valueWithCGRect:imageV.frame]];
        
        
        
        imageV.tag = 100+i;
        [btn setTag:imageV.tag+100];
        
        [self addSubview:imageV];
        
        i++;
    
    }
    [self createAddBtn];
    

}


-(void)removeAction:(UIButton * )sender{
    
    NSInteger index = sender.tag- 200;
    
    UIView * viw= [self.superview viewWithTag:index+100];
    [viw removeFromSuperview];
    
    for(int i = index+1;i<_dataList.count;i++){

       {
 
            UIView * viw= [self.superview viewWithTag:100+i];
           UIButton * btn = (UIButton*)[self.superview viewWithTag:200+i];
         
            viw.tag=i+100-1;
           btn.tag = viw.tag+100;
            NSLog(@"%ld",viw.tag);
            CGRect frame= [self getFrame:viw.tag-100];
           
           
           
            [UIView animateWithDuration:.25 animations:^{
                [viw setFrame:frame];
            }];
            
        }
        
    }
    
    [_dataList removeObjectAtIndex:index];
    if (!addBtn) {
        addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        addBtn.tag=100+_dataList.count;
        [addBtn setImage:[UIImage imageNamed:@"btn_add_photo_s"] forState:UIControlStateNormal];
        
        
        [addBtn addTarget:self action:@selector(presentImagePickVc) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:addBtn];
        
    }
    [UIView animateWithDuration:.25 animations:^{
        
        
        [addBtn setFrame:[self getFrame:_dataList.count]];
        addBtn.hidden=NO;

    }];
    


}


-(void)createAddBtn{
    

    
        addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addBtn.tag=100+_dataList.count;
        [addBtn setImage:[UIImage imageNamed:@"btn_add_photo_s"] forState:UIControlStateNormal];
        [addBtn setFrame:[self getFrame:_dataList.count]];
        addBtn.hidden= YES;
        [addBtn addTarget:self action:@selector(presentImagePickVc) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:addBtn];
    if(_dataList.count<9){
        addBtn.hidden=NO;
    }

}
-(void)presentImagePickVc{
   
    [ALAssetsLibrary disableSharedPhotoStreamsSupport];
    
    ImagePickViewController* imagePickVc = [[ImagePickViewController alloc]init];
    UINavigationController* navi = [[UINavigationController alloc]initWithRootViewController:imagePickVc];
    
    imagePickVc.library= library;
    imagePickVc.selectArr = _dataList;
    
    [imagePickVc getDataListBlock:^(NSArray *dataList) {
       
        self.dataList = [[NSMutableArray alloc]initWithArray:dataList];
    }];
    
    [self.viewController presentViewController:navi animated:YES completion:^{
        
    }];
    
    

}


-(CGRect)getFrame:(int)index{
    
    return CGRectMake(index%3*(kSpaceWH+kImageViewWH), index/3*(kSpaceWH+kImageViewWH), kImageViewWH, kImageViewWH);
    
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    _isINOtherFram = NO;
    UITouch* touch=[touches anyObject];
    UIView* view=nil;
    
    if([touch.view isKindOfClass:[UIImageView class]]){
        view = touch.view;
        [UIView animateWithDuration:.25 animations:^{
            view.alpha= .8;
            view.transform=CGAffineTransformMakeScale(1.1, 1.1);
        }];
        
        [self bringSubviewToFront:view];
    }
    
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch* touch=[touches anyObject];
    UIView* view=nil;
    
    if([touch.view isKindOfClass:[UIImageView class]]){
        view = touch.view;
        
        
        CGPoint point1=[touch locationInView:self];
        CGPoint point2=[touch previousLocationInView:self];
        
        CGFloat newx=point1.x-point2.x;
        CGFloat newy=point1.y-point2.y;
        
        CGPoint center=view.center;
        center.x+=newx;
        center.y+=newy;
        view.center=center;
        
        NSInteger isContainsPoint = [self indexOfPoint:point1];
        
        if(isContainsPoint==0|| isContainsPoint!=99 ){
            
            if(isContainsPoint != view.tag-100){
                
                

//                NSLog(@"%d",isContainsPoint);
                for(int i = view.tag-100;i<=isContainsPoint;i++){
                    NSLog(@"%ld",view.tag);
                    if(i!= view.tag-100){
                        UIView * viw= [self.superview viewWithTag:100+i];
                        viw.tag=i+100-1;
                        NSLog(@"%ld",viw.tag);
                        CGRect frame= [self getFrame:viw.tag-100];
                        [UIView animateWithDuration:.25 animations:^{
                            [viw setFrame:frame];
                        }];
             
                    }

                }
                for(int i = view.tag-100;i>=isContainsPoint;i--){
                    if(i!= view.tag-100){
                        UIView * viw= [self.superview viewWithTag:100+i];
                        viw.tag=i+100+1;
                        NSLog(@"%ld",viw.tag);
                        CGRect frame= [self getFrame:viw.tag-100];
                        [UIView animateWithDuration:.25 animations:^{
                            [viw setFrame:frame];
                        }];

                    }

                
                
                }
                
                
                
                view.tag = 100+isContainsPoint;
                
                
            }
            
        }
    }

  
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch* touch = [touches anyObject];
    UIView* view=nil;
    
    if([touch.view isKindOfClass:[UIImageView class]]){
        view = touch.view;
        [UIView animateWithDuration:.25 animations:^{
            view.alpha= 1;
            view.transform=CGAffineTransformMakeScale(1, 1);
            
            view.frame= [self getFrame:view.tag - 100];
            
        }];

    }
    
    

    
}

////通过point 获取 当前point所在的图片的index

-(NSInteger)indexOfPoint:(CGPoint)point{
    for(int i=0;i<_dataList.count;i++){

        CGRect frame =[self getFrame:i];;

        if(CGRectContainsPoint(frame, point)){
        
            return i;
        };
    
    }
    return 99;

}





@end

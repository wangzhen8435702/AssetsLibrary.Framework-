//
//  ImagePickViewController.m
//  Addimage
//
//  Created by wangzhen on 15-3-13.
//  Copyright (c) 2015年 wangzhen. All rights reserved.
//

#import "ImagePickViewController.h"
#define kScreenW     [UIScreen mainScreen].bounds.size.width


static NSString* const indentifer = @"UICollectionViewCell";

@interface ImagePickViewController (){

}

@end

@implementation ImagePickViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem= [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
    
    _dataList = [[NSMutableArray alloc]init];
    
    [self loadData];
    
    [self createCollectionView];

}
-(void)loadData{
    
    [_library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            
            if (result!=nil) {
                
                [_dataList addObject:[result defaultRepresentation].url];
            
            }
            
            
        }];
        [_collectionView reloadData];
        
    } failureBlock:^(NSError *error) {
        
        
       
        
    }];
    
    

}
-(void)setSelectArr:(NSMutableArray *)selectArr{
    _selectArr = selectArr;
    NSLog(@"%@",selectArr);
    
}

-(void)dismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)done{
    _block(_selectArr);
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)getDataListBlock:(PickViewBlock)block{

    _block = block;
}

-(void)createCollectionView{
    
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
    
    flowLayout.itemSize = CGSizeMake((kScreenW-70)/3, (kScreenW-70)/3);
    
    flowLayout.minimumInteritemSpacing = 10;

    flowLayout.minimumLineSpacing = 10;
    
    flowLayout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
    

    
     _collectionView = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:flowLayout];
    
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:indentifer];
    
    [self.view addSubview:_collectionView];
    
    
}
#pragma mark - 
#pragma mari -collectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return _dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell* cell =[collectionView dequeueReusableCellWithReuseIdentifier:indentifer forIndexPath:indexPath];

    if (![cell.contentView viewWithTag:111]) {
        
        UIImageView * imageV = [[UIImageView alloc]init];
        [imageV setFrame:cell.bounds];

        imageV.tag = 111;
        [cell.contentView addSubview:imageV];
        
        UIImageView * isOk = [[UIImageView alloc]initWithFrame:CGRectMake(cell.frame.size.width-44, cell.frame.size.height -44, 44, 44)];
        [isOk setImage:[UIImage imageNamed:@"login_ok"]];
        isOk.tag= 222;
        [cell.contentView addSubview:isOk];
        
        isOk.hidden=YES;
        
    }
    if (_dataList.count) {
    
       
        
        UIImageView * image = (UIImageView*)[cell.contentView viewWithTag:111];
        [_library assetForURL:_dataList[indexPath.item] resultBlock:^(ALAsset *asset) {
            
            ALAssetRepresentation *rep = [asset defaultRepresentation];
            Byte *buffer = (Byte*)malloc((unsigned long)rep.size);
            NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:((unsigned long)rep.size) error:nil];
            NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
            
            [image setImage:[UIImage imageWithData:data]];
            
        } failureBlock:nil];
       
        

    }
    
    BOOL isSeclet;
    
    if (_selectArr.count!=0) {
        NSURL* url = _dataList[indexPath.item];
        isSeclet =  [self ifIsSelect:url ];
        
        if (!isSeclet) {
            UIImageView *isOk = [cell.contentView viewWithTag:222];
            isOk.hidden = YES;
            
        }else{
            UIImageView *isOk = [cell.contentView viewWithTag:222];
            isOk.hidden =NO;
            
            
        }
        

    }
    
        return cell;

}

-(BOOL)ifIsSelect:(NSURL*)url {
    for(NSURL* _url in _selectArr){
        if([[_url absoluteString]isEqualToString:[url absoluteString]]){
        
            return YES;
        }
    
    }
    return NO;
    

}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    

    UICollectionViewCell * cell = [collectionView cellForItemAtIndexPath:indexPath];
    BOOL isSeclet;
    if (_selectArr.count!=0) {
        NSURL* url = _dataList[indexPath.item];
        isSeclet =  [_selectArr containsObject:url];

    }
    
    if (!isSeclet) {
        
        [_selectArr addObject:_dataList[indexPath.item]];
        
        UIImageView *isOk = [cell.contentView viewWithTag:222];
        isOk.hidden =NO;
    }else{
        UIImageView *isOk = [cell.contentView viewWithTag:222];
        isOk.hidden =YES;
    
        [_selectArr removeObject:_dataList[indexPath.row]];
    }
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

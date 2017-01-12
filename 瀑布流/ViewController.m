//
//  ViewController.m
//  瀑布流
//
//  Created by SethYin on 2017/1/2.
//  Copyright © 2017年 yanhuihui. All rights reserved.
//

#import "ViewController.h"
#import "MyCollectionLayout.h"
#import "MyCollectionViewCell.h"
@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    MyCollectionLayout *flowLayout = [[MyCollectionLayout   alloc]init];
//    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
//    flowLayout.itemSize = CGSizeMake(70, 70);
//    flowLayout.minimumLineSpacing = 50;
//    flowLayout.minimumInteritemSpacing = 25;
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 375, [UIScreen mainScreen].bounds.size.height) collectionViewLayout:flowLayout];
    [self.collectionView registerClass:[MyCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([MyCollectionViewCell class])];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    
    // 切换布局
    self.collectionView.collectionViewLayout = [[MyCollectionLayout alloc] init];
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MyCollectionViewCell class]) forIndexPath:indexPath];
    if (!cell) {
        cell = [[MyCollectionViewCell alloc] init];
    }
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  MyCollectionLayout.m
//  瀑布流
//
//  Created by SethYin on 2017/1/2.
//  Copyright © 2017年 yanhuihui. All rights reserved.
//

#import "MyCollectionLayout.h"
#define MyCollectionW self.collectionView.frame.size.width

static const CGFloat MyDefaultRowMargin = 10;  // 每一行之间的间距
static const CGFloat MyDefaultColumnMargin = 10; //每一列之间的间距
static const UIEdgeInsets MyDefaultInsets = {10,10,10,10};    ///每一列之间的间距 top,left,bottom,right
static const int MyDefaultColumnCount = 2;

@interface MyCollectionLayout()

@property(nonatomic,strong)NSMutableArray *columnMaxYs;  //每一列的最大Y值
@property(nonatomic,strong)NSMutableArray *attrsArray;   //存放所有cell的布局属性

@end

@implementation MyCollectionLayout


#pragma mark 懒加载
-(NSMutableArray *)columnMaxYs
{
    if (!_columnMaxYs) {
        _columnMaxYs = [[NSMutableArray alloc]init];
    }
    return _columnMaxYs;
}
-(NSMutableArray *)attrsArray
{
    if (!_attrsArray) {
        _attrsArray = [[NSMutableArray alloc]init];
    }
    return _attrsArray;
}
#pragma mark 实现内部方法
//决定了collectionView的contentSize
-(CGSize)collectionViewContentSize
{
    //找出最长那一列的Y值
    CGFloat destMaxY = [self.columnMaxYs[0] doubleValue];
    for (NSUInteger i = 1; i < self.columnMaxYs.count; i++) {
        //取出第i列的最大值
        CGFloat columnMaxY = [self.columnMaxYs[i] doubleValue];
        //找出数组中的最大值
        if (destMaxY < columnMaxY)
        {
            destMaxY = columnMaxY;
        }
    }
    return CGSizeMake(0, destMaxY + MyDefaultInsets.bottom);
}
-(void)prepareLayout{
    [super prepareLayout];
    //重置每一列的最大Y值
    [self.columnMaxYs removeAllObjects];
    for (NSUInteger i =0; i< MyDefaultColumnCount; i++) {
        [self.columnMaxYs addObject:@(MyDefaultInsets.top)];
    }
    //计算所有cell的布局属性
    [self.attrsArray removeAllObjects];
    NSUInteger count = [self.collectionView numberOfItemsInSection:0];
    for (NSUInteger i = 0; i< count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attrsArray addObject:attrs];
    }
}
//说明所有元素（比如cell,补充控件，装饰控件）的布局属性
-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return  self.attrsArray;
}
//说明cell的布局属性
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    //计算indexpath位置cell的布局属性
    //水平方向上的总间距
    CGFloat xMargin = MyDefaultInsets.left + MyDefaultInsets.right + (MyDefaultColumnCount - 1) * MyDefaultColumnMargin;
    //cell的宽度
    CGFloat w = (MyCollectionW - xMargin) / MyDefaultColumnCount;
    //cell 的高度 测试数据 随机数
    CGFloat h = 50 + arc4random_uniform(150);
    // 找出最短那一列的 列号 和 最大Y值
    CGFloat destMaxY = [self.columnMaxYs[0] doubleValue];
    NSUInteger destColumn = 0;
    for (NSUInteger i = 0; i<self.columnMaxYs.count; i++) {
        // 取出第i列的最大Y值
        CGFloat columnMaxY = [self.columnMaxYs[i] doubleValue];
        
        // 找出数组中的最小值
        if (destMaxY > columnMaxY) {
            destMaxY = columnMaxY;
            destColumn = i;
        }
    }
    
    
    // cell的x值
    CGFloat x = MyDefaultInsets.left + destColumn * (w + MyDefaultColumnMargin);
    // cell的y值
    CGFloat y = [self.columnMaxYs[destColumn] floatValue] + MyDefaultRowMargin ;
    
    // cell的frame
    attrs.frame = CGRectMake(x, y, w, h);
    
    
    //更新数组中的最大Y值
    self.columnMaxYs[destColumn] = @ (CGRectGetMaxY(attrs.frame));
    NSLog(@"attrs      =====%@",attrs);
    return attrs;
}

//-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
//{
//    
//    return  YES;
//}
//- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
//{
//    NSArray *orginalArray = [super layoutAttributesForElementsInRect:rect];
//    NSArray *arrayAttrs = [[NSArray alloc]initWithArray:orginalArray copyItems:YES];
//    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.bounds.size.width *0.5;
//    for (UICollectionViewLayoutAttributes *attr in arrayAttrs) {
//        CGFloat cell_centerX = attr.center.x;
//        CGFloat distance = ABS(cell_centerX -centerX);
//        CGFloat factor = 0.0038;
//        CGFloat scale = 1.55 -distance * factor;
//        attr.zIndex = -distance;
//        attr.size = CGSizeMake(self.itemSize.width*scale, self.itemSize.height*scale);
//    }
//    return arrayAttrs;
//}
@end

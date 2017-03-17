//
//  QLMPurchasedViewController.m
//  Qomolangma
//
//  Created by NowOrNever on 15/03/2017.
//  Copyright © 2017 Focus. All rights reserved.
//

#import "QLMPurchasedViewController.h"
#import "QLMPurchasedModel.h"
#import "QLMPurchasedLable.h"
#import "QLMPurchasedFlowLayout.h"
#import "UIColor+FCSColor.h"

///已购Lable 高度
#define labSVHeight 44

@interface QLMPurchasedViewController () <UICollectionViewDelegate,UICollectionViewDataSource>

//已购Label视图
@property (nonatomic,strong) UIScrollView *labScrollView;

//已购内容视图
@property (nonatomic,strong) UICollectionView *purCollentionView;

//已购label数据源
@property (nonatomic,strong) NSArray *purchasedModelData;

//记录已购label
@property (nonatomic,strong) NSMutableArray *labArray;

@property (nonatomic, strong) UIView *labelView;

@property (nonatomic, strong) NSArray<QLMPurchasedLable *> *purchasedLabelArray;

@end

@implementation QLMPurchasedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
  
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    //已购标签视图
    [self requestPurchaseData];
    
    //已购内容视图
    [self setupPurchasedCollectionView];
    
    [self setupLabelView];
}

- (void)setupLabelView
{
    self.labelView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenWidth, labSVHeight)];
    
    self.labelView.backgroundColor = [UIColor whiteColor];
    
    NSArray *titlesArray = @[@"全部", @"每天听本书", @"精选音频", @"电子书", @"订阅"];
    
    [self.view addSubview:self.labelView];
    
    NSMutableArray *purchasedLabelArray = [NSMutableArray array];
    NSMutableArray *labelWidthArray = [NSMutableArray array];
    
    CGFloat totalWidth = 0.0;
    
    for (NSInteger i = 0 ; i < titlesArray.count; i++)
    {
        QLMPurchasedLable *label = [QLMPurchasedLable qlm_labelWithColor:[UIColor colorWithRed:140 / 255.0 green:124 / 255.0 blue:108 / 255.0 alpha:1] andFontSize:14 andText:titlesArray[i]];
        
        label.tag = i;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        
        [label addGestureRecognizer:tap];
        
        [label sizeToFit];
        
        totalWidth += label.bounds.size.width;
        
        [labelWidthArray addObject:@(label.bounds.size.width)];
        
        [self.labelView addSubview:label];
        
        [purchasedLabelArray addObject:label];
    }
    
    self.purchasedLabelArray = purchasedLabelArray.copy;
    
    CGFloat margin = (kScreenWidth - totalWidth) / (self.purchasedLabelArray.count + 1);
    
    CGFloat x = margin;
    
    for (NSInteger i = 0 ; i < purchasedLabelArray.count ; i++ )
    {
        self.purchasedLabelArray[i].frame = CGRectMake(x, 0, [labelWidthArray[i] floatValue], self.labelView.bounds.size.height);
        x += margin;
        x += [labelWidthArray[i] floatValue];
    }
}

#pragma  mark - 2.设置已购内容视图
- (void)setupPurchasedCollectionView {
    
    //创建layout
    QLMPurchasedFlowLayout *flowLaout = [[QLMPurchasedFlowLayout alloc]init];
    
    //创建已购内容视图
    self.purCollentionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, labSVHeight + kNavBarHeight, self.view.bounds.size.width, self.view.bounds.size.height - (labSVHeight + kNavBarHeight)) collectionViewLayout:flowLaout];
    
    //遵守数据源和代理
   self.purCollentionView.delegate = self;
   self.purCollentionView.dataSource = self;
    
    //注册
    [self.purCollentionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellid"];
    
    //添加视图
    [self.view addSubview:self.purCollentionView];
    
    //取消弹簧效果
    self.purCollentionView.bounces = NO;
    
    //取消滚动条
    self.purCollentionView.showsVerticalScrollIndicator = NO;
    self.purCollentionView.showsHorizontalScrollIndicator = NO;
    
    //设置分页效果
    self.purCollentionView.pagingEnabled = YES;
    
    //设置预加载cell
    self.purCollentionView.prefetchingEnabled = YES;
    
    
    
}

#pragma  mark - 数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    
//    return  self.purchasedModelData.count;
    return self.purchasedLabelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
    
    
    cell.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1];
    
    return cell;
    
}

#pragma  mark - 1.设置已购Label标签
- (void)requestPurchaseData {
    
    //记录purchasedLabel数据源
    self.purchasedModelData = [QLMPurchasedModel getPurchasedModelData];
    
    //初始化
    self.labArray = [NSMutableArray array];
    
    //已购label的大小
    CGFloat labelWidth = kScreenWidth / 5;
    
    UIView *labelView = [[UIView alloc] initWithFrame:self.labScrollView.bounds];
    
    [_labScrollView addSubview:labelView];
    
    for (int i = 0; i < self.purchasedModelData.count; i++) {
        
        QLMPurchasedModel *model = self.purchasedModelData[i];
        
        //NSLog(@"%@",model);
        
        //创建label
//        QLMPurchasedLable *purchasedLabel = [[ QLMPurchasedLable alloc]initWithFrame:CGRectMake(i * labelWidth, 0, labelWidth, labSVHeight)];
        
        QLMPurchasedLable *purchasedLabel = [[QLMPurchasedLable alloc]initWithFrame:CGRectZero];
        
        //QLMPurchasedLable *purchasedLabel = [[ QLMPurchasedLable alloc]init];
        
        //获取显示内容
        purchasedLabel.text = model.tname;
        //NSLog(@"%@",model.tname);

        //设置文字大小和居中显示
        purchasedLabel.font = [UIFont systemFontOfSize:13];
        purchasedLabel.textAlignment = NSTextAlignmentCenter;
        purchasedLabel.textColor = [UIColor colorWithRed:140 / 255.0 green:124 / 255.0 blue:108 / 255.0 alpha:1];
        [purchasedLabel sizeToFit];
        
        //添加
//        [self.labScrollView addSubview:purchasedLabel];
        [labelView addSubview:purchasedLabel];
        
        //开启用户交互
        purchasedLabel.userInteractionEnabled = YES;
        
        //创建手势
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesturePurchasedLableAction:)];
        
        //添加手势
        [purchasedLabel addGestureRecognizer:tapGesture];
        
        //设置tag
        purchasedLabel.tag = i;
        
        //记录已购Label
        [self.labArray addObject:purchasedLabel];
        
    }
    
    [self.labArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:10 leadSpacing:0 tailSpacing:0];
    [self.labArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(labelView);
    }];
   

    
    //设置scrollview的滚动范围
    self.labScrollView.contentSize = CGSizeMake(labelWidth * self.purchasedModelData.count, 0);
    
    //取消滚动条
    self.labScrollView.showsVerticalScrollIndicator = NO;
    self.labScrollView.showsHorizontalScrollIndicator = NO;
    
    
    
}

#pragma  mark - 已购内容视图结束时调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    //计算滚动页数的索引
    int index = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    //根据索引获取频道标签
    QLMPurchasedLable *purchasedLabel = self.labArray[index];
    
    //遍历频道数组,判断点击的频道和数组里的Label进行查找,找到了就改变颜色,否则保持默认状态
    for (QLMPurchasedLable *label in self.labArray) {
        
        if (purchasedLabel == label) {

            label.textColor = [UIColor blackColor];
           
            
        } else {
            
            label.textColor = [UIColor colorWithRed:140 / 255.0 green:124 / 255.0 blue:108 / 255.0 alpha:1];
        }
    }
    
}

#pragma  mark - 滚动已购内容视图 移动Label
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    //计算小数索引
    CGFloat floatIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
    //NSLog(@"%f",floatIndex);
    
    //计算整数索引
    int intIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    //获取本分比
    CGFloat precent = floatIndex - intIndex;
    
    //左边标签的百分比
    CGFloat leftPrecent = 1 - precent;
    
    //右边标签的本分比
    CGFloat rightPrecent = precent;
    
    //NSLog(@"左边: %f,右边: %f", leftPrecent, rightPrecent);
    
    //计算左边标签的索引
    int leftIndex = intIndex;
    
    //计算右边标签的索引
    int rightIndex = intIndex + 1;
    
    //根据索引获取标签
//    QLMPurchasedLable *leftPurchasedLabel = self.labArray[leftIndex];

    QLMPurchasedLable *leftPurchasedLabel = self.purchasedLabelArray[leftIndex];

    
    leftPurchasedLabel.scalePercent = leftPrecent;
    
    
    
    //判断右边的频道标签是否超出可用范围
    if (rightIndex < self.labArray.count) {
        
        QLMPurchasedLable *rightPurchasedLabel = self.purchasedLabelArray[rightIndex];
        
        rightPurchasedLabel.scalePercent = rightPrecent;
        
    }
    
}

#pragma  mark - 点击已购Label 滚动对应已购内容视图
- (void)tapGesturePurchasedLableAction:(UITapGestureRecognizer *)gesture {
    
    //获取已购Label
    QLMPurchasedLable *purchasedLabel = (QLMPurchasedLable *)gesture.view;
    
    //创建滚动的indexPath
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:purchasedLabel.tag inSection:0];
    
    //滚动已购内容视图
    [self.purCollentionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    
    //遍历频道数组,判断点击的频道和数组里的Label进行查找,找到了就放大和改变颜色,否则保持默认状态
    for (QLMPurchasedLable *label in self.labArray) {
        
        if (purchasedLabel == label) {
            
            label.textColor = [UIColor blackColor];
            label.scalePercent = 1;
   
        } else {
            label.textColor = [UIColor colorWithRed:140 / 255.0 green:124 / 255.0 blue:108 / 255.0 alpha:1];
            label.scalePercent = 0;

        }
    }
}

#pragma  mark - 懒加载
- (UIScrollView *)labScrollView {
    
    if (!_labScrollView) {
        
        self.labScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kNavBarHeight, self.view.bounds.size.width, labSVHeight)];
        
        self.labScrollView.backgroundColor = [UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1];
        
        [self.view addSubview:self.labScrollView];
    }
    
    return _labScrollView;
}

#pragma mark - 点击事件
- (void)tapAction: (UITapGestureRecognizer *)sender
{
    //获取已购Label
    QLMPurchasedLable *purchasedLabel = (QLMPurchasedLable *)sender.view;
    
    //创建滚动的indexPath
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:purchasedLabel.tag inSection:0];
    
    //滚动已购内容视图
    [self.purCollentionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    
    //遍历频道数组,判断点击的频道和数组里的Label进行查找,找到了就放大和改变颜色,否则保持默认状态
    for (QLMPurchasedLable *label in self.labArray) {
        
        if (purchasedLabel == label) {
            
            label.textColor = [UIColor blackColor];
            label.scalePercent = 1;
            
        } else {
            label.textColor = [UIColor colorWithRed:140 / 255.0 green:124 / 255.0 blue:108 / 255.0 alpha:1];
            label.scalePercent = 0;
            
        }
    }
    
}

@end

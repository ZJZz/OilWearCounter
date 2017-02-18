//
//  BaoGaoViewController.m
//  OilWearCounter
//
//  Created by Tony Zhao on 5/3/15.
//  Copyright (c) 2015 Tony Zhao. All rights reserved.
//

#import "BaoGaoViewController.h"
#import "RGCardViewLayout.h"
#import "MyCollectionViewCell.h"

CGFloat youFei = 0;
CGFloat youLiang = 0;
CGFloat liCheng = 0;
NSInteger tianShu = 0;
NSInteger yueShu = 0;
NSInteger nianShu = 1;



@interface BaoGaoViewController ()


@end

@implementation BaoGaoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    
    self.view.backgroundColor = [UIColor grayColor];
    self.title = @"油耗报告";
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width,280)];
    [tableView setScrollEnabled:NO];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    self.myArray = [[NSArray alloc] initWithObjects:@"行驶总天数",@"行驶总里程",@"耗油总量",@"油费总计",@"每升油价",nil];
    [self.view addSubview:tableView];
    
    RGCardViewLayout * layOut = [[RGCardViewLayout alloc] init];
    UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 280, [[UIScreen mainScreen]bounds].size.width,[[UIScreen mainScreen]bounds].size.height-280) collectionViewLayout:layOut];
    collectionView.pagingEnabled = YES;
    collectionView.backgroundColor = [UIColor lightTextColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [self.view addSubview:collectionView];
    
    [collectionView registerClass:[MyCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
}

-(void)viewWillAppear:(BOOL)animated{
    self.myDataArray = [NSMutableArray arrayWithArray:[[CounterDatabase counterDatabase] tableOil]];
    
    Counter * counter1 = [self.myDataArray firstObject];//counter1为新插入的记录
//    Counter *counter2 = [self.myDataArray lastObject];
    CGFloat gongLi = counter1.oil_lcb;
    liCheng = gongLi;
    
    
    CGFloat youLiangs  = 0;
    for (int i = 0; i <self.myDataArray.count ; i++)
    {
        Counter *counter3 = [self.myDataArray objectAtIndex:i];
        youLiangs += counter3.oil_jyl;
    }
    youLiang = youLiangs;
    
    CGFloat youFeis  = 0;
    for (int i = 0; i <self.myDataArray.count ; i++)
    {
        Counter *counter3 = [self.myDataArray objectAtIndex:i];
        youFeis = youFeis +counter3.oil_takermb;
    }
    youFei = youFeis;
    
    tianShu = self.dateArray.count;
    yueShu = self.monthArray.count;
    nianShu = 1;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.myArray count];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndefier = @"cellIndefier";
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndefier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndefier];
    }
    
    cell.textLabel.text = [self.myArray objectAtIndex:indexPath.row];
    

    UILabel *lael = [[UILabel alloc] initWithFrame:CGRectMake(120, 5, 180, 30)];
    lael.textAlignment = NSTextAlignmentRight;

    [cell.contentView addSubview:lael];
        
    switch (indexPath.row)
    {
        case 0:
        {
            lael.text = [NSString stringWithFormat:@"%ld天",(long)tianShu];
        }break;
            
        case 1:
        {
            lael.text = [NSString stringWithFormat:@"%g公里",liCheng];
        }break;
            
        case 2:
        {
            lael.text =[NSString stringWithFormat:@"%g升",youLiang];
        }break;
            
        case 3:
        {

            lael.text =[NSString stringWithFormat:@"%g元",youFei];

        }break;
            
        case 4:
        {
            lael.text =[NSString stringWithFormat:@"%g元/升", youFei/youLiang];
        }break;
            
        default:break;
    }
    return cell;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify = @"cell";
    MyCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    [cell sizeToFit];
    if(!cell) { NSLog(@"create cell failed"); }
    [self configureCell:cell withIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(MyCollectionViewCell *)cell withIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
        {
            cell.dateLabel.text = @"  日平均";
            cell.mileLabel.text = [NSString stringWithFormat:@"里程:  %g公里/天", liCheng/tianShu];
            cell.oilCosumLabel.text = [NSString stringWithFormat:@"油耗: %g升/天", youLiang/tianShu];
            cell.oilPriceLabel.text = [NSString stringWithFormat:@"油价: %g元/天", youFei/tianShu];
        }break;
        
        case 1:
        {
            cell.dateLabel.text = @"  月平均";
            cell.mileLabel.text = [NSString stringWithFormat:@"里程:  %g公里/月", liCheng/yueShu];
            cell.oilCosumLabel.text = [NSString stringWithFormat:@"油耗: %g升/月", youLiang/yueShu];
            cell.oilPriceLabel.text = [NSString stringWithFormat:@"油价: %g元/月", youFei/yueShu];
        }break;
        
        case 2:
        {
            cell.dateLabel.text = @"  年平均";
            cell.mileLabel.text = [NSString stringWithFormat:@"里程:  %g公里/年", liCheng/nianShu];
            cell.oilCosumLabel.text = [NSString stringWithFormat:@"油耗: %g升/年", youLiang/nianShu];
            cell.oilPriceLabel.text = [NSString stringWithFormat:@"油价: %g元/年", youFei/nianShu];
        }break;
    }
}

@end

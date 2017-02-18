//
//  BaoGaoViewController.h
//  OilWearCounter
//
//  Created by Tony Zhao on 5/3/15.
//  Copyright (c) 2015 Tony Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CounterDatabase.h"
#import "Counter.h"


@interface BaoGaoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic,strong)NSArray *myArray;
@property(nonatomic,strong)NSMutableArray *myDataArray;
@property (nonatomic,copy) NSArray * dateArray;
@property (nonatomic,copy) NSArray * monthArray;

@end

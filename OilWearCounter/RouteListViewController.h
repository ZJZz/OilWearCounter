//
//  RouteListViewController.h
//  OilWearCounter
//
//  Created by Tony Zhao on 4/25/15.
//  Copyright (c) 2015 Tony Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RouteListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,copy) NSArray * dateArray;
@property (nonatomic,copy) NSArray * monthArray;
@property (nonatomic,copy) NSArray * dayCountInMonthArray;
@end

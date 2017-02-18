//
//  View2Controller.h
//  OilWearCounter
//
//  Created by Tony Zhao on 5/3/15.
//  Copyright (c) 2015 Tony Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewCell.h"
#import "CounterDatabase.h"
#import "Counter.h"
#import "InserViewController.h"
#import "BaoGaoViewController.h"
#import "BMapKit.h"

@interface View2Controller : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,BMKLocationServiceDelegate,NSCoding>
{
    BMKLocationService* locService;
}

@property(nonatomic,strong)NSMutableArray *myDataArray;
@property(nonatomic,strong)NSMutableArray *coordinateArray;
@property(nonatomic,strong)NSMutableArray * latitudeArray;
@property(nonatomic,strong)NSMutableArray * longitudeArray;
@property(nonatomic,strong)UITableView *myTableView;
@property(nonatomic,strong)UIActionSheet *myActionSheet;
@property(nonatomic,strong)UIActionSheet *reportActionSheet;

@end

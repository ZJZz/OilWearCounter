//
//  View2Controller.m
//  OilWearCounter
//
//  Created by Tony Zhao on 5/3/15.
//  Copyright (c) 2015 Tony Zhao. All rights reserved.
//

#import "View2Controller.h"
#import "RouteListViewController.h"
#import "ModifyPhoneViewController.h"


#import "RZTransitionsInteractionControllers.h"
#import "RZTransitionsAnimationControllers.h"
#import "RZTransitionInteractionControllerProtocol.h"
#import "RZTransitionsManager.h"

static NSString *cellIndefier = @"cellIndefier";

@interface View2Controller ()<RZTransitionInteractionControllerDelegate>

@property (nonatomic, strong) id<RZTransitionInteractionController> pushPopInteractionController;

@end

@implementation View2Controller

int success = 0;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.pushPopInteractionController = [[RZHorizontalInteractionController alloc] init];
    [self.pushPopInteractionController setNextViewControllerDelegate:self];
    [self.pushPopInteractionController attachViewController:self withAction:RZTransitionAction_PushPop];
    [[RZTransitionsManager shared] setInteractionController:self.pushPopInteractionController
                                         fromViewController:[self class]
                                           toViewController:[ModifyPhoneViewController class]
                                                  forAction:RZTransitionAction_PushPop];
    
    [[RZTransitionsManager shared] setAnimationController:[[RZZoomPushAnimationController alloc] init]
                                       fromViewController:[self class]
                                                forAction:RZTransitionAction_PushPop];
    [[RZTransitionsManager shared] setAnimationController:[[RZZoomPushAnimationController alloc] init]
                                       fromViewController:[ModifyPhoneViewController class]
                                         toViewController:[self class]
                                                forAction:RZTransitionAction_PushPop];
    
    
    
    locService = [[BMKLocationService alloc] init];
    locService.delegate = self;
    
    self.coordinateArray = [[NSMutableArray alloc] init];
    self.longitudeArray = [[NSMutableArray alloc] init];
    self.latitudeArray = [[NSMutableArray alloc] init];
    
    self.navigationController.navigationBarHidden = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"油耗计算器";
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height)];
    UINib *myNib = [UINib nibWithNibName:@"TableView" bundle:nil];
    [tableView registerNib:myNib forCellReuseIdentifier:cellIndefier];
    tableView.dataSource = self;
    tableView.delegate = self;
    self.myTableView = tableView;
    
    UIBarButtonItem *editBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editClicked:)];
    [self.navigationItem setLeftBarButtonItem:editBarButtonItem];
    
    UIBarButtonItem *insertBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertClicked:)];
    [self.navigationItem setRightBarButtonItem:insertBarButtonItem];
    
    //下面的toolBar
    UIToolbar *myToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, [[UIScreen mainScreen]bounds].size.height - 44, [[UIScreen mainScreen]bounds].size.width, 44)];
    UIBarButtonItem *shuJuBarButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(shuJu:)];
    
    UIBarButtonItem *baoGaoBarButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction  target:self action:@selector(baoGao:)];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [myToolbar setItems:@[shuJuBarButton,space,baoGaoBarButton]];
    
    [self.view addSubview:tableView];
    [self.view addSubview:myToolbar];
    
}

//ToolBar按钮的方法
-(void)shuJu:(id)sender{
    UIActionSheet *shuJuActionSheet = [[UIActionSheet alloc]initWithTitle:@"定位服务" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"开始定位",@"停止定位", nil];
    self.myActionSheet = shuJuActionSheet;
    [shuJuActionSheet showInView:self.view];
}

-(void)baoGao:(id)sender{
    UIActionSheet *shuJuActionSheet = [[UIActionSheet alloc] initWithTitle:@"使用信息" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"油耗报告",@"行驶路线",@"修改绑定号码",nil];
    self.reportActionSheet = shuJuActionSheet;
    [shuJuActionSheet showInView:self.view];

}

//ActionSheetdelegate方法
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(actionSheet == self.myActionSheet)
    {
        if (buttonIndex == 0)
        {

            NSLog(@"开始定位");
            [locService startUserLocationService];
            
        }
        else if(buttonIndex == 1)
        {
            NSLog(@"停止定位");
            [locService stopUserLocationService];
            //        NSLog(@"coordinateArray %@",self.coordinateArray);
            NSLog(@"longitudeArray:%@",self.longitudeArray);
            NSLog(@"latitudeArray:%@",self.latitudeArray);
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString *paths = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSLog(@"%@",paths);
            
            NSDateFormatter * dateformatter = [[NSDateFormatter alloc]init];
            [dateformatter setDateFormat:@"YYYYMMdd"];//YYYYMMDDHHmmss
            
            //write longtitude file
            NSString *FileName_long=[paths stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_longtitude",[dateformatter stringFromDate:[NSDate date]]]];
            NSLog(@"%@",FileName_long);
            //判断有没有缓存文件
            if ([fileManager fileExistsAtPath:FileName_long])
            {
                NSLog(@"file exist");
            }
            else
            {
                [fileManager createFileAtPath:FileName_long contents:nil attributes:nil];
            }
            
            NSArray * myLongitudeArray = [[NSArray alloc] initWithArray:self.longitudeArray];
            
            if( [myLongitudeArray writeToFile:FileName_long atomically:YES] )
            {
                NSLog(@"write success");
            }
            else
            {
                NSLog(@"write failed ");
            }
            
            //write latitude file
            NSString *FileName_lati=[paths stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_latitude",[dateformatter stringFromDate:[NSDate date]]]];
            NSLog(@"%@",FileName_lati);
            //判断有没有缓存文件
            if ([fileManager fileExistsAtPath:FileName_lati])
            {
                NSLog(@"file exist");
            }
            else
            {
                [fileManager createFileAtPath:FileName_lati contents:nil attributes:nil];
            }
            
            NSArray * myLatitudeArray = [[NSArray alloc] initWithArray:self.latitudeArray];
            
            if( [myLatitudeArray writeToFile:FileName_lati atomically:YES] )
            {
                NSLog(@"write success");
            }
            else
            {
                NSLog(@"write failed ");
            }
            
            
        }
    }
    else if(actionSheet == self.reportActionSheet)
    {
            NSString *paths = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSArray *tmp = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:paths error:nil];
            NSLog(@"%@",tmp);
        
            NSString *head = @"201";
            NSString *rear = @"_latitude";
            NSPredicate *headPred = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH %@",head];
            NSPredicate *rearPred = [NSPredicate predicateWithFormat:@"SELF ENDSWITH %@",rear];
        
            NSArray * fileArray = [[tmp filteredArrayUsingPredicate:headPred] filteredArrayUsingPredicate:rearPred];
        
            NSLog(@"fileArray: %@",fileArray);
        
            NSMutableArray * dateArray = [[NSMutableArray alloc] init];
        
            for (NSString * filename in fileArray)
            {
                [dateArray addObject:[filename substringWithRange:NSMakeRange(0,8)]];
            }
            NSLog(@"dateArray: %@",dateArray);
        
            NSMutableArray * monthArray = [[NSMutableArray alloc] init];
            for(NSString * date in dateArray)
            {
                NSString * month = [date substringWithRange:NSMakeRange(4,2)];
                if([monthArray indexOfObject:month] == NSNotFound)
                {
                    [monthArray addObject:month];
                }
            }
            NSLog(@"monthArray: %@",monthArray);
        
            NSMutableArray * monthWithDayArray = [[NSMutableArray alloc] init];
            for(NSString * date in dateArray)
            {
                NSString * month = [date substringWithRange:NSMakeRange(4,4)];
                if([monthWithDayArray indexOfObject:month] == NSNotFound)
                {
                    [monthWithDayArray addObject:month];
                }
            }
            NSMutableArray * daysCntInMonthArray = [[NSMutableArray alloc] init];
            for(int i = 1; i <= 12; i++ )
            {
                NSString * monthPrefix = [[NSString alloc] init];
                if(i < 10)
                {
                   monthPrefix = [NSString stringWithFormat:@"0%d",i];
                }
                else if(i>=10)
                {
                    monthPrefix = [NSString stringWithFormat:@"%d",i];
                }
                NSPredicate *monthPredicate = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH %@",monthPrefix];
                NSArray * daysInMonthArray = [[NSArray arrayWithArray:monthWithDayArray] filteredArrayUsingPredicate:monthPredicate];
                if(daysInMonthArray.count != 0)
                {
                    [daysCntInMonthArray addObject:[NSNumber numberWithLong:daysInMonthArray.count]];
                }
            }
            NSLog(@"daysCntInMonthArray: %@",daysCntInMonthArray);
        
        if (buttonIndex == 0)
        {
            BaoGaoViewController *baoGaoView = [[BaoGaoViewController alloc] init];
            baoGaoView.monthArray = [NSArray arrayWithArray:monthArray];
            baoGaoView.dateArray = [NSArray arrayWithArray:dateArray];
            [self.navigationController pushViewController:baoGaoView animated:YES];
        }
        else if(buttonIndex == 1)
        {
            RouteListViewController * routeListViewController = [[RouteListViewController alloc] init];
            routeListViewController.dateArray = [NSArray arrayWithArray:dateArray];
            routeListViewController.monthArray = [NSArray arrayWithArray:monthArray];
            routeListViewController.dayCountInMonthArray = [NSArray arrayWithArray:daysCntInMonthArray];
            [self.navigationController pushViewController:routeListViewController animated:YES];
        }
        else if(buttonIndex == 2)
        {
            ModifyPhoneViewController * modifyPhoneViewController = [[ModifyPhoneViewController alloc] init];
            [self.navigationController pushViewController:modifyPhoneViewController animated:YES];
        }
    }
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [self.latitudeArray addObject:[NSNumber numberWithDouble:userLocation.location.coordinate.latitude]];
    [self.longitudeArray addObject:[NSNumber numberWithDouble:userLocation.location.coordinate.longitude]];
    if(success == 0)
    {
        UIAlertView * locateSuccessAlert = [[UIAlertView alloc] initWithTitle:@"定位服务" message:@"定位成功" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [locateSuccessAlert show];
        success = 1;
    }
    
    
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
}

- (void)didFailToLocateUserWithError:(NSError *)error
{
    
    [locService stopUserLocationService];
    UIAlertView * locateFailedAlert = [[UIAlertView alloc] initWithTitle:@"定位服务" message:@"定位失败，请稍后重试" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    [locateFailedAlert show];
    
    NSLog(@"locating failed");
    NSLog(@"%@",error);
}


-(void)viewWillAppear:(BOOL)animated{//取出数据库存的油耗数据
    self.myDataArray = [NSMutableArray arrayWithArray: [[CounterDatabase counterDatabase] tableOil]];
    [self.myTableView reloadData];
    locService.delegate = self;
    
}//

-(void)viewWillDisappear:(BOOL)animated {
    locService.delegate = nil;
}

-(void)editClicked:(UIBarButtonItem *)sender{
    
    if ([sender.title isEqualToString:@"Edit"] ) {
        [sender setTitle:@"Done"];
        [self.myTableView setEditing:YES animated:YES];
    }else{
        [sender setTitle:@"Edit"];
        [self.myTableView setEditing:NO animated:YES];
    }
    
    
}
-(void)insertClicked:(id)sender{
    InserViewController *insertView = [[InserViewController alloc]init];
    insertView.panduan = 0;
    [self.navigationController pushViewController:insertView animated:YES];
}

#pragma mark - tableView数据源方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.myDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndefier];
    if (cell == nil) {
        cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndefier];
    }
   
    Counter *counter = [self.myDataArray objectAtIndex:indexPath.row];
    
    cell.dateLabel.text =  counter.oil_date;
    cell.dateLabel.font = [UIFont systemFontOfSize:20];
    
    cell.jylLabel.text = [NSString stringWithFormat:@"%gL",counter.oil_jyl] ;
    cell.jylLabel.font = [UIFont systemFontOfSize:15];
    
    cell.rmbLabel.text = [NSString stringWithFormat:@"%g元",counter.oil_takermb];
    cell.rmbLabel.font = [UIFont systemFontOfSize:15];
    
    cell.pingJunLabel.textColor = [UIColor greenColor];
    cell.pingJunLabel.font = [UIFont systemFontOfSize:15];
    
    if (self.myDataArray.count > 1 && indexPath.row < self.myDataArray.count - 1 )
    {
        Counter *counter1 = [self.myDataArray objectAtIndex:indexPath.row];
        Counter *counter2 = [self.myDataArray objectAtIndex:indexPath.row + 1];
        CGFloat haoyou = (counter.oil_jyl /(counter1.oil_lcb - counter2.oil_lcb)) * 100 ;
        
        cell.pingJunLabel.text = [NSString stringWithFormat:@"%.2f升/百公里",haoyou];
        cell.pingJunLabel.textAlignment = NSTextAlignmentLeft;
    }
    if ( self.myDataArray.count == 1 || indexPath.row == self.myDataArray.count - 1 )
    {
        Counter *counter1 = [self.myDataArray objectAtIndex:indexPath.row];
        CGFloat haoyou = (counter.oil_jyl /(counter1.oil_lcb)) * 100 ;
        
        cell.pingJunLabel.text = [NSString stringWithFormat:@"%.2f升/百公里",haoyou];
        cell.pingJunLabel.textColor = [UIColor greenColor];
        cell.pingJunLabel.textAlignment = NSTextAlignmentLeft;
    }

    return cell;
}

//能否对某一行进行添加和删除操作
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    //表示对所有行都可以操作
    return YES;
}

//实际的添加或者删除的操作要实现的地方
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    Counter *counter = [self.myDataArray objectAtIndex:indexPath.row];
    [[CounterDatabase counterDatabase] deleteTableOilWith:counter.oil_id];
    [self.myDataArray removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}


#pragma mark - tableView代理方法
//Cell高度
- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 59;
}

//表示你能对某一行能做哪些操作（添加或删除）(触发的条件识TanleView必须处于编辑模式下)
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

//选中单元格
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    InserViewController *insertView = [[InserViewController alloc]init];
    insertView.panduan = indexPath.row + 1;
    [self.navigationController pushViewController:insertView animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end

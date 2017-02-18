//
//  RegViewController.h
//  SMS_SDKDemo
//
//  Created by 掌淘科技 on 14-6-4.
//  Copyright (c) 2014年 掌淘科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SectionsViewController.h"

@protocol SecondViewControllerDelegate;

@interface RegViewController : UIViewController
<
UIAlertViewDelegate,
UITableViewDataSource,
UITableViewDelegate,
SecondViewControllerDelegate,
UITextFieldDelegate
>

@property(nonatomic,strong) UITableView* tableView;
@property(nonatomic,strong) UITextField* areaCodeField;
@property(nonatomic,strong) UILabel* telLabel;
@property(nonatomic,strong) UIWindow* window;
@property(nonatomic,strong) UIButton* next;
@property(nonatomic,copy) NSMutableArray* areaArray;
@property(nonatomic,copy) NSString * savePhoneNumber;
@property(nonatomic,copy) NSString * showedPhoneNumber;


-(void)nextStep;

@end

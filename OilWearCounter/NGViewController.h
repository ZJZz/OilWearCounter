//
//  NGViewController.h
//  OilWearCounter
//
//  Created by Tony Zhao on 5/3/15.
//  Copyright (c) 2015 Tony Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "CounterDatabase.h"
#import "View2Controller.h"


@interface NGViewController : UIViewController<UIAlertViewDelegate>

@property(nonatomic,copy)NSString *passWordString;
@property(nonatomic,strong)UILabel *tiShiLabel;
@property(nonatomic,strong)NSString *firstPassWord;
@property(nonatomic,strong)NSString *secondPassWord;


@end

//
//  InserViewController.h
//  OilWearCounter
//
//  Created by Tony Zhao on 5/3/15.
//  Copyright (c) 2015 Tony Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Counter.h"
#import "CounterDatabase.h"

@interface InserViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>

@property(nonatomic,strong )UIButton *mylabel ;
@property(nonatomic,strong)UIPickerView *myPicView;
@property(nonatomic,strong)UIToolbar *myToolBar;
@property(nonatomic,assign)NSInteger panduan;
@property(nonatomic,strong)NSMutableArray *myDataArray;
@property(nonatomic,strong)UIDatePicker *myDatePicker;
@property(nonatomic,strong)UILabel *myDateLabel;
@property(nonatomic,strong)NSArray *myQiYouArray;
@property(nonatomic,strong)UILabel *myLeiXiangLabel;
@property(nonatomic,strong)UIButton *myTextButton;
@property(nonatomic,strong)UITableView *myTableView;
@property(nonatomic,strong)UITextField *myInsertTextFied;
@property(nonatomic,strong)UILabel *myJylLabel;
@property(nonatomic,strong)UILabel *myLcbLabel;
@property(nonatomic,strong)UILabel *myRmbLabel;
@property(nonatomic,strong)UILabel *myDanjiaLabel;
@property(nonatomic,strong)UILabel *myStationLabel;
@property(nonatomic,strong)UILabel *myNoteLabel;
@property(nonatomic,assign)NSInteger isFull;


@end

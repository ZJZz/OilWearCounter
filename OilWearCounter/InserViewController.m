//
//  InserViewController.m
//  OilWearCounter
//
//  Created by Tony Zhao on 5/3/15.
//  Copyright (c) 2015 Tony Zhao. All rights reserved.
//

#import "InserViewController.h"
#import "MyRouteViewController.h"

int cellNum = 1;

@interface InserViewController ()

@end

@implementation InserViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //汽油类型数组
    self.myQiYouArray = @[@"92号汽油",@"93号汽油"];
    
    self.myDataArray = [NSMutableArray arrayWithArray:[[CounterDatabase counterDatabase] tableOil]];
    
    self.title = @"加油详情";
    self.view.backgroundColor = [UIColor whiteColor];
    UITableView *myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height)];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    self.myTableView = myTableView;
    
    //Save Button
    UIBarButtonItem *saveBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveClicked:)];
    [self.navigationItem setRightBarButtonItem:saveBarButtonItem];
    //Cancel Button
    UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(cancelBarClicked:)];
    [self.navigationItem setLeftBarButtonItem:cancelBarButtonItem];
    
    [self.view addSubview:myTableView];
}

//Save Button selector
-(void)saveClicked:(UIBarButtonItem *)sender{
    
    if (self.panduan == 0) //添加过来还是点击单元格过来 0为点击添加
    {
        if ([self.myJylLabel.text isEqualToString:@"输入加油量"] ||[self.myRmbLabel.text isEqualToString:@"输入本次加油金额"] || [self.myLcbLabel.text isEqualToString:@"输入当前里程表读数"])
        {
            UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"警告" message:@"请输入正确的加油信息" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
            [alertview show];
        }
        else
        {
            Counter *counter = [[Counter alloc]init];
            counter.oil_date = self.myDateLabel.text;
            counter.oil_jyl = [self.myJylLabel.text floatValue];
            counter.oil_lcb = [self.myLcbLabel.text integerValue];
            counter.oil_takermb = [self.myRmbLabel.text floatValue];
            counter.oil_station = self.myStationLabel.text;
            counter.oil_note = self.myNoteLabel.text;
            counter.oil_isFull = self.isFull;
            counter.danJia = [self.myDanjiaLabel.text floatValue];
            //汽油类型
            for (int i = 0; i < self.myQiYouArray.count; i++)
            {
                if ([self.myLeiXiangLabel.text isEqualToString:[self.myQiYouArray objectAtIndex:i]])
                {
                    counter.oil_type = i;
                }
                
            }
            [[CounterDatabase counterDatabase] insertToTableOilWith:counter];
        }
        
    }
    else
    {
        
        Counter *counter = [[Counter alloc]init];
        counter.oil_date = self.myDateLabel.text;
        counter.oil_jyl = [self.myJylLabel.text floatValue];
        counter.oil_lcb = [self.myLcbLabel.text integerValue];
        counter.oil_takermb = [self.myRmbLabel.text floatValue];
        counter.oil_station = self.myStationLabel.text;
        counter.oil_note = self.myNoteLabel.text;
        counter.oil_isFull = self.isFull;
        counter.danJia = [self.myDanjiaLabel.text floatValue];
        //汽油类型
        for (int i = 0; i < self.myQiYouArray.count; i++) {
            if ([self.myLeiXiangLabel.text isEqualToString:[self.myQiYouArray objectAtIndex:i]]) {
                counter.oil_type = i;
            }
            
        }
        //用cell得行数,获得对应的counter对象,在将对象的id传过去,用来判断修改对象.
        Counter *counter2 = [self.myDataArray objectAtIndex:self.panduan -1];
        [[CounterDatabase counterDatabase] updateTableOilWith:counter2.oil_id and:counter];
    }
}

//取消按钮方法
-(void)cancelBarClicked:(UIBarButtonItem *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark -tableView数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.myInsertTextFied.text = @"";
    
    static NSString *cellIndefier = @"cellIndefier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndefier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndefier];
    }
    if (self.panduan == 0) {
        
        
        switch (indexPath.row) {
            case 0:{
                UILabel *datelael = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 90, 30)];
                datelael.text = @"加油日期:";
                UILabel *datelabelShow = [[UILabel alloc]initWithFrame:CGRectMake(200, 5, 90, 30)];
                NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
                [dateformatter setDateFormat:@"yyyy-MM-dd"];
                datelabelShow.text = [dateformatter stringFromDate:[NSDate date]];
                self.myDateLabel = datelabelShow;
                datelabelShow.textAlignment = NSTextAlignmentRight;
                
                [cell.contentView addSubview:datelael];
                [cell.contentView addSubview:datelabelShow];
            }
                break;
            case 1:{
                UILabel *liChenglael = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 90, 30)];
                liChenglael.text = @"里程表:";
                UILabel *liChengLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 5, 170, 30)];
                liChengLabel.text = @"输入当前里程表读数";
                liChengLabel.textColor = [UIColor grayColor];
                self.myLcbLabel = liChengLabel;
                liChengLabel.textAlignment = NSTextAlignmentRight;
                
                [cell.contentView addSubview:liChenglael];
                [cell.contentView addSubview:liChengLabel];
            }
                break;
            case 2:{
                UILabel *liChenglael = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 90, 30)];
                liChenglael.text = @"加油量:";
                UILabel *jylLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 5, 170, 30)];
                jylLabel.text = @"输入加油量";
                jylLabel.textColor = [UIColor grayColor];
                self.myJylLabel = jylLabel;
                jylLabel.textAlignment = NSTextAlignmentRight;
                [cell.contentView addSubview:liChenglael];
                [cell.contentView addSubview:jylLabel];
            }
                break;
            case 3:{
                UILabel *liChenglael = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 90, 30)];
                liChenglael.text = @"加油金额:";
                UILabel *rmbLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 5, 170, 30)];
                rmbLabel.text = @"输入本次加油金额";
                rmbLabel.textColor = [UIColor grayColor];
                self.myRmbLabel = rmbLabel;
                rmbLabel.textAlignment = NSTextAlignmentRight;
                [cell.contentView addSubview:liChenglael];
                [cell.contentView addSubview:rmbLabel];
            }
                break;
            case 4:{
                UILabel *liChenglael = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 90, 30)];
                liChenglael.text = @"单价:";
                UILabel *danJiaLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 5, 170, 30)];
                
                self.myDanjiaLabel = danJiaLabel;
                danJiaLabel.textAlignment = NSTextAlignmentRight;
                danJiaLabel.text = @"0.99" ;
                
                [cell.contentView addSubview:liChenglael];
                [cell.contentView addSubview:danJiaLabel];
            }
                break;
            case 5:{
                UILabel *liChenglael = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 90, 30)];
                liChenglael.text = @"燃油类型:";
                
                UILabel *pickerShow = [[UILabel alloc]initWithFrame:CGRectMake(120, 5, 170, 30)];
                pickerShow.text = @"92号汽油";
                pickerShow.textAlignment = NSTextAlignmentRight;
                self.myLeiXiangLabel = pickerShow;
                
                
                [cell.contentView addSubview:liChenglael];
                [cell.contentView addSubview:pickerShow];
            }
                break;
            case 6:{
                UILabel *liChenglael = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 90, 30)];
                liChenglael.text = @"是否加满:";
                UISegmentedControl *segmented = [[UISegmentedControl alloc]initWithItems:@[@"是",@"否"]];
              //  segmented.momentary = YES;
                [segmented addTarget:self action:@selector(Changed:) forControlEvents:UIControlEventValueChanged];
                
                self.isFull = segmented.selectedSegmentIndex;
                segmented.frame = CGRectMake(190, 10, 100, 25);
                
                
                [cell.contentView addSubview:liChenglael];
                [cell.contentView addSubview:segmented];
            }
                break;
            case 7:{
                UILabel *liChenglael = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 90, 30)];
                liChenglael.text = @"加油站:";
                UILabel *jyzLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 5, 170, 30)];
                self.myStationLabel = jyzLabel;
                
                jyzLabel.textAlignment = NSTextAlignmentRight;
                [cell.contentView addSubview:liChenglael];
                [cell.contentView addSubview:jyzLabel];
            }
                break;
            case 8:{
                UILabel *liChenglael = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 90, 30)];
                liChenglael.text = @"备注:";
                UILabel *beiZhuLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 5, 170, 30)];
                self.myNoteLabel = beiZhuLabel;
                
                beiZhuLabel.textAlignment = NSTextAlignmentRight;
                [cell.contentView addSubview:liChenglael];
                [cell.contentView addSubview:beiZhuLabel];
            }break;
//            case 9:
//            {
//                UILabel* routeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 90, 30)];
//                routeLabel.text = @"行驶路线";
//                [cell.contentView addSubview:routeLabel];
//            }break;
                
            default:
                break;
        }
    }
    else
    {
        Counter *counter = [self.myDataArray objectAtIndex:self.panduan - 1];

        switch (indexPath.row) {
            case 0:{
                UILabel *datelael = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 90, 30)];
                datelael.text = @"加油日期:";
                UILabel *datelabelShow = [[UILabel alloc]initWithFrame:CGRectMake(200, 5, 90, 30)];
                NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
                [dateformatter setDateFormat:@"yyyy-MM-dd"];
                datelabelShow.text = counter.oil_date;
                datelabelShow.textAlignment = NSTextAlignmentRight;
                self.myDateLabel = datelabelShow;
                
                [cell.contentView addSubview:datelael];
                [cell.contentView addSubview:datelabelShow];
            }
                break;
            case 1:{
                UILabel *liChenglael = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 90, 30)];
                liChenglael.text = @"里程表:";
                UILabel *liChengLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 5, 170, 30)];
//                liChengLabel.text = [NSString stringWithFormat:@"%d",counter.oil_lcb];
                liChengLabel.text = [NSString stringWithFormat:@"%ld",(long)counter.oil_lcb];
                self.myLcbLabel = liChengLabel;
                
                //文字靠右
                liChengLabel.textAlignment = NSTextAlignmentRight;
                
                [cell.contentView addSubview:liChenglael];
                [cell.contentView addSubview:liChengLabel];
            }
                break;
            case 2:{
                UILabel *liChenglael = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 90, 30)];
                liChenglael.text = @"加油量:";
                UILabel *jylLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 5, 170, 30)];
                jylLabel.text = [NSString stringWithFormat:@"%g",counter.oil_jyl];
                self.myJylLabel = jylLabel;
                jylLabel.textAlignment = NSTextAlignmentRight;
                [cell.contentView addSubview:liChenglael];
                [cell.contentView addSubview:jylLabel];
            }
                break;
            case 3:{
                UILabel *liChenglael = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 90, 30)];
                liChenglael.text = @"加油金额:";
                UILabel *rmbLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 5, 170, 30)];
                rmbLabel.text = [NSString stringWithFormat:@"%g",counter.oil_takermb];
                self.myRmbLabel = rmbLabel;
                rmbLabel.textAlignment = NSTextAlignmentRight;
                [cell.contentView addSubview:liChenglael];
                [cell.contentView addSubview:rmbLabel];
            }
                break;
            case 4:{
                UILabel *liChenglael = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 90, 30)];
                liChenglael.text = @"单价:";
                UILabel *danJiaLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 5, 170, 30)];
                
                self.myDanjiaLabel = danJiaLabel;
                danJiaLabel.textAlignment = NSTextAlignmentRight;
                danJiaLabel.text = [NSString stringWithFormat:@"%g",counter.danJia] ;
                
                [cell.contentView addSubview:liChenglael];
                [cell.contentView addSubview:danJiaLabel];
            }
                break;
            case 5:{
                UILabel *liChenglael = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 90, 30)];
                liChenglael.text = @"燃油类型:";
                
                UILabel *pickerShow = [[UILabel alloc]initWithFrame:CGRectMake(120, 5, 170, 30)];
                pickerShow.text = [self.myQiYouArray objectAtIndex:counter.oil_type];
                self.myLeiXiangLabel = pickerShow;
                
                pickerShow.textAlignment = NSTextAlignmentRight;
                
                
                
                [cell.contentView addSubview:liChenglael];
                [cell.contentView addSubview:pickerShow];
            }
                break;
            case 6:{
                UILabel *liChenglael = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 90, 30)];
                liChenglael.text = @"是否加满:";
                UISegmentedControl *segmented = [[UISegmentedControl alloc]initWithItems:@[@"否",@"是"]];
                segmented.selectedSegmentIndex = counter.oil_isFull;
               // segmented.momentary = YES;
               [segmented addTarget:self action:@selector(Changed:) forControlEvents:UIControlEventValueChanged];
                
                self.isFull = segmented.selectedSegmentIndex;
                segmented.frame = CGRectMake(190, 10, 100, 25);
                
                
                [cell.contentView addSubview:liChenglael];
                [cell.contentView addSubview:segmented];
            }
                break;
            case 7:{
                UILabel *liChenglael = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 90, 30)];
                liChenglael.text = @"加油站:";
                UILabel *jyzLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 5, 170, 30)];
                jyzLabel.text = counter.oil_station;
                self.myStationLabel = jyzLabel;
                jyzLabel.textAlignment = NSTextAlignmentRight;
                [cell.contentView addSubview:liChenglael];
                [cell.contentView addSubview:jyzLabel];
            }
                break;
            case 8:{
                UILabel *liChenglael = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 90, 30)];
                liChenglael.text = @"备注:";
                UILabel *beiZhuLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 5, 170, 30)];
                beiZhuLabel.text = counter.oil_note;
                self.myNoteLabel = beiZhuLabel;
                beiZhuLabel.textAlignment = NSTextAlignmentRight;
                [cell.contentView addSubview:liChenglael];
                [cell.contentView addSubview:beiZhuLabel];
            } break;
            default:break;
        }
    }
    
    return cell;
    
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 7 || textField.tag == 8) {
        self.myTableView.frame = CGRectMake(0,-216 ,[[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height);
    }
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 7 || textField.tag == 8) {
        self.myTableView.frame = CGRectMake(0,0 ,[[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height);
    }
}

-(void)Changed:(UISegmentedControl *)sender
{
    self.isFull = sender.selectedSegmentIndex;
}

-(void)viewWillAppear:(BOOL)animated{
    
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height)];
    toolBar.backgroundColor = [UIColor clearColor];
    toolBar.alpha = 0.8;
    toolBar.hidden = YES;
    self.myToolBar = toolBar;
    [self.view addSubview:toolBar];
    
    UIButton *label = [[UIButton alloc]initWithFrame:CGRectMake(-160, -80, 200, 110)];
    label.backgroundColor = [UIColor whiteColor];
    label.layer.cornerRadius = 10;
    self.mylabel = label;
    //确认按钮
    UIButton *queRenButton = [[UIButton alloc]initWithFrame:CGRectMake(50, 10, 100, 40)];
    [queRenButton setTitle:@"确认" forState:UIControlStateNormal];
    [queRenButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [queRenButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [queRenButton addTarget:self action:@selector(queRen:) forControlEvents:UIControlEventTouchDown];
    queRenButton.layer.cornerRadius = 10;
    [label addSubview:queRenButton];
    //取消按钮
    UIButton *quXiaoButton = [[UIButton alloc]initWithFrame:CGRectMake(50, 60, 100, 40)];
    [quXiaoButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [quXiaoButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [quXiaoButton setTitle:@"取消" forState:UIControlStateNormal];
    [quXiaoButton addTarget:self action:@selector(quXiao:) forControlEvents:UIControlEventTouchDown];
    quXiaoButton.layer.cornerRadius = 10;
    [label addSubview:quXiaoButton];
    
    UIPickerView *pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 800, 320, 100)];
    
    //选中的时候会出现一个框
    pickerView.showsSelectionIndicator = YES;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    self.myPicView = pickerView;
    
    UIDatePicker *datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 800, 320, 100)];
    datePicker.datePickerMode = daylight;
    [datePicker addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    [datePicker setTimeZone:[NSTimeZone timeZoneWithName:@"zh_Hans_CN"]];
    self.myDatePicker = datePicker;
    
    //创建输入的textFiel和button
    UIButton *myButtonText = [[UIButton alloc]initWithFrame:CGRectMake(0, -44, 0, 0)];
    myButtonText.backgroundColor = [UIColor lightGrayColor];
    
    UITextField *myTextField = [[UITextField alloc]initWithFrame:CGRectMake(10, 7, [[UIScreen mainScreen]bounds].size.width - 90, 30)];
    myTextField.delegate = self;
    //myTextField.keyboardType = UIKeyboardTypeNumberPad;
    myTextField.layer.cornerRadius = 10;
    myTextField.backgroundColor = [UIColor whiteColor];
    
    //判断输入内容的类型符不符合要求的方法
    [myTextField addTarget:self action:@selector(myTextFieldClicked:) forControlEvents:UIControlEventEditingChanged];
    //myTextField.placeholder = @"<#string#>"
    self.myInsertTextFied = myTextField;
    myTextField.layer.borderWidth = 1;
    //点击单元格弹出的取消按钮
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(240, 7, 70, 30)];
    
    [button setTitle:@"Cancel" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(cancelClicked:) forControlEvents:UIControlEventTouchUpInside];
    [myButtonText addSubview:myTextField];
    [myButtonText addSubview:button];
    self.myTextButton = myButtonText;
    

    
    [self.view addSubview:datePicker];
    
    [self.view addSubview:label];
    [self.view addSubview:pickerView];
    [self.view addSubview:myButtonText];
}

//在字符串中提取数字
-(NSString *)numberTiQUWith:(NSString *)sender{
    NSMutableString *strippedString = [NSMutableString
                                       stringWithCapacity:sender.length];
    
    NSScanner *scanner = [NSScanner scannerWithString:sender];
    NSCharacterSet *numbers = [NSCharacterSet
                               characterSetWithCharactersInString:@"0123456789"];
    
    while ([scanner isAtEnd] == NO) {
        NSString *buffer;
        if ([scanner scanCharactersFromSet:numbers intoString:&buffer]) {
            [strippedString appendString:buffer];
        }
        // --------- Add the following to get out of endless loop
        else {
            [scanner setScanLocation:([scanner scanLocation] + 1)];
        }
        // --------- End of addition
    }
    return strippedString;

}

#pragma mark -textField 代理方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [UIView animateWithDuration:1 animations:^{
        self.myTextButton.frame = CGRectMake(0, -44, 0, 0);
        
    }];
    
    
    
    switch (cellNum) {
        case 1:
            self.myLcbLabel.text = [self numberTiQUWith:self.myInsertTextFied.text];
            self.myLcbLabel.textColor = [UIColor blackColor];
            break;
        case 2:
            self.myJylLabel.text = [self numberTiQUWith:self.myInsertTextFied.text];
            self.myJylLabel.textColor = [UIColor blackColor];
            self.myDanjiaLabel.text =  [NSString stringWithFormat:@"%g",[self.myRmbLabel.text floatValue]/[self.myJylLabel.text floatValue]];
            break;
        case 3:
            self.myRmbLabel.text = [self numberTiQUWith:self.myInsertTextFied.text];
            self.myRmbLabel.textColor = [UIColor blackColor];
            self.myDanjiaLabel.text =  [NSString stringWithFormat:@"%g",[self.myRmbLabel.text floatValue]/[self.myJylLabel.text floatValue]];
            break;
        case 4:
            self.myDanjiaLabel.text =  [NSString stringWithFormat:@"%g",[self.myRmbLabel.text floatValue]/[self.myJylLabel.text floatValue]];
            break;
        case 7:
            self.myStationLabel.text = self.myInsertTextFied.text;
            self.myStationLabel.textColor = [UIColor blackColor];
            break;
        case 8:
            self.myNoteLabel.text = self.myInsertTextFied.text;
            self.myNoteLabel.textColor = [UIColor blackColor];
            break;
            
        default:
            break;
    }

    
    [textField resignFirstResponder];
    return YES;
}

//输入的文本改变是调用的方法

-(void)myTextFieldClicked:(UITextField *)sender{
    NSLog(@"huhu");
}


//点击单元格弹出的取消按钮
-(void)cancelClicked:(UIButton *)sender{
    NSLog(@"3333333");
    //输入框失去第一焦点
    [self.myInsertTextFied resignFirstResponder];
    //让所有的Cell可以点击
    for (int i = 0; i < 9; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UITableViewCell *cell = [self.myTableView cellForRowAtIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    //动画
    [UIView animateWithDuration:1 animations:^{
        self.myTextButton.frame = CGRectMake(0, -44, 0, 0);
        
    }];


    
}

//datePicker
-(void)change:(id)sender{
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc]init];
    [myDateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.myDateLabel.text = [myDateFormatter stringFromDate:[sender date]];
    
}


- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.myInsertTextFied.tag = indexPath.row;
    if (indexPath.row == 5) {
        self.myToolBar.hidden = NO;
        [UIView animateWithDuration:1 animations:^{
            self.myPicView.frame = CGRectMake(0, 400, 320, 100);
            self.mylabel.frame = CGRectMake(60, 280, 200, 110);
        }];
        
    }
    else if (indexPath.row == 0)
    {
        self.myToolBar.hidden = NO;
        [UIView animateWithDuration:1 animations:^{
            self.myDatePicker.frame = CGRectMake(0, 400, 320, 100);
            self.mylabel.frame = CGRectMake(60, 280, 200, 110);
        }];

    }
    else if(indexPath.row == 9)
    {
        NSLog(@"Route row selected");
        MyRouteViewController * routeViewController = [[MyRouteViewController alloc] init];
        [self.navigationController pushViewController:routeViewController animated:YES];
    }
    else
    {
        [self.myInsertTextFied becomeFirstResponder];
        cellNum = indexPath.row;
        //让所有的Cell不可以点击
        for (int i = 0; i < 9; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }

        
        
        [UIView animateWithDuration:1 animations:^{
            self.myTextButton.frame = CGRectMake(0, 64, [[UIScreen mainScreen]bounds].size.width, 44);
            
        }];
        //判断里面的提示内容
        if (self.panduan == 0) {
            self.myInsertTextFied.text = @"";

        }
        else{
            
            switch (indexPath.row) {
                case 1:{
                    self.myInsertTextFied.text = self.myLcbLabel.text;
                }
                    break;
                case 2:{
                    self.myInsertTextFied.text = self.myJylLabel.text;
                }
                    break;
                case 3:{
                    self.myInsertTextFied.placeholder =
                    self.myRmbLabel.text;
                }
                    break;
                    
                    
                default:
                    break;
            }
            
            

        
        }
        switch (indexPath.row) {
            case 1:{
                self.myInsertTextFied.placeholder = @"输入当前里程表读数";
            }
                break;
            case 2:{
                self.myInsertTextFied.placeholder = @"输入加油量";
            }
                break;
            case 3:{
                self.myInsertTextFied.placeholder = @"输入本次加油金额";
            }
                break;
                
                
            default:
                break;
        }

    }
}

-(void)queRen:(UIButton *)sender{
    
    self.myToolBar.hidden = YES;
    [UIView animateWithDuration:1 animations:^{
        self.myPicView.frame = CGRectMake(0, 600, 320, 100);
        self.myDatePicker.frame = CGRectMake(0, 600, 320, 100);
        self.mylabel.frame = CGRectMake(460, -80, 200, 110);
    }];

    
    if (self.panduan == 0) {
        //根据pickerView决定汽油类型(不对)
        self.myLeiXiangLabel.text = [self.myQiYouArray objectAtIndex:self.myPicView.numberOfComponents];
    }else{
        NSLog(@"   %d",self.myPicView.numberOfComponents);
        self.myLeiXiangLabel.text = [self.myQiYouArray objectAtIndex:self.myPicView.numberOfComponents];
    }
    
}

-(void)quXiao:(UIButton *)sender{
    NSLog(@"111111");
    self.myToolBar.hidden = YES;
    [UIView animateWithDuration:1 animations:^{
        self.myPicView.frame = CGRectMake(0, 600, 320, 100);
        self.myDatePicker.frame = CGRectMake(0, 600, 320, 100);
        self.mylabel.frame = CGRectMake(460, -80, 200, 110);
    }];
    if (self.panduan == 0) {
        NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
        [dateformatter setDateFormat:@"yyyy-MM-dd"];
        self.myDateLabel.text = [dateformatter stringFromDate:[NSDate date]];
        

    }else{
        Counter *counter = [self.myDataArray objectAtIndex:self.panduan - 1];
        self.myDateLabel.text = counter.oil_date;
    }

}


#pragma mark -pickerView 数据源方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
    
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 2;
}

#pragma mark - PickerView delegate方法
//添加数据源
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [self.myQiYouArray objectAtIndex:row];
}

//确定已经选择了某一列的某一行之后会触发该方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.myLeiXiangLabel.text = [self.myQiYouArray objectAtIndex:row];
}

@end

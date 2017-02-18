//
//  ModifyPhoneViewController.m
//  OilWearCounter
//
//  Created by Tony Zhao on 5/3/15.
//  Copyright (c) 2015 Tony Zhao. All rights reserved.
//

#import "ModifyPhoneViewController.h"

@interface ModifyPhoneViewController ()

@end

@implementation ModifyPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"修改号码";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UITextField* telField=[[UITextField alloc] init];
    telField.frame=CGRectMake(65, 155+20,(self.view.frame.size.width - 30)*3/4 , 40+20/4);
    telField.borderStyle= UITextBorderStyleRoundedRect;
    self.telField = telField;
    
    NSError *error;
    NSString *paths = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *FileName=[paths stringByAppendingPathComponent:@"phonenumber"];
    NSString * savePhoneNumber = [[NSString alloc] initWithContentsOfFile:FileName encoding:NSUTF8StringEncoding error:&error];
    
    telField.placeholder= savePhoneNumber;
    telField.keyboardType=UIKeyboardTypePhonePad;
    telField.clearButtonMode=UITextFieldViewModeWhileEditing;
    [self.view addSubview:telField];
    
    UIButton* submitButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [submitButton setTitle:@"修改号码" forState:UIControlStateNormal];
    NSString *icon = [NSString stringWithFormat:@"smssdk.bundle/button4.png"];
    [submitButton setBackgroundImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    submitButton.frame=CGRectMake(10, 220+20, self.view.frame.size.width - 20, 42);
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submitChangedPhone) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitButton];
    

}

- (void)submitChangedPhone
{
    NSLog(@"submited");
    [self.telField resignFirstResponder];
    if(self.telField.text.length != 11)
    {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"notice", nil)
                                                      message:NSLocalizedString(@"errorphonenumber", nil)
                                                     delegate:self
                                            cancelButtonTitle:NSLocalizedString(@"sure", nil)
                                            otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *paths = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"%@",paths);
    NSString *FileName=[paths stringByAppendingPathComponent:@"phonenumber"];
    if ([fileManager fileExistsAtPath:FileName])
    {
        NSLog(@"file exist");
    }
    else
    {
        [fileManager createFileAtPath:FileName contents:nil attributes:nil];
    }
    if( [self.telField.text writeToFile:FileName atomically:YES encoding:NSUTF8StringEncoding error:&error])
    {
        NSLog(@"write success");
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"请注意"
                                                      message:@"号码修改成功"
                                                     delegate:self
                                            cancelButtonTitle:@"确认"
                                            otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        NSLog(@"write failed ");
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"请注意"
                                                      message:@"号码修改失败，请再试一次"
                                                     delegate:self
                                            cancelButtonTitle:@"确认"
                                            otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - UITextFieldDelegate
//
//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    NSLog(@"DidEndEditing");
//}

@end

//
//  NGViewController.m
//  OilWearCounter
//
//  Created by Tony Zhao on 5/3/15.
//  Copyright (c) 2015 Tony Zhao. All rights reserved.
//

#import "NGViewController.h"
#import "RegViewController.h"

#import "RZTransitionsInteractionControllers.h"
#import "RZTransitionsAnimationControllers.h"
#import "RZTransitionInteractionControllerProtocol.h"
#import "RZTransitionsManager.h"

int a = 0;//按过的数字键个数
int b = 0;//判断数据库有没有密码 b=1表示没有 b=0表示有
int c = 0;//c用来判断第几次设置密码

@interface NGViewController () <RZTransitionInteractionControllerDelegate>

@property (nonatomic, strong) id<RZTransitionInteractionController> pushPopInteractionController;

@end

@implementation NGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.navigationController.navigationBarHidden = YES;
    
    
    self.pushPopInteractionController = [[RZHorizontalInteractionController alloc] init];
    [self.pushPopInteractionController setNextViewControllerDelegate:self];
    [self.pushPopInteractionController attachViewController:self withAction:RZTransitionAction_PushPop];
    [[RZTransitionsManager shared] setInteractionController:self.pushPopInteractionController
                                         fromViewController:[self class]
                                           toViewController:[View2Controller class]
                                                  forAction:RZTransitionAction_PushPop];
    
    
    
    [[RZTransitionsManager shared] setAnimationController:[[RZCirclePushAnimationController alloc] init]
                                       fromViewController:[self class]
                                                forAction:RZTransitionAction_PushPop];

    //初始化密码字符串
    self.passWordString = @"";
    self.firstPassWord = @"";
    self.secondPassWord = @"";
    
	UIImageView *myImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height)];
    myImageView.image = [UIImage imageNamed:@"background3.jpg"];
    
    
    //显示密码的小圈
    [self.view addSubview:myImageView];
    for (int i = 0; i < 4; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(78+48 * i, 60, 20, 20)];
        label.backgroundColor = [UIColor clearColor];
        label.layer.borderWidth = 1;
        label.layer.masksToBounds = YES;
        label.layer.borderColor = [[UIColor whiteColor]CGColor];
        label.layer.cornerRadius = 10;
        label.tag = i + 1;
        [self.view addSubview:label];
    }

    int cnt = 0;
    for(int i = 0; i < 4; i++ )
    {
        for(int j = 0; j < 3; j++)
        {
            cnt++;
            
            UIButton * numberButton = [[UIButton alloc] init];
            if(i != 3)
            {
                [numberButton setFrame:CGRectMake(22 + (92 * j), 120 + (110 * i), 70, 70)];
            }
            else if( i==3 && j==2 )
            {
                [numberButton setFrame:CGRectMake(114, 450, 70, 70)];
                cnt = 0;
            }
            

            numberButton.backgroundColor = [UIColor clearColor];
            numberButton.layer.borderColor = [[UIColor whiteColor]CGColor];
            numberButton.layer.borderWidth = 1;
            numberButton.layer.cornerRadius = 35;

            
            NSNumber * showNumber = [NSNumber numberWithInteger:cnt];
            NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
            NSString* numStr = [numberFormatter stringFromNumber:showNumber];
            [numberButton setTitle:numStr forState:UIControlStateNormal];
            
            numberButton.titleLabel.font = [UIFont systemFontOfSize:40];
            [numberButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
            [numberButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:numberButton];
            
        }
    }

    UIButton * forgetButton = [[UIButton alloc] initWithFrame:CGRectMake(206,450,70,70)];
    forgetButton.backgroundColor = [UIColor clearColor];
    forgetButton.layer.borderColor = [[UIColor whiteColor]CGColor];
    forgetButton.layer.borderWidth = 1;
    forgetButton.layer.cornerRadius = 35;
    [forgetButton setTitle:@"忘" forState:UIControlStateNormal];
    forgetButton.titleLabel.font = [UIFont systemFontOfSize:40];
    [forgetButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [forgetButton addTarget:self action:@selector(forgetPassword) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetButton];
    
    self.tiShiLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 80, 160, 40)];
    self.tiShiLabel.textColor = [UIColor redColor];
    [self.view addSubview:self.tiShiLabel];
    self.tiShiLabel.text = @"请设置登陆密码";
    self.tiShiLabel.hidden = YES;
    
    

}
-(void)viewWillAppear:(BOOL)animated{
    //判断数据库中有没有密码.没有就改变b的值.第一次就是设置密码
    if ([[[CounterDatabase counterDatabase]tablePassWord] isEqualToString:@""])
    {
        b = 1;
        self.tiShiLabel.hidden = NO;
    }
}

-(void)buttonClicked:(UIButton *)btn{
    
    if (b == 0) {//0代表有密码
        
        
        a++;
        [self.view viewWithTag:a].backgroundColor = [UIColor whiteColor];
        NSLog(@"%@",btn.titleLabel.text);
        self.passWordString = [self.passWordString stringByAppendingString:btn.titleLabel.text];
        NSLog(@"asds%@",self.passWordString);
        
        
        if (a == 4) {
            
            
            if ([self.passWordString isEqualToString:[[CounterDatabase counterDatabase]tablePassWord]])
            {
                View2Controller *view2Controller = [[View2Controller alloc]init];
                [self.navigationController pushViewController:view2Controller animated:YES];
            }
            else
            {
                for (int i = 1; i<5; i++)
                {
                    [self.view viewWithTag:i].backgroundColor = [UIColor clearColor];
                }
            }
            //[passWord release];
            a = 0;
            self.passWordString = @"";
            
        }
    }
    else{
        //c用来判断第几次设置密码
        if (c == 0)
        {
            a++;
            
            [self.view viewWithTag:a].backgroundColor = [UIColor whiteColor];
            NSLog(@"%@",btn.titleLabel.text);
            
            
            self.firstPassWord = [self.firstPassWord stringByAppendingString:btn.titleLabel.text];
            if (a == 4) {
                for (int i = 1; i<5; i++) {
                    [self.view viewWithTag:i].backgroundColor =[UIColor clearColor];
                }
                    a = 0;
                    c = 1;
                    self.tiShiLabel.text = @"请再次确认登陆密码";

            }
            
        }
        else
        {
            a++;
            [self.view viewWithTag:a].backgroundColor = [UIColor whiteColor];
            self.secondPassWord = [self.secondPassWord stringByAppendingString:btn.titleLabel.text];
            
            
            if (a == 4) {
                if ([self.firstPassWord isEqualToString:self.secondPassWord]) {
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"密码设置成功,注意保存。请输入一个绑定电话号码，以防忘记密码" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
                    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
                    
                    [[alertView textFieldAtIndex:0] resignFirstResponder];
                    [[alertView textFieldAtIndex:0] setKeyboardType:UIKeyboardTypePhonePad];
                    [[alertView textFieldAtIndex:0] becomeFirstResponder];
                    [alertView show];

                    [[CounterDatabase counterDatabase] insertToTableSettingWith:self.secondPassWord];
                    
                    
                    View2Controller *view2Controller = [[View2Controller alloc] init];
                    [self.navigationController pushViewController:view2Controller animated:YES];
                }else{
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"两次输入的密码不同,请从新输入" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
                    alertView.alertViewStyle = UIAlertViewStyleDefault;
                    [alertView show];
                    self.tiShiLabel.text = @"请设置登陆密码";
                    
                }
                for (int i = 1; i<5; i++) {
                    [self.view viewWithTag:i].backgroundColor =[UIColor clearColor];
                }
                c= 0;
                a = 0;
                self.firstPassWord = @"";
                self.secondPassWord = @"";
                
            }
        }
    }
    
}


- (void)forgetPassword
{
    RegViewController * reg = [[RegViewController alloc] init];
    //[self presentViewController:reg animated:YES completion:nil];
    [self.navigationController pushViewController:reg animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        NSLog(@"%@",[[alertView textFieldAtIndex:0] text]);
        
        
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
        if( [[[alertView textFieldAtIndex:0] text] writeToFile:FileName atomically:YES encoding:NSUTF8StringEncoding error:&error])
        {
            NSLog(@"write success");
        }
        else
        {
            NSLog(@"write failed ");
        }
    }
}


@end

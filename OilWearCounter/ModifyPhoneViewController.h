//
//  ModifyPhoneViewController.h
//  OilWearCounter
//
//  Created by Tony Zhao on 5/3/15.
//  Copyright (c) 2015 Tony Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModifyPhoneViewController : UIViewController<UITextFieldDelegate>

@property(nonatomic,strong) UITextField* telField;
@property(nonatomic,strong) UIButton* submitButton;

@end

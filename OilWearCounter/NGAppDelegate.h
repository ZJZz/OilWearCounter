//
//  NGAppDelegate.h
//  OilWearCounter
//
//  Created by Tony Zhao on 5/3/15.
//  Copyright (c) 2015 Tony Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

@interface NGAppDelegate : UIResponder <UIApplicationDelegate,BMKGeneralDelegate>

@property (nonatomic,strong) UIWindow *window;
@property (nonatomic,assign) NSInteger awc;
@property (nonatomic,strong) BMKMapManager* mapManager;

@end

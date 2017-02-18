//
//  MyRouteViewController.h
//  OilWearCounter
//
//  Created by Tony Zhao on 3/16/15.
//  Copyright (c) 2015 Tony Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

@interface MyRouteViewController : UIViewController<BMKMapViewDelegate>
{
    BMKMapView * _mapView;
}

@property (nonatomic,copy) NSString * date;

@end

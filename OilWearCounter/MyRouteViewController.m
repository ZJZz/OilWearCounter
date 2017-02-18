//
//  MyRouteViewController.m
//  OilWearCounter
//
//  Created by Tony Zhao on 3/16/15.
//  Copyright (c) 2015 Tony Zhao. All rights reserved.
//

#import "MyRouteViewController.h"

@interface MyRouteViewController ()

@end

@implementation MyRouteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height)];
    //self.date = [[NSString alloc] init];
    
    [self.view addSubview:_mapView];
    
    //draw line
    BMKPolyline* polyline = [[BMKPolyline alloc] init];
    
    
    [_mapView setZoomLevel:11];
    
    
//    NSDateFormatter * dateformatter = [[NSDateFormatter alloc] init];
//    [dateformatter setDateFormat:@"YYYYMMdd"];//YYYYMMDDHHmmss
    
    NSString *paths = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSLog(@"self.date: %@",self.date);
    
    [self setTitle:self.date];
    
    //read longtitude file
    NSString *FileName_long=[paths stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_longtitude",self.date]];
    
    NSArray * longtitudeArray = [[NSArray alloc] initWithContentsOfFile:FileName_long];
    NSLog(@"Longtitude Array %@",longtitudeArray);
    
    //read latitude file
    NSString *FileName_lati=[paths stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_latitude",self.date]];
    NSArray * latitudeArray = [[NSArray alloc] initWithContentsOfFile:FileName_lati];
    NSLog(@"latitude Array %@",latitudeArray);
    
    
   
    NSInteger count = [longtitudeArray count];
    CLLocationCoordinate2D coors[100] = {0};
    for(int i = 0; i < (int)count; i++ )
    {
        coors[i].longitude = [[longtitudeArray objectAtIndex:i] doubleValue];
        coors[i].latitude = [[latitudeArray objectAtIndex:i] doubleValue];
    }
    for(int i = 0; i < (int)count; i++)
    {
        printf("coors[%d] %lf %lf\n",i,coors[i].longitude,coors[i].latitude);
    }
    
    polyline = [BMKPolyline polylineWithCoordinates:coors count:count];
    
    [_mapView addOverlay:polyline];

    
}

//- (void)addOverlayView
//{
//    NSInteger count = [longtitudeArray count];
//    CLLocationCoordinate2D coors[100] = {0};
//    for(int i = 0; i < (int)count; i++ )
//    {
//        coors[i].longitude = [[longtitudeArray objectAtIndex:i] doubleValue];
//        coors[i].longitude = [[latitudeArray objectAtIndex:i] doubleValue];
//    }
//    polyline = [BMKPolyline polylineWithCoordinates:coors count:count];
//}

//根据overlay生成对应的View
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]])
    {
        NSLog(@"isKindOfClass BMKPolyline");
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:1];
        polylineView.lineWidth = 20.0;
        [polylineView loadStrokeTextureImage:[UIImage imageNamed:@"texture_arrow.png"]];
        
        return polylineView;
    }
    NSLog(@"isNotKindOfClass BMKPolyline");
    return nil;
}

-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}

- (void)dealloc
{
    if (_mapView)
    {
        _mapView = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

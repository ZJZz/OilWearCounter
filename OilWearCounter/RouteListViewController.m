//
//  RouteListViewController.m
//  OilWearCounter
//
//  Created by Tony Zhao on 4/25/15.
//  Copyright (c) 2015 Tony Zhao. All rights reserved.
//

#import "RouteListViewController.h"
#import "MyRouteViewController.h"

#import "RZTransitionsInteractionControllers.h"
#import "RZTransitionsAnimationControllers.h"
#import "RZTransitionInteractionControllerProtocol.h"
#import "RZTransitionsManager.h"


@interface RouteListViewController () <RZTransitionInteractionControllerDelegate>
@property (nonatomic, strong) id<RZTransitionInteractionController> pushPopInteractionController;
@end

@implementation RouteListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"行驶路线";
    
    self.pushPopInteractionController = [[RZHorizontalInteractionController alloc] init];
    [self.pushPopInteractionController setNextViewControllerDelegate:self];
    [self.pushPopInteractionController attachViewController:self withAction:RZTransitionAction_PushPop];
    [[RZTransitionsManager shared] setInteractionController:self.pushPopInteractionController
                                         fromViewController:[self class]
                                           toViewController:[MyRouteViewController class]
                                                  forAction:RZTransitionAction_PushPop];
    
    
    
    [[RZTransitionsManager shared] setAnimationController:[[RZCardSlideAnimationController alloc] init]
                                       fromViewController:[self class]
                                                forAction:RZTransitionAction_PushPop];
    [[RZTransitionsManager shared] setAnimationController:[[RZZoomPushAnimationController alloc] init]
                                       fromViewController:[MyRouteViewController class]
                                         toViewController:[self class]
                                                forAction:RZTransitionAction_PushPop];
    
    
    UITableView * routeListView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [routeListView setDelegate:self];
    [routeListView setDataSource:self];
    [self.view addSubview:routeListView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark- Delegate - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.monthArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.dayCountInMonthArray objectAtIndex:section] longValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"CellReuse";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    NSUInteger lastGroup = 0;
    for(NSUInteger i = 0; i < indexPath.section; i++)
    {
        lastGroup = lastGroup + [[self.dayCountInMonthArray objectAtIndex:i]longValue];
    }
    NSUInteger index = indexPath.row + lastGroup;
    [cell.textLabel setText:[self.dateArray objectAtIndex:index]];
    
    return cell;
}

#pragma mark - Delegate - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyRouteViewController * myRouteViewController = [[MyRouteViewController alloc] init];
    NSUInteger index = (indexPath.section)*([[self.dayCountInMonthArray objectAtIndex:indexPath.section] longValue])+(indexPath.row);
    myRouteViewController.date = [self.dateArray objectAtIndex:index];
    [self.navigationController pushViewController:myRouteViewController animated:YES];
}

@end

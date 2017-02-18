//
//  TableViewCell.h
//  OilWearCounter
//
//  Created by 智享 on 14-9-26.
//  Copyright (c) 2014年 智享. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@property (strong, nonatomic) IBOutlet UILabel *jylLabel;
@property (strong, nonatomic) IBOutlet UILabel *rmbLabel;
@property (strong, nonatomic) IBOutlet UILabel *pingJunLabel;
@end

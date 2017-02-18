//
//  TableViewCell.m
//  OilWearCounter
//
//  Created by 智享 on 14-9-26.
//  Copyright (c) 2014年 智享. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//oil_id,oil_date,oil_lcb,oil_jyl,oil_takermb,oil_danjia,oil_type,oil_isfull,oil_station,oil_note )
//values(0, '2014-09-26',250,40,400,10,1,0,'东风','不爱加');


@end

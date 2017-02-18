//
//  MyCollectionViewCell.m
//  LearnCollectionView
//
//  Created by Tony Zhao on 4/30/15.
//  Copyright (c) 2015 Tony Zhao. All rights reserved.
//

#import "MyCollectionViewCell.h"

@implementation MyCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = [UIColor whiteColor];
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
        [self addSubview:self.dateLabel];
        
        self.mileLabel = [[UILabel alloc] initWithFrame:CGRectMake(60,40 , 200, 40)];
        [self.mileLabel setText:@"里程: 0元/天"];
        [self addSubview:self.mileLabel];
        
        self.oilCosumLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 80, 200, 40)];
        [self.oilCosumLabel setText:@"油耗: 0元/天"];
        [self addSubview:self.oilCosumLabel];
        
        self.oilPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 120, 200, 40)];
        [self.oilPriceLabel setText:@"油费: 0元/天"];
        [self addSubview:self.oilPriceLabel];
    }
    return self;
}

@end

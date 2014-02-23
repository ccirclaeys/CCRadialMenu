//
//  CCRadialButtonView.m
//  RadialEx
//
//  Created by Charles Circlaeys on 02/02/2014.
//  Copyright (c) 2014 Charles Circlaeys. All rights reserved.
//

#import "CCRadialButtonView.h"

@implementation CCRadialButtonView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:_titleLabel];
        
        // Initialization code
    }
    return self;
}

- (void)setText:(NSString*)text
{
    _titleLabel.text = text;
    [_titleLabel sizeToFit];
    _titleLabel.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

//
//  CoordinatingController.h
//  RadialEx
//
//  Created by Charles Circlaeys on 02/02/2014.
//  Copyright (c) 2014 Charles Circlaeys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoordinatingController : NSObject
{
    UIViewController *_activeViewController;
}

@property (nonatomic, strong) UIViewController *rootViewController;

+ (CoordinatingController*)sharedInstance;
- (void)requestViewChangeByObject:(id)object;

@end

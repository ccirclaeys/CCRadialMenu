//
//  ViewController.h
//  RadialEx
//
//  Created by Charles Circlaeys on 29/01/2014.
//  Copyright (c) 2014 Charles Circlaeys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCRadialMenuView.h"

#define kMenuSize 5

#define kButtonSize 40

@interface RootViewController : UIViewController
<CCRadialMenuViewDataSource, CCRadialMenuViewDelegate>

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSMutableArray *buttonsArray;

@property (nonatomic, strong) CCRadialMenuView *radialMenuView;

- (void)setupRadialMenu;
- (void)setupRadialButtons;

@end

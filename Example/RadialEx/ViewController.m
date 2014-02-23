//
//  ViewController1.m
//  RadialEx
//
//  Created by Charles Circlaeys on 02/02/2014.
//  Copyright (c) 2014 Charles Circlaeys. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = self.identifier;
    [label sizeToFit];
    label.center = self.view.center;
    [self.view addSubview:label];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupRadialButtons
{
    self.buttonsArray = [NSMutableArray arrayWithCapacity:kMenuSize];
    
    for (NSInteger i = 0; i < kMenuSize; ++i)
    {
        CCRadialButtonView *view = [[CCRadialButtonView alloc] initWithFrame:CGRectMake(0, 0, kButtonSize, kButtonSize)];
        
        view.backgroundColor = [UIColor blueColor];
        view.layer.cornerRadius = view.frame.size.width / 2;
        view.clipsToBounds = YES;
        
        if (self.identifier.integerValue == i + 1)
            [view setText:@"home"];
        else
            [view setText:[NSString stringWithFormat:@"%d", i + 1]];
        
        [self.buttonsArray addObject:view];
    }
}

@end

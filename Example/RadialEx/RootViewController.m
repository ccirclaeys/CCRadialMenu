//
//  ViewController.m
//  RadialEx
//
//  Created by Charles Circlaeys on 29/01/2014.
//  Copyright (c) 2014 Charles Circlaeys. All rights reserved.
//

#import "RootViewController.h"
#import "CoordinatingController.h"
#import "CCRadialButtonView.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (id)init
{
    if (self = [super init])
    {
        self.identifier = @"home";
    }
    return self;
}

- (void)setupRadialMenu
{
    _radialMenuView = [[CCRadialMenuView alloc] init];
    _radialMenuView.dataSource = self;
    _radialMenuView.delegate = self;
    _radialMenuView.hidden = YES;
    _radialMenuView.offset = 20;
    _radialMenuView.shouldDisplayOnError = YES;
    
    [self.view addSubview:_radialMenuView];
}

- (void)setupRadialButtons
{
    _buttonsArray = [NSMutableArray arrayWithCapacity:kMenuSize];
    
    for (NSInteger i = 0; i < kMenuSize; ++i)
    {
        CCRadialButtonView *view = [[CCRadialButtonView alloc] initWithFrame:CGRectMake(0, 0, kButtonSize, kButtonSize)];
        
        view.backgroundColor = [UIColor blueColor];
        view.layer.cornerRadius = view.frame.size.width / 2;
        view.clipsToBounds = YES;
        [view setText:[NSString stringWithFormat:@"%d", i + 1]];
        [_buttonsArray addObject:view];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    _radialMenuView.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupRadialMenu];
    [self setupRadialButtons];
    
//    UIView *back = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//    back.backgroundColor = [UIColor redColor];
//    
//    _radialMenuView.backgroundView = back;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    
    _radialMenuView.hidden = NO;
    _radialMenuView.center = point;
    [_radialMenuView display];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_radialMenuView touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    _radialMenuView.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (CGSize)radialButtonSizeForRadialMenuView:(CCRadialMenuView *)radialMenuView
{
    return CGSizeMake(40, 40);
}

- (NSInteger)numberOfButtonsForRadialMenuView:(CCRadialMenuView *)radialMenuView
{
    return _buttonsArray.count;
}

- (UIView *)radialMenuView:(CCRadialMenuView *)radialMenuView buttonForIndex:(NSInteger)index
{
    return [_buttonsArray objectAtIndex:index];
}

- (void)radialMenuView:(CCRadialMenuView *)radialMenuView didSelectViewAtIndex:(NSInteger)index
{
    [[CoordinatingController sharedInstance] requestViewChangeByObject:[_buttonsArray objectAtIndex:index]];
}

- (void)radialMenuView:(CCRadialMenuView *)radialMenuView didFailToDisplayForError:(CCRadialErrorType)error
{
    NSLog(@"didFailToDisplayForError");
}

- (void)radialMenuView:(CCRadialMenuView *)radialMenuView didChangeRadius:(CGFloat)radius
{
    _radialMenuView.backgroundView.frame = CGRectMake(_radialMenuView.frame.origin.x, _radialMenuView.frame.origin.y, radius * 2, radius * 2);
}

@end

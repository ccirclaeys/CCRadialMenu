//
//  CoordinatingController.m
//  RadialEx
//
//  Created by Charles Circlaeys on 02/02/2014.
//  Copyright (c) 2014 Charles Circlaeys. All rights reserved.
//

#import "CoordinatingController.h"
#import "ViewController.h"
#import "CCRadialButtonView.h"

@implementation CoordinatingController

+ (CoordinatingController*)sharedInstance
{
    static CoordinatingController *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CoordinatingController allocWithZone:nil] init];
    });
    return sharedInstance;
}

- (void)requestViewChangeByObject:(id)object
{
    if ([object isKindOfClass:[CCRadialButtonView class]])
    {
        CCRadialButtonView *view = (CCRadialButtonView*)object;
        ViewController *vc = [[ViewController alloc] init];
        vc.identifier = view.titleLabel.text;
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

        if (vc)
        {
            if (_activeViewController)
            {
                if ([vc.identifier isEqualToString:@"home"])
                {
                    [self topTransitionFrom:_activeViewController to:vc];
                    _rootViewController = vc;
                    _activeViewController = nil;
                }
                else
                {
                    if (vc.identifier.integerValue > ((RootViewController*)_activeViewController).identifier.integerValue)
                        [self rightTransitionFrom:_activeViewController to:vc];
                    else
                        [self leftTransitionFrom:_activeViewController to:vc];
                    
                    _activeViewController = vc;
                }
            }
            else
            {
                [self bottomTransitionFrom:_rootViewController to:vc];
                _activeViewController = vc;
            }
            
        }
    }
    else
    {
        [_rootViewController dismissViewControllerAnimated:YES completion:nil];
        _activeViewController = _rootViewController;
    }
}

- (void)leftTransitionFrom:(UIViewController*)fromViewController to:(UIViewController*)destViewController
{
    UIView *fromView = fromViewController.view;
    UIView *toView = destViewController.view;
    
    CGRect viewSize = fromView.frame;
    
    [fromView.superview addSubview:toView];
    
    toView.frame = CGRectMake(-320, viewSize.origin.y, 320, viewSize.size.height);
    
    [UIView animateWithDuration:0.4 animations:
     ^{
         fromView.frame = CGRectMake(320 , viewSize.origin.y, 320, viewSize.size.height);
         toView.frame = CGRectMake(0, viewSize.origin.y, 320, viewSize.size.height);
     }
    completion:^(BOOL finished)
     {
         if (finished)
         {
             [fromView removeFromSuperview];
         }
     }];
}

- (void)rightTransitionFrom:(UIViewController*)fromViewController to:(UIViewController*)destViewController
{
    UIView *fromView = fromViewController.view;
    UIView *toView = destViewController.view;
    
    CGRect viewSize = fromView.frame;
    
    [fromView.superview addSubview:toView];
    
    toView.frame = CGRectMake(320, viewSize.origin.y, 320, viewSize.size.height);
    
    [UIView animateWithDuration:0.4 animations:
     ^{
         fromView.frame = CGRectMake(-320 , viewSize.origin.y, 320, viewSize.size.height);
         toView.frame = CGRectMake(0, viewSize.origin.y, 320, viewSize.size.height);
     }
                     completion:^(BOOL finished)
     {
         if (finished)
         {
             [fromView removeFromSuperview];
         }
     }];
}

- (void)bottomTransitionFrom:(UIViewController*)fromViewController to:(UIViewController*)destViewController
{
    UIView *fromView = fromViewController.view;
    UIView *toView = destViewController.view;
    
    CGRect viewSize = fromView.frame;
    
    [fromView.superview addSubview:toView];
    
    toView.frame = CGRectMake(viewSize.origin.x, viewSize.size.height, 320, viewSize.size.height);
    
    [UIView animateWithDuration:0.4 animations:
     ^{
         fromView.frame = CGRectMake(viewSize.origin.x, -viewSize.size.height, 320, viewSize.size.height);
         toView.frame = CGRectMake(viewSize.origin.y, 0, 320, viewSize.size.height);
     }
                     completion:^(BOOL finished)
     {
         if (finished)
         {
             [fromView removeFromSuperview];
         }
     }];
}

- (void)topTransitionFrom:(UIViewController*)fromViewController to:(UIViewController*)destViewController
{
    UIView *fromView = fromViewController.view;
    UIView *toView = destViewController.view;
    
    CGRect viewSize = fromView.frame;
    
    [fromView.superview addSubview:toView];
    
    toView.frame = CGRectMake(viewSize.origin.x, -viewSize.size.height, 320, viewSize.size.height);
    
    [UIView animateWithDuration:0.4 animations:
     ^{
         fromView.frame = CGRectMake(viewSize.origin.x, viewSize.size.height, 320, viewSize.size.height);
         toView.frame = CGRectMake(viewSize.origin.y, 0, 320, viewSize.size.height);
     }
                     completion:^(BOOL finished)
     {
         if (finished)
         {
             [fromView removeFromSuperview];
         }
     }];
}

@end

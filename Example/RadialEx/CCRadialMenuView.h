//
//  CCRadialMenu.h
//  RadialEx
//
//  Created by Charles Circlaeys on 29/01/2014.
//  Copyright (c) 2014 Charles Circlaeys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCRadialButtonView.h"

typedef enum
{
    TopAngle = 270,
    RightAngle = 0,
    BottomAngle = 90,
    LeftAngle = 180
} DirectionAngle;

typedef enum
{
    kErrorSizeMax
} CCRadialErrorType;

typedef enum
{
    CCRadialAnimationFromCenter,
    CCRadialAnimationNone
} CCRadialAnimation;

@class CCRadialMenuView;

@protocol CCRadialMenuViewDataSource <NSObject>

- (NSInteger)numberOfButtonsForRadialMenuView:(CCRadialMenuView *)radialMenuView;
- (UIView *)radialMenuView:(CCRadialMenuView *)radialMenuView buttonForIndex:(NSInteger)index;

@end

@protocol CCRadialMenuViewDelegate <NSObject>

- (CGSize)radialButtonSizeForRadialMenuView:(CCRadialMenuView *)radialMenuView;
- (void)radialMenuView:(CCRadialMenuView *)radialMenuView didSelectViewAtIndex:(NSInteger)index;

@optional
- (void)radialMenuView:(CCRadialMenuView *)radialMenuView didFailToDisplayForError:(CCRadialErrorType)error;
- (void)radialMenuView:(CCRadialMenuView *)radialMenuView didChangeRadius:(CGFloat)radius;

@end

@interface CCRadialMenuView : UIView

@property (nonatomic, weak) id <CCRadialMenuViewDataSource> dataSource;
@property (nonatomic, weak) id <CCRadialMenuViewDelegate> delegate;

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, assign) CCRadialAnimation animation;
@property (nonatomic, assign) CGFloat offset;

@property (nonatomic, readonly) CGFloat currentRadius;

- (void)reloadData;
- (void)display;

@end

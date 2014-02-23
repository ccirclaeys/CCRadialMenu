//
//  CCRadialMenu.m
//  RadialEx
//
//  Created by Charles Circlaeys on 29/01/2014.
//  Copyright (c) 2014 Charles Circlaeys. All rights reserved.
//

#import "CCRadialMenuView.h"

const float kDegreeToRadians = M_PI / 180;

@interface CCRadialMenuView()
{
    CGPoint _anchorPoint;
    CGPoint _touchedAreaPoint;
    
    NSDictionary *_valueDict;
    
    NSArray *_collisionKeysArray;
    NSMutableArray *_dataSourceArray;
    
    CGFloat _dataSourceTotalWidth;
    CGFloat _dataSourceTotalHeight;

    CGSize _currentButtonSize;
}

@end

@implementation CCRadialMenuView

- (void)setup
{
    _valueDict = [NSDictionary dictionaryWithObjectsAndKeys:@0, @"right", @90, @"bottom", @180, @"left", @270, @"top", nil];
    _collisionKeysArray = [NSArray arrayWithObjects:@"right", @"bottom", @"left", @"top", nil];
}

- (id)init
{
    self = [super init];
    if (self) {
        
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setup];
    }
    return self;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    NSInteger i = 0;
    for (UIView *view in _dataSourceArray)
    {
        if (CGRectContainsPoint(view.frame, point))
        {
            [self.delegate radialMenuView:self didSelectViewAtIndex:i];
            break;
        }
        ++i;
    }
}

- (void)updateFrame
{
    CGFloat width = 0;
    CGFloat height = 0;
    
    for (UIView *view in _dataSourceArray)
    {
        width += view.frame.size.width;
        height += view.frame.size.height;
        
        width += _offset;
        height += _offset;
    }

    _dataSourceTotalWidth = width;
    _dataSourceTotalHeight = height;
    _touchedAreaPoint = self.center;
    self.frame = CGRectMake(self.center.x - width / 2, self.center.y - height / 2, width, height);
}

- (void)reloadData
{
    NSInteger size = [self.dataSource numberOfButtonsForRadialMenuView:self];
    _dataSourceArray = [[NSMutableArray alloc] initWithCapacity:size];
    
    for (NSInteger i = 0; i < size; ++i)
    {
        [_dataSourceArray addObject:[self.dataSource radialMenuView:self buttonForIndex:i]];
    }
    
    _currentButtonSize = [self.delegate radialButtonSizeForRadialMenuView:self];
}

- (NSDictionary*)checkCollision
{
    CGFloat globalRadius = _dataSourceTotalWidth / M_PI * (CGFloat)(180.f / 360.f);
    
    if (_dataSourceArray.count == 1)
        globalRadius += _currentButtonSize.width / 2;
    
    NSMutableDictionary *collisionDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@NO, @"right", @NO, @"bottom", @NO, @"left", @NO, @"top", nil];
    
    CGFloat rightX = _touchedAreaPoint.x + globalRadius;
    CGFloat leftX = _touchedAreaPoint.x - globalRadius;
    CGFloat bottomY = _touchedAreaPoint.y + globalRadius;
    CGFloat topY = _touchedAreaPoint.y - globalRadius;
    
    if (rightX + _currentButtonSize.width > self.superview.bounds.size.width)
    {
        [collisionDict setObject:@YES forKey:@"right"];
    }
    else if (leftX - _currentButtonSize.width < self.superview.frame.origin.x)
    {
        [collisionDict setObject:@YES forKey:@"left"];
    }
    
    if (bottomY + _currentButtonSize.height > self.superview.bounds.size.height)
    {
        [collisionDict setObject:@YES forKey:@"bottom"];
    }
    else if (topY - _currentButtonSize.height < self.superview.frame.origin.y)
    {
        [collisionDict setObject:@YES forKey:@"top"];
    }
    
    return collisionDict;
}

- (BOOL)isCollisionForRadius:(CGFloat)radius withAngle:(NSInteger)angle
{
    if (angle == 0 || angle == 360)
    {
        return (self.center.x + (radius + _currentButtonSize.width / 2) > self.superview.frame.size.width);
    }
    else if (angle == 90)
    {
        return (self.center.y + (radius + _currentButtonSize.height / 2) > self.superview.frame.size.height);

    }
    else if (angle == 180)
    {
        return (self.center.x - (radius + _currentButtonSize.width / 2) < self.superview.frame.origin.x);

    }
    else if (angle == 270)
    {
        return (self.center.y - (radius + _currentButtonSize.height / 2) < self.superview.frame.origin.y);
    }

    
    return NO;
}

- (NSString*)getStartFromCollisionDict:(NSDictionary*)collisionDict
{
    for (NSInteger i = 0; i < 4; ++i)
    {
        NSString *key = [_collisionKeysArray objectAtIndex:i];
        BOOL value = ((NSNumber*)[collisionDict objectForKey:key]).boolValue;
        
        if (value)
        {
            i += 1;
            
            while (TRUE)
            {
                if (i == 4)
                    i = 0;
                
                NSString *key = [_collisionKeysArray objectAtIndex:i];
                BOOL value = ((NSNumber*)[collisionDict objectForKey:key]).boolValue;
                if (!value)
                    return key;
                
                ++i;
            }
        }
    }
    return nil;
}

- (NSString*)getEndFromCollisionDict:(NSDictionary*)collisionDict
{
    for (NSInteger i = 0; i < 4; ++i)
    {
        NSString *key = [_collisionKeysArray objectAtIndex:i];
        BOOL value = ((NSNumber*)[collisionDict objectForKey:key]).boolValue;
        
        if (value)
        {
            i -= 1;
            while (TRUE)
            {
                if (i < 0)
                    i = 3;
                
                NSString *key = [_collisionKeysArray objectAtIndex:i];
                BOOL value = ((NSNumber*)[collisionDict objectForKey:key]).boolValue;
                if (!value)
                    return key;
                
                --i;
            }
        }
    }
    return nil;
}

- (void)display
{
    for (UIView *subview in self.subviews)
    {
        [subview removeFromSuperview];
    }
    
    if (!_dataSourceArray)
    {
        [self reloadData];
    }
    
    [self updateFrame];
    
    NSDictionary *collisionDict = [self checkCollision];
    
    NSString *startKey = [self getStartFromCollisionDict:collisionDict];
    NSString *endKey = [self getEndFromCollisionDict:collisionDict];
    
    NSInteger startAngle = 0;
    if (startKey && ![startKey isEqualToString:@"right"])
        startAngle = ((NSNumber*)[_valueDict objectForKey:startKey]).integerValue;
    
    NSInteger endAngle = 360;
    if (endKey && ![endKey isEqualToString:@"right"])
        endAngle = ((NSNumber*)[_valueDict objectForKey:endKey]).integerValue;
    
    NSInteger max = (startAngle > endAngle ? startAngle : endAngle);
    NSInteger min = (startAngle < endAngle ? startAngle : endAngle);
    NSInteger maxAngle = max - min;
    
    if (maxAngle <= 0)
    {
        [self.delegate radialMenuView:self didFailToDisplayForError:CCRadialErrorSizeMax];
        return;
    }
    
    if (maxAngle == 90)
    {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width * 1.8f, self.frame.size.height * 1.8f);
    }
    
    CGFloat radius = _dataSourceTotalWidth / M_PI * (CGFloat)(180.f / (CGFloat)maxAngle);
    
    if (maxAngle == 360)
        radius += _currentButtonSize.width / 2;
    
    if (_dataSourceArray.count == 1)
        radius += _currentButtonSize.width / 2;
    
    if (_touchedAreaPoint.x - _currentButtonSize.width / 2 < 0)
    {
        _touchedAreaPoint.x = _currentButtonSize.width / 2;
    }
    else if (_touchedAreaPoint.x > self.superview.bounds.size.width - _currentButtonSize.width / 2)
    {
        _touchedAreaPoint.x = self.superview.bounds.size.width - _currentButtonSize.width / 2;
    }
    
    if (_touchedAreaPoint.y - _currentButtonSize.height / 2 < 0)
    {
        _touchedAreaPoint.y = _currentButtonSize.height / 2;
    }
    else if (_touchedAreaPoint.y > self.superview.bounds.size.height - _currentButtonSize.height / 2)
    {
        _touchedAreaPoint.y = self.superview.bounds.size.height - _currentButtonSize.height / 2;
    }
    
    self.center = _touchedAreaPoint;
    _anchorPoint = [self.superview convertPoint:_touchedAreaPoint toView:self];
    
    if (maxAngle < 360 && ([self isCollisionForRadius:radius withAngle:startAngle] ||
        [self isCollisionForRadius:radius withAngle:endAngle]))
    {
        [self.delegate radialMenuView:self didFailToDisplayForError:CCRadialErrorRadiusCollision];
        if (!_shouldDisplayOnRadiusCollision)
            return;
    }
    
    [self displayWithStart:startAngle maxAngle:maxAngle forCenter:_anchorPoint radius:radius];
    
    if (_currentRadius != radius)
    {
        _currentRadius = radius;
        [self.delegate radialMenuView:self didChangeRadius:_currentRadius];
    }
    
    if (!_backgroundView.superview)
        [self insertSubview:_backgroundView atIndex:0];
    _backgroundView.center = _anchorPoint;
}

- (void)displayWithStart:(NSInteger)startAngle maxAngle:(NSInteger)maxAngle forCenter:(CGPoint)center radius:(CGFloat)radius
{
    NSInteger i = startAngle;
    double offset = 0;
    NSInteger count = (_dataSourceArray.count > 1 ? _dataSourceArray.count - 1 : 1);
    
    if (maxAngle < 360)
        offset = (maxAngle / count);
    else
        offset = maxAngle / _dataSourceArray.count;

    NSInteger sourceIndex = 0;
    
    for (NSInteger value = 0; value <= maxAngle && sourceIndex < _dataSourceArray.count; value += offset, i += offset, sourceIndex++)
    {
        if (i >= 360)
            i = i - 360;
        
        CGFloat degInRad = i * kDegreeToRadians;
        CGFloat x = center.x + cos(degInRad) * radius;
        CGFloat y = center.y + sin(degInRad) * radius;
        
        UIView *view = [_dataSourceArray objectAtIndex:sourceIndex];
        
        if (_animation == CCRadialAnimationFromCenter)
        {
            view.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
            
            [UIView animateWithDuration:0.1f animations:^{
                view.center = CGPointMake(x, y);
            }];
        }
        else if (_animation == CCRadialAnimationNone)
        {
            view.center = CGPointMake(x, y);
        }
        
        [self addSubview:view];
    }
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

//
//  CPJoystick.h
//
//
//  Created by Max Chuquimia on 2/03/13.
//
//  HOW-TO: http://www.chuquimianproductions.com/code/cpjoystick

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>//needed for rouding views

@protocol CPJoystickDelegate;
@interface CPJoystick : UIView
{
    UIView *handle;
    BOOL isTouching;
    CGPoint defaultPoint;
    CGFloat updateMInterval;
    CGPoint lastMoveFactor;
    UIImageView *thumbImageView;
    UIImageView *bgImageView;
    CGFloat moveViscosity;
    CGFloat smallestPossible;
}

@property (readonly) CGPoint moveFactor;
@property (nonatomic, weak,   readwrite) id<CPJoystickDelegate> delegate;

-(void)setMovementUpdateInterval:(CGFloat)interval;
-(void)setThumbImage:(UIImage *)thumbImage andBGImage:(UIImage *)bgImage;
-(void)setMoveViscosity:(CGFloat)mv andSmallestValue:(CGFloat)sv;

@end

@protocol CPJoystickDelegate <NSObject>
@optional
-(void)cpJoystick:(CPJoystick *)aJoystick didUpdate:(CGPoint)movement;
@end

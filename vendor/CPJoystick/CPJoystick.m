//
//  CPJoystick.m
//
//
//  Created by Max Chuquimia on 2/03/13.
//  HOW-TO: http://www.chuquimianproductions.com/code/cpjoystick
//

#import "CPJoystick.h"

@implementation CPJoystick
@synthesize moveFactor;

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self)
    {
        NSAssert(frame.size.width==frame.size.height, @"The width and the height of your joystick were not equal!");
        [self setRoundedView:self toDiameter:self.bounds.size.width];
        [self log:@"Creating Joystick"];
        moveViscosity = 7;
        smallestPossible = 0.09;
        moveFactor.x = 0;
        moveFactor.y = 0;
        lastMoveFactor = moveFactor;
        updateMInterval = 1.0/45;
        bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        [self setRoundedView:bgImageView toDiameter:bgImageView.bounds.size.width];
        [self addSubview:bgImageView];

        [self makeHandle];
        [self animate];
    }

    return self;
}

-(void)makeHandle
{
    handle = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.size.width/4, self.bounds.size.height/4, self.bounds.size.width/2, self.bounds.size.height/2)];
    defaultPoint = handle.center;
    [self setRoundedView:handle toDiameter:handle.bounds.size.width];
    [self addSubview:handle];
    thumbImageView = [[UIImageView alloc] initWithFrame:handle.frame];
    [self setRoundedView:thumbImageView toDiameter:thumbImageView.bounds.size.width];
    [self addSubview:thumbImageView];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *myTouch = [[touches allObjects] objectAtIndex:0];
    CGPoint currentPos = [myTouch locationInView: self];

    UIWindow *mainWindow = [[UIApplication sharedApplication] keyWindow];
    CGPoint superPoint = [mainWindow convertPoint:handle.center fromWindow:nil];

    if (![self checkPoint:currentPos isInCircle:superPoint withRadius:handle.bounds.size.width/2])
    {
        //forget about it if it's not holding the handle
        [self log:@"Touch not on handle"];
        isTouching = FALSE;
        return;
    }

    //else
    CGPoint selfCenter = CGPointMake(self.bounds.origin.x+self.bounds.size.width/2, self.bounds.origin.y+self.bounds.size.height/2);
    CGFloat selfRadius = self.bounds.size.width/2;

    if ([self checkPoint:currentPos isInCircle:selfCenter withRadius:selfRadius])//only let the handle move within a circle
    {
        handle.center = currentPos;
        thumbImageView.center = currentPos;
        isTouching = TRUE;
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self touchesBegan:touches withEvent:event];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    isTouching = FALSE;
}

-(BOOL)checkPoint:(CGPoint)point isInCircle:(CGPoint)center withRadius:(CGFloat)radius
{
    return (powf(point.x-center.x, 2) + powf(point.y-center.y, 2) < powf(radius, 2));
}

-(void)animate
{
    [self log:[NSString stringWithFormat:@"A: %c",isTouching]];

    if (!isTouching)
    {
        //move the handle back to the default position
        CGFloat newX = handle.center.x;
        CGFloat newY = handle.center.y;
        CGFloat dx = fabsf(newX - defaultPoint.x);
        CGFloat dy = fabsf(newY - defaultPoint.y);

        if (handle.center.x > defaultPoint.x)
        {
            newX = handle.center.x - dx/moveViscosity;
        }
        else if (handle.center.x < defaultPoint.x)
        {
            newX = handle.center.x + dx/moveViscosity;
        }

        if (handle.center.y > defaultPoint.y)
        {
            newY = handle.center.y - dy/moveViscosity;
        }
        else if (handle.center.y < defaultPoint.y)
        {
            newY = handle.center.y + dy/moveViscosity;
        }

        if (fabsf(dx/moveViscosity) < smallestPossible && fabsf(dy/moveViscosity) < smallestPossible)
        {
            newX = defaultPoint.x;
            newY = defaultPoint.y;
        }

        handle.center = CGPointMake(newX, newY);
        thumbImageView.center = handle.center;
    }

    moveFactor.x = (handle.center.x - defaultPoint.x)/(self.bounds.size.width/2);
    moveFactor.y = (handle.center.y - defaultPoint.y)/(self.bounds.size.height/2);

    if (lastMoveFactor.x == moveFactor.x && lastMoveFactor.y == moveFactor.y && moveFactor.x == 0 && moveFactor.y == 0)
    {
        //just chill for a bit
    }
    else
    {
            [self.delegate cpJoystick:self didUpdate:moveFactor touching:isTouching];
    }

    lastMoveFactor = moveFactor;

    [self performSelector:@selector(animate) withObject:nil afterDelay:updateMInterval];
}

-(void)setMovementUpdateInterval:(CGFloat)interval
{
    if (interval <= 0)
    {
        updateMInterval = 1.0;
        [self log:@"Please make your update interval greater than zero!"];
    }
    else
    {
        updateMInterval = interval;
    }
}
-(void)setMoveViscosity:(CGFloat)mv andSmallestValue:(CGFloat)sv
{
    moveViscosity = mv;
    smallestPossible = sv;
}

-(void)setThumbImage:(UIImage *)thumbImage andBGImage:(UIImage *)bgImage
{
    thumbImageView.image = thumbImage;
    bgImageView.image = bgImage;
}

-(void)setRoundedView:(UIView *)roundedView toDiameter:(float)newSize;
{
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;
    roundedView.center = saveCenter;
}

-(void)log:(NSString *)message
{
    if (FALSE)//toggle me!
    {
        NSLog(@"[CPJoystick]: %@", message);
    }
}

@end

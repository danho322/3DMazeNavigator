//
//  LayerView.m
//  PhonixCodingChallenge
//
//  Created by Daniel Ho on 7/31/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "LayerView.h"
#import <QuartzCore/QuartzCore.h>

@implementation LayerView
@synthesize offsetX = _offsetX;
@synthesize offsetY = _offsetY;

- (id)initWithData:(LayerData*)layerData
{
    CGFloat cubeSize = CUBE_SIZE;
    CGRect frame = CGRectMake(0, 0, 300, 400);
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
        
        int maxX = 0;
        int maxY = 0;
        for (NSString* key in layerData.gridData)
        {
            Cube* cube = [layerData.gridData objectForKey:key];
            if (cube.x > maxX) maxX = cube.x;
            if (cube.y > maxY) maxY = cube.y;
            
            CGRect cubeFrame = CGRectMake(cube.x * cubeSize, cube.y * cubeSize, cubeSize, cubeSize);
            UIView* cubeView = [[[UIView alloc] initWithFrame:cubeFrame] autorelease];
            UIColor* cubeColor = [UIColor whiteColor];
            if (cube.type == CubeTypeBegin)
            {
                cubeColor = [UIColor greenColor];
            }
            else if (cube.type == CubeTypeSolid)
            {
                cubeColor = [UIColor grayColor];
            }
            else if (cube.type == CubeTypeEnd)
            {
                cubeColor = [UIColor redColor];
            }
            
            [cubeView setBackgroundColor:cubeColor];
            [cubeView.layer setBorderColor:[UIColor blackColor].CGColor];
            [cubeView.layer setBorderWidth:1];
            [self addSubview:cubeView];
        }
        
        CGSize frameSize = CGSizeMake((maxX + 1) * cubeSize, (maxY + 1) * cubeSize);
        
        _offsetX = (300 - frameSize.width) / 2.f;
        _offsetY = (400 - frameSize.height) / 2.f;
        [self setFrame:CGRectMake(self.frame.origin.x + _offsetX, self.frame.origin.y + _offsetY, frameSize.width, frameSize.height)];
    }
    
    return self;
}

@end

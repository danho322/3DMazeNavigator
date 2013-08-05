//
//  Cube.m
//  PhonixCodingChallenge
//
//  Created by Daniel Ho on 7/30/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "Cube.h"

@implementation Cube
@synthesize x = _x;
@synthesize y = _y;
@synthesize z = _z;
@synthesize type = _type;
@synthesize visited = _visited;
@synthesize parentCube = _parentCube;
@synthesize value = _value;

- (id)initWithX:(int)myX y:(int)myY z:(int)myZ cubeType:(CubeType)myType
{
    if (self = [self init])
    {
        _x = myX;
        _y = myY;
        _z = myZ;
        _type = myType;
        _value = HUGE_VAL;
        _visited = NO;
        self.parentCube = nil;
    }
    return self;
}

- (NSString*)key
{
    return [NSString stringWithFormat:@"%d,%d,%d", _x, _y, _z];
}

+ (NSString*)keyForX:(int)x y:(int)y z:(int)z
{
    return [NSString stringWithFormat:@"%d,%d,%d", x, y, z];
}

@end

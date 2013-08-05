//
//  Cube.h
//  PhonixCodingChallenge
//
//  Created by Daniel Ho on 7/30/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    CubeTypeBegin,
    CubeTypeTransparent,
    CubeTypeSolid,
    CubeTypeEnd,
    CubeTypeUnknown,
} CubeType;

@interface Cube : NSObject
{
    int _x;
    int _y;
    int _z;
    CubeType _type;
    
    // Djikstra
    BOOL _visited;
    int _value;
    Cube* _parentCube;
}

@property int x;
@property int y;
@property int z;
@property CubeType type;
@property BOOL visited;
@property int value;
@property (nonatomic, assign) Cube* parentCube;

- (id)initWithX:(int)myX y:(int)myY z:(int)myZ cubeType:(CubeType)myType;
- (NSString*)key;
+ (NSString*)keyForX:(int)x y:(int)y z:(int)z;

@end

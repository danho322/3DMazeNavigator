//
//  LayerData.m
//  PhonixCodingChallenge
//
//  Created by Daniel Ho on 7/30/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "LayerData.h"

@interface LayerData()

@end

@implementation LayerData
@synthesize gridData = _gridData;

- (void)dealloc
{
    self.gridData = nil;
    [super dealloc];
}

- (id)initWithOrder:(int)orderNum rows:(int)layerRows lineArray:(NSArray*)lineArray
{
    if (self = [self init])
    {
        _orderNum = orderNum;
        self.gridData = [NSMutableDictionary dictionary];
        
        int startIndex = orderNum * layerRows;
        //NSLog(@"new");
        for (int i = startIndex; i < startIndex + layerRows; i++)
        {
            NSString* line = [lineArray objectAtIndex:i];
            //NSLog(@"%@!", line);
            int y = i - startIndex;
            for (int x = 0; x < [line length]; x++)
            {
                unichar c = [line characterAtIndex:x];
                CubeType type = CubeTypeUnknown;
                switch (c) {
                    case 'B':
                        type = CubeTypeBegin;
                        break;
                    case '.':
                        type = CubeTypeTransparent;
                        break;
                    case '#':
                        type = CubeTypeSolid;
                        break;
                    case 'E':
                        type = CubeTypeEnd;
                        break;
                    default:
                        break;
                }
                
                Cube* cube = [[[Cube alloc] initWithX:x y:y z:orderNum cubeType:type] autorelease];
                [_gridData setObject:cube forKey:[cube key]];
            }
        }
    }
    return self;
}

- (Cube*)findBeginningCube
{
    for (NSString* key in _gridData)
    {
        Cube* cube = [_gridData objectForKey:key];
        if (cube.type == CubeTypeBegin)
        {
            return cube;
        }
    }
    return nil;
}

- (Cube*)findDestinationCube
{
    for (NSString* key in _gridData)
    {
        Cube* cube = [_gridData objectForKey:key];
        if (cube.type == CubeTypeEnd)
        {
            return cube;
        }
    }
    return nil;
}

- (Cube*)cubeAtX:(int)x y:(int)y
{
    NSString* key = [Cube keyForX:x y:y z:_orderNum];
    return [_gridData objectForKey:key];
}

@end

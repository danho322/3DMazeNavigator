//
//  PathFinder.m
//  PhonixCodingChallenge
//
//  Created by Daniel Ho on 7/31/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "PathFinder.h"
#import "Cube.h"
#import "MazeData.h"

@interface PathFinder()
@property(nonatomic, retain) NSMutableArray* openList;
@property(nonatomic, retain) NSMutableArray* closedList;

- (void)addCubesToOpenList:(NSArray*)neighborCubes;
- (Cube*)lowestValueCube;
@end

@implementation PathFinder
@synthesize openList = _openList;
@synthesize closedList = _closedList;

- (void) dealloc
{
    self.openList = nil;
    self.closedList = nil;
    
    [super dealloc];
}

- (id)init
{
    if (self = [super init])
    {
        self.openList = [NSMutableArray array];
        self.closedList = [NSMutableArray array];
    }
    return self;
}

/*
 1. Start at begin point
 2. Set/Re-set all neighbor cube values (if re-set, update parent cube as well)
 3. Put all neighbor cubes on open list (if not there already)
 4. Put current cube on closed list
 5a. Set current cube to cube in open list with lowest value (if any)
 5b. Go to step 2
 6. Finish when destination cube is on open list, or if open list is empty
 */

- (BOOL)findShortestPath
{
    MazeData* mazeData = [MazeData sharedInstance];
    
    Cube* currentCube = mazeData.currentCube;
    currentCube.value = 0;
    
    [_openList addObject:currentCube];
    
    while ([_openList count] > 0)
    {
        NSMutableArray* neighborCubes = [mazeData availableAdjacentCubesToCurrentCube];
        for (Cube* cube in neighborCubes)
        {
            int cubeValue = currentCube.value + 1;
            if (cubeValue < cube.value)
            {
                cube.value = cubeValue;
                cube.parentCube = currentCube;
            }
            if (cube.type == CubeTypeEnd)
            {
                return YES;
            }
        }
        
        [self addCubesToOpenList:neighborCubes];
        
        [_openList removeObject:currentCube];
        [_closedList addObject:currentCube];
        currentCube.visited = YES;
        
        currentCube = [self lowestValueCube];
        mazeData.currentCube = currentCube;
    }
    return NO;
}

- (void)addCubesToOpenList:(NSArray*)neighborCubes
{
    for (Cube* cube in neighborCubes)
    {
        if (![_openList containsObject:cube])
        {
            [_openList addObject:cube];
        }
    }
}

- (Cube*)lowestValueCube
{
    Cube* lowCube = nil;
    for (Cube* cube in _openList)
    {
        if (!lowCube)
        {
            lowCube = cube;
        }
        else
        {
            if (cube.value < lowCube.value)
            {
                lowCube = cube;
            }
        }
    }
    return lowCube;
}

@end

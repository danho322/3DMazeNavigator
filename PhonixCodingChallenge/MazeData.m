//
//  MazeData.m
//  PhonixCodingChallenge
//
//  Created by Daniel Ho on 7/30/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "MazeData.h"
#import "LayerData.h"

@interface MazeData()


- (Cube*)findBeginningCube;
- (Cube*)findDestinationCube;
- (Cube*)cubeAtX:(int)x y:(int)y z:(int)z;
- (Cube*)adjacentCubeToCurrentCube:(MoveDirection)direction;
@end

@implementation MazeData
@synthesize inputText = _inputText;
@synthesize currentCube = _currentCube;
@synthesize endCube = _endCube;
@synthesize layersArray = _layersArray;

- (void)dealloc
{
    self.inputText = nil;
    self.currentCube = nil;
    self.endCube = nil;
    self.layersArray = nil;
    
    [super dealloc];
}

- (void)reset
{
    self.inputText = nil;
    self.currentCube = nil;
    self.endCube = nil;
    [_layersArray removeAllObjects];
    self.layersArray = nil;
    _width = 0;
    _height = 0;
}

- (void)initWithInputText:(NSString*)inputText
{
    self.inputText = inputText;
    
    // Parse line by line... hopefully in the correct format!
    NSArray* lineArray = [inputText componentsSeparatedByCharactersInSet:
                          [NSCharacterSet newlineCharacterSet]];
    
    // Remove whitespace
    _width = 0;
    NSMutableArray* adjustedLineArray = [NSMutableArray arrayWithCapacity:[lineArray count]];
    for (NSString* line in lineArray)
    {
        NSArray* words = [line componentsSeparatedByCharactersInSet :[NSCharacterSet whitespaceCharacterSet]];
        NSString* trimmedLine = [words componentsJoinedByString:@""];
        [adjustedLineArray addObject:trimmedLine];
        
        if (_width <= 1)    // We are expecting at least 1 for the first line
        {
            _width = [trimmedLine length];
        }
    }
    
    // Take out empty components
    NSMutableArray* linesToRemove = [NSMutableArray array];
    for (NSString* line in adjustedLineArray)
    {
        if ([line length] == 0 || ![[line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length])
        {
            [linesToRemove addObject:line];
        }
    }
    [adjustedLineArray removeObjectsInArray:linesToRemove];
    
    int numberOfLayers = [[adjustedLineArray objectAtIndex:0] intValue];
    self.layersArray = [NSMutableArray arrayWithCapacity:numberOfLayers];
    [adjustedLineArray removeObjectAtIndex:0];
    
    // Create each layer
    
    int layerRows = [adjustedLineArray count] / numberOfLayers;
    _height = layerRows;
    for (int i = 0; i < numberOfLayers; i++)
    {
        LayerData* layer = [[[LayerData alloc] initWithOrder:i rows:layerRows lineArray:adjustedLineArray] autorelease];
        [_layersArray addObject:layer];
    }
    
    // Start it up!
    self.currentCube = [self findBeginningCube];
    self.endCube = [self findDestinationCube];
    
    // The Maze is somewhat rotated so that each layer has x,y coordinates and z increments to 
    // the next layer.  Makes more sense in my head.
    // x == left/right
    // y == backwards/forwards
    // z == up/down
}

#pragma mark - Navigating maze

- (Cube*)findBeginningCube
{
    Cube* beginCube = nil;
    for (LayerData* layer in _layersArray)
    {
        beginCube = [layer findBeginningCube];
        if (beginCube)
        {
            break;
        }
    }
    return beginCube;
}

- (Cube*)findDestinationCube
{
    Cube* endCube = nil;
    for (LayerData* layer in _layersArray)
    {
        endCube = [layer findDestinationCube];
        if (endCube)
        {
            break;
        }
    }
    return endCube;
}

- (NSMutableArray*)availableAdjacentCubesToCurrentCube
{
    NSMutableArray* availableCubes = [NSMutableArray arrayWithCapacity:6];
    NSArray* typeArray = [NSArray arrayWithObjects:[NSNumber numberWithInt:MoveDirectionLeft],
                          [NSNumber numberWithInt:MoveDirectionRight],
                          [NSNumber numberWithInt:MoveDirectionBackward],
                          [NSNumber numberWithInt:MoveDirectionForward],
                          [NSNumber numberWithInt:MoveDirectionUp],
                          [NSNumber numberWithInt:MoveDirectionDown],nil];
    for (NSNumber* typeNum in typeArray)
    {
        MoveDirection direction = (MoveDirection)[typeNum intValue];
        Cube* cube = [self adjacentCubeToCurrentCube:direction];
        if (cube && !cube.visited)
        {
            [availableCubes addObject:cube];
        }
    }
    
    NSMutableArray* cubesToRemove = [NSMutableArray array];
    for (Cube* cube in availableCubes)
    {
        if (cube.type == CubeTypeSolid)
        {
            [cubesToRemove addObject:cube];
        }
    }
    [availableCubes removeObjectsInArray:cubesToRemove];
    
    return availableCubes;
}

- (Cube*)adjacentCubeToCurrentCube:(MoveDirection)direction
{
    Cube* adjacentCube = nil;
    
    int x = _currentCube.x;
    int y = _currentCube.y;
    int z = _currentCube.z;
    
    if (direction == MoveDirectionLeft)
    {
        x--;
    }
    else if (direction == MoveDirectionRight)
    {
        x++;
    }
    else if (direction == MoveDirectionBackward)
    {
        y--;
    }
    else if (direction == MoveDirectionForward)
    {
        y++;
    }
    else if (direction == MoveDirectionUp)
    {
        z--;
    }
    else if (direction == MoveDirectionDown)
    {
        z++;
    }
    
    // Check boundaries
    if (x < 0 || y < 0 || z < 0 || x >= _width || y >= _height || z >= [_layersArray count])
    {
        return nil;
    }
    
    adjacentCube = [self cubeAtX:x y:y z:z];
    
    return adjacentCube;
}

- (Cube*)cubeAtX:(int)x y:(int)y z:(int)z
{
    Cube* cube = nil;
    if (z >= 0 && z < [_layersArray count])
    {
        LayerData* layer = [_layersArray objectAtIndex:z];
        cube = [layer cubeAtX:x y:y];
    }
    return cube;
}

#pragma mark - Singleton

+ (MazeData*)sharedInstance
{
    static dispatch_once_t pred;
    static MazeData* sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[MazeData alloc] init];
    });
    return sharedInstance;
}

@end

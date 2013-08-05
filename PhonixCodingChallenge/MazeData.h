//
//  MazeData.h
//  PhonixCodingChallenge
//
//  Created by Daniel Ho on 7/30/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cube.h"

typedef enum
{
    MoveDirectionLeft,
    MoveDirectionRight,
    MoveDirectionBackward,
    MoveDirectionForward,
    MoveDirectionUp,
    MoveDirectionDown,
} MoveDirection;

@interface MazeData : NSObject
{
    NSString* _inputText;
    Cube* _currentCube;
    Cube* _endCube;
    NSMutableArray* _layersArray;
    
    int _width;     // max x
    int _height;    // max y
}

@property (nonatomic, retain) Cube* currentCube;
@property (nonatomic, retain) Cube* endCube;
@property (nonatomic, retain) NSString* inputText;
@property (nonatomic, retain) NSMutableArray* layersArray;

+ (MazeData*)sharedInstance;
- (void)initWithInputText:(NSString*)inputText;
- (NSMutableArray*)availableAdjacentCubesToCurrentCube;
- (void)reset;

@end

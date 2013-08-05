//
//  LayerData.h
//  PhonixCodingChallenge
//
//  Created by Daniel Ho on 7/30/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cube.h"

@interface LayerData : NSObject
{
    int _orderNum;
    NSMutableDictionary* _gridData;
}

@property (nonatomic, retain) NSMutableDictionary* gridData;

- (id)initWithOrder:(int)orderNum rows:(int)layerRows lineArray:(NSArray*)lineArray;
- (Cube*)findBeginningCube;
- (Cube*)findDestinationCube;
- (Cube*)cubeAtX:(int)x y:(int)y;

@end

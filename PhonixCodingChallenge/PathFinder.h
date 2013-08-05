//
//  PathFinder.h
//  PhonixCodingChallenge
//
//  Created by Daniel Ho on 7/31/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PathFinder : NSObject
{
    NSMutableArray* _openList;
    NSMutableArray* _closedList;
}

- (BOOL)findShortestPath;

@end

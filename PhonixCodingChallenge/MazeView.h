//
//  MazeView.h
//  PhonixCodingChallenge
//
//  Created by Daniel Ho on 7/31/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LayerView.h"
#import "MazeData.h"

@interface MazeView : UIView
{
    int _currentZ;
    int _solutionIndex;
    LayerView* _currentLayerView;
    UIView* _roboView;
    NSMutableArray* _viewArray;
    NSArray* _solutionArray;
}

- (id)initWithData:(MazeData*)mazeData;
- (void)solveWithSolutionArray:(NSArray*)solutionArray;

@end

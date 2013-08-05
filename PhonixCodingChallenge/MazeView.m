//
//  MazeView.m
//  PhonixCodingChallenge
//
//  Created by Daniel Ho on 7/31/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "MazeView.h"
#import <QuartzCore/QuartzCore.h>
#define SOLUTION_DELAY  .5f

@interface MazeView()
@property (nonatomic, retain) NSMutableArray* viewArray;
@property (nonatomic, retain) LayerView* currentLayerView;
@property (nonatomic, retain) UIView* roboView;
@property (nonatomic, retain) NSArray* solutionArray;
- (void)showNextPosition;
@end

@implementation MazeView
@synthesize viewArray = _viewArray;
@synthesize currentLayerView = _currentLayerView;
@synthesize roboView = _roboView;
@synthesize solutionArray = _solutionArray;

- (void)dealloc
{
    self.viewArray = nil;
    self.currentLayerView = nil;
    self.roboView = nil;
    self.solutionArray = nil;
    
    [super dealloc];
}

- (id)initWithData:(MazeData*)mazeData
{
    CGRect frame = CGRectMake(10, 10, 300, 400);
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor purpleColor]];
        [self.layer setCornerRadius:5];
        [self.layer setMasksToBounds:YES];
        
        UIButton* closeButton = [[[UIButton alloc] initWithFrame:CGRectMake(210, 350, 70, 30)] autorelease];
        [closeButton setBackgroundColor:[UIColor grayColor]];
        [closeButton setTitle:@"Return" forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(onCloseClicked) forControlEvents:UIControlEventTouchUpInside];
        [closeButton.layer setCornerRadius:5];
        [closeButton.layer setMasksToBounds:YES];
        [self addSubview:closeButton];
        
        self.viewArray = [NSMutableArray arrayWithCapacity:[mazeData.layersArray count]];
        
        for (LayerData* layer in mazeData.layersArray)
        {
            LayerView* layerView = [[[LayerView alloc] initWithData:layer] autorelease];
            [_viewArray addObject:layerView];
        }
    }
    return self;
}

- (void)onCloseClicked
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self removeFromSuperview];
}

- (void)moveRobotToCube:(Cube*)cube
{
    CGFloat cubeSize = CUBE_SIZE;
    CGRect cubeFrame = CGRectMake(_currentLayerView.offsetX + cube.x * cubeSize, _currentLayerView.offsetY + cube.y * cubeSize, cubeSize, cubeSize);
    [_roboView setFrame:cubeFrame];
    [self bringSubviewToFront:_roboView];
}

- (void)solveWithSolutionArray:(NSArray*)solutionArray
{
    self.solutionArray = solutionArray;
    
    Cube* firstCube = [solutionArray objectAtIndex:0];
    _currentZ = firstCube.z;
    _solutionIndex = 0;
    
    LayerView* layer = [_viewArray objectAtIndex:_currentZ];
    self.currentLayerView = layer;
    [self addSubview:layer];
    
    CGFloat cubeSize = CUBE_SIZE;
    CGRect cubeFrame = CGRectMake(0, 0, cubeSize, cubeSize);
    
    self.roboView = [[[UIView alloc] initWithFrame:cubeFrame] autorelease];
    [_roboView setBackgroundColor:[UIColor yellowColor]];
    [_roboView setAlpha:.7f];
    [self moveRobotToCube:firstCube];
    [self addSubview:_roboView];
    
    [self performSelector:@selector(showNextPosition) withObject:nil afterDelay:SOLUTION_DELAY];
}

- (void)showNextPosition
{
    _solutionIndex++;
    if (_solutionIndex >= [_solutionArray count])
    {
        return;
    }
    
    Cube* cube = [_solutionArray objectAtIndex:_solutionIndex];
    
    if (_currentZ != cube.z)
    {
        CGFloat scaleFrom = (_currentZ < cube.z) ? .25f : 4.0f;
        CGFloat scaleTo = (_currentZ < cube.z) ? 4.0f : .25f;
        _currentZ = cube.z;
        LayerView* layer = [_viewArray objectAtIndex:_currentZ];
        [self addSubview:layer];
        [self bringSubviewToFront:_currentLayerView];
        
        UIView* animateView = layer;
        animateView.transform = CGAffineTransformMakeScale(scaleFrom, scaleFrom);
        [animateView setAlpha:0];
        
        [UIView animateWithDuration:0.25
                              delay:0.0
                            options:UIViewAnimationCurveEaseOut
                         animations:^{
                             animateView.transform = CGAffineTransformMakeScale(1, 1);
                             [animateView setAlpha:1];
                         }
                         completion:^(BOOL finished) {
                             animateView.transform = CGAffineTransformMakeScale(1.f, 1.f);
                        }];
        
        animateView = _currentLayerView;
        [UIView animateWithDuration:0.25
                              delay:0.0
                            options:UIViewAnimationCurveEaseOut
                         animations:^{
                             animateView.transform = CGAffineTransformMakeScale(scaleTo, scaleTo);
                             [animateView setAlpha:0];
                         }
                         completion:^(BOOL finished) {
                             [animateView removeFromSuperview];
                             animateView.transform = CGAffineTransformMakeScale(1.f, 1.f);
                             [animateView setAlpha:1];
                         }];
        self.currentLayerView = layer;
        
    }
    
    [self moveRobotToCube:cube];
    
    [self performSelector:@selector(showNextPosition) withObject:nil afterDelay:SOLUTION_DELAY];
}

@end

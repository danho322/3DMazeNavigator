//
//  ViewController.m
//  PhonixCodingChallenge
//
//  Created by Daniel Ho on 7/30/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MazeData.h"
#import "PathFinder.h"
#import "MazeView.h"

@interface ViewController()
@property (nonatomic, retain) UITextView* inputTextView;
@property (nonatomic, retain) UITextView* outputTextView;
@end

@implementation ViewController
@synthesize inputTextView = _inputTextView;
@synthesize outputTextView = _outputTextView;

- (void)dealloc
{
    self.inputTextView = nil;
    self.outputTextView = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    _solution = NO;
    NSMutableArray* layersToMask = [NSMutableArray arrayWithCapacity:5];
    
    UIView* view = [[[UIView alloc] initWithFrame:CGRectMake(10, 30, 300, 400)] autorelease];
    [view setBackgroundColor:[UIColor purpleColor]];
    [layersToMask addObject:view.layer];
    
    UILabel* instructionsLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 280, 60)] autorelease];
    [instructionsLabel setBackgroundColor:[UIColor clearColor]];
    [instructionsLabel setText:@"Please enter the 3D maze description:"];
    [instructionsLabel setNumberOfLines:0];
    [instructionsLabel setTextColor:[UIColor whiteColor]];
    [instructionsLabel setTextAlignment:UITextAlignmentCenter];
    [view addSubview:instructionsLabel];

    self.inputTextView = [[[UITextView alloc] initWithFrame:CGRectMake(20, 80, 260, 100)] autorelease];
    [view addSubview:_inputTextView];
    [layersToMask addObject:_inputTextView.layer];
    
    UIButton* submitButton = [[[UIButton alloc] initWithFrame:CGRectMake(210, 200, 70, 30)] autorelease];
    [submitButton setBackgroundColor:[UIColor grayColor]];
    [submitButton setTitle:@"Submit" forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(onSubmitClicked) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:submitButton];
    [layersToMask addObject:submitButton.layer];
    
    UIButton* resetButton = [[[UIButton alloc] initWithFrame:CGRectMake(210, 240, 70, 30)] autorelease];
    [resetButton setBackgroundColor:[UIColor grayColor]];
    [resetButton setTitle:@"Reset" forState:UIControlStateNormal];
    [resetButton addTarget:self action:@selector(onResetClicked) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:resetButton];
    [layersToMask addObject:resetButton.layer];

    UILabel* outputLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 260, 280, 30)] autorelease];
    [outputLabel setBackgroundColor:[UIColor clearColor]];
    [outputLabel setText:@"Output:"];
    [outputLabel setTextColor:[UIColor whiteColor]];
    [outputLabel setTextAlignment:UITextAlignmentCenter];
    [view addSubview:outputLabel];
    
    self.outputTextView = [[[UITextView alloc] initWithFrame:CGRectMake(20, 300, 260, 30)] autorelease];
    [view addSubview:_outputTextView];
    [layersToMask addObject:_outputTextView.layer];
        
    UIButton* animateButton = [[[UIButton alloc] initWithFrame:CGRectMake(210, 350, 70, 30)] autorelease];
    [animateButton setBackgroundColor:[UIColor grayColor]];
    [animateButton setTitle:@"Animate" forState:UIControlStateNormal];
    [animateButton addTarget:self action:@selector(onAnimateClicked) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:animateButton];
    [layersToMask addObject:animateButton.layer];
    
    for (CALayer* layer in layersToMask)
    {
        [layer setCornerRadius:5];
        [layer setMasksToBounds:YES];
    }
    
    [self.view addSubview:view];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (NSMutableArray*)solutionArray
{
    MazeData* mazeData = [MazeData sharedInstance];
    NSMutableArray* solutionArray = [NSMutableArray array];
    Cube* currentCube = mazeData.endCube;
    while (currentCube)
    {
        [solutionArray insertObject:currentCube atIndex:0];
        currentCube = currentCube.parentCube;
    }
    return solutionArray;
}

#pragma mark - Button Handlers

- (void)onSubmitClicked
{
    [_inputTextView resignFirstResponder];
    
    if (_inputTextView.text.length == 0) return;
    
    MazeData* mazeData = [MazeData sharedInstance];
    [mazeData initWithInputText:_inputTextView.text];
        
    PathFinder* pathFinder = [[[PathFinder alloc] init] autorelease];
    _solution = [pathFinder findShortestPath];
    
    if (_solution)
    {
        NSMutableArray* solutionArray = [self solutionArray];
        NSString* outputString = @"Escapable:";
        
        Cube* prevCube = nil;
        for (Cube* cube in solutionArray)
        {
            if (prevCube)
            {
                if (prevCube.x < cube.x)
                {
                    outputString = [outputString stringByAppendingFormat:@"%@", @"E"];
                }
                else if (prevCube.x > cube.x)
                {
                    outputString = [outputString stringByAppendingFormat:@"%@", @"W"];
                }
                else if (prevCube.y < cube.y)
                {
                    outputString = [outputString stringByAppendingFormat:@"%@", @"S"];
                }
                else if (prevCube.y > cube.y)
                {
                    outputString = [outputString stringByAppendingFormat:@"%@", @"N"];
                }
                else if (prevCube.z < cube.z)
                {
                    outputString = [outputString stringByAppendingFormat:@"%@", @"U"];
                }
                else if (prevCube.z > cube.z)
                {
                    outputString = [outputString stringByAppendingFormat:@"%@", @"D"];
                }
            }
            prevCube = cube;
        }
        _outputTextView.text = outputString;
    }
    else
    {
        _outputTextView.text = @"Not Escapable";
    }
}

- (void)onAnimateClicked
{
    if (_solution)
    {
        MazeData* mazeData = [MazeData sharedInstance];
        NSMutableArray* solutionArray = [self solutionArray];
        
        MazeView* mazeView = [[[MazeView alloc] initWithData:mazeData] autorelease];
        [self.view addSubview:mazeView];
        [mazeView solveWithSolutionArray:solutionArray];
    }
}

- (void)onResetClicked
{
    _inputTextView.text = @"";
    _outputTextView.text = @"";
    [[MazeData sharedInstance] reset];
    _solution = NO;
}

@end

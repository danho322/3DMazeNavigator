//
//  LayerView.h
//  PhonixCodingChallenge
//
//  Created by Daniel Ho on 7/31/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LayerData.h"

#define CUBE_OFFSET 20
#define CUBE_SIZE   20

@interface LayerView : UIView
{
    CGFloat _offsetX;
    CGFloat _offsetY;
}

@property CGFloat offsetX;
@property CGFloat offsetY;

- (id)initWithData:(LayerData*)layerData;

@end

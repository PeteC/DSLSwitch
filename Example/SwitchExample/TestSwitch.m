//
//  TestSwitch.m
//  SwitchExample
//
//  Created by Pete Callaway on 24/06/2012.
//  Copyright 2012 Dative Studios. All rights reserved.
//

#import "TestSwitch.h"


@interface TestSwitch ()

@end


@implementation TestSwitch


#pragma mark - Initialisation

// Designated initialisers
- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self != nil) {
		// Initialise properties
        [self commonInit];
	}
	
	return self;
}

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self != nil) {
		// Initialise properties
        [self commonInit];
	}
	
	return self;
}

- (void)commonInit {
    self.gutterImage = [[UIImage imageNamed:@"switch-gutter"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 13)];
    self.handleImage = [UIImage imageNamed:@"switch-handle"];
    self.onOffView.maskImage = [[UIImage imageNamed:@"switch-mask"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 13)];
}

@end

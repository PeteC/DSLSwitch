/*
 DSLSwitch.m
 
 Copyright (c) 2012 Dative Studios. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 * Neither the name of the author nor the names of its contributors may be used
 to endorse or promote products derived from this software without specific
 prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "DSLSwitch.h"
#import "DSLSwitchOnOffView.h"


@interface DSLSwitch ()

@end


@implementation DSLSwitch {
    __strong UIImageView *_gutterView;
    __strong UIImageView *_handleView;
    CGFloat _startPanOffset;
}

@synthesize on=_on;
@synthesize onOffView=_onOffView;


#pragma mark - Memory management

- (void)dealloc {
}


#pragma mark - Initialisation

// Designated initialiser
- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self != nil) {
        [self commonSwitchInit];
	}
	
	return self;
}

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self != nil) {
        [self commonSwitchInit];
	}
	
	return self;
}

- (void)commonSwitchInit {
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor clearColor];
    
    _onOffView = [[DSLSwitchOnOffView alloc] initWithFrame:self.bounds];
    [self addSubview:_onOffView];
}


#pragma mark - Properties

- (void)setGutterImage:(UIImage *)gutterImage {
    [_gutterView removeFromSuperview];
    
    if (gutterImage == nil) {
        _gutterView = nil;
    }
    else {
        _gutterView = [[UIImageView alloc] initWithImage:gutterImage];
        _gutterView.frame = self.bounds;
        _gutterView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _gutterView.userInteractionEnabled = YES;
        [self insertSubview:_gutterView aboveSubview:self.onOffView];

        UITapGestureRecognizer *tapPecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recognizedTap:)];
        tapPecognizer.numberOfTapsRequired = 1;
        tapPecognizer.numberOfTouchesRequired = 1;
        [_gutterView addGestureRecognizer:tapPecognizer];
    }
}

- (UIImage*)gutterImage {
    return _gutterView.image;
}

- (void)setHandleImage:(UIImage *)handleImage {
    [_handleView removeFromSuperview];
    if (handleImage == nil) {
        _handleView = nil;
    }
    else {
        _handleView = [[UIImageView alloc] initWithImage:handleImage];
        _handleView.userInteractionEnabled = YES;
        
        if (self.isOn) {
            CGRect frame = _handleView.frame;
            frame.origin.x = self.bounds.size.width - frame.size.width;
            _handleView.frame = frame;
        }
        [self addSubview:_handleView];
        
        self.onOffView.handlePosition = CGRectGetMidX(_handleView.frame);
        [_handleView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(recognizedPan:)]];
    }
}

- (UIImage*)handleImage {
    return _handleView.image;
}

- (void)setOn:(BOOL)on {
    [self setOn:on animated:NO];
}

- (void)setOn:(BOOL)on animated:(BOOL)animated {
    BOOL valueChanged = on != _on;
    _on = on;
    
    CGRect handleframe = _handleView.frame;
    if (self.isOn) {
        handleframe.origin.x = self.bounds.size.width - handleframe.size.width;
    }
    else {
        handleframe.origin.x = 0;
    }
    
    CGFloat duration = animated ? 0.15 : 0.0;
    [self setUserInteractionEnabled:NO];
    
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _handleView.frame = handleframe;
        self.onOffView.handlePosition = CGRectGetMidX(_handleView.frame);
    } completion:^(BOOL finished) {
        [self setUserInteractionEnabled:YES];
        
        if (valueChanged) {
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
    }];
}


#pragma mark - UIGestureRecognizers

- (void)recognizedPan:(UIPanGestureRecognizer*)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        _startPanOffset = [recognizer locationInView:_handleView].x;
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGRect frame = _handleView.frame;
        frame.origin.x = [recognizer locationInView:self].x - _startPanOffset;
        frame.origin.x = MAX(frame.origin.x, 0);
        frame.origin.x = MIN(frame.origin.x, self.bounds.size.width - frame.size.width);
        _handleView.frame = frame;
        self.onOffView.handlePosition = CGRectGetMidX(_handleView.frame);
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
        if (CGRectGetMidX(_handleView.frame) < self.bounds.size.width / 2.0) {
            [self setOn:NO animated:YES];
        }
        else {
            [self setOn:YES animated:YES];
        }
    }
}

- (void)recognizedTap:(UITapGestureRecognizer*)recognizer {
    if (recognizer.state == UIGestureRecognizerStateRecognized) {
        [self setOn:!self.isOn animated:YES];
    }
}

@end

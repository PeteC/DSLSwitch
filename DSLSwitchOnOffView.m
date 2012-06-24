/*
 DSLSwitchOnOffView.m
 
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

#import "DSLSwitchOnOffView.h"
#import <QuartzCore/QuartzCore.h>


@interface DSLSwitchOnOffView ()

@end


@implementation DSLSwitchOnOffView

@synthesize maskImage=_maskImage;
@synthesize handlePosition=_handlePosition;
@synthesize onView=_onView;
@synthesize offView=_offView;


#pragma mark - Memory management

- (void)dealloc {
}


#pragma mark - Initialisation

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        [self commonInit];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit {
    _onView = [[UIView alloc] initWithFrame:self.bounds];
    _onView.backgroundColor = [UIColor greenColor];
    [self addSubview:_onView];

    _offView = [[UIView alloc] initWithFrame:self.bounds];
    _offView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_offView];
    
    [self updateSelectionViewPositions];
}


#pragma mark - Properties

- (void)setMaskImage:(UIImage *)maskImage {
    _maskImage = maskImage;
    
    CALayer *mask = [CALayer layer];
    mask.frame = self.bounds;
    
    self.layer.mask = mask;
    self.layer.mask.delegate = self;
    [self.layer.mask setNeedsDisplay];
}

- (void)setHandlePosition:(CGFloat)handlePosition {
    _handlePosition = handlePosition;
    [self updateSelectionViewPositions];
}

- (void)setOnView:(UIView *)onView {
    [_onView removeFromSuperview];
    [onView removeFromSuperview];
    
    _onView = onView;
    [self addSubview:onView];

    [self updateSelectionViewPositions];
}

- (void)setOffView:(UIView *)offView {
    [_offView removeFromSuperview];
    [_offView removeFromSuperview];
    
    _offView = offView;
    [self addSubview:offView];
    
    [self updateSelectionViewPositions];
}


#pragma mark -

- (void)updateSelectionViewPositions {
    CGRect frame = _onView.frame;
    frame.origin.x = self.handlePosition - frame.size.width;
    _onView.frame = frame;
    
    frame = _offView.frame;
    frame.origin.x = self.handlePosition;
    _offView.frame = frame;
}


#pragma mark - Layer delegate methods

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)context {
    UIGraphicsPushContext(context);
    
    if (layer == self.layer.mask && self.maskImage != nil) {
        [self.maskImage drawInRect:self.bounds];
    }
    
    UIGraphicsPopContext();
}

@end

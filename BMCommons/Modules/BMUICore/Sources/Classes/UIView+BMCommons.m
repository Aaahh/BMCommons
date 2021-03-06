//
//  UIView+BMCommons.m
//  BMCommons
//
//  Created by Werner Altewischer on 1/11/11.
//  Copyright 2011 BehindMedia. All rights reserved.
//

#import "UIView+BMCommons.h"
#import <QuartzCore/QuartzCore.h>
#import <BMCommons/BMCore.h>

@implementation UIView(BMCommons)

- (UIView *)bmFirstResponder {
	if (self.isFirstResponder) {
		return self;
	}
	for (UIView *subView in self.subviews) {
		UIView *r = [subView bmFirstResponder];
		if (r) {
			return r;
		}
	}
	return nil;
}

- (UIImage *)bmContentsAsImage {
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    else
        UIGraphicsBeginImageContext(self.bounds.size);

    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    
    // Get the snapshot
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return snapshotImage;
}

- (BOOL)bmIsVisible {
    return self.window != nil;
}

- (void)bmTraverseSubviewHierarchyWithBlock:(BOOL (^)(UIView *view))block {
    if (block(self)) {
        NSArray *subviews = [NSArray arrayWithArray:self.subviews];
        for (UIView *subview in subviews) {
            [subview bmTraverseSubviewHierarchyWithBlock:block];
       }
    }
}

- (void)bmRemoveMarginsAndInsets {
    [self setPreservesSuperviewLayoutMargins:NO];    
    [self setLayoutMargins:UIEdgeInsetsZero];
}

- (void)bmLayoutWithBlock:(void (^)(void))block animationDuration:(NSTimeInterval)duration {
    [self bmLayoutWithBlock:block animationDuration:duration applyPendingLayoutBeforeAnimation:YES];
}

- (void)bmLayoutWithBlock:(void (^)(void))block animationDuration:(NSTimeInterval)duration applyPendingLayoutBeforeAnimation:(BOOL)applyPendingLayout {
    [self bmLayoutWithBlock:block animationDuration:duration animationOptions:(UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState)
            applyPendingLayoutBeforeAnimation:applyPendingLayout];
}

- (void)bmLayoutWithBlock:(void (^)(void))block animationDuration:(NSTimeInterval)duration animationOptions:(UIViewAnimationOptions)animationOptions
        applyPendingLayoutBeforeAnimation:(BOOL)applyPendingLayout {
    [self bmLayoutWithBlock:block animationDuration:duration animationOptions:animationOptions applyPendingLayoutBeforeAnimation:applyPendingLayout completion:nil];
}

- (void)bmLayoutWithBlock:(void (^)(void))block animationDuration:(NSTimeInterval)duration animationOptions:(UIViewAnimationOptions)animationOptions  applyPendingLayoutBeforeAnimation:(BOOL)applyPendingLayout completion:(void (^)(BOOL finished))completion {
    if (duration > 0.0) {
        if (applyPendingLayout) {
            [self layoutIfNeeded];
        }
        [UIView animateWithDuration:duration
                              delay:0.0
                            options:animationOptions
                         animations:^{
                             if (block) {
                                 block();
                             }
                             [self layoutIfNeeded];
                         } completion:completion];
    } else if (block) {
        block();
        if (completion) {
            completion(YES);
        }
    }
}

- (void)bmTransitionWithBlock:(void (^)(void))block animationDuration:(NSTimeInterval)duration {
    [self bmTransitionWithBlock:block animationDuration:duration animationOptions:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionTransitionCrossDissolve];
}

- (void)bmTransitionWithBlock:(void (^)(void))block animationDuration:(NSTimeInterval)duration animationOptions:(UIViewAnimationOptions)animationOptions {
    [self bmTransitionWithBlock:block animationDuration:duration animationOptions:animationOptions completion:nil];
}

- (void)bmTransitionWithBlock:(void (^)(void))block animationDuration:(NSTimeInterval)duration animationOptions:(UIViewAnimationOptions)animationOptions completion:(void (^)(BOOL finished))completion {
    if (duration > 0.0) {
        [UIView transitionWithView:self
                          duration:duration
                           options:animationOptions
                        animations:^{
                            if (block) {
                                block();
                            }
                        }
                        completion:completion];
    } else if (block) {
        block();
        if (completion) {
            completion(YES);
        }
    }
}

@end

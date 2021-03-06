//
//  BMAsyncImageLoader.h
//  BMCommons
//
//  Created by Werner Altewischer on 20/05/10.
//  Copyright 2010 BehindMedia. All rights reserved.
//

//Class is only available for iOS

#import <UIKit/UIKit.h>
#import <BMCommons/BMAsyncDataLoader.h>

/**
 Async data loader for loading images.
 
 Uses BMURLCache for storing images.
 */
@interface BMAsyncImageLoader : BMAsyncDataLoader {
}

#if TARGET_OS_IPHONE

/**
 The returned image after loading completes.
 */
@property (nonatomic, strong) UIImage *image;

#endif

@end



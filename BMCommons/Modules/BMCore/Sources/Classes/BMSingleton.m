//
// Created by Werner Altewischer on 02/01/17.
// Copyright (c) 2017 BehindMedia. All rights reserved.
//

#import "BMSingleton.h"

@implementation BMSingleton {

}

BM_SYNTHESIZE_DEFAULT_SINGLETON

+ (void)releaseAllSharedInstances {
    [[NSNotificationCenter defaultCenter] postNotificationName:BMReleaseSharedInstancesNotification object:nil];
}

@end
//
//  BMBlockServiceDelegate.m
//  BMCommons
//
//  Created by Werner Altewischer on 2/3/11.
//  Copyright 2011 BehindMedia. All rights reserved.
//

#import "BMBlockServiceDelegate.h"
#import <BMCommons/BMWeakReference.h>
#import <BMCommons/BMWeakReferenceRegistry.h>
#import <BMCommons/BMCore.h>

@interface BMBlockServiceDelegate ()

@property(nonatomic, copy) BMServiceSuccessBlock successBlock;
@property(nonatomic, copy) BMServiceFailureBlock failureBlock;

@end

@implementation BMBlockServiceDelegate {
    BMWeakReference *_ownerReference;
}

static NSMutableArray *runningServices = nil;

@synthesize successBlock = _successBlock;
@synthesize failureBlock = _failureBlock;
@synthesize service = _service;

+ (BMBlockServiceDelegate *)delegateWithSuccess:(BMServiceSuccessBlock)success failure:(BMServiceFailureBlock)failure owner:(id)owner {
    return [[self alloc] initWithSuccess:success failure:failure owner:owner];
}

+ (BMBlockServiceDelegate *)delegateWithSuccess:(BMServiceSuccessBlock)success failure:(BMServiceFailureBlock)failure {
    return [[self alloc] initWithSuccess:success failure:failure];
}

+ (void)initialize {
    if (runningServices == nil) {
        runningServices = [NSMutableArray new];
    }
}

- (id)initWithSuccess:(BMServiceSuccessBlock)success failure:(BMServiceFailureBlock)failure owner:(id)owner {
    if ((self = [self init])) {
        self.successBlock = success;
        self.failureBlock = failure;

        [self setOwner:owner];
    }
    return self;
}

- (id)initWithSuccess:(BMServiceSuccessBlock)success failure:(BMServiceFailureBlock)failure {
    return [self initWithSuccess:success failure:failure owner:nil];
}

- (void)dealloc {
    if (_ownerReference) {
        [[BMWeakReferenceRegistry sharedInstance] deregisterReference:_ownerReference];
    }
    _service = nil;
    _ownerReference = nil;
    BM_RELEASE_SAFELY(_successBlock);
    BM_RELEASE_SAFELY(_failureBlock);
}

- (id)owner {
    return _ownerReference.target;
}

- (void)setOwner:(id)owner {
    if (_ownerReference) {
        [[BMWeakReferenceRegistry sharedInstance] deregisterReference:_ownerReference];
        _ownerReference = nil;
    }
    if (owner) {
        _ownerReference = [BMWeakReference weakReferenceWithTarget:owner];
        [[BMWeakReferenceRegistry sharedInstance] registerReference:_ownerReference withCleanupBlock:^{
            [_service cancel];
        }];
    }
}

- (void)service:(id <BMService>)service succeededWithResult:(id)result {
    _service = nil;
    if (self.successBlock) {
        self.successBlock(result);
    }
    [[self class] popDelegate:self forService:service];
}

- (void)service:(id <BMService>)service failedWithError:(NSError *)error {
    _service = nil;
    if (self.failureBlock) {
        self.failureBlock(NO, error);
    }
    [[self class] popDelegate:self forService:service];
}

- (void)serviceDidStart:(id<BMService>)service {
    _service = service;
    [[self class] pushDelegate:self];
}

- (void)serviceWasCancelled:(id<BMService>)service {
    _service = nil;
    if (self.failureBlock) {
        self.failureBlock(YES, nil);
    }
    [[self class] popDelegate:self forService:service];
}

+ (void)pushDelegate:(BMBlockServiceDelegate *)delegate {
    if (![runningServices containsObject:delegate]) {
        [runningServices addObject:delegate];
    }
}

+ (void)popDelegate:(BMBlockServiceDelegate *)delegate forService:(id <BMService>)service {
    service.delegate = nil;
    [runningServices removeObject:delegate];
}

+ (NSArray *)activeBlockDelegatesForOwner:(id)owner {
    NSMutableArray *ret = [NSMutableArray array];
    for (BMBlockServiceDelegate *d in [NSArray arrayWithArray:runningServices]) {
        if (owner == nil || d.owner == owner) {
            [ret addObject:d];
        }
    }
    return ret;
}

@end

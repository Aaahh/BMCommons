//
// Created by Werner Altewischer on 12/10/16.
// Copyright (c) 2016 BehindMedia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMethodSignature (BMCommons)

/**
 * The number of arguments corrected for the hidden arguments (target and selector).
 *
 * @return
 */
- (NSUInteger)bmNumberOfSelectorArguments;

/**
 * Converts the method argument index to the selector argument index (correcting for the hidden arguments target and selector).
 *
 * @return
 */
- (NSUInteger)bmSelectorArgumentIndexForArgumentIndex:(NSUInteger)argumentIndex;

/**
 * Converts the selector argument index to the method argument index (correcting for the hidden arguments target and selector).
 *
 * @return
 */
- (NSUInteger)bmArgumentIndexForSelectorArgumentIndex:(NSUInteger)argumentIndex;

/**
 * Length in bytes for the argument at the specified index.
 *
 * @param argumentIndex The argument index
 * @return Length in bytes.
 */
- (NSUInteger)bmArgumentLengthAtIndex:(NSUInteger)argumentIndex;

@end
//
//  BMBufferedInputStream.h
//  BMCommons
//
//  Created by Werner Altewischer on 3/2/11.
//  Copyright 2011 BehindMedia. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Inputstream that adds in-memory buffering to the underlying inputstream.
 */
@interface BMBufferedInputStream : NSInputStream {
    @private
	// The decorated stream
	NSInputStream *stream;
	// The size of each chunk read from the stream into memory
	NSUInteger bufSize;
	// The encoding of the text represented by the underlying stream
	NSStringEncoding encoding;
	
	// Buffer containing the bytes of the current chunk read from the stream
	uint8_t *dataBuffer;
	
	// Temporary buffer of the bytes of the current line till a line termination marker is reached
	// Only when a line ending is reached can the bytes safely be decoded into a string
	NSMutableData *lineBuffer;
	// The position being read from the current chunk
	NSInteger pos;
	// The number of bytes read from the stream into the chunk
	NSInteger read;
	// The number of bytes actually processed so far
	NSUInteger bytesProcessed;
	// Whether the stream was opened by this decorator and should therefore be closed with it     
	BOOL shouldCloseStream;
}

/**
 Returns the number of bytes that have currently been processed by the decorator
 */
@property (readonly) NSUInteger bytesProcessed;

/**
 Creates a new decorator with the given stream, chunk size, and encoding
 */
- (id)initWithInputStream:(NSInputStream *)stream bufferSize:(NSUInteger)bufSize encoding:(NSStringEncoding)encoding;

/**
 Read a new line of text from the underlying stream
 */
- (NSString *)readLine;

@end

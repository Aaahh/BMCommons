//
//  BMBufferedInputStream.m
//  BMCommons
//
//  Created by Werner Altewischer on 3/2/11.
//  Copyright 2011 BehindMedia. All rights reserved.
//

#import <BMCommons/BMBufferedInputStream.h>


@implementation BMBufferedInputStream

@synthesize bytesProcessed;

#pragma mark -
#pragma mark Initialisation

- (id) initWithInputStream:(NSInputStream *)_stream bufferSize:(NSUInteger)_bufSize encoding:(NSStringEncoding)_encoding {
	if ( (self = [super init]) ) {
		if (!_stream) {
			return nil;
		}
		stream = _stream;
		bufSize = _bufSize;
		encoding = _encoding;
	}
	return self;
}

#pragma mark -
#pragma mark BMBufferedInputStream methods

- (NSString *) readLine {
	// emptying out the line buffer - this method will keep on reading
	// from the byte buffer and the stream until it can return a string,
	// either because it found a new line, or because it reached EOF
	[lineBuffer setLength:0];
	// make sure you start from where we left off with the previous call
	NSUInteger offset = pos;
	// this specifies where in the byte buffer the new line element was
	// found, but also serves as flag (if -1, no new line was found)
	NSInteger found = -1;
	do {
		if ( pos >= read ) {
			// we have reached the end of the byte buffer, read another chunk
			read = [stream read:dataBuffer maxLength:bufSize];
			// reset position in buffer and offset
			pos = offset = 0;
			if ( !read ) {
				// nothing was read, we have reached EOF
				if ( [lineBuffer length] ) {
					// if there are bytes in the line buffer, make sure whatever is there
					// is returned as the last line of the file
					break;
				} else {
					// no byte in the byte buffer, so signal that we have finished parsing
					return nil;
				}
			}
		}
		// this loop looks for line termination markers
		for ( ; pos < read; ++pos ) {
			if ( dataBuffer[pos] == 0x0A || dataBuffer[pos] == 0x0D ) {
				// found one, save its position
				found = pos;
				// move the pointer forward to the character at the beginning of the new line
				++pos;
				break;
			}
		}
		// add the processed bytes to the line buffer
		[lineBuffer appendBytes:&dataBuffer[offset] length:(found < 0 ? read : found) - offset];
		// if a new line was not found, read more from the stream and continue
	} while ( (found < 0) /* && read */ );
	//TODO: not very good multithread support - if bytesProcessed is read by another thread in the middle
	// of the execution of this method it will return inconsistent values - but it's ok for now
	// Also note we increase bytesProcessed in readLine as it doesn't invoke [self read:maxLength:],
	// but rather [stream read:maxLength:] directly, otherwise increasing in [MDBufferedInputStream read:maxLength:]
	// would be enough
	bytesProcessed += [lineBuffer length];
	// create a new string with the line buffer
	return [[NSString alloc] initWithData:lineBuffer encoding:encoding];
}

#pragma mark -
#pragma mark NSInputStream methods

- (void) open {
	if ( (shouldCloseStream = ([stream streamStatus] == kCFStreamStatusNotOpen)) ) {
		// If the underlying stream is not already open, we open it ourselves
		// and we will close it when the decorator is closed
		[stream open];
	}
	lineBuffer = [[NSMutableData alloc] init];
	dataBuffer = calloc(bufSize, sizeof(uint8_t));
	pos = 0;
	read = 0;
	bytesProcessed = 0;
    [super open];
}

- (BOOL) hasBytesAvailable {
	return [stream hasBytesAvailable];
}

// TODO define the semantics of this method within the decorator
- (NSInteger) read:(uint8_t *)buffer maxLength:(NSUInteger)len {
	return (bytesProcessed += [stream read:buffer maxLength:len]);
}

- (BOOL) getBuffer:(uint8_t **)buffer length:(NSUInteger *)len {
	return [stream getBuffer:buffer length:len];
}

- (void) close {
	free(dataBuffer);
	lineBuffer = nil;
	dataBuffer = nil;
	if ( shouldCloseStream ) {
		// Close the underlying stream if is was opened by this decorator
		[stream close];
	}
    [super close];
}

#pragma mark -
#pragma mark Deallocation

- (void) dealloc {
	[self close];
}

@end

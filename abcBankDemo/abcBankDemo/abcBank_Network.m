//
//  abcBank_Network.m
//  abcBankDemo
//
//  Created by Orasi Software on 6/10/13.
//  Copyright (c) 2013 Orasi Software. All rights reserved.
//

#import "abcBank_Network.h"

@interface NSStream (BoundPairAdditions)
+ (void)createBoundInputStream:(NSInputStream **)inputStreamPtr outputStream:(NSOutputStream **)outputStreamPtr bufferSize:(NSUInteger)bufferSize;
@end

@implementation NSStream (BoundPairAdditions)

+ (void)createBoundInputStream:(NSInputStream **)inputStreamPtr outputStream:(NSOutputStream **)outputStreamPtr bufferSize:(NSUInteger)bufferSize
{
    CFReadStreamRef     readStream;
    CFWriteStreamRef    writeStream;
    
    assert( (inputStreamPtr != NULL) || (outputStreamPtr != NULL) );
    
    readStream = NULL;
    writeStream = NULL;
    
#if defined(__MAC_OS_X_VERSION_MIN_REQUIRED) && (__MAC_OS_X_VERSION_MIN_REQUIRED < 1070)
#error If you support Mac OS X prior to 10.7, you must re-enable CFStreamCreateBoundPairCompat.
#endif
#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED) && (__IPHONE_OS_VERSION_MIN_REQUIRED < 50000)
#error If you support iOS prior to 5.0, you must re-enable CFStreamCreateBoundPairCompat.
#endif
    
    if (NO) {
        CFStreamCreateBoundPairCompat(
                                      NULL,
                                      ((inputStreamPtr  != nil) ? &readStream : NULL),
                                      ((outputStreamPtr != nil) ? &writeStream : NULL),
                                      (CFIndex) bufferSize
                                      );
    } else {
        CFStreamCreateBoundPair(
                                NULL,
                                ((inputStreamPtr  != nil) ? &readStream : NULL),
                                ((outputStreamPtr != nil) ? &writeStream : NULL),
                                (CFIndex) bufferSize
                                );
    }
    
    if (inputStreamPtr != NULL) {
        *inputStreamPtr  = CFBridgingRelease(readStream);
    }
    if (outputStreamPtr != NULL) {
        *outputStreamPtr = CFBridgingRelease(writeStream);
    }
}

@end

#pragma mark * PostController



@interface abcBank_Network () <NSStreamDelegate>
@property (nonatomic, assign, readonly ) BOOL               isSending;
@property (nonatomic, strong, readwrite) NSURLConnection *  connection;
@property (nonatomic, copy,   readwrite) NSData *           bodyPrefixData;
@property (nonatomic, strong, readwrite) NSInputStream *    fileStream;
@property (nonatomic, copy,   readwrite) NSData *           bodySuffixData;
@property (nonatomic, strong, readwrite) NSOutputStream *   producerStream;
@property (nonatomic, strong, readwrite) NSInputStream *    consumerStream;
@property (nonatomic, assign, readwrite) const uint8_t *    buffer;
@property (nonatomic, assign, readwrite) uint8_t *          bufferOnHeap;
@property (nonatomic, assign, readwrite) size_t             bufferOffset;
@property (nonatomic, assign, readwrite) size_t             bufferLimit;
@end


@implementation abcBank_Network
// Properties that don't need to be seen by the outside world.

@synthesize connection      = _connection;
@synthesize bodyPrefixData  = _bodyPrefixData;
@synthesize fileStream      = _fileStream;
@synthesize bodySuffixData  = _bodySuffixData;
@synthesize producerStream  = _producerStream;
@synthesize consumerStream  = _consumerStream;
@synthesize buffer          = _buffer;
@synthesize bufferOnHeap    = _bufferOnHeap;
@synthesize bufferOffset    = _bufferOffset;
@synthesize bufferLimit     = _bufferLimit;
@synthesize delegate        = _delegate;

enum {
    kPostBufferSize = 32768
};


#pragma mark * Status management

// These methods are used by the core transfer code to update the UI.

- (void)sendDidStart
{
//code that is called when the http post started sending
    
    

}

- (void)sendDidStopWithStatus:(NSString *)statusString
{
    if (statusString == nil) {
        statusString = @"POST succeeded";
    }
    //code that is called to the delegate
    //Is anyone listening
    if([self.delegate respondsToSelector:@selector(gotData)])
    {
        //send the delegate function with the amount entered by the user
        [self.delegate gotData];
    }
}

#pragma mark * Core transfer code

// This is the code that actually does the networking.

- (BOOL)isSending
{
    return (self.connection != nil);
}

- (NSString *)generateBoundaryString
{
    CFUUIDRef       uuid;
    CFStringRef     uuidStr;
    NSString *      result;
    
    uuid = CFUUIDCreate(NULL);
    assert(uuid != NULL);
    
    uuidStr = CFUUIDCreateString(NULL, uuid);
    assert(uuidStr != NULL);
    
    result = [NSString stringWithFormat:@"Boundary-%@", uuidStr];
    
    CFRelease(uuidStr);
    CFRelease(uuid);
    
    return result;
}

- (void)startSend
{
    NSString *              filePath;
    filePath = [[NSBundle mainBundle] pathForResource:@"bigimage" ofType:@"png"];
    assert(filePath != nil);
    
    BOOL                    success;
    NSURL *                 url;
    NSMutableURLRequest *   request;
    NSString *              boundaryStr;
    NSString *              contentType;
    NSString *              bodyPrefixStr;
    NSString *              bodySuffixStr;
    NSNumber *              fileLengthNum;
    unsigned long long      bodyLength;
    NSInputStream *         consStream;
    NSOutputStream *        prodStream;
    
    assert(filePath != nil);
    assert([[NSFileManager defaultManager] fileExistsAtPath:filePath]);
    assert( [filePath.pathExtension isEqual:@"png"] || [filePath.pathExtension isEqual:@"jpg"] );
    
    assert(self.connection == nil);         // don't tap send twice in a row!
    assert(self.bodyPrefixData == nil);     // ditto
    assert(self.fileStream == nil);         // ditto
    assert(self.bodySuffixData == nil);     // ditto
    assert(self.consumerStream == nil);     // ditto
    assert(self.producerStream == nil);     // ditto
    assert(self.buffer == NULL);            // ditto
    assert(self.bufferOnHeap == NULL);      // ditto
    
    // First get and check the URL.
    
    url = [NSURL URLWithString:@"mtestorasi-suda.rhcloud.co/health_check.php"];
    success = (url != nil);
    // If the URL is bogus, let the user know.  Otherwise kick off the connection.
    
    if ( ! success) {
        //url failed
    } else {
        // Determine the MIME type of the file.
        
        if ( [filePath.pathExtension isEqual:@"png"] ) {
            contentType = @"image/png";
        } else if ( [filePath.pathExtension isEqual:@"jpg"] ) {
            contentType = @"image/jpeg";
        } else if ( [filePath.pathExtension isEqual:@"gif"] ) {
            contentType = @"image/gif";
        } else {
            assert(NO);
            contentType = nil;          // quieten a warning
        }
        
        // Calculate the multipart/form-data body.  For more information about the
        // format of the prefix and suffix, see:
        //
        // o HTML 4.01 Specification
        //   Forms
        //   <http://www.w3.org/TR/html401/interact/forms.html#h-17.13.4>
        //
        // o RFC 2388 "Returning Values from Forms: multipart/form-data"
        //   <http://www.ietf.org/rfc/rfc2388.txt>
        
        boundaryStr = [self generateBoundaryString];
        assert(boundaryStr != nil);
        
        bodyPrefixStr = [NSString stringWithFormat:
                         @
                         // empty preamble
                         "\r\n"
                         "--%@\r\n"
                         "Content-Disposition: form-data; name=\"fileContents\"; filename=\"%@\"\r\n"
                         "Content-Type: %@\r\n"
                         "\r\n",
                         boundaryStr,
                         [filePath lastPathComponent],       // +++ very broken for non-ASCII
                         contentType
                         ];
        assert(bodyPrefixStr != nil);
        
        bodySuffixStr = [NSString stringWithFormat:
                         @
                         "\r\n"
                         "--%@\r\n"
                         "Content-Disposition: form-data; name=\"uploadButton\"\r\n"
                         "\r\n"
                         "Upload File\r\n"
                         "--%@--\r\n"
                         "\r\n"
                         //empty epilogue
                         ,
                         boundaryStr,
                         boundaryStr
                         ];
        assert(bodySuffixStr != nil);
        
        self.bodyPrefixData = [bodyPrefixStr dataUsingEncoding:NSASCIIStringEncoding];
        assert(self.bodyPrefixData != nil);
        self.bodySuffixData = [bodySuffixStr dataUsingEncoding:NSASCIIStringEncoding];
        assert(self.bodySuffixData != nil);
        
        fileLengthNum = (NSNumber *) [[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:NULL] objectForKey:NSFileSize];
        assert( [fileLengthNum isKindOfClass:[NSNumber class]] );
        
        bodyLength =
        (unsigned long long) [self.bodyPrefixData length]
        + [fileLengthNum unsignedLongLongValue]
        + (unsigned long long) [self.bodySuffixData length];
        
        // Open a stream for the file we're going to send.  We open this stream
        // straight away because there's no need to delay.
        
        self.fileStream = [NSInputStream inputStreamWithFileAtPath:filePath];
        assert(self.fileStream != nil);
        
        [self.fileStream open];
        
        // Open producer/consumer streams.  We open the producerStream straight
        // away.  We leave the consumerStream alone; NSURLConnection will deal
        // with it.
        
        [NSStream createBoundInputStream:&consStream outputStream:&prodStream bufferSize:32768];
        assert(consStream != nil);
        assert(prodStream != nil);
        self.consumerStream = consStream;
        self.producerStream = prodStream;
        
        self.producerStream.delegate = self;
        [self.producerStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [self.producerStream open];
        
        // Set up our state to send the body prefix first.
        
        self.buffer      = [self.bodyPrefixData bytes];
        self.bufferLimit = [self.bodyPrefixData length];
        
        // Open a connection for the URL, configured to POST the file.
        
        request = [NSMutableURLRequest requestWithURL:url];
        assert(request != nil);
        
        [request setHTTPMethod:@"POST"];
        [request setHTTPBodyStream:self.consumerStream];
        
        [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=\"%@\"", boundaryStr] forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%llu", bodyLength] forHTTPHeaderField:@"Content-Length"];
        
        self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
        assert(self.connection != nil);
        
        // Tell the UI we're sending.
        
        [self sendDidStart];
    }
}

- (void)stopSendWithStatus:(NSString *)statusString
{
    if (self.bufferOnHeap) {
        free(self.bufferOnHeap);
        self.bufferOnHeap = NULL;
    }
    self.buffer = NULL;
    self.bufferOffset = 0;
    self.bufferLimit  = 0;
    if (self.connection != nil) {
        [self.connection cancel];
        self.connection = nil;
    }
    self.bodyPrefixData = nil;
    if (self.producerStream != nil) {
        self.producerStream.delegate = nil;
        [self.producerStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [self.producerStream close];
        self.producerStream = nil;
    }
    self.consumerStream = nil;
    if (self.fileStream != nil) {
        [self.fileStream close];
        self.fileStream = nil;
    }
    self.bodySuffixData = nil;
    [self sendDidStopWithStatus:statusString];
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
// An NSStream delegate callback that's called when events happen on our
// network stream.
{
#pragma unused(aStream)
    assert(aStream == self.producerStream);
    
    switch (eventCode) {
        case NSStreamEventOpenCompleted: {
            // NSLog(@"producer stream opened");
        } break;
        case NSStreamEventHasBytesAvailable: {
            assert(NO);     // should never happen for the output stream
        } break;
        case NSStreamEventHasSpaceAvailable: {
            // Check to see if we've run off the end of our buffer.  If we have,
            // work out the next buffer of data to send.
            
            if (self.bufferOffset == self.bufferLimit) {
                
                // See if we're transitioning from the prefix to the file data.
                // If so, allocate a file buffer.
                
                if (self.bodyPrefixData != nil) {
                    self.bodyPrefixData = nil;
                    
                    assert(self.bufferOnHeap == NULL);
                    self.bufferOnHeap = malloc(kPostBufferSize);
                    assert(self.bufferOnHeap != NULL);
                    self.buffer = self.bufferOnHeap;
                    
                    self.bufferOffset = 0;
                    self.bufferLimit  = 0;
                }
                
                // If we still have file data to send, read the next chunk.
                
                if (self.fileStream != nil) {
                    NSInteger   bytesRead;
                    
                    bytesRead = [self.fileStream read:self.bufferOnHeap maxLength:kPostBufferSize];
                    
                    if (bytesRead == -1) {
                        [self stopSendWithStatus:@"File read error"];
                    } else if (bytesRead != 0) {
                        self.bufferOffset = 0;
                        self.bufferLimit  = bytesRead;
                    } else {
                        // If we hit the end of the file, transition to sending the
                        // suffix.
                        
                        [self.fileStream close];
                        self.fileStream = nil;
                        
                        assert(self.bufferOnHeap != NULL);
                        free(self.bufferOnHeap);
                        self.bufferOnHeap = NULL;
                        self.buffer       = [self.bodySuffixData bytes];
                        
                        self.bufferOffset = 0;
                        self.bufferLimit  = [self.bodySuffixData length];
                    }
                }
                
                // If we've failed to produce any more data, we close the stream
                // to indicate to NSURLConnection that we're all done.  We only do
                // this if producerStream is still valid to avoid running it in the
                // file read error case.
                
                if ( (self.bufferOffset == self.bufferLimit) && (self.producerStream != nil) ) {
                    // We set our delegate callback to nil because we don't want to
                    // be called anymore for this stream.  However, we can't
                    // remove the stream from the runloop (doing so prevents the
                    // URL from ever completing) and nor can we nil out our
                    // stream reference (that causes all sorts of wacky crashes).
                    //
                    // +++ Need bug numbers for these problems.
                    self.producerStream.delegate = nil;
                    // [self.producerStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
                    [self.producerStream close];
                    // self.producerStream = nil;
                }
            }
            
            // Send the next chunk of data in our buffer.
            
            if (self.bufferOffset != self.bufferLimit) {
                NSInteger   bytesWritten;
                bytesWritten = [self.producerStream write:&self.buffer[self.bufferOffset] maxLength:self.bufferLimit - self.bufferOffset];
                if (bytesWritten <= 0) {
                    [self stopSendWithStatus:@"Network write error"];
                } else {
                    self.bufferOffset += bytesWritten;
                }
            }
        } break;
        case NSStreamEventErrorOccurred: {
            NSLog(@"producer stream error %@", [aStream streamError]);
            [self stopSendWithStatus:@"Stream open error"];
        } break;
        case NSStreamEventEndEncountered: {
            assert(NO);     // should never happen for the output stream
        } break;
        default: {
            assert(NO);
        } break;
    }
}

- (void)connection:(NSURLConnection *)theConnection didReceiveResponse:(NSURLResponse *)response
// A delegate method called by the NSURLConnection when the request/response
// exchange is complete.  We look at the response to check that the HTTP
// status code is 2xx.  If it isn't, we fail right now.
{
#pragma unused(theConnection)
    NSHTTPURLResponse * httpResponse;
    
    assert(theConnection == self.connection);
    
    httpResponse = (NSHTTPURLResponse *) response;
    assert( [httpResponse isKindOfClass:[NSHTTPURLResponse class]] );
    
    if ((httpResponse.statusCode / 100) != 2) {
        [self stopSendWithStatus:[NSString stringWithFormat:@"HTTP error %zd", (ssize_t) httpResponse.statusCode]];
    } else {
        
        //the connection did receive a response
        //statusLabel.text = @"Response OK.";
    }
}

- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)data
// A delegate method called by the NSURLConnection as data arrives.  The
// response data for a POST is only for useful for debugging purposes,
// so we just drop it on the floor.
{
#pragma unused(theConnection)
#pragma unused(data)
    
    assert(theConnection == self.connection);
  
    // do nothing
}

- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error
// A delegate method called by the NSURLConnection if the connection fails.
// We shut down the connection and display the failure.  Production quality code
// would either display or log the actual error.
{
#pragma unused(theConnection)
#pragma unused(error)
    assert(theConnection == self.connection);
    
    [self stopSendWithStatus:@"Connection failed"];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection
// A delegate method called by the NSURLConnection when the connection has been
// done successfully.  We shut down the connection with a nil status, which
// causes the image to be displayed.
{
#pragma unused(theConnection)
    assert(theConnection == self.connection);
    
    
    
    [self stopSendWithStatus:nil];
}

















- (void)dealloc
{
    // Because NSURLConnection retains its delegate until the connection finishes, and 
    // any time the connection finishes we call -stopSendWithStatus: to clean everything 
    // up, we can't be deallocated with a connection in progress.
    assert(self->_connection == nil);
}@end

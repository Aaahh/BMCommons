//
//  BMHTTPStatusCodes.h
//
//  Created by Werner Altewischer on 03/09/08.
//  Copyright 2008 BehindMedia. All rights reserved.
//

#import <BMCommons/BMCoreObject.h>


#define HTTP_STATUS_CONTINUE 100
#define HTTP_STATUS_SWITCHING_PROTOCOLS 101
#define HTTP_STATUS_PROCESSING 102

#define HTTP_STATUS_OK 200
#define HTTP_STATUS_CREATED 201
#define HTTP_STATUS_ACCEPTED 202
#define HTTP_STATUS_NON_AUTHORITIVE_INFORMATION 203
#define HTTP_STATUS_NO_CONTENT 204
#define HTTP_STATUS_RESET_CONTENT 205
#define HTTP_STATUS_PARTIAL_CONTENT 206
#define HTTP_STATUS_MULTI_STATUS 207
#define HTTP_STATUS_ALREADY_REPORTED 208
#define HTTP_STATUS_IM_USED 226

#define HTTP_STATUS_MULTIPLE_CHOICES 300
#define HTTP_STATUS_MOVED_PERMANENTLY 301
#define HTTP_STATUS_FOUND 302
#define HTTP_STATUS_SEE_OTHER 303
#define HTTP_STATUS_NOT_MODIFIED 304
#define HTTP_STATUS_USE_PROXY 305
#define HTTP_STATUS_SWITCH_PROXY 306
#define HTTP_STATUS_TEMPORARY_REDIRECT 307
#define HTTP_STATUS_PERMANENT_REDIRECT 307

#define HTTP_STATUS_BAD_REQUEST 400
#define HTTP_STATUS_UNAUTHORIZED 401
#define HTTP_STATUS_PAYMENT_REQUIRED 402
#define HTTP_STATUS_FORBIDDEN 403
#define HTTP_STATUS_NOT_FOUND 404
#define HTTP_STATUS_METHOD_NOT_ALLOWED 405
#define HTTP_STATUS_NOT_ACCEPTABLE 406
#define HTTP_STATUS_PROXY_AUTHENTICATION_REQUIRED 407
#define HTTP_STATUS_REQUEST_TIMEOUT 408
#define HTTP_STATUS_CONFLICT 409
#define HTTP_STATUS_GONE 410
#define HTTP_STATUS_LENGTH_REQUIRED 411
#define HTTP_STATUS_PRECONDITION_FAILED 412
#define HTTP_STATUS_ENTITY_TOO_LARGE 413
#define HTTP_STATUS_URI_TOO_LONG 414
#define HTTP_STATUS_UNSUPPORTED_MEDIA_TYPE 415
#define HTTP_STATUS_REQUESTED_RANGE_NOT_SATISFIABLE 416
#define HTTP_STATUS_EXPECTATION_FAILED 417
#define HTTP_STATUS_AUTHENTICATION_TIMEOUT 419
#define HTTP_STATUS_ENHANCE_YOUR_CALM 420
#define HTTP_STATUS_UNPROCESSABLE_ENTITY 422
#define HTTP_STATUS_LOCKED 423
#define HTTP_STATUS_FAILED_DEPENDENCY 424
#define HTTP_STATUS_UNORDERED_COLLECTION 425
#define HTTP_STATUS_UPGRADE_REQUIRED 426
#define HTTP_STATUS_PRECONDITION_REQUIRED 428
#define HTTP_STATUS_TOO_MANY_REQUEST 429
#define HTTP_STATUS_REQUEST_HEADER_FIELD_TOO_LARGE 431
#define HTTP_STATUS_REQUEST_NO_RESPONSE 444
#define HTTP_STATUS_REQUEST_RETRY_WITH 449
#define HTTP_STATUS_REQUEST_BLOCKED_BY_PARENTAL_CONTROLS 450
#define HTTP_STATUS_REQUEST_UNVAILABLE_FOR_LEGAL_REASONS 451
#define HTTP_STATUS_REQUEST_REQUEST_HEADER_TOO_LARGE 494
#define HTTP_STATUS_REQUEST_CERT_ERROR 495
#define HTTP_STATUS_REQUEST_NO_CERT 496
#define HTTP_STATUS_REQUEST_HTTP_TO_HTTPS 497
#define HTTP_STATUS_REQUEST_CLIENT_CLOSED_REQUEST 499

#define HTTP_STATUS_INTERNAL_SERVER_ERROR 500
#define HTTP_STATUS_NOT_IMPLEMENTED 501
#define HTTP_STATUS_BAD_GATEWAY 502
#define HTTP_STATUS_SERVICE_UNAVAILABLE 503
#define HTTP_STATUS_GATEWAY_TIMEOUT 504
#define HTTP_STATUS_VERSION_NOT_SUPPORTED 505
#define HTTP_STATUS_VARIANT_ALSO_NEGOTIATES 506
#define HTTP_STATUS_INSUFFICIENT_STORAGE 507
#define HTTP_STATUS_LOOP_DETECTED 508
#define HTTP_STATUS_BANDWIDTH_LIMIT_EXCEEDED 509
#define HTTP_STATUS_NOT_EXTENDED 510
#define HTTP_STATUS_NETWORK_AUTHENTICATION_REQUIRED 511
#define HTTP_STATUS_NETWORK_READ_TIMEOUT_ERROR 598
#define HTTP_STATUS_NETWORK_CONNECTION_TIMEOUT 599

/**
 Helper class for HTTP status codes
 */
@interface BMHTTPStatusCodes : BMCoreObject

/**
 Returns the message corresponding to the specified HTTP code, such as "OK" for 200.
 */
+ (NSString *)messageForCode:(NSInteger)code;

@end

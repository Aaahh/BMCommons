//
//  BMDeviceHelper.h
//  BMCommons
//
//  Created by Werner Altewischer on 06/04/12.
//  Copyright (c) 2012 BehindMedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BMCommons/BMUICoreObject.h>

/**
 UIDevice utility methods.
 */
@interface BMDeviceHelper : BMUICoreObject {
    
}

/**
 Returns the network mac address as a string in format xx:xx:xx:xx:xx:xx
 */
+ (NSString *)macAddress;

@end

//
//  BMEnumeratedValue.m
//  BMCommons
//
//  Created by Werner Altewischer on 2/15/11.
//  Copyright 2011 BehindMedia. All rights reserved.
//

#import <BMCommons/BMEnumerationValue.h>
#import "NSNumber+BMCommons.h"
#import <BMCommons/BMRestKit.h>

@implementation BMEnumerationValue 

@synthesize value = _value;

+ (BMEnumerationValue *)enumerationValueWithValue:(id)theValue {
	BMEnumerationValue *ret = [BMEnumerationValue new];
	ret.value = theValue;
	return ret;
}

- (id)init {
    if ((self = [super init])) {
        BMRestKitCheckLicense();
    }
    return self;
}


- (NSString *)formattedValue {
	id theValue = _value;
	if ([_value isKindOfClass:[NSString class]]) {
		NSString *valueString = _value;
		NSArray *components = [valueString componentsSeparatedByString:@"_"];
		NSMutableString *s = [NSMutableString stringWithCapacity:valueString.length];
		for (NSString *component in components) {
			[s appendString:[component capitalizedString]];
		}
		theValue = s;
	}
	return [theValue description];
}

- (NSString *)valueDeclaration {
	NSString *ret = nil;
	if ([_value isKindOfClass:[NSNumber class]]) {
		NSNumber *n = _value;
		if ([n bmIsFloatNumber]) {
			ret = [NSString stringWithFormat:@"[NSNumber numberWithDouble:%f]", [n doubleValue]];
		} else if ([n bmIsBoolNumber]) {
			ret = [NSString stringWithFormat:@"[NSNumber numberWithBool:%@]", [n stringValue]];
		} else {
			ret = [NSString stringWithFormat:@"[NSNumber numberWithInt:%d]", [n intValue]];
		}
	} else {
		ret = [NSString stringWithFormat:@"@\"%@\"", [_value description]];
	}
	return ret;
}

- (BOOL)isEqual:(id)other {
	if (![other isKindOfClass:[self class]]) {
		return NO;
	}
	
	BMEnumerationValue *otherValue = other;
	return self.value == otherValue.value || [self.value isEqual:otherValue.value];
}

- (NSUInteger)hash {
	return [self.value hash];
}

@end

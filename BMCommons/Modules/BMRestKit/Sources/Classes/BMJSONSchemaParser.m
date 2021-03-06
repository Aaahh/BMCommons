//
//  BMJSONSchemaParser.m
//  BMCommons
//
//  Created by Werner Altewischer on 12/17/13.
//  Copyright (c) 2013 BehindMedia. All rights reserved.
//

#import <BMCommons/BMJSONSchemaParser.h>
#import <BMCommons/NSObject+BMCommons.h>
#import <BMCommons/NSDictionary+BMCommons.h>
#import <BMCommons/BMObjectMapping.h>
#import <BMCommons/BMStringHelper.h>
#import <BMCommons/NSString+BMCommons.h>
#import <BMCommons/BMLogging.h>
#import <BMCommons/BMErrorHelper.h>
#import <BMCommons/NSArray+BMCommons.h>
#import <BMCommons/BMCore.h>

@implementation BMJSONSchemaParser

static NSDictionary *jsonDataTypeDict = nil;

#define JS_MULTIPLE_OF @"multipleOf" //int: valid if <instance count>/multipleOf is an integer
#define JS_MAXIMUM @"maximum" //max value
#define JS_EXCLUSIVE_MAXIMUM @"exclusiveMaximum" //bool
#define JS_MINIMUM @"minimum" //min value
#define JS_EXCLUSIVE_MINIMUM @"exclusiveMinimum" //bool

#define JS_MAX_LENGTH @"maxLength" //max string length: UINT
#define JS_MIN_LENGTH @"minLength" //min string length: UINT, default 0
#define JS_PATTERN @"pattern" //regex validation pattern

#define JS_PROPERTIES @"properties"
#define JS_ENUM @"enum"
#define JS_TYPE @"type"
#define JS_REF @"$ref"
#define JS_ID @"id"
#define JS_ITEMS @"items"
#define JS_TITLE @"title"

#define JS_TYPE_OBJECT  @"object"
#define JS_TYPE_ARRAY @"array"
#define JS_TYPE_STRING @"string"
#define JS_TYPE_INTEGER @"integer"
#define JS_TYPE_NUMBER @"number"
#define JS_TYPE_BOOLEAN @"boolean"
#define JS_TYPE_NULL @"null"

+ (void)initialize {

    /*
     A JSON array.
     boolean
     A JSON boolean.
     integer
     A JSON number without a fraction or exponent part.
     number
     Any JSON number. Number includes integer.
     null
     The JSON null value.
     object
     A JSON object.
     string
     */
    
    if (jsonDataTypeDict == nil) {
        jsonDataTypeDict = @{
                             JS_TYPE_ARRAY : BM_FIELD_TYPE_ARRAY,
                             JS_TYPE_INTEGER : BM_FIELD_TYPE_INT,
                             JS_TYPE_NUMBER : BM_FIELD_TYPE_DOUBLE,
                             JS_TYPE_NULL : BM_FIELD_TYPE_OBJECT,
                             JS_TYPE_OBJECT : BM_FIELD_TYPE_OBJECT,
                             JS_TYPE_STRING : BM_FIELD_TYPE_STRING,
                             JS_TYPE_BOOLEAN : BM_FIELD_TYPE_BOOL
                             };
    }
    
}

#pragma mark - Protected

- (NSDictionary *)primitiveTypeDictionary {
    return jsonDataTypeDict;
}

- (NSDictionary *)parseSchemaImpl:(NSData *)schemaData objectMappings:(NSMutableDictionary *)objectMappings withError:(NSError *__autoreleasing *)error {
    
    Class sbjsonClass = NSClassFromString(@"SBJSON");
    id jsonObject = nil;
    
    SEL objectFromJSONDataSelector = NSSelectorFromString(@"objectFromJSONData");
    
    if ([schemaData respondsToSelector:objectFromJSONDataSelector]) {
        BM_IGNORE_SELECTOR_LEAK_WARNING(
        jsonObject = [schemaData performSelector:objectFromJSONDataSelector withObject:nil];
        )
    } else if (sbjsonClass) {
        id jsonParser = [sbjsonClass new];
        
        SEL objectWithStringSelector = NSSelectorFromString(@"objectWithString:");
        if ([jsonParser respondsToSelector:objectWithStringSelector]) {
            NSString *jsonString = [[NSString alloc] initWithData:schemaData encoding:NSUTF8StringEncoding];
            BM_IGNORE_SELECTOR_LEAK_WARNING(
            jsonObject = [jsonParser performSelector:objectWithStringSelector withObject:jsonString];
            )
        }
    }
    
    if (!jsonObject) {
        jsonObject = [NSJSONSerialization JSONObjectWithData:schemaData options:0 error:error];
    }
    
    NSDictionary *schemaDict = [jsonObject bmCastSafely:[NSDictionary class]];
    NSString *rootElementName = @"";
    
    if (schemaDict) {
        if ([self parseSchemaDict:schemaDict withName:rootElementName objectMapping:nil objectMappingDict:objectMappings addToFieldMappings:NO fieldTypeRef:nil error:error] != BMSchemaFieldTypeNone) {
            return objectMappings;
        }
    }
    return nil;
}

#pragma mark - Private

- (BMSchemaFieldType)parseSchemaDict:(NSDictionary *)schemaDict withName:(NSString *)theName objectMapping:(BMObjectMapping *)objectMapping objectMappingDict:(NSMutableDictionary *)objectMappingDict addToFieldMappings:(BOOL)addToFieldMappings fieldTypeRef:(NSString **)fieldTypeRef error:(NSError **)error {
    NSString *jsonType = [schemaDict objectForKey:JS_TYPE];
    NSString *refId = [schemaDict objectForKey:JS_REF];
    NSString *title = [schemaDict objectForKey:JS_TITLE];
    NSString *fieldType = nil;
    BMSchemaFieldType schemaFieldType = BMSchemaFieldTypeNone;
    
    if (refId != nil) {
        schemaFieldType = BMSchemaFieldTypeObjectReference;
        fieldType = refId;

    } else if ([jsonType isEqual:JS_TYPE_OBJECT]) {
        
        NSString *mappingId = [schemaDict objectForKey:JS_ID];
        if (title == nil) {
            //Ignore object mappings without a title
            LogWarn(@"Object mapping without title is ignored for element name: %@", theName);
            return BMSchemaFieldTypeNone;
        }
        
        schemaFieldType = BMSchemaFieldTypeObject;
        
        NSDictionary *jsonProperties = [schemaDict objectForKey:JS_PROPERTIES];
        BMObjectMapping *om = [self objectMappingForProperties:jsonProperties withElementName:theName title:title mappingId:mappingId objectMappingDict:objectMappingDict error:error];
        
        if (om == nil) {
            return BMSchemaFieldTypeNone;
        }
        
        if (!objectMapping) {
            objectMapping = om;
            objectMapping.rootElement = YES;
        }
        
        fieldType = om.name;
        
    } else if ([jsonType isEqual:JS_TYPE_ARRAY]) {
        
        schemaFieldType = BMSchemaFieldTypeArray;
        
        NSDictionary *itemDict = [schemaDict bmObjectForKey:JS_ITEMS ofClass:[NSDictionary class]];
        
        BMSchemaFieldType retType = [self parseSchemaDict:itemDict withName:theName objectMapping:objectMapping objectMappingDict:objectMappingDict addToFieldMappings:NO fieldTypeRef:&fieldType error:error];
        
        if (retType == BMSchemaFieldTypeNone) {
            return BMSchemaFieldTypeNone;
        }
        
        schemaFieldType |= retType;
    } else {
        fieldType = [self.primitiveTypeDictionary objectForKey:jsonType];
        
        schemaFieldType = BMSchemaFieldTypePrimitive;
    }
    
    if (fieldType == nil) {
        //Ignore object mappings without a title
        LogWarn(@"JSON type: '%@' is not supported by the BMRestKit framework for mapping with name: '%@' for object mapping: '%@'", jsonType, theName, objectMapping.name);
        return BMSchemaFieldTypeNone;
    }
    
    if (addToFieldMappings) {
        NSString *mappingPath = theName;
        if ((schemaFieldType & BMSchemaFieldTypeObjectReference) == BMSchemaFieldTypeObjectReference) {
            //Add a temporary mapping: will be resolved when all parsing is done
            
            BMFieldMapping *fieldMapping = [BMFieldMapping new];
            fieldMapping.mappingPath = mappingPath;
            fieldMapping.objectMappingRefId = fieldType;
            fieldMapping.schemaFieldType = schemaFieldType;
            [objectMapping addFieldMapping:fieldMapping];
            
        } else {
            NSString *fieldDescriptor = [self fieldDescriptorForField:mappingPath type:fieldType fieldType:schemaFieldType];
            
            BMFieldMapping *fieldMapping = [[BMFieldMapping alloc] initWithFieldDescriptor:fieldDescriptor
                                                                               mappingPath:mappingPath];
            [objectMapping addFieldMapping:fieldMapping];
        }
    }
    
    if (objectMapping != nil) {
        BMObjectMapping* existingObjectMapping = [objectMappingDict objectForKey:objectMapping.name];
        
        if (existingObjectMapping && !existingObjectMapping.rootElement && objectMapping.rootElement) {
            existingObjectMapping.rootElement = YES;
            existingObjectMapping.elementName = objectMapping.elementName;
        } else {
            [objectMappingDict setObject:objectMapping forKey:objectMapping.name];
        }
    }
    
    if (fieldTypeRef) {
        *fieldTypeRef = fieldType;
    }
    
    return schemaFieldType;
}

- (NSArray *)genericClassNamesFromString:(NSString *)classNameString {
    
    if (!classNameString) {
        return nil;
    }
    
    NSMutableArray *ret = [NSMutableArray array];
    
    NSMutableString *s = [NSMutableString stringWithString:classNameString];
    NSRange range1;
    NSRange range2;
    
    BOOL classFound;
    do {
        classFound = NO;
        NSString *className = nil;
        range1 = [s rangeOfString:@"<" options:NSBackwardsSearch];
        if (range1.location != NSNotFound) {
            range2 = [s rangeOfString:@">" options:0 range:NSMakeRange(range1.location, s.length - range1.location)];
            if (range2.location != NSNotFound && range2.location > range1.location) {
                className = [s substringWithRange:NSMakeRange(range1.location + 1, range2.location - range1.location - 1)];
                if (className.length > 0) {
                    [ret insertObject:className atIndex:0];
                    classFound = YES;
                    [s deleteCharactersInRange:NSMakeRange(range1.location, range2.location - range1.location + 1)];
                }
            }
        }
    } while (classFound);
    
    [ret insertObject:s atIndex:0];
    
    return ret;
}


- (BOOL)getObjectType:(NSString **)objectType namespace:(NSString **)namespace fromFQClassName:(NSString *)classNameString {
    
    classNameString = [classNameString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"[]{} \t\n"]];
    
    NSArray *classNameComponents = [classNameString componentsSeparatedByString:@","];
    if (classNameComponents.count > 1) {
        //Only parse the value type
        LogWarn(@"For dictionaries the key type is ignored and is always a string, key type found: %@", classNameComponents.firstObject);
    }
    classNameString = classNameComponents.lastObject;
    
    NSArray *genericClassNames = [self genericClassNamesFromString:classNameString];
    
    NSMutableString *className = [NSMutableString string];
    
    for (NSString *s in genericClassNames) {
        if (className.length > 0) {
            [className appendString:@"Of"];
        }
        
        NSRange range = [s rangeOfString:@"." options:NSBackwardsSearch];
        NSString *genericClassName = nil;
        if (range.location == NSNotFound || range.location >= s.length) {
            genericClassName = s;
        } else {
            genericClassName = [s substringFromIndex:(range.location + 1)];
        }
        [className appendString:genericClassName];
    }
    [className replaceOccurrencesOfString:@"$" withString:@"_" options:0 range:NSMakeRange(0, className.length)];
    
    BOOL parsedSuccessfully = NO;
    
    if (className.length > 0) {
        parsedSuccessfully = YES;
        
        NSRange range = [genericClassNames.firstObject rangeOfString:@"." options:NSBackwardsSearch];
        NSString *theNameSpace = nil;
        if (range.location != NSNotFound) {
            theNameSpace = [genericClassNames.firstObject substringToIndex:range.location];
        }
        if (objectType) {
            *objectType = className;
        }
        if (namespace) {
            *namespace = theNameSpace;
        }
    }
    return parsedSuccessfully;
}

- (BOOL)getObjectType:(NSString **)objectType namespace:(NSString **)namespace parentObjectType:(NSString **)parentObjectType parentNamespace:(NSString **)parentNamespace fromTitle:(NSString *)title {
    
    NSArray *components = [title componentsSeparatedByString:@":"];
    BOOL valid = components.count >= 1 && components.count <= 2;
    if (components.count >= 1) {
        valid = valid && [self getObjectType:objectType namespace:namespace fromFQClassName:[components objectAtIndex:0]];
    }
    if (components.count >= 2) {
        valid = valid && [self getObjectType:parentObjectType namespace:parentNamespace fromFQClassName:[components objectAtIndex:1]];
    }
    return valid;
}

- (BMObjectMapping *)objectMappingForProperties:(NSDictionary *)jsonProperties withElementName:(NSString *)elementName title:(NSString *)title
                                      mappingId:(NSString *)mappingId objectMappingDict:(NSMutableDictionary *)objectMappingDict error:(NSError **)error {
    BMObjectMapping *currentMapping = [BMObjectMapping new];
    
    currentMapping.elementName = elementName;
    currentMapping.mappingId = mappingId;
    
    NSString *mappingName = nil;
    NSString *parentMappingName = nil;
    
    if (!title) {
        mappingName = [self.mappableObjectClassResolver mappableObjectClassNameForObjectType:elementName namespace:nil];
        
    } else if ([self.mappableObjectClassResolver getMappableObjectClassName:&mappingName andParentClassName:&parentMappingName fromDescriptor:title]) {
        
    } else {
        if (error) {
            *error = [BMErrorHelper genericErrorWithDescription:[NSString stringWithFormat:@"Could not parse object mapping with title: %@", title]];
        }
        return nil;
    }

    currentMapping.name = mappingName;
    currentMapping.parentName = parentMappingName;
    
    for (NSString *propertyName in jsonProperties) {
        NSDictionary *propertyDict = [jsonProperties objectForKey:propertyName];
        if ([self parseSchemaDict:propertyDict withName:propertyName objectMapping:currentMapping objectMappingDict:objectMappingDict addToFieldMappings:YES fieldTypeRef:nil error:error] == BMSchemaFieldTypeNone) {
            return nil;
        }
    }
    return currentMapping;
}


@end

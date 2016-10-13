/***

Important:

This is sample code demonstrating API, technology or techniques in development.
Although this sample code has been reviewed for technical accuracy, it is not 
final. Apple is supplying this information to help you plan for the adoption of 
the technologies and programming interfaces described herein. This information 
is subject to change, and software implemented based on this sample code should 
be tested with final operating system software and final documentation. Newer 
versions of this sample code may be provided with future seeds of the API or 
technology. For information about updates to this and other developer 
documentation, view the New & Updated sidebars in subsequent documentation seeds.

***/

/*

File: XMLReader.m
Abstract: Use libxml to parse a document and return an XMLDocument.

Version: 1.0

Disclaimer: IMPORTANT:  This Apple software is supplied to you by
Apple Inc. ("Apple") in consideration of your agreement to the
following terms, and your use, installation, modification or
redistribution of this Apple software constitutes acceptance of these
terms.  If you do not agree with these terms, please do not use,
install, modify or redistribute this Apple software.

In consideration of your agreement to abide by the following terms, and
subject to these terms, Apple grants you a personal, non-exclusive
license, under Apple's copyrights in this original Apple software (the
"Apple Software"), to use, reproduce, modify and redistribute the Apple
Software, with or without modifications, in source and/or binary forms;
provided that if you redistribute the Apple Software in its entirety and
without modifications, you must retain this notice and the following
text and disclaimers in all such redistributions of the Apple Software.
Neither the name, trademarks, service marks or logos of Apple Inc.
may be used to endorse or promote products derived from the Apple
Software without specific prior written permission from Apple.  Except
as expressly stated in this notice, no other rights or licenses, express
or implied, are granted by Apple herein, including but not limited to
any patent rights that may be infringed by your derivative works or by
other works in which the Apple Software may be incorporated.

The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.

IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.

Copyright (C) 2008 Apple Inc. All Rights Reserved.

*/

#import <BMCommons/BMXMLReader.h>
#import <BMCommons/BMXMLDocument.h>
#import <BMCommons/BMXMLUtilities.h>
#import <BMCommons/BMCore.h>

@implementation BMXMLReader

+ (BMXMLDocument *)parseXMLFileAtURL:(NSURL *)URL parseError:(NSError **)error
{
    NSError *err = nil;
    NSString *URLContents = [NSString stringWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:&err];
    
    if (!URLContents) {
        return nil;
    }
        
    return [[self class] parseXMLString:URLContents parseError:error];
}

+ (BMXMLDocument *)parseXMLString:(NSString *)XMLString parseError:(NSError **)error
{
    const char *XMLChars = [XMLString cStringUsingEncoding:NSUTF8StringEncoding];
    
    return [[self class] parseXML:XMLChars parseError:error];
}

+ (BMXMLDocument *)parseXMLData:(NSData *)XMLData parseError:(NSError **)error {
	NSString *xmlString = [[NSString alloc] initWithData:XMLData encoding:NSUTF8StringEncoding];
    BMXMLDocument *doc = [[self class] parseXMLString:xmlString parseError:error];
	return doc;
}

+ (BMXMLDocument *)parseXML:(const char *)XMLString parseError:(NSError **)parseError
{
    if (!XMLString) {
        return nil;
    }

    xmlDocPtr doc;
    xmlNodePtr cur;
 
    xmlParserCtxtPtr ctxt = xmlNewParserCtxt();
    
    if( !(doc = xmlCtxtReadMemory(ctxt, XMLString, BMShortenUIntToIntSafely(strlen(XMLString), nil), NULL, NULL, 0) ) ){
        
        xmlError *originalError = xmlCtxtGetLastError(ctxt);
        
        NSError *error = originalError ? [BMXMLUtilities errorWithXMLError:originalError] : nil;
        if (parseError) {
            *parseError = error;
        }
		
		xmlClearParserCtxt(ctxt);
        xmlFreeParserCtxt(ctxt);
        xmlCleanupParser();
        xmlFreeDoc(doc);
        return nil;
    }
 
    if( !(cur = xmlDocGetRootElement( doc ) ) ){
		
		xmlClearParserCtxt(ctxt);
        xmlFreeParserCtxt(ctxt);
        xmlCleanupParser();
        xmlFreeDoc(doc);
        return nil;
    }
    
    xmlClearParserCtxt(ctxt);
    xmlFreeParserCtxt(ctxt);
    xmlCleanupParser();
    
    return [BMXMLDocument documentWithXMLDocument:doc];
}

@end

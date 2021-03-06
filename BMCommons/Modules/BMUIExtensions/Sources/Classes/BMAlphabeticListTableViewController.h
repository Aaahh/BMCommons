//
//  BMAlphabeticListTableViewController.h
//  BMCommons
//
//  Created by Werner Altewischer on 14/10/10.
//  Copyright 2010 BehindMedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BMCommons/BMEntityServiceModelTableViewController.h>
#import <BMCommons/BMNamedObject.h>

@interface BMAlphabeticListTableViewController : BMEntityServiceModelTableViewController {
	NSDictionary *allObjects;
	NSMutableDictionary *searchedObjects;
	BOOL searching;
	NSString *searchString;
	NSMutableArray *indexTitles;
	BOOL summaryCellEnabled;
}

@property (nonatomic, readonly) NSDictionary *allObjects;
@property (nonatomic, readonly) NSMutableDictionary *searchedObjects;
@property (nonatomic, assign, getter=isSummaryCellEnabled) BOOL summaryCellEnabled;

//Methods to be implemented by sub classes

/**
  * Action to perform when the row for the supplied object has been selected.
  */
- (void)didSelectRowForObject:(id<BMNamedObject>)object;

/**
  * The summary cell (to be displayed at the bottom of the table)
  */
- (UITableViewCell *)summaryCellForCount:(NSUInteger)count;

/**
  * Cell for the specified object
  */
- (UITableViewCell *)cellForObject:(id<BMNamedObject>)object;

@end

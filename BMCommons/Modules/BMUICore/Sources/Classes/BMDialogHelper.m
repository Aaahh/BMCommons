//
//  BMDialogHelper.m
//  BMCommons
//
//  Created by Werner Altewischer on 7/10/08.
//  Copyright 2010 BehindMedia. All rights reserved.
//

#import <BMCommons/BMDialogHelper.h>
#import <BMCommons/BMUICore.h>

#define TEXT_FIELD_TAG 8654

@implementation BMDialogHelper

+ (UIActionSheet *)dialogOKCancelWithTitle:(NSString *)title withDelegate:(id <UIActionSheetDelegate>)delegate withView:(UIView *)view
{
	// open a dialog with an OK and cancel button
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title
															 delegate:delegate cancelButtonTitle:BMUICoreLocalizedString(@"button.title.cancel", @"Cancel") destructiveButtonTitle:BMUICoreLocalizedString(@"button.title.ok", @"OK") otherButtonTitles:nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	[actionSheet showInView:view];
	return actionSheet;
}

+ (UIActionSheet *)dialogYesNoWithTitle:(NSString *)title withDelegate:(id <UIActionSheetDelegate>)delegate withView:(UIView *)view
{
	// open a dialog with an OK and cancel button
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title
															 delegate:delegate cancelButtonTitle:BMUICoreLocalizedString(@"button.title.no", @"No") destructiveButtonTitle:BMUICoreLocalizedString(@"button.title.yes", @"Yes") otherButtonTitles:nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	[actionSheet showInView:view];
	return actionSheet;
}

+ (UIActionSheet *)dialogWithTitle:(NSString *)title 
			   delegate:(id <UIActionSheetDelegate>)delegate 
	  cancelButtonTitle:(NSString *)cancelTitle
 destructiveButtonTitle:(NSString *)destructiveTitle
	  otherButtonTitles:(NSArray *)otherTitles 
				forView:(UIView *)theView 
				withTag:(NSUInteger)tag {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title
															 delegate:delegate cancelButtonTitle:cancelTitle destructiveButtonTitle:destructiveTitle otherButtonTitles:nil];
	for (NSString *title in otherTitles) {
		[actionSheet addButtonWithTitle:title];
	}
	actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
	actionSheet.tag = tag;
	actionSheet.cancelButtonIndex = 1 + [otherTitles count];
	[actionSheet showInView:theView];
	return actionSheet;
}

+ (UIAlertView *)alertWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
	[alertView show];
	return alertView;
}

+ (UIAlertView *)alertWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate {
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:BMUICoreLocalizedString(@"button.title.ok", @"OK") otherButtonTitles:nil];
	[alertView show];
	return alertView;
}

@end

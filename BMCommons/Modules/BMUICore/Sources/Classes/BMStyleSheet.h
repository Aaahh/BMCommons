//
//  BMStyleSheet.h
//  BMCommons
//
//  Created by Werner Altewischer.
//  Copyright 2011 BehindMedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BMCommons/BMUICoreObject.h>
#import <UIKit/UIKit.h>

/**
 UI style sheet.
 
 Stylesheets return common user interface elements used in views or view controllers.
 */
@interface BMStyleSheet : BMUICoreObject

/**
 The default stylesheet to be used.
 */
+ (instancetype)defaultStyleSheet;

/**
 Sets the default stylesheet.
 */
+ (void)setDefaultStyleSheet:(BMStyleSheet*)styleSheet;

/**
 Returns the top-most stylesheet of the stack or the default stylesheet as fallback.
 */
+ (instancetype)currentStyleSheet;

/**
 Push a stylesheet on the stack to make it current.
 */
+ (void)pushStyleSheet:(BMStyleSheet*)styleSheet;

/**
 Pops the top-most stylesheet from the stack.
 */
+ (void)popStyleSheet;

/**
 Frees any memory caches held
 */
- (void)freeMemory;

@end

@interface BMStyleSheet(BMNavigationController)

/**
 The default navigation bar style to use.
 */
- (UIBarStyle)navigationBarStyle;

/**
 The default navigation bar tint color to use. 
 
 This maps to tintColor on iOS < 7 and barTintColor >= 7.
 */
- (UIColor *)navigationBarTintColor;

/**
 The tintColor (under iOS 7) for the navigation bar. 
 
 Doesn't have any effect on iOS < 7.
 */
- (UIColor *)navigationBarTextTintColor;

/**
 The default translucency of navigation bar to use.
 */
- (BOOL)navigationBarTranslucent;

@end

/**
 Defaults used by BMTableViewController.
 */
@interface BMStyleSheet(BMTableViewController)

/**
 Default plain background color.
 */
- (UIColor*)tableViewPlainBackgroundColor;

/**
 Default grouped background color.
 */
- (UIColor*)tableViewGroupedBackgroundColor;

/**
 Default row height if non other is supplied.
 */
- (CGFloat)tableViewRowHeight;

/**
 Default separator style.
 */
- (UITableViewCellSeparatorStyle)tableViewSeparatorStyle;

/**
 Default separator color.
 */
- (UIColor *)tableViewSeparatorColor;

/**
 The default background image for the table view.
 If this returns non-nil the background color of the tableview itself is set to [UIColor clearColor].
 */
- (UIImage *)tableViewBackgroundImage;

/**
 The default background color for a tableview cell.
 */
- (UIColor *)tableViewCellBackgroundColor;

@end

/**
 Default style for BMTableViewCells.
 */
@interface BMStyleSheet (BMTableViewCell)

/**
 Default cell selection style for sub classes of BMTableViewCell.
 */
- (UITableViewCellSelectionStyle)tableViewCellSelectionStyle;

/**
 Default BMTableViewCell text color.
 
 @see [UITableViewCell textLabel]
 */
- (UIColor *)tableViewCellTextColor;

/**
 Default BMTableViewCell text font.
 
 @see [UITableViewCell textLabel]
 */
- (UIFont *)tableViewCellTextFont;

/**
 Default BMTableViewCell detail text color.
 
 @see [UITableViewCell detailTextLabel]
 */
- (UIColor *)tableViewCellDetailTextColor;

/**
 Default BMTableViewCell detail text font.
 
 @see [UITableViewCell detailTextLabel]
 */
- (UIFont *)tableViewCellDetailTextFont;

@end

/**
 Style elements for the BMTableHeaderDragRefreshView and BMTableFooterDragLoadMoreView.
 */
@interface BMStyleSheet (BMDragRefreshHeader)

/**
 The font used for the last updated label.
 */
- (UIFont*) tableRefreshHeaderLastUpdatedFont;

/**
 The font used for the status label.
 */
- (UIFont*) tableRefreshHeaderStatusFont;

/**
 The background color used for the view.
 */
- (UIColor*) tableRefreshHeaderBackgroundColor;

/**
 The text color used.
 */
- (UIColor*) tableRefreshHeaderTextColor;

/**
 The shadow text color used.
 */
- (UIColor*) tableRefreshHeaderTextShadowColor;

/**
 The shadow offset for the text.
 */
- (CGSize)   tableRefreshHeaderTextShadowOffset;

/**
 The arrow image used. 
 
 This image is rotated automatically by the view as needed.
 */
- (UIImage*) tableRefreshHeaderArrowImage;

/**
 Sound to play when the user drags to refresh.
 */
- (NSURL*)dragRefreshSoundFileURL;

/**
 The style to use for the activity indicator.
 */
- (UIActivityIndicatorViewStyle)tableRefreshHeaderActivityIndicatorStyle;

@end

/**
 Style elements used by BMBusyView (loading indicator).
 */
@interface BMStyleSheet (BMBusyView)

/**
 The background image for the send to background button.
 */
- (UIImage *)busyViewSendToBackgroundButtonImage;

/**
 The text color for the cancel label of the busy view.
 */
- (UIColor *)busyViewCancelLabelTextColor;

/**
 The text color for the title label of the busy view.
 */
- (UIColor *)busyViewTitleLabelTextColor;

/**
 The background color for the busy view.
 */
- (UIColor *)busyViewBackgroundColor;

/**
 The activity indicator style for the busy view.
 */
- (UIActivityIndicatorViewStyle)busyViewActivityIndicatorStyle;

@end

/**
 Style elements used by BMAsyncImageButton.
 */
@interface BMStyleSheet(BMAsyncImageButton)

/**
 The image to show when an async image button is loading or fails loading.
 */
- (UIImage *)asyncImageButtonPlaceHolderImage;

@end


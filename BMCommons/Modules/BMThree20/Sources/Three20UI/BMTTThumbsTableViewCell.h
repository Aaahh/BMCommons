//
// Copyright 2009-2011 Facebook
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

// UI
#import <UIKit/UIKit.h>

@protocol BMTTPhoto;
@protocol BMTTThumbsTableViewCellDelegate;
@class BMTTThumbView;

@interface BMTTThumbsTableViewCell : UITableViewCell {
    id<BMTTPhoto>     _photo;
    
    NSMutableArray* _thumbViews;
    
    CGFloat         _thumbSize;
    CGPoint         _thumbOrigin;
    NSInteger       _columnCount;
    
    Class _thumbViewClass;
    
    id<BMTTThumbsTableViewCellDelegate> _delegate;
}

@property (nonatomic, retain) id<BMTTPhoto> photo;
@property (nonatomic)         CGFloat     thumbSize;
@property (nonatomic)         CGPoint     thumbOrigin;
@property (nonatomic)         NSInteger   columnCount;
@property (nonatomic)         Class       thumbViewClass;

@property (nonatomic, assign) id<BMTTThumbsTableViewCellDelegate> delegate;

- (void)suspendLoading:(BOOL)suspended;

@end

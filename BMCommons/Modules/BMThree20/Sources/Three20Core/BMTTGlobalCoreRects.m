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

#import "Three20Core/BMTTGlobalCoreRects.h"


///////////////////////////////////////////////////////////////////////////////////////////////////
CGRect BMTTRectContract(CGRect rect, CGFloat dx, CGFloat dy) {
  return CGRectMake(rect.origin.x, rect.origin.y, rect.size.width - dx, rect.size.height - dy);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
CGRect BMTTRectShift(CGRect rect, CGFloat dx, CGFloat dy) {
  return CGRectOffset(BMTTRectContract(rect, dx, dy), dx, dy);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
CGRect BMTTRectInset(CGRect rect, UIEdgeInsets insets) {
  return CGRectMake(rect.origin.x + insets.left, rect.origin.y + insets.top,
                    rect.size.width - (insets.left + insets.right),
                    rect.size.height - (insets.top + insets.bottom));
}

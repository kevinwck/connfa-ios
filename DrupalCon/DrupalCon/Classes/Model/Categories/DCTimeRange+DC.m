/**********************************************************************************
 *                                                                           
 *  The MIT License (MIT)
 *  Copyright (c) 2015 Lemberg Solutions Limited
 *  Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the "Software"), to
 *  deal in the Software without restriction, including without limitation the 
 *  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
 *  sell copies of the Software, and to permit persons to whom the Software is
 *  furnished to do so, subject to the following conditions:
 *   The above copyright notice and this permission notice shall be included in
 *   all  copies or substantial portions of the Software.
 *
 *   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 *  FROM,  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS 
 *  IN THE SOFTWARE.
 *
 *                                                                           
 *****************************************************************************/



#import "DCTimeRange+DC.h"
#import "NSDate+DC.h"
#import "NSManagedObject+DC.h"

#import "DCMainProxy.h"

@implementation DCTimeRange (DC)

- (NSString*)stringValue {
  return
      [NSString stringWithFormat:@"%@ - %@",
                                 [self.from dateToStringWithFormat:@"h:mm aaa"],
                                 [self.to dateToStringWithFormat:@"h:mm aaa"]];
}

- (void)setFrom:(NSString*)from to:(NSString*)to {
  self.from = [NSDate dateFromString:from format:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
  self.to = [NSDate dateFromString:to format:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
}

- (BOOL)isEqualTo:(DCTimeRange*)timeRange {
  BOOL result = YES;
  if (![timeRange.from isEqualToDate:self.from]) {
    result = NO;
  }

  if (![timeRange.to isEqualToDate:self.to]) {
    result = NO;
  }

  return result;
}
- (NSString*)description {
  return [self stringValue];
}

@end

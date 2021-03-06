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





#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DCLevel, DCSpeaker, DCTimeRange, DCTrack, DCType;

@interface DCEvent : NSManagedObject

@property(nonatomic, retain) NSDate* date;
@property(nonatomic, retain) NSString* desctiptText;
@property(nonatomic, retain) NSNumber* eventId;
@property(nonatomic, retain) NSString* name;
@property(nonatomic, retain) NSString* link;
@property(nonatomic, retain) NSString* place;
@property(nonatomic, retain) NSNumber* order;
@property(nonatomic, retain) DCLevel* level;
@property(nonatomic, retain) NSSet* speakers;
@property(nonatomic, retain) DCTimeRange* timeRange;
@property(nonatomic, retain) NSSet* tracks;
@property(nonatomic, retain) DCType* type;

@property(nonatomic, retain) NSNumber* favorite;
@property(nonatomic, retain) NSString* calendarId;

@end

@interface DCEvent (CoreDataGeneratedAccessors)

- (void)addSpeakersObject:(DCSpeaker*)value;
- (void)removeSpeakersObject:(DCSpeaker*)value;
- (void)addSpeakers:(NSSet*)values;
- (void)removeSpeakers:(NSSet*)values;

- (void)addTracksObject:(DCTrack*)value;
- (void)removeTracksObject:(DCTrack*)value;
- (void)addTracks:(NSSet*)values;
- (void)removeTracks:(NSSet*)values;

@end

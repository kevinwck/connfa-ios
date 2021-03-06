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



#import "DCDayEventsController.h"
#import "DCEventCell.h"
#import "DCDayEventsDataSource.h"
#import "DCTimeRange+DC.h"
#import "DCTime+DC.h"
#import "DCType+DC.h"
#import "DCSpeaker+DC.h"
#import "DCLevel+DC.h"
#import "DCEventDetailViewController.h"
#import "DCLimitedNavigationController.h"
#import "DCAppFacade.h"
#import "DCTrack+DC.h"
#import "DCInfoEventCell.h"
#import "DCFavoriteEventsDataSource.h"
@interface DCDayEventsController ()<DCEventCellProtocol>

@property(nonatomic, weak) IBOutlet UILabel* noItemsLabel;
@property(nonatomic, weak) IBOutlet UIImageView* noItemsImageView;

@property(nonatomic, strong) NSString* stubMessage;
@property(nonatomic, strong) UIImage* stubImage;

@property(nonatomic) DCEventDataSource* eventsDataSource;

@property(nonatomic, strong) DCEventCell* cellPrototype;

@end

@implementation DCDayEventsController

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
  [super viewDidLoad];

  if (!self.stubMessage && !self.stubImage) {
    // this controller is not Stub controller and contains events
    [self registerCells];
    [self initDataSource];

    self.cellPrototype = [self.tableView
        dequeueReusableCellWithIdentifier:NSStringFromClass(
                                              [DCEventCell class])];
  } else {
    // this controller does not have events and will show stub Message or Image
    self.tableView.dataSource = nil;
    self.tableView.hidden = YES;

    self.noItemsLabel.hidden = !self.stubMessage;
    self.noItemsImageView.hidden = !self.stubImage;

    if (self.stubMessage) {
      self.noItemsLabel.text = self.stubMessage;
    } else if (self.stubImage) {
      self.noItemsImageView.image = self.stubImage;
    }
  }
}

- (void)dealloc {
  self.stubMessage = nil;
  self.stubImage = nil;

  self.cellPrototype = nil;
}

- (void)initAsStubControllerWithString:(NSString*)noEventMessage {
  self.stubMessage = noEventMessage;
}

- (void)initAsStubControllerWithImage:(UIImage*)noEventsImage {
  self.stubImage = noEventsImage;
}

- (void)updateEvents {
  [self.eventsDataSource reloadEvents];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
}

- (void)registerCells {
  NSString* className = NSStringFromClass([DCEventCell class]);
  [self.tableView registerNib:[UINib nibWithNibName:className bundle:nil]
       forCellReuseIdentifier:className];
}

- (void)initDataSource {
  self.eventsDataSource = [self dayEventsDataSource];
  __weak typeof(self) weakSelf = self;
  [self.eventsDataSource
      setPrepareBlockForTableView:^UITableViewCell*(UITableView* tableView,
                                                    NSIndexPath* indexPath) {
        NSString* cellIdentifier = NSStringFromClass([DCEventCell class]);
        DCEventCell* cell = (DCEventCell*)
            [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

        DCEvent* event =
            [weakSelf.eventsDataSource eventForIndexPath:indexPath];
        NSInteger eventsCountInSection =
            [weakSelf.eventsDataSource tableView:tableView
                           numberOfRowsInSection:indexPath.section];
        cell.isLastCellInSection =
            (indexPath.row == eventsCountInSection - 1) ? YES : NO;
        cell.isFirstCellInSection = !indexPath.row;

        [cell initData:event delegate:weakSelf];
        // Some conditions for favorite events
        NSString* titleForNextSection = [weakSelf.eventsDataSource
            titleForSectionAtIdexPath:indexPath.section + 1];
        cell.separatorCellView.hidden =
            (titleForNextSection && cell.isLastCellInSection) ? YES : NO;
        if ([weakSelf.eventsStrategy leftSectionContainerColor]) {
          cell.leftSectionContainerView.backgroundColor =
              [weakSelf.eventsStrategy leftSectionContainerColor];
        }

        cell.eventTitleLabel.textColor = [UIColor blackColor];
        if ([event.favorite boolValue] &&
            [weakSelf.eventsStrategy favoriteTextColor]) {
          cell.eventTitleLabel.textColor =
              [weakSelf.eventsStrategy favoriteTextColor];
        }

        return cell;
      }];
}

- (DCEventDataSource*)dayEventsDataSource {
  if (self.eventsStrategy.strategy == EDCEeventStrategyFavorites) {
    return [[DCFavoriteEventsDataSource alloc]
        initWithTableView:self.tableView
            eventStrategy:self.eventsStrategy
                     date:self.date];
  }
  return [[DCDayEventsDataSource alloc] initWithTableView:self.tableView
                                            eventStrategy:self.eventsStrategy
                                                     date:self.date];
}

- (void)didSelectCell:(DCEventCell*)eventCell {
  NSIndexPath* cellIndexPath = [self.tableView indexPathForCell:eventCell];
  DCEvent* selectedEvent =
      [self.eventsDataSource eventForIndexPath:cellIndexPath];
  [self.parentProgramController openDetailScreenForEvent:selectedEvent];
}

#pragma mark - UITableView delegate

- (CGFloat)tableView:(UITableView*)tableView
    heightForRowAtIndexPath:(NSIndexPath*)indexPath {
  DCEvent* event = [self.eventsDataSource eventForIndexPath:indexPath];
  self.cellPrototype.isFirstCellInSection = !indexPath.row;
  [self.cellPrototype initData:event delegate:self];

  return [self.cellPrototype getHeightForEvent:event
                              isFirstInSection:!indexPath.row];
}

- (CGFloat)tableView:(UITableView*)tableView
    heightForHeaderInSection:(NSInteger)section {
  return [self.eventsDataSource titleForSectionAtIdexPath:section] ? 30 : 0.;
}

- (UIView*)tableView:(UITableView*)tableView
    viewForHeaderInSection:(NSInteger)section {
  DCInfoEventCell* headerViewCell = (DCInfoEventCell*)[tableView
      dequeueReusableCellWithIdentifier:NSStringFromClass(
                                            [DCInfoEventCell class])];

  NSString* title = [self.eventsDataSource titleForSectionAtIdexPath:section];
  if (title) {
    headerViewCell.titleLabel.text = title;
    return [headerViewCell contentView];
  }

  UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0.0)];
  v.backgroundColor = [UIColor whiteColor];
  return v;
}

@end

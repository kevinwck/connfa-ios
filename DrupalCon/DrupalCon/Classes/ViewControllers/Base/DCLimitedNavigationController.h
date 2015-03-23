//
//  DCLimitedNavigationController.h
//  DrupalCon
//
//  Created by Volodymyr Hyrka on 3/3/15.
//  Copyright (c) 2015 Lemberg Solution. All rights reserved.
//

// this controller is used for limiting Stack depth.
// So if we have 10 controllers in stack and MAX_DEPTH == 3, on Back button press we will be returned to previous, and then return to the root.
// Also it has fake root VC to show native Back button and dismisses itself after last Back button press
// This controller can be shown modally (dismissAction must be nil) or in another way (in that case developer should handle last Back button press with dismissAction Block)

#import <UIKit/UIKit.h>


typedef void (^CompletionBlock)();
typedef void (^BackButtonBlock)();

@interface DCLimitedNavigationController : UINavigationController<UINavigationControllerDelegate>

@property (nonatomic) NSInteger maxDepth;

- (instancetype) initWithRootViewController:(UIViewController *)rootViewController
                                 completion:(CompletionBlock)aBlock;

- (instancetype) initWithRootViewController:(UIViewController *)rootViewController
                                 completion:(CompletionBlock)aBlock
                                      depth:(NSInteger)maxDepth;

- (instancetype) initWithRootViewController:(UIViewController *)rootViewController
                              dismissAction:(BackButtonBlock)aBlock
                                      depth:(NSInteger)maxDepth;

@end
//
//  AppDelegate.h
//  ARSpaceships
//
//  Created by Nick on 6/8/11.
//  Copyright Nick Waynik Jr. 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
    UIView *overlay;
}

@property (nonatomic, retain) UIWindow *window;

@end

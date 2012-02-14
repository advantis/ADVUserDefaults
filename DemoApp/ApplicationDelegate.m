//
//  Copyright © 2012 Yuri Kotov
//


#import "ApplicationDelegate.h"

// Controller
#import "EmergencyCardViewController.h"

@implementation ApplicationDelegate

@synthesize window = _window;

- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	_window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	_window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[EmergencyCardViewController new]];
	[_window makeKeyAndVisible];
	return YES;
}

@end

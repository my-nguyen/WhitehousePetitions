//
//  AppDelegate.swift
//  WhitehousePetitions
//
//  Created by My Nguyen on 8/7/16.
//  Copyright © 2016 My Nguyen. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        let splitViewController = self.window!.rootViewController as! UISplitViewController
        let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as! UINavigationController
        navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem()
        splitViewController.delegate = self

        /// the following creates a duplicate MasterViewController wrapped inside a navigation controller,
        /// gives it a new tab bar item to distinguish it form the existing tab, then adds it to the list
        /// of visible tabs. This lets us use the same class for both tabs without having to duplicate
        /// things in the storyboard.
        // in this Master-Detail application, the root view controller is the UISplitViewController,
        // which has a property called viewControllers, which stores 2 items: 1) the table view controller
        // on the left; and 2) the detail view controller on the right
        let tabBarController = splitViewController.viewControllers[0] as! UITabBarController
        // obtain a reference to Main.storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // create a view controller based on the storyboard ID of "NavController" set earlier
        let viewController = storyboard.instantiateViewControllerWithIdentifier("NavController") as! UINavigationController
        // create a UITabBarItem with "Top Rated" icon; a tag of 1 is to identify this MasterViewController
        viewController.tabBarItem = UITabBarItem(tabBarSystemItem: .TopRated, tag: 1)
        // add the new view controller to the array viewControllers of the tab bar controller
        tabBarController.viewControllers?.append(viewController)

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: - Split view

    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController:UIViewController, ontoPrimaryViewController primaryViewController:UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController else { return false }
        if topAsDetailController.detailItem == nil {
            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
            return true
        }
        return false
    }

}


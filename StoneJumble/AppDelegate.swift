//
//  AppDelegate.swift
//  StoneJumble
//
//  Created by Tony Ayoub on 11/4/15.
//  Copyright © 2015 amahy. All rights reserved.
//

import UIKit
import Foundation
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, ChartboostDelegate
{

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        // Override point for customization after application launch.
        PlistManager.sharedInstance.startPlistManager()
        
        Chartboost.start(withAppId: "5918666e04b016421b68f37d", appSignature: "cdd14df71b60862ee056c4dad0a00a61df5b05ca", delegate: self)

        // my app id
        GADMobileAds.configure(withApplicationID: "ca-app-pub-6439333454694134~6656115022")


            //    NSSetUncaughtExceptionHandler(&myExceptionHandler)

        
        return true
    }


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func didDismissInterstitial(_ location: String!)
    {
        NPDirector.runActionAfterAdDismissed()
        NPDirector.shared.gamePaused = false
        if(NPDirector.shared.musicEnabled)
        {
            SJDirector.shared.playBGMusic()
        }
        print("function after ad")
    }

    func didDismissRewardedVideo(_ location: String!)
    {
        NPDirector.shared.gamePaused = false
        if(NPDirector.shared.musicEnabled)
        {
            SJDirector.shared.playBGMusic()
        }
        if NPDirector.shared.hasGoldToAdd
        {
            Boxes.addGoldWithPrice(price: 0) //so that gold is not added unless after ad is watched
            NPDirector.shared.hasGoldToAdd = false
        }
        print("function after rewarded video")
    }

}


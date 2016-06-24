//
//  AppDelegate.swift
//  Instagram
//
//  Created by Abha Vedula on 6/20/16.
//  Copyright © 2016 Abha Vedula. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        var navigationBarAppearace = UINavigationBar.appearance()
        

        navigationBarAppearace.tintColor = uicolorFromHex(getWhite())
        navigationBarAppearace.barTintColor = uicolorFromHex(getBlue())
        
        
        
        // change navigation item title color
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "Helvetica", size: 24.0)!]
        
        // Add this code to change StateNormal text Color,
        // then if StateSelected should be different, you should add this code
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState: .Selected)
        
        navigationBarAppearace.shadowImage = UIImage(contentsOfFile: "white")



        
        
        Parse.initializeWithConfiguration(
            ParseClientConfiguration(block: { (configuration:ParseMutableClientConfiguration) -> Void in
                configuration.applicationId = "Instagram"
                configuration.clientKey = "instagram"  // set to nil assuming you have not set clientKey
                configuration.server = "https://guarded-oasis-28558.herokuapp.com/parse"
            })
        )
        
        if PFUser.currentUser() != nil {
            // if there is a logged in user then load the home view controller
        }
        
        return true
    }
    
    func getBlue() -> UInt32 {
        // Example: use color triplet CC6699 "=" {204, 102, 153} (RGB triplet)
        let color = UIColor(red: 81/255.0, green: 155/255.0, blue: 209/255.0, alpha: 1.0)
        var col : UInt32 = 0
        // read colors to CGFloats and convert and position to proper bit positions in UInt32
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if color.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            
            
            
            col += UInt32(red * 255.0) << 16 +
                UInt32(green * 255.0) << 8 +
                UInt32(blue * 255.0)
            
            
        }
        return col
    }
    
    func getWhite() -> UInt32 {
        // Example: use color triplet CC6699 "=" {204, 102, 153} (RGB triplet)
        let color = UIColor.whiteColor()
        var col : UInt32 = 0
        // read colors to CGFloats and convert and position to proper bit positions in UInt32
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if color.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            
            
            
            col += UInt32(red * 255.0) << 16 +
                UInt32(green * 255.0) << 8 +
                UInt32(blue * 255.0)
            
            
        }
        return col
    }

    
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
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


}


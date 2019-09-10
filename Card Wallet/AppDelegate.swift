//
//  AppDelegate.swift
//  Card Wallet
//
//  Created by Keyur on 11/03/19.
//  Copyright © 2019 Keyur. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import NVActivityIndicatorView
import Firebase
import MFSideMenu

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var activityLoader : NVActivityIndicatorView!
    var container : MFSideMenuContainerViewController = MFSideMenuContainerViewController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        application.statusBarStyle = .lightContent
        
        //IQKeyboardManager
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = true
        
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
        
        if isUserLogin()
        {
            AppModel.shared.currentUser = getLoginUserData()
            AppDelegate().sharedDelegate().navigateToDashboard()
        }
        setupFirebase()
        
        return true
    }

    //MARK:- App Delete function
    var statusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func storyboard() -> UIStoryboard
    {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    func sharedDelegate() -> AppDelegate
    {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    //MARK:- Navigation
    func navigateToDashboard()
    {
        let rootVC: MFSideMenuContainerViewController = self.storyboard().instantiateViewController(withIdentifier: "MFSideMenuContainerViewController") as! MFSideMenuContainerViewController
        container = rootVC
        
        let navRoot : UINavigationController = (self.storyboard().instantiateViewController(withIdentifier: "DashboardVCNavigation") as? UINavigationController)!
        
        let leftSideMenuVC: UIViewController = self.storyboard().instantiateViewController(withIdentifier: "SideMenuVC")
        
        container.menuWidth = (UI_USER_INTERFACE_IDIOM() == .pad) ? 300 : (UIScreen.main.bounds.size.width - 70)
        container.panMode = MFSideMenuPanModeSideMenu
        container.menuSlideAnimationEnabled = false
        container.leftMenuViewController = leftSideMenuVC
        container.centerViewController = navRoot
        
        container.view.layer.masksToBounds = false
        container.view.layer.shadowOffset = CGSize(width: 10, height: 10)
        container.view.layer.shadowOpacity = 0.5
        container.view.layer.shadowRadius = 5
        container.view.layer.shadowColor = UIColor.clear.cgColor
        
        if let rootNavigatioVC : UINavigationController = self.window?.rootViewController as? UINavigationController
        {
            rootNavigatioVC.pushViewController(container, animated: false)
        }
    }
    
    func logoutFromApp()
    {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            AppModel.shared.currentUser = nil
            AppModel.shared.USERS = [UserModel]()
            AppModel.shared.CARDS = [CardModel]()
            removeUserDefaultValues()
            
            if let nav : UINavigationController = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "LoginVCNavigation") as? UINavigationController
            {
               self.window?.rootViewController = nav
            }
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    
    //MARK:- Loader
    func showLoader()
    {
        removeLoader()
        window?.isUserInteractionEnabled = false
        activityLoader = NVActivityIndicatorView(frame: CGRect(x: ((window?.frame.size.width)!-50)/2, y: ((window?.frame.size.height)!-50)/2, width: 50, height: 50))
        activityLoader.type = .ballSpinFadeLoader
        activityLoader.color = ColorType.White.value
        window?.addSubview(activityLoader)
        activityLoader.startAnimating()
    }
    
    func removeLoader()
    {
        window?.isUserInteractionEnabled = true
        if activityLoader == nil
        {
            return
        }
        activityLoader.stopAnimating()
        activityLoader.removeFromSuperview()
        activityLoader = nil
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Card_Wallet")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

/**
 * Get Top View Control
 *
 * Find the top view controller from queue and return it.
 * It's used in global function whenever need active View controller
 *
 * @param
 */
extension UIApplication {
    class func topViewController(base: UIViewController? = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}

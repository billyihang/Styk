//
//  AppDelegate.swift
//  Styk
//
//  Created by William Yang on 8/1/18.
//  Copyright © 2018 William Yang. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var fetchedRC: NSFetchedResultsController<Project>!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        guard let tabBarController = window?.rootViewController as? UITabBarController,
            let splitViewController =  tabBarController.viewControllers?[1] as? UISplitViewController,
            let leftNavController = splitViewController.viewControllers.first as? UINavigationController,
            let masterTableViewController = leftNavController.topViewController as? MasterTableViewController,
            let rightNavController = splitViewController.viewControllers.last as? UINavigationController,
            let taskViewController = rightNavController.topViewController as? TasksTableViewController,
        let bootcampSplitViewController = tabBarController.viewControllers?[2] as? UISplitViewController,
        let bootcampTopNavController = bootcampSplitViewController.viewControllers.first as? UINavigationController,
        let bootcampMasterViewController = bootcampTopNavController.topViewController as? BootcampMasterTableViewController,
        let bootcampBottomNavController = bootcampSplitViewController.viewControllers.last as? UINavigationController,
        let bootcampDetailViewController = bootcampBottomNavController.topViewController as? BootcampDetailViewController
            else { fatalError() }
        
        // TODO: - first time user input
        //DataManager.delete(fileName: "EB318C12-1EFC-4BA1-BC2C-2E1E4DD3EDB4")
        refresh()
        
        // Set delegate
        masterTableViewController.delegate = taskViewController
        bootcampMasterViewController.delegate = bootcampDetailViewController
        
        // Random stuff for Ipad
        taskViewController.navigationItem.leftItemsSupplementBackButton = true
        taskViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
        
        bootcampDetailViewController.navigationItem.leftItemsSupplementBackButton = true
        bootcampDetailViewController.navigationItem.leftBarButtonItem = bootcampSplitViewController.displayModeButtonItem

        // Set initial project
        bootcampDetailViewController.introSelected()
        taskViewController.project = fetchedRC.fetchedObjects?.first
    

        return true
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
    }

    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Styk")
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

    func refresh() {
        let context = self.persistentContainer.viewContext
        let request = Project.fetchRequest() as NSFetchRequest<Project>
        let sort = NSSortDescriptor(keyPath: \Project.sort, ascending: true)
        request.sortDescriptors = [sort]
        do {
            fetchedRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            try fetchedRC.performFetch()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        if (fetchedRC.fetchedObjects?.isEmpty)! {
            let projects = ProjectData.createProjects()
            for i in 0...1 {
                let projectGenerated: ProjectData = projects[i]
                let project = Project(entity: Project.entity(), insertInto: context)
                project.name = projectGenerated.name
                project.color = projectGenerated.color
                project.colorString = projectGenerated.colorString
                project.deletable = projectGenerated.deletable
                project.sort = Int16(i)
            }
            self.saveContext()
            refresh()
        }
    }
    
}




//
//  AppDelegate.swift
//  StudioMedDatabase
//
//  Created by Sean Goldsborough on 5/6/18.
//  Copyright © 2018 Sean Goldsborough. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseAuth
import FirebaseMessaging
import FirebaseInstanceID
import GoogleSignIn
import UserNotifications


var userIsAdmin = false
var userObject = UserData.sharedInstance()
//var numberOfAppLaunches = 0



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            // ...
            print("error on google sign-in \(error)")
            return
        } else {
            // Perform any operations on signed in user here.
            let userId = user.userID// For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let firstName = user.profile.givenName

            userObject.firstName = firstName
            print("idToken on google sign-in is \(user.authentication.idToken)")
            print("userId on google sign-in is \(user.userID)")
            print("userObject first name on google sign-in is \(userObject.firstName)")
            
            if firstName == "Konrad" && idToken != nil {
                userIsAdmin = true
            }
            // ...
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        // ...
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
               print("error on google sign-in Auth \(error)")
                return
            } else {
                print("Google Authentification Success")
                let authID = Auth.auth().currentUser?.uid
                print("Auth id is: \(Auth.auth().currentUser?.uid)")
                
                if authID == "foAmqL4Qm3UgpzkTckLOBMHHwd53" || authID == "foAmqL4Qm3UgpzkTckLOBMHHwd53" {
                    userIsAdmin = false
                }
                
                let mainStoryBoard: UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
                
                if userIsAdmin == true {
                let adminTabBarVC = mainStoryBoard.instantiateViewController(withIdentifier: "AdminTabBarVC") as! AdminTabBarVC
                let appDelegate = UIApplication.shared.delegate
                appDelegate?.window??.rootViewController = adminTabBarVC
                    
                } else {
                    let clientTabVC = mainStoryBoard.instantiateViewController(withIdentifier: "ClientTabVC") as! ClientTabVC
                    
                    let appDelegate = UIApplication.shared.delegate
                    appDelegate?.window??.rootViewController = clientTabVC
                    
                }
            }            }
            // User is signed in
            // ...
        }
    
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error {
            // ...
            print("error on google sign-in disconnect \(error)")
            return
        } else {
            print("google sign-in disconnected correctly!")
            // Perform any operations when the user disconnects from app here.
            // ...
        }
    }

    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
   
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let newFont = UIFont(name: "Avenir Next", size: 16.0)!
        //let color = UIColor.white
        let color = UIColor(rgb: 0xFF6666)
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.classForCoder() as! UIAppearanceContainer.Type]).setTitleTextAttributes([NSAttributedStringKey.foregroundColor: color, NSAttributedStringKey.font: newFont], for: .normal)
     
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        Messaging.messaging().delegate = self
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        
        let token = Messaging.messaging().fcmToken
        print("FCM token: \(token ?? "")")
        
        func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
            print("Firebase registration token: \(fcmToken)")
            
            // TODO: If necessary send token to application server.
            // Note: This callback is fired at each app startup and whenever a new token is generated.
        }
        
        //Instansiate View
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var initialViewController: UIViewController
        
        // COUNT NUMBER OF APP LAUNCHES get current number of times app has been launched
        let currentCount = UserDefaults.standard.integer(forKey: "launchCount")
        
        // increment received number by one
        UserDefaults.standard.set(currentCount+1, forKey:"launchCount")
        
        // save changes to disk
        UserDefaults.standard.synchronize()
        
        
        print("currentCount app launches = \(currentCount)")

        //Choose which VC to show based on UserDefaults notification
        if UIApplication.isFirstLaunch() {
            initialViewController = mainStoryboard.instantiateViewController(withIdentifier: "OnBoardingVC") as! OnBoardingVC
        } else {
            initialViewController = mainStoryboard.instantiateViewController(withIdentifier: "FirstLoginVC") as! FirstLoginVC
        }
        
//        if currentCount > 4 {
//            print("we launched the app more than 4 times")
//            AlertView.alertPopUp(view: initialViewController, alertMessage: "Rate the app!")
//        }
        
        self.window?.rootViewController = initialViewController
        
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
        -> Bool {
            return GIDSignIn.sharedInstance().handle(url, sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: [:])
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
    
    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    // [END receive_message]
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the FCM registration token.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        
        // With swizzling disabled you must set the APNs token here.
        // Messaging.messaging().apnsToken = deviceToken
    }


    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "StudioMedDatabase")
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

extension UIApplication {
    class func isFirstLaunch() -> Bool {
        if !UserDefaults.standard.bool(forKey: "HasAtLeastLaunchedOnce") {
            UserDefaults.standard.set(true, forKey: "HasAtLeastLaunchedOnce")
            UserDefaults.standard.synchronize()
            return true
        }
        return false
    }
}

// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler()
    }
}
// [END ios_10_message_handling]

extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    // [END refresh_token]
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
    // [END ios_10_data_message]
}


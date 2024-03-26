//
//  AppDelegate.swift
//  MyDua
//
//  Created by IB Arts Mac on 08/11/23.
//

import UIKit
import MediaPlayer
import AVKit
import FirebaseCore
import UserNotifications
import AVFoundation

@main
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var audioPlayer: AVAudioPlayer?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: { _, _ in }
            )
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "EEEE"
        let dateString = df.string(from: date)
        print(dateString)
        UserDefaults.standard.set(dateString, forKey: "currentDay")
        FirebaseApp.configure()
    
        return true
    }

    // If the app is in the background
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let id = response.notification.request.identifier
        print("Received notification with ID = \(id)")
        let userInfo = response.notification.request.content.userInfo
        //playMusic()
        // Print full message.
        print(userInfo)
    
        //load details screen
        completionHandler()

    }
    
    // If the app is in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let id = notification.request.identifier
        print("Received notification with ID = \(id)")
        playMusic()
        completionHandler([.sound, .alert,.badge])
    }
    
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


    
    
    func playMusic() {
        guard let soundURL = Bundle.main.url(forResource: "azan", withExtension: "mp3") else {
            print("Music file not found")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.play()
            
            
            
        } catch {
            print("Error playing music: \(error.localizedDescription)")
        }
    }
    
    
}


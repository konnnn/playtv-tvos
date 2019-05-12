//
//  AppDelegate.swift
//  playtv-tvos
//
//  Created by Evgeny Konkin on 19.04.2019.
//  Copyright © 2019 Evgeny Konkin. All rights reserved.
//

import UIKit
import AVFoundation
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let yandexChannelsURL = "http://tv.evgenykonkin.ru/playlist/yandex-channels.txt"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if user.object(forKey: "ChannelCell") == nil {
            user.set(CellIdentifier.ProgramCell.identifier(), forKey: "ChannelCell")
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback, options: .mixWithOthers)
        } catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed, \(error.localizedDescription)")
        }
        
        print("\(Realm.Configuration.defaultConfiguration.fileURL!)\n\n" )

        do {
            let realm = try Realm()
            
            // Загружаем каналы Яндекс, если их нет в бд
            let results: Results<YandexChannel>? = realm.objects(YandexChannel.self)
            
            if results?.count == 0 {
                downloadYandexChannels(url: URL(string: yandexChannelsURL)!)
                print("\n\n Каналы Яндекс загружены")
            }
            
        } catch {
            print("Error initialising new realm, \(error)")
        }
        
        return true
    }
    
    private func downloadYandexChannels(url: URL) {
        // http://tv.evgenykonkin.ru/playlist/yandex-channels.txt
        
        let task = URLSession.shared.downloadTask(with: url) { (localURL, urlResponse, error) in
            
            if let localURL = localURL, error == nil {
                
                if let channelsString = try? String(contentsOf: localURL) {
                    
                    let realm = try! Realm()
                    
                    // разбиваем строковый файл на строки в массив
                    let linesArray: [String] = channelsString.components(separatedBy: .newlines)
                    
                    for line in linesArray {
                        
                        if line.trimmingCharacters(in: .whitespacesAndNewlines).count != 0 {
                            let items = line.components(separatedBy: "|")
                            
                            let newChannel = YandexChannel()
                            newChannel.yaid = Int(items[2])!
                            newChannel.name = items[3]
                            newChannel.synonyms = items[5].count == 0 ? "" : items[5]
                            newChannel.desc = items[9].count == 0 ? "" : items[9]
                            
                            do {
                                try realm.write {
                                    realm.add(newChannel)
                                }
                            } catch {
                                print("\n\n  !Error add new channel")
                            }
                        }
                    }
                }
            }
        }
        task.resume()
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        print("\nApplication Will Resign Active")
        player?.pause()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("\nApplication Did Enter Background, Player paused")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        print("\nApplication Will Enter Foreground, Player playing")
//        player?.play()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        print("\nApplication Did Become Active")
        let delay = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: delay) {
            player?.play()
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        print("\nApplication Will Terminate")
    }


}


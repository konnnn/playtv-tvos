//
//  DownloadHandler.swift
//  playtv-tvos
//
//  Created by Evgeny Konkin on 24.04.2019.
//  Copyright © 2019 Evgeny Konkin. All rights reserved.
//

//import UIKit
import Foundation
import RealmSwift

class DownloadHandler: NSObject {
    
    public static func download(name: String, urlString: String, completion: @escaping (_ message: String, _ failure: Bool) -> Void) {
        
        // убираем все пробелы из адреса, если они там оказались
        let urlStringTrimmed = urlString.components(separatedBy: .whitespaces).joined()
        
        var urlStringEdited: String?
        
        // проверяем на наличие префикса в адресе (http://)
        if urlStringTrimmed.hasPrefix("http://") || urlStringTrimmed.hasPrefix("https://") {
            urlStringEdited = urlStringTrimmed
        } else {
            // если нет! то добавляем
            urlStringEdited = "http://" + urlStringTrimmed
        }
        
        print("\n\n  Name: \(name), URL: \(urlStringEdited!)")
        
        guard let url = URL(string: urlStringEdited!), name.count > 0 else { return }
        
        let trimmingName: String = name.trimmingCharacters(in: .whitespaces)
        
        var message: String = "Ошибка!"
        var failure: Bool = true
        
        // загрузка файла-плейлиста
        let task = URLSession.shared.downloadTask(with: url) { (localURL, urlResponse, error) in
            
            // если url-адрес существует
            if let localURL = localURL, error == nil {
                
                if let playlistString = try? String(contentsOf: localURL) {
                    
                    let realm = try! Realm()
                    
                    // создаем новый плейлист
                    let newPlaylist = Playlist()
                    newPlaylist.title = trimmingName
                    let date = Date()
                    newPlaylist.dateAdded = date
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyyMMddHHmmss"
                    newPlaylist.id = formatter.string(from: date)
                    
                    // разбиваем строковый файл на строки в массив
                    var linesArray: [String] = playlistString.components(separatedBy: .newlines)
                    linesArray = linesArray.filter{ $0 != "" }
                    linesArray = linesArray.filter{ !$0.isEmpty }
                    
                    // проверка на правильность плейлиста,
                    // первая строка должна содержать — #EXTM3U
                    if linesArray[0].hasPrefix("#EXTM3U") {
                        linesArray.removeFirst()
                        var channel = Channel()
                        var index = 0
                        
                        for (_, line) in linesArray.enumerated() {
                            
                            if line.hasPrefix("#EXTINF") {
                                let lines = line.components(separatedBy: ",")
                                
                                getYandexChannelName(name: lines[1], completion: { (yaid, yandexName, yandexDesc) in
                                    index += 1
                                    channel.index = index
                                    channel.yaid = yaid
                                    channel.name = yandexName
                                    channel.desc = yandexDesc
                                })
                                
                            } else if line.hasPrefix("#EXTGRP") {
                                let lines = line.components(separatedBy: ":")
                                channel.genre = lines[1]
                                
                            } else if line.hasPrefix("http") {
                                channel.url = line
                                
                                // добавляем канал в новый плейлист
                                newPlaylist.channels.append(channel)
                                
                                print("  \(channel.index). \(channel.name!) / \(channel.genre) / \(channel.url!)")
                                
                                // обнуляем переменные объекта
                                channel = Channel()
                            }
                            
                        }
                        
                        if newPlaylist.channels.count > 0 {
                            do {
                                // сохраняем в бд
                                try realm.write {
                                    realm.add(newPlaylist)
                                }
                                
                                savePlaylistURLForUser(name: trimmingName, url: urlStringTrimmed)
                                
                                message = "Загрузка завершена успешно"
                                failure = false
                                
                            } catch {
                                // если не удалось сохранить в бд
                                message = "Не удалось сохранить плейлист"
                                failure = true
                            }
                            
                        } else {
                            message = "Плейлист пустой"
                            failure = true
                        }
                        
                    } else {
                        // если файл-плейлист не правильный
                        message = "Не правильный плейлист"
                        failure = true
                    }
                    
                } else {
                    // ошибка содержимого файла
                    message = "Файл повреждён"
                    failure = true
                }
                
            } else {
                // если ошибка загрузки
                message = "Не правильный url-адрес"
                failure = true
            }
            
            completion(message, failure)
        }
        task.resume()
//        completion(message, failure)
    }
    
    private static func savePlaylistURLForUser(name: String, url: String) {
        // сохраняем введеннный URL на случай,
        // если система выгрузит плейлист из кэша
        
        if name.count != 0, url.count != 0 {
            // создаем новый объект
            let enteredURL: [String: Any] = [
                "name": name,
                "url": url,
                "dateAdded": Date()
            ]
            
            var userPlaylistURLs = [[String: Any]]()
            var isTherePlaylistLikeThat: Bool = false
            
            // проверяем есть уже массив с адресами или нет
            if let userURLs: [[String: Any]] = user.array(forKey: UserDefaultsKeys.PlaylistsURLs.key()) as? [[String : Any]] {
                userPlaylistURLs = userURLs
                // перебераем плейлисты, проверяем на дублирующий адрес
                for playlist in userURLs {
                    
                    if playlist["url"] as? String == url {
                        isTherePlaylistLikeThat = true
                        break
                    }
                    
                    isTherePlaylistLikeThat = false
                }
            } else {
                print("\n\n Плейлист пользователя пустой!")
            }
            
            
            
            if !isTherePlaylistLikeThat {
                userPlaylistURLs.append(enteredURL)
                user.set(userPlaylistURLs, forKey: UserDefaultsKeys.PlaylistsURLs.key())
                user.synchronize()
                print("\n\n Новый URL был добавлен")
            } else {
                print("\n\n Такой URL уже есть!")
            }
        }
    }
    
    private static func getYandexChannelName(name: String, completion: @escaping (_ yaid: Int, _ yandexName: String, _ yandexDesc: String) -> Void) {
        
        var results: Results<YandexChannel>?
        
        var yaid: Int = 0
        var yandexName = name
        var yandexDesc = ""
        
        let realm = try! Realm()
        results = realm.objects(YandexChannel.self)
        
        for channel in results! {
            
            var synonyms = channel.synonyms?.components(separatedBy: ",")
            synonyms?.append(channel.name!)
            
            for synonym in synonyms! {
                if synonym.caseInsensitiveCompare(name) == .orderedSame {
                    yaid = channel.yaid
                    yandexName = channel.name!
                    yandexDesc = channel.desc!
                }
            }
            
        }
        
        completion(yaid, yandexName, yandexDesc)
    }
    
}

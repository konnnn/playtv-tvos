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
        
        var urlStringEdited: String?
        
        // проверяем на наличие префикса в адресе (http://)
        if urlString.hasPrefix("http://") || urlString.hasPrefix("https://") {
            urlStringEdited = urlString
        } else {
            // если нет! то добавляем
            urlStringEdited = "http://" + urlString
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
                    newPlaylist.dateAdded = Date()
                    
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
                                channel.name = lines[1]
                                index += 1
                                channel.index = index
                                
                            } else if line.hasPrefix("#EXTGRP") {
                                let lines = line.components(separatedBy: ":")
                                channel.genre = lines[1]
                                
                            } else if line.hasPrefix("http") {
                                channel.url = line
                                
                                // добавляем канал в новый плейлист
                                newPlaylist.channels.append(channel)
                                
                                print("\n \(channel.index). \(channel.name!) / \(channel.genre) / \(channel.url!)")
                                
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
        completion(message, failure)
    }
    
}

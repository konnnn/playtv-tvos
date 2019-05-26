//
//  Program.swift
//  playtv-tvos
//
//  Created by Evgeny Konkin on 09.05.2019.
//  Copyright © 2019 Evgeny Konkin. All rights reserved.
//

import Foundation
import RealmSwift

class Program: Object {
    @objc dynamic var yaid: Int = 0 // id канала
    @objc dynamic var objectID: String? = nil // id объекта
    @objc dynamic var programID: String? = nil // id программы
    @objc dynamic var programTitle: String? = nil // название программы
    @objc dynamic var programDesc: String? = nil // описание программы
    @objc dynamic var episodeID: String? = nil // id эпизода
    @objc dynamic var episodeTitle: String? = nil // название эпизода
    @objc dynamic var episodeDesc: String? = nil // описание эпизода
    @objc dynamic var seasonNumber: Int = 0 // номер сезона
    @objc dynamic var imgBaseURL: String? = nil // url картинки
    @objc dynamic var ageRestriction: String? = nil // возрастное ограничение
    @objc dynamic var typeName: String? = nil // жарн программы
    @objc dynamic var countries: String? = nil // страна производства
    @objc dynamic var year: String? = nil // год создания
    @objc dynamic var socialDate: Date? // дата показа
    @objc dynamic var start: Date? // дата начала программы
    @objc dynamic var finish: Date? // дата конца программы
    var parentChannel = LinkingObjects(fromType: Channel.self, property: "program")
}

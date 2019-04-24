//
//  Playlist.swift
//  playtv-tvos
//
//  Created by Evgeny Konkin on 19.04.2019.
//  Copyright © 2019 Evgeny Konkin. All rights reserved.
//

import Foundation
import RealmSwift

class Playlist: Object {
    @objc dynamic var title: String? = nil
    let channels = List<Channel>()
}

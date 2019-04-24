//
//  Channel.swift
//  playtv-tvos
//
//  Created by Evgeny Konkin on 19.04.2019.
//  Copyright © 2019 Evgeny Konkin. All rights reserved.
//

import Foundation
import RealmSwift

class Channel: Object {
    @objc dynamic var index: Int = 0
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String? = nil
    @objc dynamic var logoName: String? = nil
    @objc dynamic var url: String? = nil
    var parentPlaylist = LinkingObjects(fromType: Playlist.self, property: "channels")
}

class CurrentChannel: Object {
    @objc dynamic var index: Int = 0
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String? = nil
    @objc dynamic var logoName: String? = nil
    @objc dynamic var url: String? = nil
}

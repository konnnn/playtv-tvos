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
    @objc dynamic var dateAdded: Date?
    let channels = List<Channel>()
}

extension Playlist {
    var isThereAnyPlaylists: Bool {
        let playlistResult: Results<Playlist> = try! Realm().objects(Playlist.self)
        return (playlistResult.count != 0)
    }
    
    var isThereAnyChannelsInPlaylist: Bool {
        let playlistResult: Results<Playlist> = try! Realm().objects(Playlist.self)
        return (playlistResult.first?.channels.count != 0)
    }
}

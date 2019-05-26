//
//  UIImageView+Download.swift
//  playtv-tvos
//
//  Created by Evgeny Konkin on 17.05.2019.
//  Copyright © 2019 Evgeny Konkin. All rights reserved.
//

import UIKit

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIImageView.ContentMode = .scaleAspectFill) {
        self.contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse,
                httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType,
                mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            main(task: {
                self.image = image
            })
            }.resume()
    }
    
    func downloaded(from urlString: String, contentMode mode: UIImageView.ContentMode = .scaleAspectFill) {
        guard let url = URL(string: urlString) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

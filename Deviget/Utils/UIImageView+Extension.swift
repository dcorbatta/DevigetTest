//
//  UIImageView+Extension.swift
//  Deviget
//
//  Created by Daniel N Corbatta B on 15/05/2019.
//  Copyright © 2019 com.dcorbatta. All rights reserved.
//

import UIKit
extension UIImageView {
    
    private func fetchFromServer(url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        
        self.image = UIImage(named: "placeholder")
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    
    func setImage(fromURL urlStr : String?, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let urlStr = urlStr, let url = URL(string: urlStr) else { return }
        fetchFromServer(url: url, contentMode: mode)
    }
}

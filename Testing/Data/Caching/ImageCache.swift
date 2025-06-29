//
//  ImageCache.swift
//  Testing
//
//  Created by NghiaNT on 24/6/25.
//

import Foundation
import UIKit
final class ImageCache{
    static let shared = ImageCache()
    private init() {}
     private let cache = NSCache<NSString, UIImage>()

     func image(for key: String) -> UIImage? {
       cache.object(forKey: key as NSString)
     }
     func save(_ img: UIImage, for key: String) {
       cache.setObject(img, forKey: key as NSString)
     }
}

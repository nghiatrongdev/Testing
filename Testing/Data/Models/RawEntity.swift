//
//  RawEntity.swift
//  Testing
//
//  Created by NghiaNT on 29/6/25.
//

import Foundation
struct RawPhoto: Codable {
    let id: String
    let author: String
    let width: Int
    let height: Int
    let download_url: String
}

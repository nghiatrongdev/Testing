//
//  PhotoRepositoryProtocol.swift
//  Testing
//
//  Created by NghiaNT on 29/6/25.
//

import Foundation
protocol PhotoRepositoryProtocol {
  func fetchPhotos(page: Int, limit: Int,
                   completion: @escaping (Result<[PhotoEntity], Error>) -> Void)
}

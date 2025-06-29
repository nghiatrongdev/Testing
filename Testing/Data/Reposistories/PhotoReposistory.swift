//
//  PhotoReposistory.swift
//  Testing
//
//  Created by NghiaNT on 29/6/25.
//

import Foundation
final class PhotoRepository: PhotoRepositoryProtocol {
  private let service: PhotoService

  init(service: PhotoService = .shared) {
    self.service = service
  }

  func fetchPhotos(page: Int, limit: Int,
                   completion: @escaping (Result<[PhotoEntity], Error>) -> Void) {
    service.fetchPhotos(page: page, limit: limit, completion: completion)
  }
}

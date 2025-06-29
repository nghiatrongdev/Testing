//
//  FetchPhotoUseCaseImplement.swift
//  Testing
//
//  Created by NghiaNT on 29/6/25.
//

import Foundation
final class FetchPhotosUseCaseImpl: FetchPhotosUseCase {
  private let repository: PhotoRepositoryProtocol

  init(repository: PhotoRepositoryProtocol) {
    self.repository = repository
  }

  func execute(page: Int, limit: Int,
               completion: @escaping (Result<[PhotoEntity], Error>) -> Void) {
    repository.fetchPhotos(page: page, limit: limit, completion: completion)
  }
}

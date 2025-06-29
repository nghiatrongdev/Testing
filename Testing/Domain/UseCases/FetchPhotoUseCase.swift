//
//  FetchPhotoUseCase.swift
//  Testing
//
//  Created by NghiaNT on 29/6/25.
//

import Foundation
protocol FetchPhotosUseCase {
  func execute(page: Int, limit: Int,
               completion: @escaping (Result<[PhotoEntity], Error>) -> Void)
}

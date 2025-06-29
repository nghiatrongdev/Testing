//
//  PhotoListViewModel.swift
//  Testing
//
//  Created by NghiaNT on 29/6/25.
//

import Foundation
class PhotoListViewModel {
    private let fetchUseCase: FetchPhotosUseCase
    var photos: [PhotoEntity] = []
    private var currentPage = 1
    let pageSize = 15
    var isLoading = false
    var hasMore = true
    
    var onUpdate: (() -> Void)?
    
    init(fetchUseCase: FetchPhotosUseCase) {
        self.fetchUseCase = fetchUseCase
    }
    
    func refresh() {
        currentPage = 1
        hasMore = true
        photos = []
        loadNext()
    }
    
    func loadNext() {
        guard !isLoading && hasMore else { return }
        isLoading = true
        fetchUseCase.execute(page: currentPage, limit: pageSize) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
            case .success(let newPhotos):
                self.hasMore = newPhotos.count == self.pageSize
                if self.currentPage == 1 {
                    self.photos = newPhotos
                } else {
                    self.photos += newPhotos
                }
                self.currentPage += 1
            case .failure:
                break
            }
            DispatchQueue.main.async {
                self.onUpdate?()
            }
        }
    }
}

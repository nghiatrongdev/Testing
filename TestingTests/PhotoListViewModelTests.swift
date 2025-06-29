//
//  PhotoListViewModelTests.swift
//  TestingTests
//
//  Created by NghiaNT on 29/6/25.
//

import XCTest
@testable import Testing

class PhotoListViewModelTests: XCTestCase {
    private class FakeUseCase: FetchPhotosUseCase {
        var invoked = false
        var stubResult: Result<[PhotoEntity], Error> = .success([])
        func execute(page: Int, limit: Int, completion: @escaping (Result<[PhotoEntity], Error>) -> Void) {
            invoked = true
            completion(stubResult)
        }
    }

    func testLoadNext() {
        // Given
        let fake = FakeUseCase()
        let vm = PhotoListViewModel(fetchUseCase: fake)
        let sample = PhotoEntity(id: "a",
                                 author: "A",
                                 width: 10,
                                 height: 10,
                                 download_url: "u")
      
        let fullPage = Array(repeating: sample, count: vm.pageSize)
        fake.stubResult = .success(fullPage)

        let exp = expectation(description: "onUpdate called twice")
        exp.expectedFulfillmentCount = 2
        vm.onUpdate = { exp.fulfill() }

        // When
        vm.loadNext()
        vm.loadNext()

        // Then
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(vm.photos, fullPage + fullPage)
    }



    func testRefreshPhotos() {
        let fake = FakeUseCase()
        let vm = PhotoListViewModel(fetchUseCase: fake)
        vm.photos = [PhotoEntity(id: "x", author: "X", width: 1, height: 1, download_url: "u")]
        fake.stubResult = .success([])

        vm.refresh()
        XCTAssertTrue(fake.invoked)
        XCTAssertTrue(vm.photos.isEmpty)
    }
}

//
//  FetchPhotosUseCaseTests.swift
//  TestingTests
//
//  Created by NghiaNT on 29/6/25.
//

import XCTest
@testable import Testing
final class FetchPhotosUseCaseTests: XCTestCase {
    private class FakeRepository: PhotoRepositoryProtocol {
         var invoked = false
         var stubResult: Result<[PhotoEntity], Error> = .success([])
         func fetchPhotos(page: Int, limit: Int, completion: @escaping (Result<[PhotoEntity], Error>) -> Void) {
             invoked = true
             completion(stubResult)
         }
     }

     func testExecuteToRepositoryAndReturnsData() {
         let fakeRepo = FakeRepository()
         let useCase = FetchPhotosUseCaseImpl(repository: fakeRepo)
         let sample = PhotoEntity(id: "42", author: "Alice", width: 10, height: 20, download_url: "url")
         fakeRepo.stubResult = .success([sample])

         let exp = expectation(description: "Completion called")
         useCase.execute(page: 1, limit: 1) { result in
             XCTAssertTrue(fakeRepo.invoked)
             switch result {
             case .success(let photos):
                 XCTAssertEqual(photos, [sample])
             case .failure:
                 XCTFail("Expected success")
             }
             exp.fulfill()
         }
         wait(for: [exp], timeout: 1)
     }

     func testExecuteFromRepository() {
         let fakeRepo = FakeRepository()
         let useCase = FetchPhotosUseCaseImpl(repository: fakeRepo)
         let testError = NSError(domain: "Test", code: 1, userInfo: nil)
         fakeRepo.stubResult = .failure(testError)

         let exp = expectation(description: "Error bubbled")
         useCase.execute(page: 1, limit: 1) { result in
             switch result {
             case .success:
                 XCTFail("Expected failure")
             case .failure(let error as NSError):
                 XCTAssertEqual(error, testError)
             }
             exp.fulfill()
         }
         wait(for: [exp], timeout: 1)
     }

}

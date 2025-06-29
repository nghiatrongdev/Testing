//
//  PhotoServiceTests.swift
//  TestingTests
//
//  Created by NghiaNT on 29/6/25.
//

import XCTest
@testable import Testing

// Stub URLProtocol to intercept network calls
class URLProtocolStub: URLProtocol {
    static var stubData: Data?
    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
    override func startLoading() {
        if let data = URLProtocolStub.stubData {
            client?.urlProtocol(self, didLoad: data)
        }
        client?.urlProtocolDidFinishLoading(self)
    }
    override func stopLoading() {}
}

class PhotoServiceTests: XCTestCase {
    private var service: PhotoService!

    override func setUp() {
        super.setUp()
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: config)
        service = PhotoService(session: session)
    }

    func testFetchPhoto() {
        // Given
        let json = """
          [{"id":"1","author":"Bob","width":100,"height":200,"download_url":"u"}]
        """.data(using: .utf8)!
        URLProtocolStub.stubData = json

        let exp = expectation(description: "Fetch completes")
        // When
        service.fetchPhotos(page: 1, limit: 1) { result in
            // Then
            switch result {
            case .success(let photos):
                XCTAssertEqual(photos.count, 1)
                let photo = photos.first!
                XCTAssertEqual(photo.width, 10)
                XCTAssertEqual(photo.height, 20)
                XCTAssertTrue(photo.download_url.contains("/10/20"))
            case .failure(let error):
                XCTFail("Expected success, got error: \(error)")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
}

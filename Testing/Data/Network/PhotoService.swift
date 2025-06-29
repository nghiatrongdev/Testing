//
//  PhotoService.swift
//  Testing
//
//  Created by NghiaNT on 24/6/25.
//

import Foundation

final class PhotoService {
    static let shared = PhotoService()

    private let session: URLSession
    private let scale: Double = 0.1

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchPhotos(page: Int,
                     limit: Int = 100,
                     completion: @escaping (Result<[PhotoEntity], Error>) -> Void) {

        var components = URLComponents(string: "https://picsum.photos/v2/list")!
        components.queryItems = [
            URLQueryItem(name: "page",  value: "\(page)"),
            URLQueryItem(name: "limit", value: "\(limit)")
        ]
        let url = components.url!

        session.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                let err = NSError(domain: "PhotoService",
                                  code: -1,
                                  userInfo: [NSLocalizedDescriptionKey: "No data"])
                completion(.failure(err))
                return
            }

            do {
                let rawPhotos = try JSONDecoder().decode([RawPhoto].self, from: data)
                let entities: [PhotoEntity] = rawPhotos.map { raw in
                    let newW = Int(Double(raw.width) * self.scale)
                    let newH = Int(Double(raw.height) * self.scale)
                    let thumbURL = "https://picsum.photos/id/\(raw.id)/\(newW)/\(newH)"
                    return PhotoEntity(
                        id: raw.id,
                        author: raw.author,
                        width: newW,
                        height: newH,
                        download_url: thumbURL
                    )
                }
                completion(.success(entities))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

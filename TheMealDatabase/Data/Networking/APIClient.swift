//
//  APIClient.swift
//  TheMovieDatabase
//
//  Created by Artur on 01.10.2026.
//

import Foundation

final class APIClient {
    static let shared = APIClient()
    private init() {}

    func request<T: Decodable>(endpoint: Endpoint) async throws -> T {
        var components = URLComponents(
            string: "\(Constants.baseURL)/\(endpoint.path)"
        )

        if !endpoint.queryItems.isEmpty {
            components?.queryItems = endpoint.queryItems
        }

        guard let url = components?.url else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        if endpoint.body != nil {
            request.setValue(
                "application/json",
                forHTTPHeaderField: "Content-Type"
            )
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.server(statusCode: httpResponse.statusCode)
        }

        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            print("❌ Decoding error: \(error)")
            throw APIError.decodingFailed(error)
        }
    }
}

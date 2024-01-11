//
//  NetworkManager.swift
//  BusinessDisplay
//
//  Created by 李昀 on 2024/1/11.
//

import Foundation

class NetworkManager {
    enum ManagerError: Error {
        case invalidResponse
        case invalidStatusCode(Int)
        case invalidData
    }
    
    enum HttpMethod: String {
        case get
        
        var method: String { rawValue.uppercased() }
    }
    
    func request<T: Decodable> (fromUrl url: URL, httpMethod: HttpMethod = .get, completion: @escaping (Result<T, Error>) -> Void) {
        let completionOnMain: (Result<T, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.method
        
        let urlSession = URLSession.shared.dataTask(with: request) { data, response, error in
            // Error
            if let error = error {
                completionOnMain(.failure(error))
                return
            }
            
            // Invalid response
            guard let urlResponse = response as? HTTPURLResponse else {
                completionOnMain(.failure(ManagerError.invalidResponse))
                return
            }
            
            // Invalid status code
            if !(200..<300).contains(urlResponse.statusCode) {
                completionOnMain(.failure(ManagerError.invalidStatusCode(urlResponse.statusCode)))
                return
            }
            
            // Invalid data
            guard let data = data else {
                completionOnMain(.failure(ManagerError.invalidData))
                return
            }
            
            do {
                // Success decode and return decoded data
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completionOnMain(.success(decodedData))
            } catch {
                // Unable to decode
                debugPrint("Unable to decode the data to the requested type. Reason: \(error.localizedDescription)")
                completionOnMain(.failure(error))
            }
        }
        
        urlSession.resume()
    }
}

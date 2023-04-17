//
//  HomeViewModel.swift
//  WeatherAPI
//
//  Created by Çağla Karakuş on 10.03.2023.
//



import Foundation
import Alamofire

class HomeViewModel: ObservableObject {
    // MARK: INIT
    init(){
        fetchWeatherData(for: "Ankara") {_ in}
    }
    // MARK: PROPERTIES
    @Published var isAlertActive: Bool = false
    @Published var searchString: String = ""
    @Published var weatherData: WeatherDataModel?
}
// MARK: Functions
extension HomeViewModel {

    func fetchWeatherData(for city: String, completion: @escaping (Result<WeatherDataModel, APIError>) -> Void) {
        let urlString = String.concatenate(API.baseURL, API.apiKey, API.queryParameter, city)

        guard let safeURLString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed),
            let endpointURL = URL(string: safeURLString) else {
            return
        }

        
        /*
        
        let task = URLSession.shared.dataTask(with: endpointURL) { (data, response, error) in
            if let error = error {
                completion(.failure(.requestFailed(description: error.localizedDescription)))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }

            guard httpResponse.statusCode == 200 else {
                let statusCode = httpResponse.statusCode
                switch statusCode {
                case 400:
                    completion(.failure(.resourceDoesNotExits))
                case 101:
                    completion(.failure(.unauthorized))
                case 102:
                    completion(.failure(.blockedUser))
                default:
                    completion(.failure(.unknownError(statusCode: statusCode)))
                }
                return
            }

            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }

            do {
                let decoder = JSONDecoder()
                let decodedWeatherData = try decoder.decode(WeatherDataModel.self, from: data)
                DispatchQueue.main.async {
                    self.weatherData = decodedWeatherData
                }
                completion(.success(decodedWeatherData)
                )
            } catch {
                completion(.failure(.decodingError))
            }
        }
        task.resume()
         
         */

        
        /*
        
        AF.request(endpointURL).responseDecodable(of: WeatherDataModel.self) { response in
            switch response.result{
                
                //guard case or switch case
                
            case .success(let decodedWeatherData):
                self.weatherData = decodedWeatherData
            case .failure(let error): completion(.failure(.requestFailed(description: "unknown failure")))
                
            
        
            }
            
            
        }
         
         
         */
        
        
        AF.request(endpointURL).responseDecodable(of: WeatherDataModel.self) { response in
            switch response.result{
            case .success(let decodedWeatherData):
                self.weatherData = decodedWeatherData
            case .failure(let error):
                completion(.failure(.requestFailed(description: "unknown failure")))
                
                 let error = error as AFError
                    switch error {
                    case .invalidURL(let url):
                        print("Invalid URL: \(url) - \(error.localizedDescription)")
                    case .parameterEncodingFailed(let reason):
                        print("Parameter encoding failed: \(error.localizedDescription)")
                        print("Failure Reason: \(reason)")
                    case .multipartEncodingFailed(let reason):
                        print("Multipart encoding failed: \(error.localizedDescription)")
                        print("Failure Reason: \(reason)")
                    case .responseValidationFailed(let reason):
                        print("Response validation failed: \(error.localizedDescription)")
                        print("Failure Reason: \(reason)")
                        
                    switch reason {
                        case .dataFileNil, .dataFileReadFailed:
                            print("Downloaded file could not be read")
                        case .missingContentType(let acceptableContentTypes):
                            print("Content Type Missing: \(acceptableContentTypes)")
                        case .unacceptableContentType(let acceptableContentTypes, let responseContentType):
                            print("Response content type: \(responseContentType) was unacceptable: \(acceptableContentTypes)")
                        case .unacceptableStatusCode(let code):
                            print("Response status code was unacceptable: \(code)")
                    case .customValidationFailed(error: let error):
                        <#code#>
                    }
                    case .responseSerializationFailed(let reason):
                        print("Response serialization failed: \(error.localizedDescription)")
                        print("Failure Reason: \(reason)")
                    }
                    
                    print("Underlying error: \(String(describing: error.underlyingError))")
            }; else if let error = error as? URLError {
                    print("URLError occurred: \(error)")
                } else {
                    print("Unknown error occurred")
                }
            
        }

         
    }
}



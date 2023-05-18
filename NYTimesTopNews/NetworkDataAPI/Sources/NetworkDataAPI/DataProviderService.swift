import Foundation

public protocol DataProviderServiceProtocol: AnyObject {
    func fetchData<T: Decodable>(from urlString: String,
                                 dataType: T.Type,
                                 decode: Bool,
                                 completion: @escaping (Result<T, DataProviderServiceError>) -> Void)
}

public class DataProviderService: DataProviderServiceProtocol {
    
    public init() {}
    
    public func fetchData<T>(from urlString: String,
                             dataType: T.Type = Data.self,
                             decode: Bool = false,
                             completion: @escaping (Result<T, DataProviderServiceError>) -> Void) where T : Decodable {
        guard let url = URL(string: urlString)
        else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let response = response as? HTTPURLResponse {
                if response.statusCode > 199 && response.statusCode < 300 {
                    if let data = data {
                        if decode {
                            do
                            {
                                let resultData = try JSONDecoder().decode(T.self, from: data)
                                completion(.success(resultData))
                            } catch {
                                completion(.failure(DataProviderServiceError.decodeError))
                            }
                        } else {
                            completion(.success(data as! T))
                        }
                    } else {
                        completion(.failure(DataProviderServiceError.emptyResponse))
                    }
                } else {
                    completion(.failure(DataProviderServiceError.statusCode(code: response.statusCode)))
                }
            } else {
                completion(.failure(DataProviderServiceError.emptyResponse))
            }
        }.resume()
    }
}

import Foundation

class Repo {
        
    func getData<T : Decodable>(_ urlString : String, _ errorCompletion : ((ApiError)->())? = nil, _ completion : ((T)->())? = nil){
        
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                errorCompletion?(.URL)
            }
            return
        }
                
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.setValue("15bc8dc0561a47648ecc5d26db27f54d", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
                        
            guard error == nil, let data = data else {
                DispatchQueue.main.async {
                    errorCompletion?(.Connection)
                }
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print(json)
                }
                                
                let decoder = JSONDecoder()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                dateFormatter.locale = Locale(identifier: "en_US")
                dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
                
                let res : T = try decoder.decode(T.self, from: data)
                
                DispatchQueue.main.async {
                    completion?(res)
                }
            } catch _ {
                DispatchQueue.main.async {
                    errorCompletion?(.Json)
                }
            }
        }.resume()
    }
    
    func getImageData(_ urlString : String, _ errorCompletion : ((ApiError)->())? = nil, _ completion : ((Data)->())? = nil){
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                errorCompletion?(.URL)
            }
            return
        }
        
        URLSession.shared.dataTask(with: url) {
            data, response, error in
            
            guard error == nil, let data = data else {
                DispatchQueue.main.async{
                    errorCompletion?(.Connection)
                }
                return
            }
            
            DispatchQueue.main.async {
                completion?(data)
            }
        }.resume()
    }
}



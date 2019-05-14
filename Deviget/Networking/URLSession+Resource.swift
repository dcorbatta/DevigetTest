//
//  URLSession+Resource.swift
//  Deviget
//
//  Created by Daniel N Corbatta B on 14/05/2019.
//  Copyright © 2019 com.dcorbatta. All rights reserved.
//

import Foundation
extension URLSession {
    func load<A>(_ resource: Resource<A>, completion: @escaping (A?,String?) -> ()) {
        dataTask(with: resource.urlRequest) { data, response, error in
            if let error = error {
                completion(nil,"DataTask error: " + error.localizedDescription + "\n")
            } else if let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                completion(data.flatMap(resource.parse),nil)
            }else {
                completion(nil,"Error in services")
            }
            }.resume()
    }
}

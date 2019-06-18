//
//  DogAPI.swift
//  RandomDog
//
//  Created by Abdallah Eid on 6/18/19.
//  Copyright © 2019 Abdallah Eid. All rights reserved.
//

import Foundation

class DogAPI {
    enum Endpoint: String {
        case randomImageUrlString = "https://dog.ceo/api/breeds/image/random"
        
        var url: URL {
            return URL(string: self.rawValue)!
        }
    }
    
    class func requestRandomImage(completionHandler: @escaping (DogImage?, Error?) -> Void){
        let randomImageEndpoint = DogAPI.Endpoint.randomImageUrlString.url
        
        let task = URLSession.shared.dataTask(with: randomImageEndpoint) { (data, response, error) in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            
            do {
                let dogImageData = try JSONDecoder().decode(DogImage.self, from: data)
                completionHandler(dogImageData, nil)
            } catch{
                completionHandler(nil, error)
            }
        }
        
        task.resume()
    }
    
    class func requestImageFile(urlString: String, completionHandler: @escaping (Data? , Error?) -> Void){
        let url = URL(string: urlString)
        if let url = url {
            let downloadImageTask = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                guard let data = data else {
                    completionHandler(nil, error)
                    return
                }
                
                completionHandler(data, nil)

            })
            downloadImageTask.resume()
        }
    }
}

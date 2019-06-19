//
//  DogAPI.swift
//  RandomDog
//
//  Created by Abdallah Eid on 6/18/19.
//  Copyright © 2019 Abdallah Eid. All rights reserved.
//

import Foundation

class DogAPI {
    enum Endpoint {
        case randomImageUrlString
        case randomImageForBreed(String)
        case listAllBreeds
        
        var stringValue: String {
            switch self{
            case .randomImageUrlString:
                return "https://dog.ceo/api/breeds/image/random"
            
            case .randomImageForBreed(let breed):
                return "https://dog.ceo/api/breed/\(breed)/images/random"
                
            case .listAllBreeds:
                return "https://dog.ceo/api/breeds/list/all"
                
            }
        }
        
        var url: URL {
            return URL(string: self.stringValue)!
        }
    }
    
    class func requestRandomImage(breed: String, completionHandler: @escaping (DogImage?, Error?) -> Void){
        let randomImageEndpoint = DogAPI.Endpoint.randomImageForBreed(breed).url
        
        let task = URLSession.shared.dataTask(with: randomImageEndpoint) { (data, response, error) in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            
            do {
                let dogImageData = try JSONDecoder().decode(DogImage.self, from: data)
                completionHandler(dogImageData, nil)
                return
            } catch{
                completionHandler(nil, error)
                return
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
                return

            })
            downloadImageTask.resume()
        }
    }
    
    class func listAllBreeds(completionHandler: @escaping ([String]?, Error?) -> Void){
        let listAllBreedsAPI = DogAPI.Endpoint.listAllBreeds.url
        
        let task = URLSession.shared.dataTask(with: listAllBreedsAPI) { (data, response, error) in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            
            do {
                let breedsList = try JSONDecoder().decode(BreedsList.self, from: data)
                let breeds = breedsList.message.keys.map({$0})
                completionHandler(breeds, nil)
                return
            } catch{
                print(error)
            }
        }
        task.resume()
    }
}

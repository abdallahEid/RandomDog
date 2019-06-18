//
//  ViewController.swift
//  RandomDog
//
//  Created by Abdallah Eid on 6/18/19.
//  Copyright © 2019 Abdallah Eid. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DogAPI.requestRandomImage(completionHandler: handleRandomImageResponse(dogImageData:error:))
        
    }
    
    func handleRandomImageResponse(dogImageData: DogImage?, error: Error?){
        
        guard let dogImageData = dogImageData else {
            return
        }
        
        if let urlString = dogImageData.message {
            DogAPI.requestImageFile(urlString: urlString, completionHandler: self.handleImageFileResponse(data:error:))
        }
    }
    
    func handleImageFileResponse(data: Data?, error: Error?){
        if let data = data {
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: data)
            }
        }
    }

}


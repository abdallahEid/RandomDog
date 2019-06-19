//
//  ViewController.swift
//  RandomDog
//
//  Created by Abdallah Eid on 6/18/19.
//  Copyright © 2019 Abdallah Eid. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // Mark: Outlets & Variables

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var breeds:[String] = []
    
    // Mark: View Controller LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        DogAPI.listAllBreeds(completionHandler: self.handleListAllBreedsResponse(breeds:error:))
    }
    
    // Mark: Actions & Functions

    func handleRandomImageResponse(dogImageData: DogImage?, error: Error?){
        
        guard let dogImageData = dogImageData else {
            print(error ?? "" )
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
    
    func handleListAllBreedsResponse(breeds: [String]?, error: Error?){
        guard let breeds = breeds else {
            return
        }
        self.breeds = breeds
        DispatchQueue.main.async {
            self.pickerView.reloadAllComponents()
        }
    }

}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return breeds.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return breeds[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        DogAPI.requestRandomImage(breed: breeds[row], completionHandler: handleRandomImageResponse(dogImageData:error:))
    }
}

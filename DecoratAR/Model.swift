//
//  Model.swift
//  DecoratAR
//
//  Created by Quincy Williams on 1/10/21.
//

import UIKit
import RealityKit
import Combine

//Class created to help with async issues when loading objects
class Model {
    var modelName: String
    var image: UIImage
    var modelEntity: ModelEntity?
    
    private var cancellable: AnyCancellable? = nil
    
    init(modelName: String) {
        self.modelName = modelName
        self.image = UIImage(named: modelName)!
        
        let filename = modelName + ".usdz"
        self.cancellable = ModelEntity.loadModelAsync(named: filename)
            .sink(receiveCompletion: {loadCompletion in
                //Handle error
                print("DEBUG: Unable to load model entity for modelName: \(self.modelName)")
            }, receiveValue: { modelEntity in
                //Get model entity
                self.modelEntity = modelEntity
                print("DEBUG: Successfully loaded model entity for modelName: \(self.modelName)")
            })
    }
}

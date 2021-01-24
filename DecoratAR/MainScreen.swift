//
//  ContentView.swift
//  DecoratAR
//
//  Created by Quincy Williams on 11/22/20.
//

import SwiftUI
import RealityKit
import ARKit
import FocusEntity

struct ContentView : View {
    @State private var isPlacemenEnabled = false
    @State private var modelSelected: Model?
    @State private var modelPlacementConfirmed: Model?
    
    private var models: [Model] = {
        //Dynamically get file names
        let filemanager = FileManager.default
        guard let path = Bundle.main.resourcePath, let files = try? filemanager.contentsOfDirectory(atPath: path)
        else {
            return []
        }
        
        var modelsToUse: [Model] = []
        for filename in files where filename.hasSuffix("usdz") {
            let modelName = filename.replacingOccurrences(of: ".usdz", with: "")
            let model = Model(modelName: modelName)
            modelsToUse.append(model)
        }
        
        return modelsToUse
    }()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ARViewContainer(modelConfirmedForPlacement: self.$modelPlacementConfirmed)
            
            if self.isPlacemenEnabled {
                PlacementButtonsView(isPlacementEnabled: self.$isPlacemenEnabled, selectedModel: self.$modelSelected, modelConfirmedForPlacement: self.$modelPlacementConfirmed)
            } else {
                ModelPickerView(isPlacementEnabled: self.$isPlacemenEnabled, selectedModel: self.$modelSelected, models: self.models)
            }
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    @Binding var modelConfirmedForPlacement: Model?
    
    func makeUIView(context: Context) -> ARView {
        let arView = CustomView(frame: .zero)
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        if let model = self.modelConfirmedForPlacement {
            if let modelEntity = model.modelEntity {
                print("DEBUG: adding model to scene - \(model.modelName)")
                let anchorEntity = AnchorEntity(plane: .any)
                anchorEntity.addChild(modelEntity)
                anchorEntity.name = "ModelAnchor"
                uiView.scene.addAnchor(anchorEntity)
                
        //MARK: Functionality to be able to transform the models in the scene after they have been placed
                //Collision shapes needed to be able to use gestures after model has been placed in the scene
                modelEntity.generateCollisionShapes(recursive: true)
                
                //Add gestures to be able to move the objects in the scene
                uiView.installGestures([.all], for: modelEntity)
                
        //MARK: Calls to the objective C function that allows for objects to be removed from the scene on long press
                uiView.removeObject()
                
            } else {
                print("DEBUG: Unable to load modelEntity to scene for - \(model.modelName)")
            }
            
            DispatchQueue.main.async {
                self.modelConfirmedForPlacement = nil
            }
        }
    }
    
}

//MARK: Functionality to remove objects from the scene
extension ARView {
    func removeObject() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(recognizer:)))
        self.addGestureRecognizer(longPress)
    }
    
    @objc func handleLongPress(recognizer:UILongPressGestureRecognizer) {
        let screenLocation = recognizer.location(in: self)
        
        if let entity = self.entity(at: screenLocation) {
            if let anchorEntity = entity.anchor, anchorEntity.name == "ModelAnchor" {
                anchorEntity.removeFromParent()
                print("Model removed")
            }
        }
    }
}

//MARK: Added from Swift Package to create a focal point for the user when placing an object
class CustomView :ARView {
    let focus = FESquare()
    
    required init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
        
        focus.viewDelegate = self
        focus.delegate = self
        focus.setAutoUpdate(to: true)
        
        self.setupARView()
    }
    
    @objc required dynamic init?(coder decoder: NSCoder) {
        fatalError("coder has not been implemented")
    }
}

extension CustomView : FEDelegate {
    func toTrackingState() {
        print("tracking")
    }
    
    func toInitializingState() {
        print("initializing")
    }
    
    func setupARView() {
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        
        config.environmentTexturing = .automatic
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            config.sceneReconstruction = .mesh
        }
        
        self.session.run(config)
    }
}

//MARK: Structure for Model Scroll View
struct ModelPickerView: View {
    @Binding var isPlacementEnabled: Bool
    @Binding var selectedModel: Model?
    
    var models: [Model]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 30) {
                ForEach(0 ..< self.models.count) {
                    index in
                    Button(action: {
                        print("DEBUG: selected model with name: \(self.models[index].modelName)")
                        self.selectedModel = self.models[index]
                        self.isPlacementEnabled = true
                    }, label: {
                        Image(uiImage: self.models[index].image)
                            .resizable()
                            .frame(height: 80)
                            .aspectRatio(1/1, contentMode: .fit)
                            .background(Color.white)
                            .cornerRadius(12)
                        //Text("\(self.models[index].modelName)")
                    })
                }
            }
        }
        .padding(20)
        .background(Color.black.opacity(0.5))
    }
}

//MARK: Structure for binding buttons when states change
struct PlacementButtonsView: View {
    @Binding var isPlacementEnabled: Bool
    @Binding var selectedModel: Model?
    @Binding var modelConfirmedForPlacement: Model?
    
    var body: some View {
        HStack {
            //Cancel Button
            Button(action: {
                print("DEBUG: Cancel model placement.")
                self.resetPlacment()
            }, label: {
                Image(systemName: "xmark")
                    .frame(width: 60, height: 60)
                    .font(.title)
                    .background(Color.white.opacity(0.75))
                    .cornerRadius(30)
                    .padding(20)
                Text("Cancel").foregroundColor(.white)
            })
            
            //Confirm Button
            Button(action: {
                print("DEBUG: Model Placement success.")
                self.modelConfirmedForPlacement = self.selectedModel
                self.resetPlacment()
            }, label: {
                Image(systemName: "checkmark")
                    .frame(width: 60, height: 60)
                    .font(.title)
                    .background(Color.white.opacity(0.75))
                    .cornerRadius(30)
                    .padding(20)
                Text("Okay").foregroundColor(.white)
            })
        }
    }
    
    func resetPlacment() {
        self.isPlacementEnabled = false
        self.selectedModel = nil
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif

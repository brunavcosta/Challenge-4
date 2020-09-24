//
//  GameViewController.swift
//  Challenge4
//
//  Created by Bruna Costa on 21/09/20.
//  Copyright © 2020 Bruna Costa. All rights reserved.
//

import ARKit

class GameViewController: UIViewController {
    
    //definir a view
    let arView: ARSCNView = {
        let view = ARSCNView()
        view.translatesAutoresizingMaskIntoConstraints = true
        return view
    }()
    
    //definir a view
    var virtualObjectModel: SCNNode = {
        guard let sceneURL = Bundle.main.url(forResource: "Doll", withExtension: "dae"),
              let referenceNode = SCNReferenceNode(url: sceneURL) else {
            fatalError("can't load virtual object")
        }
        referenceNode.position = SCNVector3(0,0,-1.0)
        referenceNode.load()
        
        return referenceNode
    }()
    
    var virtualObject: SCNNode?
    @IBOutlet weak var trackingStateLabel: UILabel!
    let configuration = ARFaceTrackingConfiguration() //frontCameraFeed
    var planes = [ARPlaneAnchor: SCNNode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(arView)
        
        let arView = ARSCNView(frame: UIScreen.main.bounds)
        
        //Ajustar a View para o frame do App
        //arView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        //arView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        //arView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        //arView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        //Ajustar a View para o frame do App
        
        arView.session.run(configuration, options: [])
        arView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin] //como seu APP recebe a informação pela camera
        
        let transform = arView.session.currentFrame?.camera.transform
        let anchor = ARAnchor(transform: transform!)
        arView.session.add(anchor: anchor)
        
        //playSound.play()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Prevent the screen from dimming to avoid interrupting the AR experience.
        UIApplication.shared.isIdleTimerDisabled = true
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        arView.session.pause()
    }
    
    func addPlane(for node: SCNNode, at anchor: ARPlaneAnchor) {
        let planeNode = SCNNode()
        
        let w = CGFloat(anchor.extent.x)
        let h = 0.01
        let l = CGFloat(anchor.extent.z)
        let geometry = SCNBox(width: w, height: CGFloat(h), length: l, chamferRadius: 0.0)
        
        // Translucent white plane
        geometry.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.5)
        planeNode.position = SCNVector3(
            anchor.center.x,
            anchor.center.y,
            anchor.center.z
        )
        planes[anchor] = planeNode
        node.addChildNode(planeNode)
        }
            
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let anchor = anchor as? ARPlaneAnchor else { return }
        addPlane(for: node, at: anchor)
                
            }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let anchor = anchor as? ARPlaneAnchor else { return }
          updatePlane(for: anchor)
        }
    
    func updatePlane(for anchor: ARPlaneAnchor) {
      // Pull the plane that needs to get updated
      let plane = self.planes[anchor]
    
      // Update its geometry
        if let geometry = plane?.geometry as? SCNBox {
        geometry.width  = CGFloat(anchor.extent.x)
        geometry.length = CGFloat(anchor.extent.y)
        geometry.height = 0.01
      }

        plane?.position = SCNVector3(anchor.center.x,anchor.center.y,anchor.center.z)
    }
        
        
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        switch camera.trackingState {
        case .notAvailable:
            trackingStateLabel.text = "Tracking not available"
            trackingStateLabel.textColor = .red
        case .normal:
            trackingStateLabel.text = "Tracking normal"
            trackingStateLabel.textColor = .green
        case .limited(let reason):
            switch reason {
            case .excessiveMotion:
                trackingStateLabel.text = "Tracking limited: excessive motion"
            case .insufficientFeatures:
                trackingStateLabel.text = "Tracking limited: insufficient features"
            default:
                trackingStateLabel.text = "Tracking limited: initializing"
            }
            trackingStateLabel.textColor = .red
        }
    }
        
    }



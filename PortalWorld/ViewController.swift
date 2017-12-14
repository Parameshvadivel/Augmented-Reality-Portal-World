//
//  ViewController.swift
//  PortalWorld
//
//  Created by Paramesh on 13/12/17.
//  Copyright © 2017 Paramesh. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.planeDetection = .horizontal
        
    
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            
            let touchloaction = touch.location(in: sceneView)
            
            let result = sceneView.hitTest(touchloaction, types: .existingPlaneUsingExtent)
            
            if let hitresult = result.first {
                
                let boxScene = SCNScene(named: "art.scnassets/ship.scn")!
                
                if let shipNode = boxScene.rootNode.childNode(withName: "roomPortal", recursively: true) {
                    
                    shipNode.position = SCNVector3(
                        x: hitresult.worldTransform.columns.3.x,
                        y: hitresult.worldTransform.columns.3.y,
                        z: hitresult.worldTransform.columns.3.z
                    )
                    
                    sceneView.scene.rootNode.addChildNode(shipNode)
                }
                
            }
            
        }
        
    }
    
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        
        if anchor is ARPlaneAnchor {
            
            let planeAnchor = anchor as! ARPlaneAnchor
            
            let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            
            let planeNode = SCNNode()
            
            planeNode.position = SCNVector3(x: planeAnchor.center.x, y:0, z: planeAnchor.center.z)
            
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
            
            let gridMaterial = SCNMaterial()
            
            gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.jpg")
            
            plane.materials = [gridMaterial]
            
            node.addChildNode(planeNode)
            
            
            
            
        } else {
            
            return
        }
        
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
  
}
